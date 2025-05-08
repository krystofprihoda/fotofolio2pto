package cz.cvut.fit.data.repository

import data.source.DatabaseSource
import domain.model.Creator
import domain.model.User
import io.mockk.*
import io.mockk.impl.annotations.MockK
import kotlinx.coroutines.runBlocking
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import cz.cvut.fit.config.InternalServerException
import cz.cvut.fit.config.NotFoundException
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import data.repository.CreatorRepositoryImpl

class CreatorRepositoryTest {

    @MockK
    private lateinit var databaseSource: DatabaseSource

    private lateinit var creatorRepository: CreatorRepositoryImpl

    @BeforeEach
    fun setUp() {
        MockKAnnotations.init(this)
        creatorRepository = CreatorRepositoryImpl(databaseSource)
    }

    @Test
    fun `createCreator successfully creates creator and updates user`() = runBlocking {
        // Arrange
        val creator = Creator(
            userId = "user123",
            yearsOfExperience = 5,
            description = "Test creator"
        )
        val creatorId = "creator123"

        coEvery { databaseSource.createDocument(Collections.CREATORS, any()) } returns creatorId
        coEvery {
            databaseSource.updateDocument(Collections.USERS, creator.userId, mapOf(Fields.CREATOR_ID to creatorId))
        } returns true

        // Act
        val result = creatorRepository.createCreator(creator)

        // Assert
        assertEquals(creatorId, result)
        coVerify {
            databaseSource.createDocument(Collections.CREATORS, any())
            databaseSource.updateDocument(Collections.USERS, creator.userId, mapOf(Fields.CREATOR_ID to creatorId))
        }
    }

    @Test
    fun `createCreator throws exception when user update fails`() = runBlocking {
        // Arrange
        val creator = Creator(
            userId = "user123",
            yearsOfExperience = 5,
            description = "Test creator"
        )
        val creatorId = "creator123"

        coEvery { databaseSource.createDocument(Collections.CREATORS, any()) } returns creatorId
        coEvery {
            databaseSource.updateDocument(Collections.USERS, creator.userId, mapOf(Fields.CREATOR_ID to creatorId))
        } returns false

        // Act & Assert
        assertThrows<InternalServerException> {
            creatorRepository.createCreator(creator)
        }

        coVerify {
            databaseSource.createDocument(Collections.CREATORS, any())
            databaseSource.updateDocument(Collections.USERS, creator.userId, mapOf(Fields.CREATOR_ID to creatorId))
        }
    }
    @Test
    fun `getCreatorById returns creator when found`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val creator = Creator(
            id = creatorId,
            userId = "user123",
            yearsOfExperience = 5,
            description = "Test creator"
        )

