//
//  EditPortfolioViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import Foundation
import SwiftUI
import Resolver

internal enum PortfolioIntent: Equatable {
    case createNew
    case updateExisting(Portfolio)
}

public protocol UpdatePortfolioProfileFlowDelegate: AnyObject {
    func updatePortfolios(with: Portfolio)
}

final class EditPortfolioViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    @LazyInjected private var createPortfolioUseCase: CreatePortfolioUseCase
    @LazyInjected private var updatePortfolioUseCase: UpdatePortfolioUseCase

    private weak var flowController: ProfileFlowController?
    private weak var updatePortfolioProfileFlowDelegate: UpdatePortfolioProfileFlowDelegate?

    // MARK: Init

    init(
        flowController: ProfileFlowController?,
        updatePortfolioProfileFlowDelegate: UpdatePortfolioProfileFlowDelegate? = nil,
        creatorId: String,
        intent: PortfolioIntent = .createNew
    ) {
        self.flowController = flowController
        self.updatePortfolioProfileFlowDelegate = updatePortfolioProfileFlowDelegate
        super.init()
        state.creatorId = creatorId
        state.portfolioIntent = intent
        
        switch state.portfolioIntent {
        case .createNew:
            break
        case .updateExisting(let portfolio):
            state.portfolioId = portfolio.id
            state.name = portfolio.name
            state.description = portfolio.description
            state.media = portfolio.photos
            state.selectedCategories = portfolio.category
        }
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State: Equatable {
        var isLoading: Bool = false
        var portfolioIntent: PortfolioIntent = .createNew
        var creatorId = ""
        var portfolioId: String? = nil
        var name = ""
        var description = ""
        var media: [IImage] = []
        var selectedCategories: [String] = []
        var filteredCategories = photoCategories
        var searchInput = ""
        var isSaveButtonDisabled = true
        var alertData: AlertData? = nil
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case pickMedia
        case createNewPortfolio
        case addCategory(String)
        case close
        case setName(String)
        case setCategoryInput(String)
        case removeCategory(String)
        case removePic(UUID)
        case setDescriptionInput(String)
        case saveChanges
        case onAlertDataChanged(AlertData?)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .pickMedia: pickMedia()
            case .createNewPortfolio: await createNewPortfolio()
            case .addCategory(let category): addCategory(category)
            case .close: cancelEdit()
            case .setName(let name): setName(name)
            case .setDescriptionInput(let input): setDescriptionInput(input)
            case .setCategoryInput(let input): setCategoryInput(input)
            case .removeCategory(let category): removeCategory(category)
            case .removePic(let id): removePic(id)
            case .saveChanges: await saveChanges()
            case .onAlertDataChanged(let alertData): onAlertDataChanged(alertData: alertData)
            }
        })
    }

    // MARK: Additional methods

    private func pickMedia() {
        flowController?.presentPickerModal(source: self, limit: 7)
    }
    
    private func setMedia(_ media: [IImage]) {
        DispatchQueue.main.async { [weak self] in
            self?.state.media = media
            self?.updateSaveButtonVisibility()
        }
    }
    
    private func addCategory(_ category: String) {
        guard !state.selectedCategories.contains(category), state.selectedCategories.count < 5 else { return }
        state.selectedCategories.append(category)
        state.searchInput = ""
        updateSaveButtonVisibility()
    }
    
    private func removeCategory(_ category: String) {
        state.selectedCategories.removeAll(where: { $0 == category })
        updateSaveButtonVisibility()
    }
    
    private func removePic(_ id: UUID) {
        state.media.removeAll(where: { $0.id == id })
        updateSaveButtonVisibility()
    }
    
    private func setCategoryInput(_ input: String) {
        state.searchInput = input
        
        if state.searchInput.isEmpty {
            state.filteredCategories = photoCategories
            return
        }
        
        state.filteredCategories = photoCategories.filter { $0.localizedCaseInsensitiveContains(state.searchInput) }
        updateSaveButtonVisibility()
    }
    
    private func setDescriptionInput(_ input: String) {
        state.description = input
        updateSaveButtonVisibility()
    }
    
    private func setName(_ name: String) {
        state.name = name
        updateSaveButtonVisibility()
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
    }
    
    private func createNewPortfolio() async {
        guard !state.description.isEmpty, !state.media.isEmpty, !state.selectedCategories.isEmpty else { return }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            try await createPortfolioUseCase.execute(
                creatorId: state.creatorId,
                name: state.name,
                photos: state.media,
                description: state.description,
                category: state.selectedCategories
            )
            
            await flowController?.updateProfileFlowDelegate?.fetchProfileData(refresh: true)
            dismissView()
        } catch {
            
        }
    }
    
    private func updateSaveButtonVisibility() {
        if !state.name.isEmpty, !state.description.isEmpty, !state.selectedCategories.isEmpty, !media.isEmpty {
            state.isSaveButtonDisabled = false
            return
        }
        
        state.isSaveButtonDisabled = true
    }
    
    private func saveChanges() async {
        state.portfolioIntent == .createNew ? await createNewPortfolio() : await updatePortfolio()
    }
    
    private func updatePortfolio() async {
        guard let portfolioId = state.portfolioId,
              !state.description.isEmpty,
              !state.name.isEmpty,
              !state.media.isEmpty,
              !state.selectedCategories.isEmpty
        else {
            return
        }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            let updated = try await updatePortfolioUseCase.execute(
                id: portfolioId,
                name: state.name,
                photos: state.media.compactMap { photo in
                    switch photo.src {
                    case .remote(let url):
                        return url
                    default:
                        return nil
                    }
                },
                description: state.description,
                category: state.selectedCategories
            )
            
            updatePortfolioProfileFlowDelegate?.updatePortfolios(with: updated)
            dismissView()
        } catch {
            
        }
    }
    
    private func onAlertDataChanged(alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func cancelEdit() {
        if state.isSaveButtonDisabled {
            dismissView()
            return
        }
        
        state.alertData = .init(
            title: L.Profile.goBack,
            message: nil,
            primaryAction: .init(
                title: L.Profile.cancel,
                style: .cancel,
                handler: { [weak self] in
                    self?.state.alertData = nil
                }
            ),
            secondaryAction: .init(
                title: L.Profile.yesCancel,
                style: .destruction,
                handler: { [weak self] in
                    self?.dismissView()
                }
            )
        )
    }
}

extension EditPortfolioViewModel: MediaPickerSource {
    var media: Binding<[IImage]> {
        Binding<[IImage]>(
            get: { [weak self] in self?.state.media ?? [] },
            set: { [weak self] media in self?.setMedia(media) }
        )
    }
}
