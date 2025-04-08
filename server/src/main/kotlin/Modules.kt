import org.koin.dsl.module
import data.UserRepositoryImpl
import data.source.FirestoreSource
import data.source.StorageSource
import data.source.FirebaseFirestoreSource
import data.source.FirebaseStorageSource
import domain.repository.UserRepository

val dataSourceModule = module {
    single<FirestoreSource> { FirebaseFirestoreSource() }
    single<StorageSource> { FirebaseStorageSource() }
}

val repositoryModule = module {
    single<UserRepository> { UserRepositoryImpl(get(), get()) }
}

val appModule = module {
    includes(dataSourceModule, repositoryModule)
}