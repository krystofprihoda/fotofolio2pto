package data

import domain.model.User
import domain.repository.UserRepository

internal class UserRepositoryImpl : UserRepository {
    override suspend fun getUsers(): List<User> {
        return User.mocks()
    }

    override suspend fun getUserById(id: String): User? {
        return User.mocks().find { user -> user.id == id }
    }

    override suspend fun createUser(id: User): User {
        return User.mocks().first()
    }

}