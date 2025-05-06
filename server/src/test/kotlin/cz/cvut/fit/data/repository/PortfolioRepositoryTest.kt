package data.repository

import cz.cvut.fit.application.dto.portfolio.CreatePortfolioDTO
import cz.cvut.fit.application.dto.portfolio.UpdatePortfolioDTO
import cz.cvut.fit.config.InternalServerException
import cz.cvut.fit.config.NotFoundException
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import cz.cvut.fit.config.AppConstants.Storage
import data.source.DatabaseSource
import data.source.StorageSource
import domain.model.Creator
import domain.model.Portfolio
import domain.model.User
import io.mockk.*
import io.mockk.impl.annotations.MockK
import kotlinx.coroutines.runBlocking
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows

class PortfolioRepositoryTest {

    @MockK
    private lateinit var databaseSource: DatabaseSource

    @MockK
    private lateinit var storageSource: StorageSource

    private lateinit var portfolioRepository: PortfolioRepositoryImpl

    @BeforeEach
    fun setUp() {
        MockKAnnotations.init(this)
        portfolioRepository = PortfolioRepositoryImpl(databaseSource, storageSource)
    }

    @Test
    fun `createPortfolio successfully creates portfolio with photos`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val userId = "user123"
        val username = "testuser"
        val portfolioId = "portfolio123"

        val createDto = CreatePortfolioDTO(
            creatorId = creatorId,
            name = "Test Portfolio",
            description = "Test Description",
            price = 100,
            category = listOf("category1", "category2"),
            photos = listOf(
                "photo1.jpg" to "photo1data".toByteArray(),
                "photo2.jpg" to "photo2data".toByteArray()
            )
        )

        val user = User(id = userId, username = username)
        val creator = Creator(id = creatorId, userId = userId, portfolioIds = emptyList())
        val photoUrls = listOf(
            "https://storage.example.com/photo1.jpg",
            "https://storage.example.com/photo2.jpg"
        )

        coEvery {
            databaseSource.getDocumentsWhere(Collections.USERS, Fields.CREATOR_ID, creatorId, User::class.java)
        } returns listOf(user)

        coEvery { databaseSource.createDocument(Collections.PORTFOLIOS, any()) } returns portfolioId

        coEvery {
            storageSource.uploadFile(any(), any(), Storage.CONTENT_TYPE_JPEG)
        } returnsMany photoUrls

        coEvery { databaseSource.setDocument(Collections.PORTFOLIOS, portfolioId, any()) } returns true

