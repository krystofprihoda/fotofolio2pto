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

final class EditPortfolioViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    @LazyInjected private var createPortfolioUseCase: CreatePortfolioUseCase
    @LazyInjected private var updatePortfolioUseCase: UpdatePortfolioUseCase

    private weak var flowController: ProfileFlowController?

    // MARK: Init

    init(
        flowController: ProfileFlowController?,
        portfolioAuthorUsername: String,
        intent: PortfolioIntent = .createNew
    ) {
        self.flowController = flowController
        super.init()
        state.portfolioAuthor = portfolioAuthorUsername
        state.portfolioIntent = intent
        
        switch state.portfolioIntent {
        case .createNew:
            return
        case .updateExisting(let portfolio):
            state.portfolioId = portfolio.id
            state.name = portfolio.name
            state.description = portfolio.description
            state.media = portfolio.photos
            state.selectedTags = portfolio.tags
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
        var portfolioAuthor = ""
        var portfolioId: Int? = nil
        var name = ""
        var description = ""
        var media: [IImage] = []
        var selectedTags: [String] = []
        var filteredTags = photoCategories
        var searchInput = ""
        var isSaveButtonDisabled = true
        var alertData: AlertData? = nil
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case pickMedia
        case createNewPortfolio
        case addTag(String)
        case close
        case setName(String)
        case setTagInput(String)
        case removeTag(String)
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
            case .addTag(let tag): addTag(tag)
            case .close: cancelEdit()
            case .setName(let name): setName(name)
            case .setDescriptionInput(let input): setDescriptionInput(input)
            case .setTagInput(let input): setTagInput(input)
            case .removeTag(let tag): removeTag(tag)
            case .saveChanges: await saveChanges()
            case .onAlertDataChanged(let alertData): onAlertDataChanged(alertData: alertData)
            }
        })
    }

    // MARK: Additional methods

    private func pickMedia() {
        flowController?.presentPickerModal(source: self)
    }
    
    private func setMedia(_ media: [IImage]) {
        DispatchQueue.main.async { [weak self] in
            self?.state.media = media
            self?.updateSaveButtonVisibility()
        }
    }
    
    private func addTag(_ tag: String) {
        guard !state.selectedTags.contains(tag), state.selectedTags.count < 5 else { return }
        state.selectedTags.append(tag)
        state.searchInput = ""
        updateSaveButtonVisibility()
    }
    
    private func removeTag(_ tag: String) {
        state.selectedTags.removeAll(where: { $0 == tag })
        updateSaveButtonVisibility()
    }
    
    private func setTagInput(_ input: String) {
        state.searchInput = input
        
        if state.searchInput.isEmpty {
            state.filteredTags = photoCategories
            return
        }
        
        state.filteredTags = photoCategories.filter { $0.localizedCaseInsensitiveContains(state.searchInput) }
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
        guard !state.description.isEmpty, !state.media.isEmpty, !state.selectedTags.isEmpty else { return }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            try await createPortfolioUseCase.execute(
                username: state.portfolioAuthor,
                name: state.name,
                photos: state.media,
                description: state.description,
                tags: state.selectedTags
            )
            dismissView()
        } catch {
            
        }
    }
    
    private func updateSaveButtonVisibility() {
        if !state.name.isEmpty, !state.description.isEmpty, !state.selectedTags.isEmpty, !media.isEmpty {
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
              !state.media.isEmpty,
              !state.selectedTags.isEmpty
        else {
            return
        }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            try await updatePortfolioUseCase.execute(
                id: portfolioId,
                name: state.name,
                photos: state.media,
                description: state.description,
                tags: state.selectedTags
            )
            dismissView()
        } catch {
            
        }
    }
    
    private func onAlertDataChanged(alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func cancelEdit() {
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
