package data.repository

import domain.model.User
import domain.repository.UserRepository
import data.source.DatabaseSource
import data.source.StorageSource
import domain.model.toMap
import cz.cvut.fit.config.*
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.Storage

internal class UserRepositoryImpl(
    private val databaseSource: DatabaseSource,
    private val storageSource: StorageSource
) : UserRepository {

    override suspend fun isUsernameAvailable(username: String): Boolean {
        return !databaseSource.checkDocumentExists(Collections.USERNAMES, username)
    }

    override suspend fun createUser(userData: User): User {
        if (!databaseSource.setDocument(Collections.USERS, userData.id, userData.toMap())) {
            throw InternalServerException(Messages.FAILED_CREATE_USER)
        }

        if (!databaseSource.setDocument(
                Collections.USERNAMES,
                userData.username,
                mapOf(Fields.USER_ID to userData.id)
            )) {
            throw InternalServerException(Messages.FAILED_REGISTER_USERNAME)
        }

        return databaseSource.getDocument(Collections.USERS, userData.id, User::class.java)
            ?: throw InternalServerException(Messages.FAILED_CREATE_USER)
    }

    override suspend fun getUserById(userId: String): User {
        return databaseSource.getDocument(Collections.USERS, userId, User::class.java)
            ?: throw NotFoundException(Messages.USER_NOT_FOUND)
    }

    override suspend fun updateUser(userId: String, userData: Map<String, String>): User {
        if (!databaseSource.setDocument(Collections.USERS, userId, userData)) {
            throw InternalServerException(Messages.FAILED_UPDATE_USER)
        }

        return databaseSource.getDocument(Collections.USERS, userId, User::class.java)
            ?: throw NotFoundException(Messages.FAILED_RETRIEVE_UPDATED_USER)
    }

    override suspend fun updateUserFields(userId: String, fields: Map<String, String>): Boolean {
        val filteredFields = fields.filterKeys { it in listOf(Fields.LOCATION) }
        if (filteredFields.isEmpty()) {
            return false
        }

        return databaseSource.updateDocument(Collections.USERS, userId, filteredFields)
    }

    override suspend fun uploadProfilePicture(userId: String, imageBytes: ByteArray): String {
        val path = String.format(Storage.USER_PROFILE_PATH, userId)
        val downloadUrl = storageSource.uploadFile(path, imageBytes, Storage.CONTENT_TYPE_JPEG)

        if (!databaseSource.updateDocument(
                Collections.USERS,
                userId,
                mapOf(Fields.PROFILE_PICTURE to downloadUrl)
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_PROFILE_PIC)
        }

        return downloadUrl
    }

    override suspend fun rateUser(receiverId: String, raterId: String, rating: Int): Boolean {
        val user = databaseSource.getDocument(Collections.USERS, receiverId, User::class.java)
            ?: throw NotFoundException(Messages.USER_NOT_FOUND)

        val currentRatings = user.rating.toMutableMap()
        currentRatings[raterId] = rating

        if (!databaseSource.updateDocument(
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
            return databaseSource.getDocuments(Collections.USERS, User::class.java)
        }

        val usernameResults = databaseSource.queryDocumentsByPrefix(
            Collections.USERS,
            Fields.USERNAME,
            query,
            User::class.java
        )
        val fullNameResults = databaseSource.queryDocumentsByPrefix(
            Collections.USERS,
            Fields.FULL_NAME,
            query,
            User::class.java
        )
        val locationResults = databaseSource.queryDocumentsByPrefix(
            Collections.USERS,
            Fields.LOCATION,
            query,
            User::class.java
        )

        // Create a map to deduplicate by ID
        val uniqueUsers = mutableMapOf<String, User>()

        // Add all users to the map with ID as key to deduplicate
        usernameResults.forEach { uniqueUsers[it.id] = it }
        fullNameResults.forEach { uniqueUsers[it.id] = it }
        locationResults.forEach { uniqueUsers[it.id] = it }

        // Return only the unique values
        return uniqueUsers.values.toList()
    }
}