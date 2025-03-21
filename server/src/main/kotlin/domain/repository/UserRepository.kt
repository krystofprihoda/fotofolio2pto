package domain.repository

import domain.model.User

interface UserRepository {
    suspend fun getUsers(): List<User>
    suspend fun getUserById(id: String): User?
    suspend fun createUser(id: User): User
}