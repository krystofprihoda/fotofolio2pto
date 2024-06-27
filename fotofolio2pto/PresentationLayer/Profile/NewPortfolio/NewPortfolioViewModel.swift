//
//  NewPortfolioViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import Foundation
import SwiftUI
import Resolver

final class NewPortfolioViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    @LazyInjected private var createPortfolioUseCase: CreatePortfolioUseCase

    private weak var flowController: ProfileFlowController?

    // MARK: Init

    init(
        flowController: ProfileFlowController?,
        userData: User
    ) {
        self.flowController = flowController
        super.init()
        state.userData = userData
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var isLoading: Bool = false
        var userData: User! = nil
        var name = ""
        var description = ""
        var media: [IImage] = []
        var tags: [String] = []
        var tagInput = ""
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case pickMedia
        case createNewPortfolio
        case addTag
        case close
        case setName(String)
        case setTagInput(String)
        case removeTag(String)
        case setDescriptionInput(String)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .pickMedia: pickMedia()
            case .createNewPortfolio: await createNewPortfolio()
            case .addTag: addTag()
            case .close: dismissView()
            case .setName(let name): setName(name)
            case .setDescriptionInput(let input): setDescriptionInput(input)
            case .setTagInput(let input): setTagInput(input)
            case .removeTag(let tag): removeTag(tag)
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
        }
    }
    
    private func addTag() {
        guard !state.tags.contains(state.tagInput), !state.tagInput.isEmpty else { return }
        state.tags.append(state.tagInput)
        state.tagInput = ""
    }
    
    private func removeTag(_ tag: String) {
        state.tags.removeAll(where: { $0 == tag })
    }
    
    private func setTagInput(_ input: String) {
        state.tagInput = input
    }
    
    private func setDescriptionInput(_ input: String) {
        state.description = input
    }
    
    private func setName(_ name: String) {
        state.name = name
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
    }
    
    private func createNewPortfolio() async {
        guard !state.description.isEmpty, !state.media.isEmpty, !state.tags.isEmpty else { return }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            try await createPortfolioUseCase.execute(
                for: state.userData,
                name: state.name,
                photos: state.media,
                description: state.description,
                tags: state.tags
            )
            dismissView()
        } catch {
            
        }
    }
}

extension NewPortfolioViewModel: MediaPickerSource {
    var media: Binding<[IImage]> {
        Binding<[IImage]>(
            get: { [weak self] in self?.state.media ?? [] },
            set: { [weak self] media in self?.setMedia(media) }
        )
    }
}
