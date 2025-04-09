package cz.cvut.fit.application.dto.portfolio

data class UpdatePortfolioDTO(
    val portfolioId: String,
    val name: String,
    val description: String,
    val category: List<String>,
    val photoURLs: List<String>
)
