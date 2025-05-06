package data.repository

import cz.cvut.fit.application.dto.portfolio.CreatePortfolioDTO
import cz.cvut.fit.application.dto.portfolio.UpdatePortfolioDTO
import cz.cvut.fit.config.*
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.Storage
import data.source.DatabaseSource
import data.source.StorageSource
import domain.model.Creator
import domain.model.Portfolio
import domain.model.User
import domain.model.toMap
import domain.repository.PortfolioRepository
import java.net.URLDecoder

class PortfolioRepositoryImpl(
    private val databaseSource: DatabaseSource,
    private val storageSource: StorageSource
) : PortfolioRepository {

    override suspend fun createPortfolio(
        createPortfolioDTO: CreatePortfolioDTO
    ): String {
        // Get user info for author username
        val usersWithCreatorId = databaseSource.getDocumentsWhere(
            Collections.USERS,
            Fields.CREATOR_ID,
            createPortfolioDTO.creatorId,
            User::class.java
        )

        if (usersWithCreatorId.isEmpty()) {
            throw NotFoundException(Messages.USER_NOT_FOUND)
        }

        val user = usersWithCreatorId.first()
        val userId = user.id
        val authorUsername = user.username

        // Create portfolio document to get ID
        val portfolioId = databaseSource.createDocument(
            Collections.PORTFOLIOS,
            mapOf(
                Fields.CREATOR_ID to createPortfolioDTO.creatorId,
                Fields.NAME to createPortfolioDTO.name,
                Fields.DESCRIPTION to createPortfolioDTO.description,
                Fields.PRICE to createPortfolioDTO.price,
                Fields.CATEGORY to createPortfolioDTO.category,
                Fields.PHOTOS to emptyList<String>(),
                Fields.TIMESTAMP to System.currentTimeMillis()
            )
        )

        // Upload photos
        val photoUrls = mutableListOf<String>()
        try {
            for ((fileName, fileBytes) in createPortfolioDTO.photos) {
                val path = String.format(Storage.PORTFOLIO_PHOTO_PATH, userId, portfolioId, fileName)
                val url = storageSource.uploadFile(path, fileBytes, Storage.CONTENT_TYPE_JPEG)
                photoUrls.add(url)
            }
        } catch (e: Exception) {
            throw InternalServerException("${Messages.FAILED_UPLOAD_PORTFOLIO_PHOTOS}: ${e.message}")
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

        if (!databaseSource.setDocument(Collections.PORTFOLIOS, portfolioId, portfolio.toMap())) {
            throw InternalServerException(Messages.FAILED_UPDATE_PORTFOLIO_URLS)
        }

        // Update creator's portfolio list
        val creator = databaseSource.getDocument(
            Collections.CREATORS,
            createPortfolioDTO.creatorId,
            Creator::class.java
        ) ?: throw NotFoundException(Messages.CREATOR_NOT_FOUND)

        val updatedPortfolioIds = creator.portfolioIds.toMutableList().apply { add(portfolioId) }
        if (!databaseSource.updateDocument(
                Collections.CREATORS,
                createPortfolioDTO.creatorId,
                mapOf(Fields.PORTFOLIO_IDS to updatedPortfolioIds)
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_PORTFOLIO_LIST)
        }

        return portfolioId
    }

    override suspend fun getPortfolioById(portfolioId: String): Portfolio {
        return databaseSource.getDocument(
            Collections.PORTFOLIOS,
            portfolioId,
            Portfolio::class.java
        ) ?: throw NotFoundException(Messages.PORTFOLIO_NOT_FOUND)
    }

    override suspend fun getPortfoliosByIds(portfolioIds: List<String>): List<Portfolio> {
        if (portfolioIds.isEmpty()) {
            return emptyList()
        }

        return databaseSource.getDocumentsByIds(
            Collections.PORTFOLIOS,
            portfolioIds,
            Portfolio::class.java
        )
    }

    override suspend fun getPortfoliosByCreatorId(creatorId: String): List<Portfolio> {
        val creator = databaseSource.getDocument(
            Collections.CREATORS,
            creatorId,
            Creator::class.java
        ) ?: throw NotFoundException(Messages.CREATOR_NOT_FOUND)

        if (creator.portfolioIds.isEmpty()) {
            return emptyList()
        }

        return databaseSource
            .getDocumentsByIds(
                Collections.PORTFOLIOS,
                creator.portfolioIds,
                Portfolio::class.java
            )
            .sortedByDescending { it.timestamp }
    }

    override suspend fun searchPortfolios(
        categories: List<String>?,
        sortBy: String?
    ): List<Portfolio> {
        try {
            return databaseSource.searchPortfoliosByCategories(categories, sortBy)
        } catch (e: Exception) {
            throw InternalServerException("${Messages.FAILED_SEARCH_PORTFOLIOS}: ${e.message}")
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
            throw InternalServerException("${Messages.FAILED_DELETE_UNUSED_PHOTOS}: ${e.message}")
        }

        // Update portfolio in Firestore
        val updates = mapOf(
            Fields.NAME to updatePortfolioDTO.name,
            Fields.DESCRIPTION to updatePortfolioDTO.description,
            Fields.PRICE to updatePortfolioDTO.price,
            Fields.CATEGORY to updatePortfolioDTO.category,
            Fields.PHOTOS to updatePortfolioDTO.photoURLs
        )

        if (!databaseSource.updateDocument(
                Collections.PORTFOLIOS,
                updatePortfolioDTO.portfolioId,
                updates
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_PORTFOLIO)
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
            throw InternalServerException("${Messages.FAILED_DELETE_PORTFOLIO_PHOTOS}: ${e.message}")
        }

        // Delete portfolio document
        if (!databaseSource.deleteDocument(Collections.PORTFOLIOS, portfolioId)) {
            throw InternalServerException(Messages.FAILED_DELETE_PORTFOLIO)
        }

        // Update creator's portfolio list
        val creatorId = portfolio.creatorId
        val creator = databaseSource.getDocument(
            Collections.CREATORS,
            creatorId,
            Creator::class.java
        )

        if (creator != null) {
            val updatedPortfolioIds = creator.portfolioIds.toMutableList().apply { remove(portfolioId) }
            if (!databaseSource.updateDocument(
                    Collections.CREATORS,
                    creatorId,
                    mapOf(Fields.PORTFOLIO_IDS to updatedPortfolioIds)
                )) {
                throw InternalServerException(Messages.FAILED_UPDATE_PORTFOLIO_LIST)
            }
        }

        return true
    }
}