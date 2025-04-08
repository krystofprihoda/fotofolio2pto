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
) {
    companion object {
        fun mocks(): List<Portfolio> {
            return List(5) { index ->
                Portfolio(
                    id = "id$index",
                    creatorId = "id$index",
                    name = "Portfolio $index",
                    description = "Description for portfolio $index",
                    category = listOf("Portrét", "Svatba"),
                    photos = emptyList()
                )
            }
        }
    }
}