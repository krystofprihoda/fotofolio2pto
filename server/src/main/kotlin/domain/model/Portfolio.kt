package domain.model

import kotlinx.serialization.Serializable
import java.net.URL

@Serializable
data class Portfolio(
    val id: String,
    val ownerId: String,
    var name: String = "",
    val description: String = "",
    val categories: List<String> = emptyList(),
    val photos: List<String> = emptyList()
) {
    companion object {
        fun mocks(): List<Portfolio> {
            return List(5) { index ->
                Portfolio(
                    id = "id$index",
                    ownerId = "id$index",
                    name = "Portfolio $index",
                    description = "Description for portfolio $index",
                    categories = listOf("Portrét", "Svatba"),
                    photos = emptyList()
                )
            }
        }
    }
}