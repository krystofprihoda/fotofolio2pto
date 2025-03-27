//
//  EditProfileViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import Foundation
import Resolver
import SwiftUI

final class EditProfileViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    @LazyInjected private var getCreatorDataUseCase: GetCreatorDataUseCase

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
        state.location = userData.location
        state.profilePicture = userData.profilePicture
        state.isCreator = userData.isCreator
        state.creatorId = userData.creatorId
        state.portfolios = portfolios
        state.rawUserData = userData
        
        fetchCreatorData()
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
        var creatorId: String? = nil
        var profilePicture: IImage? = nil
        var yearsOfExperience: Int = 2
        var profileDescription = ""
        var location = ""
        var portfolios: [Portfolio] = []
        var rawUserData: User? = nil
        var portfolioTagsInput = ""
        var mediaFromPicker: [IImage] = []
        var removedPortfolios: [Int] = []
        var isSaveButtonDisabled = true
        var alertData: AlertData? = nil
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
        case onAlertDataChanged(AlertData?)
        case saveChanges
        case cancel
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
            case .onAlertDataChanged(let alertData): setAlertData(alertData)
            case .saveChanges: saveChanges()
            case .cancel: cancelEdit()
            }
        })
    }

    // MARK: Additional methods
    
    private func fetchCreatorData() {
        guard let creatorId = state.creatorId else {
            return
        }
        
        executeTask(Task {
            do {
                let creatorData: Creator = try await getCreatorDataUseCase.execute(id: creatorId)
                
                state.yearsOfExperience = creatorData.yearsOfExperience
                state.profileDescription = creatorData.profileText
            } catch { }
        })
    }

    private func pickProfilePicture() {
        flowController?.presentPickerModal(source: self)
    }
    
    private func setMedia(_ media: [IImage]) {
        state.mediaFromPicker = media
        updateSaveButtonVisibility()
    }
    
    private func setLocation(_ location: String) {
        state.location = location
        updateSaveButtonVisibility()
    }
    
    private func setYearsOfExperience(_ yoe: Int) {
        state.yearsOfExperience = yoe
        updateSaveButtonVisibility()
    }
    
    private func setProfileDescription(_ description: String) {
        state.profileDescription = description
        updateSaveButtonVisibility()
    }
    
    private func presentEditPortfolio(_ portfolio: Portfolio) {
        flowController?.showEditPortfolio(portfolio, author: state.username)
        updateSaveButtonVisibility()
    }
    
    private func addToRemoved(_ portfolio: Int) {
        state.removedPortfolios.append(portfolio)
        updateSaveButtonVisibility()
    }
    
    private func setAlertData(_ alertData: AlertData?) {
        state.alertData = alertData
        updateSaveButtonVisibility()
    }
    
    private func updateSaveButtonVisibility() {
        if state.profilePicture != nil, !state.profileDescription.isEmpty, !state.location.isEmpty, !media.isEmpty {
            state.isSaveButtonDisabled = false
            return
        }
        
        state.isSaveButtonDisabled = true
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
    
    private func saveChanges() {
        #warning("TODO: Update profile info")
        #warning("TODO: Remove portfolios to be removed")
        
        dismissView()
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
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
