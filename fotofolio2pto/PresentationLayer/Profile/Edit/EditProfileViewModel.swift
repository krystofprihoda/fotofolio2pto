//
//  EditProfileViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import Foundation
import SwiftUI

final class EditProfileViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    // UCs

    private weak var flowController: ProfileFlowController?

    // MARK: Init

    init(
        flowController: ProfileFlowController?,
        userData: User,
        portfolios: [Portfolio]
    ) {
        self.flowController = flowController
        super.init()
        state.userData = userData
        state.portfolios = portfolios
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var isLoading: Bool = false
        var userData: User? = nil
        var portfolios: [Portfolio] = []
        var portfolioTagsInput = ""
        var newPortfolio: Portfolio? = nil
        var mediaFromPicker: [IImage] = []
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case pickProfilePicture
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .pickProfilePicture: pickProfilePicture()
            }
        })
    }

    // MARK: Additional methods

    private func pickProfilePicture() {
        flowController?.presentPickerModal(source: self)
    }
    
    private func setMedia(_ media: [IImage]) {
        state.mediaFromPicker = media
    }
    
    
}

extension EditProfileViewModel: MediaPickerSource {
    var media: Binding<[IImage]> {
        Binding<[IImage]>(
            get: { [weak self] in self?.state.mediaFromPicker ?? [] },
            set: { [weak self] media in self?.setMedia(media) }
        )
    }
}
