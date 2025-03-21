package domain.repository

import domain.model.Portfolio

interface PortfolioRepository {
    fun getPortfolios(): List<Portfolio>
    fun getPortfoliosForUser(userId: String): List<Portfolio>
    fun deletePortfolio(id: Int)
}