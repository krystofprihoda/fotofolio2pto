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

    @LazyInjected private var readCreatorDataUseCase: ReadCreatorDataUseCase
    @LazyInjected private var updateUserDataUseCase: UpdateUserDataUseCase
    @LazyInjected private var saveUserProfilePictureUseCase: SaveUserProfilePictureUseCase
    @LazyInjected private var updateCreatorDataUseCase: UpdateCreatorDataUseCase

    private weak var flowController: ProfileFlowController?

    // MARK: Init

    init(
        flowController: ProfileFlowController?,
        userData: User
    ) {
        self.flowController = flowController
        super.init()
        state.username = userData.username
        state.fullName = userData.fullName
        state.location = userData.location
        state.updatedLocation = userData.location
        state.profilePicture = userData.profilePicture
        state.isCreator = userData.isCreator
        state.creatorId = userData.creatorId
        state.rawUserData = userData
        
        fetchCreatorData()
    }

    // MARK: Lifecycle

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
        var updatedLocation = ""
        var rawUserData: User? = nil
        var isSaveButtonDisabled = true
        var alertData: AlertData? = nil
        var toastData: ToastData? = nil
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case pickProfilePicture
        case setLocation(String)
        case setYearsOfExperience(Int)
        case setProfileDescription(String)
        case onAlertDataChanged(AlertData?)
        case setToastData(ToastData?)
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
            case .onAlertDataChanged(let alertData): setAlertData(alertData)
            case .setToastData(let toast): setToastData(toast)
            case .saveChanges: await saveChanges()
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
                let creatorData: Creator = try await readCreatorDataUseCase.execute(id: creatorId)
                
                state.yearsOfExperience = creatorData.yearsOfExperience
                state.profileDescription = creatorData.description
            } catch {
                state.toastData = .init(message: L.Profile.profileLoadFailed, type: .error)
            }
        })
    }

    private func pickProfilePicture() {
        flowController?.presentPickerModal(source: self, limit: 1)
    }
    
    private func setMedia(_ media: [IImage]) {
        guard let image = media.first else { return }
        state.profilePicture = image
        updateSaveButtonVisibility()
    }
    
    private func setLocation(_ location: String) {
        state.updatedLocation = location
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
    
    private func setAlertData(_ alertData: AlertData?) {
        state.alertData = alertData
        updateSaveButtonVisibility()
    }
    
    private func setToastData(_ toast: ToastData?) {
        state.toastData = toast
    }
    
    private func updateSaveButtonVisibility() {
        state.isSaveButtonDisabled = false
    }
    
    private func cancelEdit() {
        guard !state.isSaveButtonDisabled else {
            dismissView()
            return
        }
        
        state.alertData = .init(
            title: L.Profile.goBack,
            message: nil,
            primaryAction: .init(
                title: L.General.cancel,
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
    
    private func saveChanges() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        // update user data
        if state.updatedLocation != state.location {
            do {
                try await updateUserDataUseCase.execute(location: state.updatedLocation)
            } catch {
                state.toastData = .init(message: L.Profile.profileUpdateFailed, type: .error)
            }
        }
        
        if let creatorId = state.creatorId {
            do {
                try await updateCreatorDataUseCase
                    .execute(
                        creatorId: creatorId,
                        yearsOfExperience: state.yearsOfExperience,
                        profileDescription: state.profileDescription
                    )
            } catch {
                state.toastData = .init(message: L.Profile.profileUpdateFailed, type: .error)
            }
        }
        
        // save profile image if displayed type == .local
        if let profilePicture = state.profilePicture?.src, case .local(let image) = profilePicture {
            do {
                try await saveUserProfilePictureUseCase.execute(image: image)
            } catch {
                state.toastData = .init(message: L.Profile.profilePicUpdateFailed, type: .error)
            }
        }
        
        await flowController?.updateProfileFlowDelegate?.fetchProfileData(refresh: true)
        dismissView()
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
    }
}

extension EditProfileViewModel: MediaPickerSource {
    var media: Binding<[IImage]> {
        Binding<[IImage]>(
            get: { [weak self] in
                guard let profilePic = self?.state.profilePicture else { return [] }
                return [profilePic]
            },
            set: { [weak self] media in
                self?.setMedia(media)
            }
        )
    }
}
