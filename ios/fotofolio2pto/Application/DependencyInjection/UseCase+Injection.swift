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
        register { ReadLoggedInUserUseCaseImpl(authRepository: resolve()) as ReadLoggedInUserUseCase }
        register { RegisterUserUseCaseImpl(authRepository: resolve()) as RegisterUserUseCase }
        register { ReadLastSignedInEmailUseCaseImpl(authRepository: resolve()) as ReadLastSignedInEmailUseCase }
        
        /// User
        register { ReadCreatorPortfoliosUseCaseImpl(creatorRepository: resolve()) as ReadCreatorPortfoliosUseCase }
        register { ReadUsersFromQueryUseCaseImpl(userRepository: resolve()) as ReadUsersFromQueryUseCase }
        register { CheckEmailAddressAvailableUseCaseImpl(authRepository: resolve()) as CheckEmailAddressAvailableUseCase }
        register { CheckUsernameAvailableUseCaseImpl(userRepository: resolve()) as CheckUsernameAvailableUseCase }
        register { SaveUserDataUseCaseImpl(userRepository: resolve()) as SaveUserDataUseCase }
        register { ReadUserByIdUseCaseImpl(userRepository: resolve()) as ReadUserByIdUseCase }
        register { SaveUserProfilePictureUseCaseImpl(userRepository: resolve()) as SaveUserProfilePictureUseCase }
        register { UpdateUserDataUseCaseImpl(userRepository: resolve()) as UpdateUserDataUseCase }
        register { GiveRatingUseCaseImpl(userRepository: resolve()) as GiveRatingUseCase }
        
        /// Creator
        register { CreateCreatorDataUseCaseImpl(creatorRepository: resolve()) as CreateCreatorDataUseCase }
        register { ReadCreatorDataUseCaseImpl(creatorRepository: resolve()) as ReadCreatorDataUseCase }
        register { ReadUserDataByCreatorIdUseCaseImpl(creatorRepository: resolve()) as ReadUserDataByCreatorIdUseCase }
        register { UpdateCreatorDataUseCaseImpl(creatorRepository: resolve()) as UpdateCreatorDataUseCase }
        
        /// Portfolios
        register { ReadAllPortfoliosUseCaseImpl(portfolioRepository: resolve()) as ReadAllPortfoliosUseCase }
        register { FlagPortfolioUseCaseImpl(portfolioRepository: resolve()) as FlagPortfolioUseCase }
        register { UnflagPortfolioUseCaseImpl(portfolioRepository: resolve()) as UnflagPortfolioUseCase }
        register { ReadFlaggedPortfoliosUseCaseImpl(portfolioRepository: resolve()) as ReadFlaggedPortfoliosUseCase }
        register { UnflagAllPortfoliosUseCaseImpl(portfolioRepository: resolve()) as UnflagAllPortfoliosUseCase }
        register { CreatePortfolioUseCaseImpl(portfolioRepository: resolve()) as CreatePortfolioUseCase }
        register { UpdatePortfolioUseCaseImpl(portfolioRepository: resolve()) as UpdatePortfolioUseCase }
        register { ReadRemoteImageUseCaseImpl(portfolioRepository: resolve()) as ReadRemoteImageUseCase }
        register { RemovePortfolioUseCaseImpl(portfolioRepository: resolve()) as RemovePortfolioUseCase }
        
        /// Messages
        register { CreateNewChatWithMessageUseCaseImpl(messageRepository: resolve()) as CreateNewChatWithMessageUseCase }
        register { SendMessageUseCaseImpl(messageRepository: resolve()) as SendMessageUseCase }
        register { ReadChatUseCaseImpl(messageRepository: resolve()) as ReadChatUseCase }
        register { ReadChatsUseCaseImpl(messageRepository: resolve()) as ReadChatsUseCase }
        register { ReadMessagesFromChatUseCaseImpl(messageRepository: resolve()) as ReadMessagesFromChatUseCase }
    }
}
