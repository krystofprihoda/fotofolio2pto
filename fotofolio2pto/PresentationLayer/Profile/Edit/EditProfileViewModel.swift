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
        state.username = userData.username
        state.fullName = userData.fullName
        state.profilePicture = userData.profilePicture
        state.yearsOfExperience = userData.creator?.yearsOfExperience ?? 5
        state.profileDescription = userData.creator?.profileText ?? ""
        state.isCreator = userData.isCreator
        state.portfolios = portfolios
        state.rawUserData = userData
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State: Equatable {
        var isLoading = false
        var username = ""
        var fullName = ""
        var isCreator = false
        var profilePicture: IImage? = nil
        var yearsOfExperience: Int = 2
        var profileDescription = ""
        var location = ""
        var portfolios: [Portfolio] = []
        var rawUserData: User? = nil
        var portfolioTagsInput = ""
        var newPortfolio: Portfolio? = nil
        var mediaFromPicker: [IImage] = []
        var removedPortfolios: [Int] = []
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case pickProfilePicture
        case setLocation(String)
        case setYearsOfExperience(Int)
        case setProfileDescription(String)
        case editPorfolio(Portfolio)
        case removePortfolio(Int)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .pickProfilePicture: pickProfilePicture()
            case .setLocation(let location): setLocation(location)
            case .setYearsOfExperience(let yoe): setYearsOfExperience(yoe)
            case .setProfileDescription(let description): setProfileDescription(description)
            case .editPorfolio(let portfolio): presentEditPortfolio(portfolio)
            case .removePortfolio(let id): addToRemoved(id)
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
    
    private func setLocation(_ location: String) {
        state.location = location
    }
    
    private func setYearsOfExperience(_ yoe: Int) {
        state.yearsOfExperience = yoe
    }
    
    private func setProfileDescription(_ description: String) {
        state.profileDescription = description
    }
    
    private func presentEditPortfolio(_ portfolio: Portfolio) {
        flowController?.showEditPortfolio(portfolio)
    }
    
    private func addToRemoved(_ portfolio: Int) {
        state.removedPortfolios.append(portfolio)
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
