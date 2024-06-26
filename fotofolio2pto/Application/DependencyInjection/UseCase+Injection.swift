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
        register { LoginWithCredentialsUseCaseImpl(authRepository: resolve()) as LoginWithCredentialsUseCase }
        register { GetLoggedInUserUseCaseImpl(authRepository: resolve()) as GetLoggedInUserUseCase }
        
        /// User
        register { GetUserDataFromUsernameUseCaseImpl(userRepository: resolve()) as GetUserDataFromUsernameUseCase }
        register { GetUserPortfoliosUseCaseImpl(feedRepository: resolve()) as GetUserPortfoliosUseCase }
        
        /// Portfolios
        register { GetAllPortfoliosUseCaseImpl(feedRepository: resolve()) as GetAllPortfoliosUseCase }
        register { FlagPortfolioUseCaseImpl(feedRepository: resolve()) as FlagPortfolioUseCase }
        register { UnflagPortfolioUseCaseImpl(feedRepository: resolve()) as UnflagPortfolioUseCase }
        register { GetFlaggedPortfoliosUseCaseImpl(feedRepository: resolve()) as GetFlaggedPortfoliosUseCase }
        register { UnflagAllPortfoliosUseCaseImpl(feedRepository: resolve()) as UnflagAllPortfoliosUseCase }
        register { GetFilteredPortfoliosUseCaseImpl(feedRepository: resolve()) as GetFilteredPortfoliosUseCase }
        
        /// Messages
        register { GetChatsForUserUseCaseImpl(messageRepository: resolve()) as GetChatsForUserUseCase }
        register { CreateNewChatUseCaseImpl(messageRepository: resolve(), userRepository: resolve()) as CreateNewChatUseCase }
        register { SendMessageUseCaseImpl(messageRepository: resolve()) as SendMessageUseCase }
        register { GetLatestChatMessagesUseCaseImpl(messageRepository: resolve()) as GetLatestChatMessagesUseCase }
        register { GetChatUseCaseImpl(messageRepository: resolve(), userRepository: resolve()) as GetChatUseCase }
    }
}
