package domain.repository

import domain.model.Portfolio

interface PortfolioRepository {
    suspend fun createPortfolio(
        creatorId: String,
        name: String,
        description: String,
        category: List<String>,
        photos: List<Pair<String, ByteArray>>
    ): String
    suspend fun getPortfolioById(portfolioId: String): Portfolio
    suspend fun getPortfoliosByCreatorId(creatorId: String): List<Portfolio>
    suspend fun searchPortfolios(
        categories: List<String>? = null,
        portfolioIds: List<String>? = null,
        sortBy: String? = null
    ): List<Portfolio>
    suspend fun updatePortfolio(
        portfolioId: String,
        name: String,
        description: String,
        category: List<String>,
        photoURLs: List<String>
    ): Portfolio
    suspend fun deletePortfolio(portfolioId: String): Boolean
}