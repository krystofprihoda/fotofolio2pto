package cz.cvut.fit.application.dto.portfolio

data class CreatePortfolioDTO(
    val creatorId: String,
    val name: String,
    val description: String,
    val category: List<String>,
    val photos: List<Pair<String, ByteArray>>
)