package domain.repository

import domain.model.User

interface UserRepository {
    suspend fun isUsernameAvailable(username: String): Boolean
    suspend fun createUser(userData: Map<String, String>): User
    suspend fun getUserById(userId: String): User
    suspend fun updateUser(userId: String, userData: Map<String, String>): User
    suspend fun updateUserFields(userId: String, fields: Map<String, String>): Boolean
    suspend fun uploadProfilePicture(userId: String, imageBytes: ByteArray): String
    suspend fun rateUser(receiverId: String, raterId: String, rating: Int): Boolean
    suspend fun searchUsers(query: String?): List<User>
}