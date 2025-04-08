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
