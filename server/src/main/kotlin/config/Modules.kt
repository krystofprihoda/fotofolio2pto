package config

import cz.cvut.fit.application.mapper.DefaultRequestParser
import cz.cvut.fit.application.mapper.RequestParser
import data.repository.CreatorRepositoryImpl
import data.repository.MessageRepositoryImpl
import data.repository.PortfolioRepositoryImpl
import org.koin.dsl.module
import data.repository.UserRepositoryImpl
import data.source.DatabaseSource
import data.source.StorageSource
import data.source.FirestoreDatabaseSource
import data.source.CloudStorageSource
import domain.repository.CreatorRepository
import domain.repository.MessageRepository
import domain.repository.PortfolioRepository
import domain.repository.UserRepository

val dataSourceModule = module {
    single<DatabaseSource> { FirestoreDatabaseSource() }
    single<StorageSource> { CloudStorageSource() }
}

val repositoryModule = module {
    single<UserRepository> { UserRepositoryImpl(get(), get()) }
    single<CreatorRepository> { CreatorRepositoryImpl(get()) }
    single<PortfolioRepository> { PortfolioRepositoryImpl(get(), get()) }
    single<MessageRepository> { MessageRepositoryImpl(get()) }
}

val utilsModule = module {
    single<RequestParser> { DefaultRequestParser() }
}

val appModule = module {
    includes(dataSourceModule, repositoryModule, utilsModule)
}