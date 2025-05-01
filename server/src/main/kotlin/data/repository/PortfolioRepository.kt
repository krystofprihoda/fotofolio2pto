package data.repository

import cz.cvut.fit.application.dto.portfolio.CreatePortfolioDTO
import cz.cvut.fit.application.dto.portfolio.UpdatePortfolioDTO
import data.source.FirestoreSource
import data.source.StorageSource
import domain.model.Creator
import domain.model.Portfolio
import domain.model.User
import domain.model.toMap
import domain.repository.PortfolioRepository
import java.net.URLDecoder
import cz.cvut.fit.config.*

class PortfolioRepositoryImpl(
    private val firestoreSource: FirestoreSource,
    private val storageSource: StorageSource
) : PortfolioRepository {

    override suspend fun createPortfolio(
        createPortfolioDTO: CreatePortfolioDTO
    ): String {
        // Get user info for author username
        val usersWithCreatorId = firestoreSource.getDocumentsWhere("user", "creatorId", createPortfolioDTO.creatorId, User::class.java)
        if (usersWithCreatorId.isEmpty()) {
            throw NotFoundException("Creator's user not found")
        }

        val user = usersWithCreatorId.first()
        val userId = user.id
        val authorUsername = user.username

        // Create portfolio document to get ID
        val portfolioId = firestoreSource.createDocument("portfolio", mapOf(
            "creatorId" to createPortfolioDTO.creatorId,
            "name" to createPortfolioDTO.name,
            "description" to createPortfolioDTO.description,
            "price" to createPortfolioDTO.price,
            "category" to createPortfolioDTO.category,
            "photos" to emptyList<String>(),
            "timestamp" to System.currentTimeMillis()
        ))

        // Upload photos
        val photoUrls = mutableListOf<String>()
        try {
            for ((fileName, fileBytes) in createPortfolioDTO.photos) {
                val path = "user/$userId/creator/portfolio/$portfolioId/$fileName"
                val url = storageSource.uploadFile(path, fileBytes, "image/jpeg")
                photoUrls.add(url)
            }
        } catch (e: Exception) {
            throw InternalServerException("Failed to upload portfolio photos: ${e.message}")
        }

        // Update portfolio with photo URLs
        val portfolio = Portfolio(
            id = portfolioId,
            creatorId = createPortfolioDTO.creatorId,
            authorUsername = authorUsername,
            name = createPortfolioDTO.name,
            description = createPortfolioDTO.description,
            price = createPortfolioDTO.price,
            photos = photoUrls,
            category = createPortfolioDTO.category,
            timestamp = System.currentTimeMillis()
        )

        if (!firestoreSource.setDocument("portfolio", portfolioId, portfolio.toMap())) {
            throw InternalServerException("Failed to update portfolio with photo URLs")
        }

        // Update creator's portfolio list
        val creator = firestoreSource.getDocument("creator", createPortfolioDTO.creatorId, Creator::class.java)
            ?: throw NotFoundException("Creator not found")

        val updatedPortfolioIds = creator.portfolioIds.toMutableList().apply { add(portfolioId) }
        if (!firestoreSource.updateDocument("creator", createPortfolioDTO.creatorId, mapOf("portfolioIds" to updatedPortfolioIds))) {
            throw InternalServerException("Failed to update creator's portfolio list")
        }

        return portfolioId
    }

    override suspend fun getPortfolioById(portfolioId: String): Portfolio {
        return firestoreSource.getDocument("portfolio", portfolioId, Portfolio::class.java)
            ?: throw NotFoundException("Portfolio not found")
    }

    override suspend fun getPortfoliosByIds(portfolioIds: List<String>): List<Portfolio> {
        if (portfolioIds.isEmpty()) {
            return emptyList()
        }

        return firestoreSource.getDocumentsByIds("portfolio", portfolioIds, Portfolio::class.java)
    }

    override suspend fun getPortfoliosByCreatorId(creatorId: String): List<Portfolio> {
        val creator = firestoreSource.getDocument("creator", creatorId, Creator::class.java)
            ?: throw NotFoundException("Creator not found")

        if (creator.portfolioIds.isEmpty()) {
            return emptyList()
        }

        return firestoreSource
            .getDocumentsByIds("portfolio", creator.portfolioIds, Portfolio::class.java)
            .sortedByDescending { it.timestamp }
    }

    override suspend fun searchPortfolios(
        categories: List<String>?,
        sortBy: String?
    ): List<Portfolio> {
        try {
            return firestoreSource.searchPortfoliosByCategories(categories, sortBy)
        } catch (e: Exception) {
            throw InternalServerException("Failed to search portfolios: ${e.message}")
        }
    }

    override suspend fun updatePortfolio(
        updatePortfolioDTO: UpdatePortfolioDTO
    ): Portfolio {
        val portfolio = getPortfolioById(updatePortfolioDTO.portfolioId)
        val existingPhotoUrls = portfolio.photos

        // Determine which photos to delete
        val photosToDelete = existingPhotoUrls.filterNot { updatePortfolioDTO.photoURLs.contains(it) }

        // Delete unused photos
        try {
            for (url in photosToDelete) {
                val path = url
                    .substringAfter("/o/")
                    .substringBefore("?")
                    .let { URLDecoder.decode(it, "UTF-8") }

                storageSource.deleteFile(path)
            }
        } catch (e: Exception) {
            throw InternalServerException("Failed to delete unused photos: ${e.message}")
        }

        // Update portfolio in Firestore
        val updates = mapOf(
            "name" to updatePortfolioDTO.name,
            "description" to updatePortfolioDTO.description,
            "price" to updatePortfolioDTO.price,
            "category" to updatePortfolioDTO.category,
            "photos" to updatePortfolioDTO.photoURLs
        )

        if (!firestoreSource.updateDocument("portfolio", updatePortfolioDTO.portfolioId, updates)) {
            throw InternalServerException("Failed to update portfolio")
        }

        return getPortfolioById(updatePortfolioDTO.portfolioId)
    }

    override suspend fun deletePortfolio(portfolioId: String): Boolean {
        val portfolio = getPortfolioById(portfolioId)

        // Delete photos from storage
        try {
            for (url in portfolio.photos) {
                val path = url
                    .substringAfter("/o/")
                    .substringBefore("?")
                    .let { URLDecoder.decode(it, "UTF-8") }

                storageSource.deleteFile(path)
            }
        } catch (e: Exception) {
            throw InternalServerException("Failed to delete portfolio photos: ${e.message}")
        }

        // Delete portfolio document
        if (!firestoreSource.deleteDocument("portfolio", portfolioId)) {
            throw InternalServerException("Failed to delete portfolio document")
        }

        // Update creator's portfolio list
        val creatorId = portfolio.creatorId
        val creator = firestoreSource.getDocument("creator", creatorId, Creator::class.java)

        if (creator != null) {
            val updatedPortfolioIds = creator.portfolioIds.toMutableList().apply { remove(portfolioId) }
            if (!firestoreSource.updateDocument("creator", creatorId, mapOf("portfolioIds" to updatedPortfolioIds))) {
                throw InternalServerException("Failed to update creator's portfolio list")
            }
        }

        return true
    }
}