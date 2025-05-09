package domain.model

import kotlinx.serialization.Serializable
import cz.cvut.fit.config.AppConstants.DefaultValues.UNKNOWN_LOCATION

@Serializable
data class User(
    val id: String = "",
    val username: String = "",
    val email: String = "",
    val fullName: String = "",
    val location: String = UNKNOWN_LOCATION,
    val profilePicture: String = "",
    val rating: Map<String, Int> = emptyMap(),
    val creatorId: String = ""
)

fun User.toMap(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "username" to username,
        "email" to email,
        "fullName" to fullName,
        "location" to location,
        "profilePicture" to profilePicture,
        "rating" to rating,
        "creatorId" to creatorId
    )
}