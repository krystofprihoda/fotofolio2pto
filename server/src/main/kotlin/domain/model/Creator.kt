package domain.model

import kotlinx.serialization.Serializable
import cz.cvut.fit.config.AppConstants.DefaultValues.PROFILE_DESCRIPTION

@Serializable
data class Creator(
    val id: String = "",
    val userId: String = "",
    val yearsOfExperience: Int = 1,
    val description: String = PROFILE_DESCRIPTION,
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