package data.repository

import domain.model.User
import domain.repository.UserRepository
import data.source.FirestoreSource
import data.source.StorageSource
import domain.model.toMap
import cz.cvut.fit.config.*
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.Storage

internal class UserRepositoryImpl(
    private val firestoreSource: FirestoreSource,
    private val storageSource: StorageSource
) : UserRepository {

    override suspend fun isUsernameAvailable(username: String): Boolean {
        return !firestoreSource.checkDocumentExists(Collections.USERNAMES, username)
    }

    override suspend fun createUser(userData: User): User {
        if (!firestoreSource.setDocument(Collections.USERS, userData.id, userData.toMap())) {
            throw InternalServerException(Messages.FAILED_CREATE_USER)
        }

        if (!firestoreSource.setDocument(
                Collections.USERNAMES,
                userData.username,
                mapOf(Fields.USER_ID to userData.id)
            )) {
            throw InternalServerException(Messages.FAILED_REGISTER_USERNAME)
        }

        return firestoreSource.getDocument(Collections.USERS, userData.id, User::class.java)
            ?: throw InternalServerException(Messages.FAILED_CREATE_USER)
    }

    override suspend fun getUserById(userId: String): User {
        return firestoreSource.getDocument(Collections.USERS, userId, User::class.java)
            ?: throw NotFoundException(Messages.USER_NOT_FOUND)
    }

    override suspend fun updateUser(userId: String, userData: Map<String, String>): User {
        if (!firestoreSource.setDocument(Collections.USERS, userId, userData)) {
            throw InternalServerException(Messages.FAILED_UPDATE_USER)
        }

        return firestoreSource.getDocument(Collections.USERS, userId, User::class.java)
            ?: throw NotFoundException(Messages.FAILED_RETRIEVE_UPDATED_USER)
    }

    override suspend fun updateUserFields(userId: String, fields: Map<String, String>): Boolean {
        val filteredFields = fields.filterKeys { it in listOf(Fields.LOCATION) }
        if (filteredFields.isEmpty()) {
            return false
        }

        return firestoreSource.updateDocument(Collections.USERS, userId, filteredFields)
    }

    override suspend fun uploadProfilePicture(userId: String, imageBytes: ByteArray): String {
        val path = String.format(Storage.USER_PROFILE_PATH, userId)
        val downloadUrl = storageSource.uploadFile(path, imageBytes, Storage.CONTENT_TYPE_JPEG)

        if (!firestoreSource.updateDocument(
                Collections.USERS,
                userId,
                mapOf(Fields.PROFILE_PICTURE to downloadUrl)
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_PROFILE_PIC)
        }

        return downloadUrl
    }

    override suspend fun rateUser(receiverId: String, raterId: String, rating: Int): Boolean {
        val user = firestoreSource.getDocument(Collections.USERS, receiverId, User::class.java)
            ?: throw NotFoundException(Messages.USER_NOT_FOUND)

        val currentRatings = user.rating.toMutableMap()
        currentRatings[raterId] = rating

        if (!firestoreSource.updateDocument(
                Collections.USERS,
                receiverId,
                mapOf(Fields.RATING to currentRatings)
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_RATING)
        }

        return true
    }

    override suspend fun searchUsers(query: String?): List<User> {
        if (query.isNullOrBlank()) {
            return firestoreSource.getDocuments(Collections.USERS, User::class.java)
        }

        val queryLower = query.lowercase()
        val usernameResults = firestoreSource.queryDocumentsByPrefix(
            Collections.USERS,
            Fields.USERNAME,
            queryLower,
            User::class.java
        )
        val fullNameResults = firestoreSource.queryDocumentsByPrefix(
            Collections.USERS,
            Fields.FULL_NAME,
            queryLower,
            User::class.java
        )
        val locationResults = firestoreSource.queryDocumentsByPrefix(
            Collections.USERS,
            Fields.LOCATION,
            queryLower,
            User::class.java
        )

        // Combine results and convert to User objects
        val combinedResults = mutableSetOf<User>()
        combinedResults.addAll(usernameResults)
        combinedResults.addAll(fullNameResults)
        combinedResults.addAll(locationResults)

        return combinedResults.toList()
    }
}