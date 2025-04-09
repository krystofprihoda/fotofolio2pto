package domain.repository

import cz.cvut.fit.application.dto.portfolio.CreatePortfolioDTO
import cz.cvut.fit.application.dto.portfolio.UpdatePortfolioDTO
import domain.model.Portfolio

interface PortfolioRepository {
    suspend fun createPortfolio(
        createPortfolioDTO: CreatePortfolioDTO
    ): String
    suspend fun getPortfolioById(portfolioId: String): Portfolio
    suspend fun getPortfoliosByCreatorId(creatorId: String): List<Portfolio>
    suspend fun searchPortfolios(
        categories: List<String>? = null,
        sortBy: String? = null
    ): List<Portfolio>
    suspend fun updatePortfolio(
        updatePortfolioDTO: UpdatePortfolioDTO
    ): Portfolio
    suspend fun deletePortfolio(portfolioId: String): Boolean
}