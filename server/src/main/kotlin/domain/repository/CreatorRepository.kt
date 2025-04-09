package domain.repository

import domain.model.Creator
import domain.model.User

interface CreatorRepository {
    suspend fun createCreator(creator: Creator): String
    suspend fun getCreatorById(creatorId: String): Creator
    suspend fun getUserByCreatorId(creatorId: String): User
    suspend fun updateCreator(creatorId: String, creator: Creator): Boolean
    suspend fun updateCreatorFields(creatorId: String, fields: Map<String, Any>): Boolean
}