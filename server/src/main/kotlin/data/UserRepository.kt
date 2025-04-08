package data

import domain.model.User
import domain.repository.UserRepository
import com.google.firebase.cloud.FirestoreClient
import data.source.FirestoreSource
import data.source.StorageSource

internal class UserRepositoryImpl(
    private val firestoreSource: FirestoreSource,
     private val storageSource: StorageSource
) : UserRepository {

    override suspend fun isUsernameAvailable(username: String): Boolean {
        return !firestoreSource.checkDocumentExists("username", username)
    }

    override suspend fun createUser(userData: Map<String, String>): User {
        val id = firestoreSource.createDocument("user", userData)
        firestoreSource.createDocument("username", mapOf("userId" to id))
        return firestoreSource.getDocument("user", id, User::class.java) ?: throw Exception("Creating user failed")
    }

    override suspend fun getUserById(userId: String): User {
        return firestoreSource.getDocument("user", userId, User::class.java) ?: throw Exception("User not found")
    }

    override suspend fun updateUser(userId: String, userData: Map<String, String>): User {
        firestoreSource.setDocument("user", userId, userData)
        return firestoreSource.getDocument("user", userId, User::class.java) ?: throw Exception("Failed to retrieve updated user")
    }

    override suspend fun updateUserFields(userId: String, fields: Map<String, String>): Boolean {
        val filteredFields = fields.filterKeys { it in listOf("location") }
        return if (filteredFields.isEmpty()) false
        else firestoreSource.updateDocument("user", userId, filteredFields)
    }

    override suspend fun uploadProfilePicture(userId: String, imageBytes: ByteArray): String {
        val path = "user/$userId/profilepicture.jpeg"
        val downloadUrl = storageSource.uploadFile(path, imageBytes, "image/jpeg")
        firestoreSource.updateDocument("user", userId, mapOf("profilePicture" to downloadUrl))
        return downloadUrl
    }

    override suspend fun rateUser(receiverId: String, raterId: String, rating: Int): Boolean {
        val user = firestoreSource.getDocument("user", receiverId, User::class.java) ?: throw Exception("User not found")
        val currentRatings = user.rating.toMutableMap()
        currentRatings[raterId] = rating
        return firestoreSource.updateDocument("user", receiverId, mapOf("rating" to currentRatings))
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