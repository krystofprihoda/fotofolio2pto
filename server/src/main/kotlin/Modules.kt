import data.repository.CreatorRepositoryImpl
import data.repository.MessageRepositoryImpl
import data.repository.PortfolioRepositoryImpl
import org.koin.dsl.module
import data.repository.UserRepositoryImpl
import data.source.FirestoreSource
import data.source.StorageSource
import data.source.FirebaseFirestoreSource
import data.source.FirebaseStorageSource
import domain.repository.CreatorRepository
import domain.repository.MessageRepository
import domain.repository.PortfolioRepository
import domain.repository.UserRepository

val dataSourceModule = module {
    single<FirestoreSource> { FirebaseFirestoreSource() }
    single<StorageSource> { FirebaseStorageSource() }
}

val repositoryModule = module {
    single<UserRepository> { UserRepositoryImpl(get(), get()) }
    single<CreatorRepository> { CreatorRepositoryImpl(get()) }
    single<PortfolioRepository> { PortfolioRepositoryImpl(get(), get()) }
    single<MessageRepository> { MessageRepositoryImpl(get()) }
}

val appModule = module {
    includes(dataSourceModule, repositoryModule)
}