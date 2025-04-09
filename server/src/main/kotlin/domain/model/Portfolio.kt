package domain.model

import kotlinx.serialization.Serializable
import java.net.URL

@Serializable
data class Portfolio(
    val id: String = "",
    val creatorId: String = "",
    val authorUsername: String = "",
    val name: String = "",
    val description: String = "",
    val photos: List<String> = emptyList(),
    val category: List<String> = emptyList(),
    val timestamp: Long = System.currentTimeMillis()
)

fun Portfolio.toMap(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "creatorId" to creatorId,
        "authorUsername" to authorUsername,
        "name" to name,
        "description" to description,
        "photos" to photos,
        "category" to category,
        "timestamp" to timestamp
    )
}