package domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Creator(
    val id: String = "",
    val userId: String = "",
    val yearsOfExperience: Int = 1,
    val description: String = "Profilový popis",
    val portfolioIds: List<String> = emptyList()
)

fun Creator.toMap(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "userId" to userId,
        "yearsOfExperience" to yearsOfExperience,
        "description" to description,
        "portfolioIds" to portfolioIds
    )
}