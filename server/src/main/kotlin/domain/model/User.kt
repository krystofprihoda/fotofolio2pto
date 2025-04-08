package domain.model

import kotlinx.serialization.Serializable

@Serializable
data class User(
    val userId: String = "",
    val username: String = "",
    val email: String = "",
    val fullName: String = "",
    val location: String = "Neznámé místo působení",
    val profilePicture: String = "",
    val rating: Map<String, Int> = emptyMap(),
    val creatorId: String = ""
)