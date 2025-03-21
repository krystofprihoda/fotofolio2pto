package data

import domain.model.Portfolio
import domain.repository.PortfolioRepository

internal class PortfolioRepositoryImpl : PortfolioRepository {
    override fun getPortfolios(): List<Portfolio> {
        return Portfolio.mocks()
    }

    override fun getPortfoliosForUser(userId: String): List<Portfolio> {
        return Portfolio.mocks().filter { folio -> folio.ownerId == userId }
    }

    override fun deletePortfolio(id: Int) {
        return
    }

}