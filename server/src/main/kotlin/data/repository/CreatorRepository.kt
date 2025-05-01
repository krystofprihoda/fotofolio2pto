package data.repository

import data.source.FirestoreSource
import domain.model.Creator
import domain.model.User
import domain.model.toMap
import domain.repository.CreatorRepository
import cz.cvut.fit.config.*

class CreatorRepositoryImpl(
    private val firestoreSource: FirestoreSource
) : CreatorRepository {

    override suspend fun createCreator(creator: Creator): String {
        val creatorId = firestoreSource.createDocument("creator", creator.toMap())
        if (!firestoreSource.updateDocument("user", creator.userId, mapOf("creatorId" to creatorId))) {
            throw InternalServerException("Failed to update user with creator ID")
        }
        return creatorId
    }

    override suspend fun getCreatorById(creatorId: String): Creator {
        return firestoreSource.getDocument("creator", creatorId, Creator::class.java)?.copy(id = creatorId)
            ?: throw NotFoundException("Creator not found")
    }

    override suspend fun getUserByCreatorId(creatorId: String): User {
        val creator = getCreatorById(creatorId)
        return firestoreSource.getDocument("user", creator.userId, User::class.java)
            ?: throw NotFoundException("User not found")
    }

    override suspend fun updateCreator(creatorId: String, creator: Creator): Boolean {
        return firestoreSource.setDocument("creator", creatorId, creator.toMap())
    }

    override suspend fun updateCreatorFields(creatorId: String, fields: Map<String, Any>): Boolean {
        val filteredFields = fields.filterKeys { it in listOf("yearsOfExperience", "description") }
        if (filteredFields.isEmpty()) {
            return false
        }
        return firestoreSource.updateDocument("creator", creatorId, filteredFields)
    }
}