        coEvery { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) } returns creator

        coEvery {
            databaseSource.updateDocument(Collections.CREATORS, creatorId, any())
        } returns true

        // Act
        val result = portfolioRepository.createPortfolio(createDto)

        // Assert
        assertEquals(portfolioId, result)

        coVerify {
            databaseSource.getDocumentsWhere(Collections.USERS, Fields.CREATOR_ID, creatorId, User::class.java)
            databaseSource.createDocument(Collections.PORTFOLIOS, any())
            storageSource.uploadFile(any(), any(), Storage.CONTENT_TYPE_JPEG)
            databaseSource.setDocument(Collections.PORTFOLIOS, portfolioId, any())
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
            databaseSource.updateDocument(Collections.CREATORS, creatorId, any())
        }
    }

    @Test
    fun `createPortfolio throws exception when creator user not found`() = runBlocking {
        // Arrange
        val creatorId = "creator123"

        val createDto = CreatePortfolioDTO(
            creatorId = creatorId,
            name = "Test Portfolio",
            description = "Test Description",
            price = 100,
            category = listOf("category1"),
            photos = emptyList()
        )

        coEvery {
            databaseSource.getDocumentsWhere(Collections.USERS, Fields.CREATOR_ID, creatorId, User::class.java)
        } returns emptyList()

        // Act & Assert
        assertThrows<NotFoundException> {
            portfolioRepository.createPortfolio(createDto)
        }

        coVerify {
            databaseSource.getDocumentsWhere(Collections.USERS, Fields.CREATOR_ID, creatorId, User::class.java)
        }

        coVerify(exactly = 0) {
            databaseSource.createDocument(any(), any())
            storageSource.uploadFile(any(), any(), any())
            databaseSource.setDocument(any(), any(), any())
        }
    }

    @Test
    fun `createPortfolio throws exception when photo upload fails`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val userId = "user123"
        val username = "testuser"
        val portfolioId = "portfolio123"

        val createDto = CreatePortfolioDTO(
            creatorId = creatorId,
            name = "Test Portfolio",
            description = "Test Description",
            price = 100,
            category = listOf("category1"),
            photos = listOf("photo1.jpg" to "photo1data".toByteArray())
        )

        val user = User(id = userId, username = username)

        coEvery {
            databaseSource.getDocumentsWhere(Collections.USERS, Fields.CREATOR_ID, creatorId, User::class.java)
        } returns listOf(user)

        coEvery { databaseSource.createDocument(Collections.PORTFOLIOS, any()) } returns portfolioId

        coEvery {
            storageSource.uploadFile(any(), any(), Storage.CONTENT_TYPE_JPEG)
        } throws Exception("Upload failed")

        // Act & Assert
        assertThrows<InternalServerException> {
            portfolioRepository.createPortfolio(createDto)
        }

        coVerify {
            databaseSource.getDocumentsWhere(Collections.USERS, Fields.CREATOR_ID, creatorId, User::class.java)
            databaseSource.createDocument(Collections.PORTFOLIOS, any())
            storageSource.uploadFile(any(), any(), Storage.CONTENT_TYPE_JPEG)
        }

        coVerify(exactly = 0) {
            databaseSource.setDocument(Collections.PORTFOLIOS, any(), any())
            databaseSource.getDocument(Collections.CREATORS, any(), Creator::class.java)
        }
    }

    @Test
    fun `getPortfolioById returns portfolio when found`() = runBlocking {
        // Arrange
        val portfolioId = "portfolio123"
        val portfolio = Portfolio(
            id = portfolioId,
            creatorId = "creator123",
            name = "Test Portfolio",
            description = "Test Description"
        )

        coEvery {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
        } returns portfolio

        // Act
        val result = portfolioRepository.getPortfolioById(portfolioId)

        // Assert
        assertEquals(portfolio, result)

        coVerify { databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java) }
    }

    @Test
    fun `getPortfolioById throws NotFoundException when portfolio not found`() = runBlocking {
        // Arrange
        val portfolioId = "nonExistentPortfolio"

        coEvery {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
        } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            portfolioRepository.getPortfolioById(portfolioId)
        }

        coVerify { databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java) }
    }

    @Test
    fun `getPortfoliosByCreatorId returns empty list when creator has no portfolios`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val creator = Creator(
            id = creatorId,
            userId = "user123",
            portfolioIds = emptyList()
        )

        coEvery {
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
        } returns creator

        // Act
        val result = portfolioRepository.getPortfoliosByCreatorId(creatorId)

        // Assert
        assertTrue(result.isEmpty())

        coVerify { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) }
        coVerify(exactly = 0) { databaseSource.getDocumentsByIds(any(), any(), Creator::class.java) }
    }

    @Test
    fun `getPortfoliosByCreatorId returns sorted portfolios when creator has portfolios`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val portfolioIds = listOf("portfolio1", "portfolio2")
        val creator = Creator(
            id = creatorId,
            userId = "user123",
            portfolioIds = portfolioIds
        )

        val portfolios = listOf(
            Portfolio(id = "portfolio1", creatorId = creatorId, timestamp = 100),
            Portfolio(id = "portfolio2", creatorId = creatorId, timestamp = 200)
        )

        coEvery {
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
        } returns creator

        coEvery {
            databaseSource.getDocumentsByIds(Collections.PORTFOLIOS, portfolioIds, Portfolio::class.java)
        } returns portfolios

        // Act
        val result = portfolioRepository.getPortfoliosByCreatorId(creatorId)

        // Assert
        assertEquals(2, result.size)
        assertEquals("portfolio2", result[0].id) // Should be first because of higher timestamp
        assertEquals("portfolio1", result[1].id)

        coVerify {
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
            databaseSource.getDocumentsByIds(Collections.PORTFOLIOS, portfolioIds, Portfolio::class.java)
        }
    }

    @Test
    fun `updatePortfolio successfully updates portfolio and removes unused photos`() = runBlocking {
        // Arrange
        val portfolioId = "portfolio123"
        val existingPhotoUrls = listOf(
            "https://storage.example.com/o/user/123/creator/portfolio/portfolio123/photo1.jpg?token=abc",
            "https://storage.example.com/o/user/123/creator/portfolio/portfolio123/photo2.jpg?token=def"
        )
        val keepPhotoUrl = existingPhotoUrls[0]

        val existingPortfolio = Portfolio(
            id = portfolioId,
            creatorId = "creator123",
            name = "Old Name",
            description = "Old Description",
            price = 50,
            category = listOf("oldCategory"),
            photos = existingPhotoUrls
        )

        val updateDto = UpdatePortfolioDTO(
            portfolioId = portfolioId,
            name = "New Name",
            description = "New Description",
            price = 100,
            category = listOf("newCategory"),
            photoURLs = listOf(keepPhotoUrl)
        )

        coEvery {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
        } returns existingPortfolio

        coEvery { storageSource.deleteFile(any()) } returns true

        coEvery {
            databaseSource.updateDocument(Collections.PORTFOLIOS, portfolioId, any())
        } returns true

        val updatedPortfolio = existingPortfolio.copy(
            name = updateDto.name,
            description = updateDto.description,
            price = updateDto.price,
            category = updateDto.category,
            photos = updateDto.photoURLs
        )

        coEvery {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
        } returns updatedPortfolio

        // Act
        val result = portfolioRepository.updatePortfolio(updateDto)

        // Assert
        assertEquals(updatedPortfolio, result)

        coVerify {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
            databaseSource.updateDocument(Collections.PORTFOLIOS, portfolioId, any())
        }
    }

    @Test
    fun `deletePortfolio successfully deletes portfolio and updates creator`() = runBlocking {
        // Arrange
        val portfolioId = "portfolio123"
        val creatorId = "creator123"
        val photoUrls = listOf(
            "https://storage.example.com/o/user/123/creator/portfolio/portfolio123/photo1.jpg?token=abc"
        )

        val portfolio = Portfolio(
            id = portfolioId,
            creatorId = creatorId,
            photos = photoUrls
        )

        val creator = Creator(
            id = creatorId,
            userId = "user123",
            portfolioIds = listOf(portfolioId, "otherPortfolio")
        )

        coEvery {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
        } returns portfolio

        coEvery { storageSource.deleteFile(any()) } returns true

        coEvery { databaseSource.deleteDocument(Collections.PORTFOLIOS, portfolioId) } returns true

        coEvery {
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
        } returns creator

        coEvery {
            databaseSource.updateDocument(Collections.CREATORS, creatorId, any())
        } returns true

        // Act
        val result = portfolioRepository.deletePortfolio(portfolioId)

        // Assert
        assertTrue(result)

        coVerify {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
            storageSource.deleteFile(any())
            databaseSource.deleteDocument(Collections.PORTFOLIOS, portfolioId)
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
            databaseSource.updateDocument(Collections.CREATORS, creatorId,
                match { updates ->
                    val portfolioIds = updates[Fields.PORTFOLIO_IDS] as List<*>
                    portfolioIds.size == 1 && portfolioIds.contains("otherPortfolio")
                }
            )
        }
    }

    @Test
    fun `deletePortfolio throws exception when portfolio not found`() = runBlocking {
        // Arrange
        val portfolioId = "nonExistentPortfolio"

        coEvery {
            databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java)
        } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            portfolioRepository.deletePortfolio(portfolioId)
        }

        coVerify { databaseSource.getDocument(Collections.PORTFOLIOS, portfolioId, Portfolio::class.java) }
        coVerify(exactly = 0) {
            storageSource.deleteFile(any())
            databaseSource.deleteDocument(any(), any())
        }
    }

    @Test
    fun `searchPortfolios delegates to firestoreSource and handles exceptions`() = runBlocking {
        // Arrange
        val categories = listOf("category1", "category2")
        val sortBy = "timestamp"

        coEvery {
            databaseSource.searchPortfoliosByCategories(categories, sortBy)
        } returns listOf(
            Portfolio(id = "portfolio1"),
            Portfolio(id = "portfolio2")
        )

        // Act
        val result = portfolioRepository.searchPortfolios(categories, sortBy)

        // Assert
        assertEquals(2, result.size)
        assertEquals("portfolio1", result[0].id)
        assertEquals("portfolio2", result[1].id)

        coVerify { databaseSource.searchPortfoliosByCategories(categories, sortBy) }
    }

    @Test
    fun `searchPortfolios throws exception when search fails`() = runBlocking {
        // Arrange
        val categories = listOf("category1")

        coEvery {
            databaseSource.searchPortfoliosByCategories(categories, null)
        } throws Exception("Search failed")

        // Act & Assert
        assertThrows<InternalServerException> {
            portfolioRepository.searchPortfolios(categories, null)
        }

        coVerify { databaseSource.searchPortfoliosByCategories(categories, null) }
    }
}