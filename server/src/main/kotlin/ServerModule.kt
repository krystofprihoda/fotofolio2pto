package fotofolio

import data.PortfolioRepositoryImpl
import org.koin.dsl.module
import data.UserRepositoryImpl
import domain.repository.PortfolioRepository
import domain.repository.UserRepository

val serverModule = module(createdAtStart = true) {
    // Repositories
    single<UserRepository> { UserRepositoryImpl() }
    single<PortfolioRepository> { PortfolioRepositoryImpl() }
}