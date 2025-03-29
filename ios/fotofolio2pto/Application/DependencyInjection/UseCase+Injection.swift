//
//  UseCase+Injection.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation
import Resolver

public extension Resolver {
    static func registerUseCases() {
        /// Auth
        register { LogoutUseCaseImpl(authRepository: resolve()) as LogoutUseCase }
        register { LoginWithCredentialsUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as LoginWithCredentialsUseCase }
        register { GetLoggedInUserUseCaseImpl(authRepository: resolve()) as GetLoggedInUserUseCase }
        register { RegisterUserUseCaseImpl(authRepository: resolve()) as RegisterUserUseCase }
        
        /// User
//        register { GetUserDataFromUsernameUseCaseImpl(userRepository: resolve()) as GetUserDataFromUsernameUseCase }
        register { GetUserPortfoliosUseCaseImpl(feedRepository: resolve()) as GetUserPortfoliosUseCase }
        register { ReadUsersFromQueryUseCaseImpl(userRepository: resolve()) as ReadUsersFromQueryUseCase }
        register { CheckEmailAddressAvailableUseCaseImpl(authRepository: resolve()) as CheckEmailAddressAvailableUseCase }
        register { CheckUsernameAvailableUseCaseImpl(userRepository: resolve()) as CheckUsernameAvailableUseCase }
        register { SaveUserDataUseCaseImpl(userRepository: resolve()) as SaveUserDataUseCase }
        register { ReadUserByIdUseCaseImpl(userRepository: resolve()) as ReadUserByIdUseCase }
        register { SaveSignedInUsernameUseCaseImpl(userRepository: resolve()) as SaveSignedInUsernameUseCase }
        register { GetSignedInUsernameUseCaseImpl(userRepository: resolve()) as GetSignedInUsernameUseCase }
        
        /// Creator
        register { CreateCreatorDataUseCaseImpl(creatorRepository: resolve()) as CreateCreatorDataUseCase }
        register { ReadCreatorDataUseCaseImpl(creatorRepository: resolve()) as ReadCreatorDataUseCase }
        
        /// Portfolios
        register { GetAllPortfoliosUseCaseImpl(feedRepository: resolve()) as GetAllPortfoliosUseCase }
        register { FlagPortfolioUseCaseImpl(feedRepository: resolve()) as FlagPortfolioUseCase }
        register { UnflagPortfolioUseCaseImpl(feedRepository: resolve()) as UnflagPortfolioUseCase }
        register { GetFlaggedPortfoliosUseCaseImpl(feedRepository: resolve()) as GetFlaggedPortfoliosUseCase }
        register { UnflagAllPortfoliosUseCaseImpl(feedRepository: resolve()) as UnflagAllPortfoliosUseCase }
        register { GetFilteredPortfoliosUseCaseImpl(feedRepository: resolve()) as GetFilteredPortfoliosUseCase }
        register { CreatePortfolioUseCaseImpl(feedRepository: resolve()) as CreatePortfolioUseCase }
        register { UpdatePortfolioUseCaseImpl(feedRepository: resolve()) as UpdatePortfolioUseCase }
        
        /// Messages
        register { GetChatsForUserUseCaseImpl(messageRepository: resolve()) as GetChatsForUserUseCase }
//        register { CreateNewChatUseCaseImpl(messageRepository: resolve(), userRepository: resolve()) as CreateNewChatUseCase }
        register { SendMessageUseCaseImpl(messageRepository: resolve()) as SendMessageUseCase }
        register { GetLatestChatMessagesUseCaseImpl(messageRepository: resolve()) as GetLatestChatMessagesUseCase }
//        register { GetChatUseCaseImpl(messageRepository: resolve(), userRepository: resolve()) as GetChatUseCase }
    }
}
