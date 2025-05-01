package data.repository

import domain.model.User
import domain.repository.UserRepository
import data.source.FirestoreSource
import data.source.StorageSource
import domain.model.toMap
import cz.cvut.fit.config.*

internal class UserRepositoryImpl(
    private val firestoreSource: FirestoreSource,
    private val storageSource: StorageSource
) : UserRepository {

    override suspend fun isUsernameAvailable(username: String): Boolean {
        return !firestoreSource.checkDocumentExists("username", username)
    }

    override suspend fun createUser(userData: User): User {
        if (!firestoreSource.setDocument("user", userData.id, userData.toMap())) {
            throw InternalServerException("Failed to create user document")
        }

        if (!firestoreSource.setDocument("username", userData.username, mapOf("userId" to userData.id))) {
            throw InternalServerException("Failed to register username")
        }

        return firestoreSource.getDocument("user", userData.id, User::class.java)
            ?: throw InternalServerException("Creating user failed")
    }

    override suspend fun getUserById(userId: String): User {
        return firestoreSource.getDocument("user", userId, User::class.java)
            ?: throw NotFoundException("User not found")
    }

    override suspend fun updateUser(userId: String, userData: Map<String, String>): User {
        if (!firestoreSource.setDocument("user", userId, userData)) {
            throw InternalServerException("Failed to update user")
        }

        return firestoreSource.getDocument("user", userId, User::class.java)
            ?: throw NotFoundException("Failed to retrieve updated user")
    }

    override suspend fun updateUserFields(userId: String, fields: Map<String, String>): Boolean {
        val filteredFields = fields.filterKeys { it in listOf("location") }
        if (filteredFields.isEmpty()) {
            return false
        }

        return firestoreSource.updateDocument("user", userId, filteredFields)
    }

    override suspend fun uploadProfilePicture(userId: String, imageBytes: ByteArray): String {
        val path = "user/$userId/profilepicture.jpeg"
        val downloadUrl = storageSource.uploadFile(path, imageBytes, "image/jpeg")

        if (!firestoreSource.updateDocument("user", userId, mapOf("profilePicture" to downloadUrl))) {
            throw InternalServerException("Failed to update profile picture URL")
        }

        return downloadUrl
    }

    override suspend fun rateUser(receiverId: String, raterId: String, rating: Int): Boolean {
        val user = firestoreSource.getDocument("user", receiverId, User::class.java)
            ?: throw NotFoundException("User not found")

        val currentRatings = user.rating.toMutableMap()
        currentRatings[raterId] = rating

        if (!firestoreSource.updateDocument("user", receiverId, mapOf("rating" to currentRatings))) {
            throw InternalServerException("Failed to update user rating")
        }

        return true
    }

    override suspend fun searchUsers(query: String?): List<User> {
        if (query.isNullOrBlank()) {
            return firestoreSource.getDocuments("user", User::class.java)
        }

        val queryLower = query.lowercase()
        val usernameResults = firestoreSource.queryDocumentsByPrefix("user", "username", queryLower, User::class.java)
        val fullNameResults = firestoreSource.queryDocumentsByPrefix("user", "fullName", queryLower, User::class.java)
        val locationResults = firestoreSource.queryDocumentsByPrefix("user", "location", queryLower, User::class.java)

        // Combine results and convert to User objects
        val combinedResults = mutableSetOf<User>()
        combinedResults.addAll(usernameResults)
        combinedResults.addAll(fullNameResults)
        combinedResults.addAll(locationResults)

        return combinedResults.toList()
    }
}