        coEvery { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) } returns creator

        // Act
        val result = creatorRepository.getCreatorById(creatorId)

        // Assert
        assertEquals(creatorId, result.id)
        assertEquals(creator.userId, result.userId)
        assertEquals(creator.yearsOfExperience, result.yearsOfExperience)
        assertEquals(creator.description, result.description)

        coVerify { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) }
    }

    @Test
    fun `getCreatorById throws NotFoundException when creator not found`() = runBlocking {
        // Arrange
        val creatorId = "nonExistentCreator"

        coEvery { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            creatorRepository.getCreatorById(creatorId)
        }

        coVerify { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) }
    }

    @Test
    fun `getUserByCreatorId returns user when creator and user exist`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val userId = "user123"
        val creator = Creator(
            id = "",
            userId = userId,
            yearsOfExperience = 5,
            description = "Test creator"
        )
        val user = User(
            id = userId,
            username = "testuser",
            email = "test@example.com"
        )

        coEvery { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) } returns creator
        coEvery { databaseSource.getDocument(Collections.USERS, userId, User::class.java) } returns user

        // Act
        val result = creatorRepository.getUserByCreatorId(creatorId)

        // Assert
        assertEquals(user, result)

        coVerify {
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
            databaseSource.getDocument(Collections.USERS, userId, User::class.java)
        }
    }

    @Test
    fun `getUserByCreatorId throws NotFoundException when creator not found`() = runBlocking {
        // Arrange
        val creatorId = "nonExistentCreator"

        coEvery { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            creatorRepository.getUserByCreatorId(creatorId)
        }

        coVerify { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) }
        coVerify(exactly = 0) { databaseSource.getDocument(Collections.USERS, any(), Creator::class.java) }
    }

    @Test
    fun `getUserByCreatorId throws NotFoundException when user not found`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val userId = "nonExistentUser"
        val creator = Creator(
            id = "",
            userId = userId,
            yearsOfExperience = 5,
            description = "Test creator"
        )

        coEvery { databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java) } returns creator
        coEvery { databaseSource.getDocument(Collections.USERS, userId, User::class.java) } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            creatorRepository.getUserByCreatorId(creatorId)
        }

        coVerify {
            databaseSource.getDocument(Collections.CREATORS, creatorId, Creator::class.java)
            databaseSource.getDocument(Collections.USERS, userId, User::class.java)
        }
    }

    @Test
    fun `updateCreator returns true when update succeeds`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val creator = Creator(
            id = creatorId,
            userId = "user123",
            yearsOfExperience = 7,
            description = "Updated description"
        )

        coEvery { databaseSource.setDocument(Collections.CREATORS, creatorId, any()) } returns true

        // Act
        val result = creatorRepository.updateCreator(creatorId, creator)

        // Assert
        assertTrue(result)
        coVerify { databaseSource.setDocument(Collections.CREATORS, creatorId, any()) }
    }

    @Test
    fun `updateCreator returns false when update fails`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val creator = Creator(
            id = creatorId,
            userId = "user123",
            yearsOfExperience = 7,
            description = "Updated description"
        )

        coEvery { databaseSource.setDocument(Collections.CREATORS, creatorId, any()) } returns false

        // Act
        val result = creatorRepository.updateCreator(creatorId, creator)

        // Assert
        assertFalse(result)
        coVerify { databaseSource.setDocument(Collections.CREATORS, creatorId, any()) }
    }

    @Test
    fun `updateCreatorFields successfully updates valid fields`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val fields = mapOf(
            Fields.YEARS_EXPERIENCE to 10,
            Fields.DESCRIPTION to "New description"
        )

        coEvery { databaseSource.updateDocument(Collections.CREATORS, creatorId, fields) } returns true

        // Act
        val result = creatorRepository.updateCreatorFields(creatorId, fields)

        // Assert
        assertTrue(result)
        coVerify { databaseSource.updateDocument(Collections.CREATORS, creatorId, fields) }
    }

    @Test
    fun `updateCreatorFields filters out invalid fields`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val fields = mapOf(
            Fields.YEARS_EXPERIENCE to 10,
            "invalidField" to "value"
        )
        val filteredFields = mapOf(
            Fields.YEARS_EXPERIENCE to 10
        )

        coEvery { databaseSource.updateDocument(Collections.CREATORS, creatorId, filteredFields) } returns true

        // Act
        val result = creatorRepository.updateCreatorFields(creatorId, fields)

        // Assert
        assertTrue(result)
        coVerify { databaseSource.updateDocument(Collections.CREATORS, creatorId, filteredFields) }
    }

    @Test
    fun `updateCreatorFields returns false when no valid fields`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val fields = mapOf(
            "invalidField1" to "value1",
            "invalidField2" to "value2"
        )

        // Act
        val result = creatorRepository.updateCreatorFields(creatorId, fields)

        // Assert
        assertFalse(result)
        coVerify(exactly = 0) { databaseSource.updateDocument(any(), any(), any()) }
    }

    @Test
    fun `updateCreatorFields returns false when update fails`() = runBlocking {
        // Arrange
        val creatorId = "creator123"
        val fields = mapOf(
            Fields.YEARS_EXPERIENCE to 10,
            Fields.DESCRIPTION to "New description"
        )

        coEvery { databaseSource.updateDocument(Collections.CREATORS, creatorId, fields) } returns false

        // Act
        val result = creatorRepository.updateCreatorFields(creatorId, fields)

        // Assert
        assertFalse(result)
        coVerify { databaseSource.updateDocument(Collections.CREATORS, creatorId, fields) }
    }
}