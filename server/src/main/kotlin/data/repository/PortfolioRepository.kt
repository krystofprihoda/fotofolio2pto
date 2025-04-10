package data.repository

import com.google.cloud.firestore.FieldPath
import com.google.cloud.firestore.Query
import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await
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
            throw Exception("Creator's username not found")
        }

        val user = usersWithCreatorId.first()
        val userId = user.id
        val authorUsername = user.username

        // Create portfolio document to get ID
        val portfolioId = firestoreSource.createDocument("portfolio", mapOf(
            "creatorId" to createPortfolioDTO.creatorId,
            "name" to createPortfolioDTO.name,
            "description" to createPortfolioDTO.description,
            "category" to createPortfolioDTO.category,
            "photos" to emptyList<String>(),
            "timestamp" to System.currentTimeMillis()
        ))

        // Upload photos
        val photoUrls = mutableListOf<String>()
        for ((fileName, fileBytes) in createPortfolioDTO.photos) {
            val path = "user/$userId/creator/portfolio/$portfolioId/$fileName"
            val url = storageSource.uploadFile(path, fileBytes, "image/jpeg")
            photoUrls.add(url)
        }

        // Update portfolio with photo URLs
        val portfolio = Portfolio(
            id = portfolioId,
            creatorId = createPortfolioDTO.creatorId,
            authorUsername = authorUsername,
            name = createPortfolioDTO.name,
            description = createPortfolioDTO.description,
            photos = photoUrls,
            category = createPortfolioDTO.category,
            timestamp = System.currentTimeMillis()
        )

        firestoreSource.setDocument("portfolio", portfolioId, portfolio.toMap())

        // Update creator's portfolio list
        val creator = firestoreSource.getDocument("creator", createPortfolioDTO.creatorId, Creator::class.java)
        if (creator != null) {
            val updatedPortfolioIds = creator.portfolioIds.toMutableList().apply { add(portfolioId) }
            firestoreSource.updateDocument("creator", createPortfolioDTO.creatorId, mapOf("portfolioIds" to updatedPortfolioIds))
        } else {
            throw Exception("Creator not found")
        }

        return portfolioId
    }

    override suspend fun getPortfolioById(portfolioId: String): Portfolio {
        return firestoreSource.getDocument("portfolio", portfolioId, Portfolio::class.java)
            ?: throw Exception("Portfolio not found")
    }

    override suspend fun getPortfoliosByIds(portfolioIds: List<String>): List<Portfolio> {
        if (portfolioIds.isEmpty()) {
            return emptyList()
        }

        return firestoreSource.getDocumentsByIds("portfolio", portfolioIds, Portfolio::class.java)
    }

    override suspend fun getPortfoliosByCreatorId(creatorId: String): List<Portfolio> {
        val creator = firestoreSource.getDocument("creator", creatorId, Creator::class.java)
            ?: throw Exception("Creator not found")

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
        return firestoreSource.searchPortfoliosByCategories(categories, sortBy)
    }

    override suspend fun updatePortfolio(
        updatePortfolioDTO: UpdatePortfolioDTO
    ): Portfolio {
        val portfolio = getPortfolioById(updatePortfolioDTO.portfolioId)
        val existingPhotoUrls = portfolio.photos

        // Determine which photos to delete
        val photosToDelete = existingPhotoUrls.filterNot { updatePortfolioDTO.photoURLs.contains(it) }

        // Delete unused photos
        for (url in photosToDelete) {
            val path = url
                .substringAfter("/o/")
                .substringBefore("?")
                .let { URLDecoder.decode(it, "UTF-8") }

            storageSource.deleteFile(path)
        }

        // Update portfolio in Firestore
        val updates = mapOf(
            "name" to updatePortfolioDTO.name,
            "description" to updatePortfolioDTO.description,
            "category" to updatePortfolioDTO.category,
            "photos" to updatePortfolioDTO.photoURLs
        )

        firestoreSource.updateDocument("portfolio", updatePortfolioDTO.portfolioId, updates)

        return getPortfolioById(updatePortfolioDTO.portfolioId)
    }

    override suspend fun deletePortfolio(portfolioId: String): Boolean {
        val portfolio = getPortfolioById(portfolioId)

        // Delete photos from storage
        for (url in portfolio.photos) {
            val path = url
                .substringAfter("/o/")
                .substringBefore("?")
                .let { URLDecoder.decode(it, "UTF-8") }

            storageSource.deleteFile(path)
        }

        // Delete portfolio document
        firestoreSource.deleteDocument("portfolio", portfolioId)

        // Update creator's portfolio list
        val creatorId = portfolio.creatorId
        val creator = firestoreSource.getDocument("creator", creatorId, Creator::class.java)

        if (creator != null) {
            val updatedPortfolioIds = creator.portfolioIds.toMutableList().apply { remove(portfolioId) }
            firestoreSource.updateDocument("creator", creatorId, mapOf("portfolioIds" to updatedPortfolioIds))
        }

        return true
    }
}