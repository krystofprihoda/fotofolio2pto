package fotofolio

import org.koin.dsl.module
import io.ktor.server.application.*
import data.UserRepositoryImpl
import domain.repository.UserRepository

val serverModule = module(createdAtStart = true) {
    // Repositories
    single<UserRepository> { UserRepositoryImpl() }
}