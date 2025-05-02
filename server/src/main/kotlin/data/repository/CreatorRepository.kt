package data.repository

import data.source.FirestoreSource
import domain.model.Creator
import domain.model.User
import domain.model.toMap
import domain.repository.CreatorRepository
import cz.cvut.fit.config.*
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import cz.cvut.fit.config.AppConstants.Messages

class CreatorRepositoryImpl(
    private val firestoreSource: FirestoreSource
) : CreatorRepository {

    override suspend fun createCreator(creator: Creator): String {
        val creatorId = firestoreSource.createDocument(Collections.CREATORS, creator.toMap())
        if (!firestoreSource.updateDocument(
                Collections.USERS,
                creator.userId,
                mapOf(Fields.CREATOR_ID to creatorId)
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_CREATOR_ID)
        }
        return creatorId
    }

    override suspend fun getCreatorById(creatorId: String): Creator {
        return firestoreSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)?.copy(id = creatorId)
            ?: throw NotFoundException(Messages.CREATOR_NOT_FOUND)
    }

    override suspend fun getUserByCreatorId(creatorId: String): User {
        val creator = getCreatorById(creatorId)
        return firestoreSource.getDocument(Collections.USERS, creator.userId, User::class.java)
            ?: throw NotFoundException(Messages.USER_NOT_FOUND)
    }

    override suspend fun updateCreator(creatorId: String, creator: Creator): Boolean {
        return firestoreSource.setDocument(Collections.CREATORS, creatorId, creator.toMap())
    }

    override suspend fun updateCreatorFields(creatorId: String, fields: Map<String, Any>): Boolean {
        val filteredFields = fields.filterKeys { it in listOf(Fields.YEARS_EXPERIENCE, Fields.DESCRIPTION) }
        if (filteredFields.isEmpty()) {
            return false
        }
        return firestoreSource.updateDocument(Collections.CREATORS, creatorId, filteredFields)
    }
}