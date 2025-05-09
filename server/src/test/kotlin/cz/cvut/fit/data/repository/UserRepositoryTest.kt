package cz.cvut.fit.data.repository

import data.source.DatabaseSource
import data.source.StorageSource
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
import cz.cvut.fit.config.AppConstants.Storage
import data.repository.UserRepositoryImpl

class UserRepositoryTest {

    @MockK
    private lateinit var databaseSource: DatabaseSource

    @MockK
    private lateinit var storageSource: StorageSource

    private lateinit var userRepository: UserRepositoryImpl

    @BeforeEach
    fun setUp() {
        MockKAnnotations.init(this)
        userRepository = UserRepositoryImpl(databaseSource, storageSource)
    }

    @Test
    fun `isUsernameAvailable returns true when username doesn't exist`() = runBlocking {
        // Arrange
        val username = "availableUsername"
        coEvery { databaseSource.checkDocumentExists(Collections.USERNAMES, username) } returns false

        // Act
        val result = userRepository.isUsernameAvailable(username)

        // Assert
        assertTrue(result)
        coVerify(exactly = 1) { databaseSource.checkDocumentExists(Collections.USERNAMES, username) }
    }

    @Test
    fun `isUsernameAvailable returns false when username exists`() = runBlocking {
        // Arrange
        val username = "takenUsername"
        coEvery { databaseSource.checkDocumentExists(Collections.USERNAMES, username) } returns true

        // Act
        val result = userRepository.isUsernameAvailable(username)

        // Assert
        assertFalse(result)
        coVerify(exactly = 1) { databaseSource.checkDocumentExists(Collections.USERNAMES, username) }
    }

    @Test
    fun `createUser successfully creates new user`() = runBlocking {
        // Arrange
        val user = User(
            id = "user123",
            username = "testuser",
            email = "test@example.com",
            fullName = "Test User"
        )

        coEvery { databaseSource.setDocument(Collections.USERS, user.id, any()) } returns true
        coEvery {
            databaseSource.setDocument(Collections.USERNAMES, user.username, mapOf(Fields.USER_ID to user.id))
        } returns true
        coEvery { databaseSource.getDocument(Collections.USERS, user.id, User::class.java) } returns user

        // Act
        val result = userRepository.createUser(user)

        // Assert
        assertEquals(user, result)
        coVerify {
            databaseSource.setDocument(Collections.USERS, user.id, any())
            databaseSource.setDocument(Collections.USERNAMES, user.username, mapOf(Fields.USER_ID to user.id))
            databaseSource.getDocument(Collections.USERS, user.id, User::class.java)
        }
    }

    @Test
    fun `createUser throws exception when user document creation fails`() = runBlocking {
        // Arrange
        val user = User(
            id = "user123",
            username = "testuser",
            email = "test@example.com"
        )

        coEvery { databaseSource.setDocument(Collections.USERS, user.id, any()) } returns false

        // Act & Assert
        assertThrows<InternalServerException> {
            userRepository.createUser(user)
        }

        coVerify { databaseSource.setDocument(Collections.USERS, user.id, any()) }
        coVerify(exactly = 0) {
            databaseSource.setDocument(Collections.USERNAMES, any(), any())
            databaseSource.getDocument(Collections.USERS, any(), User::class.java)
        }
    }

    @Test
    fun `createUser throws exception when username registration fails`() = runBlocking {
        // Arrange
        val user = User(
            id = "user123",
            username = "testuser",
            email = "test@example.com"
        )

        coEvery { databaseSource.setDocument(Collections.USERS, user.id, any()) } returns true
        coEvery {
            databaseSource.setDocument(Collections.USERNAMES, user.username, mapOf(Fields.USER_ID to user.id))
        } returns false

        // Act & Assert
        assertThrows<InternalServerException> {
            userRepository.createUser(user)
        }

        coVerify {
            databaseSource.setDocument(Collections.USERS, user.id, any())
            databaseSource.setDocument(Collections.USERNAMES, user.username, mapOf(Fields.USER_ID to user.id))
        }
        coVerify(exactly = 0) { databaseSource.getDocument(Collections.USERS, any(), User::class.java) }
    }

    @Test
    fun `getUserById returns user when found`() = runBlocking {
        // Arrange
        val userId = "user123"
        val mockUser = User(id = userId, username = "testUser", email = "test@example.com")
        coEvery { databaseSource.getDocument(Collections.USERS, userId, User::class.java) } returns mockUser

        // Act
        val result = userRepository.getUserById(userId)

        // Assert
        assertEquals(mockUser, result)
        coVerify(exactly = 1) { databaseSource.getDocument(Collections.USERS, userId, User::class.java) }
    }

    @Test
    fun `getUserById throws NotFoundException when user not found`() = runBlocking {
        // Arrange
        val userId = "nonExistentUser"
        coEvery { databaseSource.getDocument(Collections.USERS, userId, User::class.java) } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            userRepository.getUserById(userId)
        }
        coVerify(exactly = 1) { databaseSource.getDocument(Collections.USERS, userId, User::class.java) }
    }

    @Test
    fun `uploadProfilePicture successfully uploads picture and updates user`() = runBlocking {
        // Arrange
        val userId = "user123"
        val imageBytes = "test image data".toByteArray()
        val downloadUrl = "https://storage.example.com/user123/profilepicture.jpeg"
        val path = String.format(Storage.USER_PROFILE_PATH, userId)

        coEvery {
            storageSource.uploadFile(path, imageBytes, Storage.CONTENT_TYPE_JPEG)
        } returns downloadUrl
        coEvery {
            databaseSource.updateDocument(Collections.USERS, userId, mapOf(Fields.PROFILE_PICTURE to downloadUrl))
        } returns true

        // Act
        val result = userRepository.uploadProfilePicture(userId, imageBytes)

        // Assert
        assertEquals(downloadUrl, result)
        coVerify {
            storageSource.uploadFile(path, imageBytes, Storage.CONTENT_TYPE_JPEG)
            databaseSource.updateDocument(Collections.USERS, userId, mapOf(Fields.PROFILE_PICTURE to downloadUrl))
        }
    }

    @Test
    fun `uploadProfilePicture throws exception when update fails`() = runBlocking {
        // Arrange
        val userId = "user123"
        val imageBytes = "test image data".toByteArray()
        val downloadUrl = "https://storage.example.com/user123/profilepicture.jpeg"
        val path = String.format(Storage.USER_PROFILE_PATH, userId)

        coEvery {
            storageSource.uploadFile(path, imageBytes, Storage.CONTENT_TYPE_JPEG)
        } returns downloadUrl
        coEvery {
            databaseSource.updateDocument(Collections.USERS, userId, mapOf(Fields.PROFILE_PICTURE to downloadUrl))
        } returns false

        // Act & Assert
        assertThrows<InternalServerException> {
            userRepository.uploadProfilePicture(userId, imageBytes)
        }

        coVerify {
            storageSource.uploadFile(path, imageBytes, Storage.CONTENT_TYPE_JPEG)
            databaseSource.updateDocument(Collections.USERS, userId, mapOf(Fields.PROFILE_PICTURE to downloadUrl))
        }
    }

    @Test
    fun `rateUser successfully updates user rating`() = runBlocking {
        // Arrange
        val receiverId = "user123"
        val raterId = "user456"
        val rating = 5
        val existingUser = User(
            id = receiverId,
            username = "testuser",
            rating = mapOf("existingRater" to 4)
        )
        val expectedRatings = mapOf("existingRater" to 4, raterId to rating)

        coEvery { databaseSource.getDocument(Collections.USERS, receiverId, User::class.java) } returns existingUser
        coEvery {
            databaseSource.updateDocument(Collections.USERS, receiverId, mapOf(Fields.RATING to expectedRatings))
        } returns true

        // Act
        val result = userRepository.rateUser(receiverId, raterId, rating)

        // Assert
        assertTrue(result)
        coVerify {
            databaseSource.getDocument(Collections.USERS, receiverId, User::class.java)
            databaseSource.updateDocument(Collections.USERS, receiverId, mapOf(Fields.RATING to expectedRatings))
        }
    }

    @Test
    fun `rateUser throws NotFoundException when user not found`() = runBlocking {
        // Arrange
        val receiverId = "nonExistentUser"
        val raterId = "user456"
        val rating = 5

        coEvery { databaseSource.getDocument(Collections.USERS, receiverId, User::class.java) } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            userRepository.rateUser(receiverId, raterId, rating)
        }

        coVerify { databaseSource.getDocument(Collections.USERS, receiverId, User::class.java) }
        coVerify(exactly = 0) { databaseSource.updateDocument(any(), any(), any()) }
    }

    @Test
    fun `searchUsers returns all users when query is blank`() = runBlocking {
        // Arrange
        val allUsers = listOf(
            User(id = "user1", username = "user1"),
            User(id = "user2", username = "user2")
        )

        coEvery { databaseSource.getDocuments(Collections.USERS, User::class.java) } returns allUsers

        // Act
        val result = userRepository.searchUsers("")

        // Assert
        assertEquals(allUsers, result)
        coVerify { databaseSource.getDocuments(Collections.USERS, User::class.java) }
        coVerify(exactly = 0) { databaseSource.queryDocumentsByPrefix(any(), any(), any(), User::class.java) }
    }

    @Test
    fun `searchUsers combines results from multiple fields`() = runBlocking {
        // Arrange
        val query = "test"
        val usernameResults = listOf(
            User(id = "user1", username = "testUser1"),
            User(id = "user2", username = "testUser2")
        )
        val fullNameResults = listOf(
            User(id = "user3", fullName = "Test Person")
        )
        val locationResults = listOf(
            User(id = "user4", location = "Test City"),
            User(id = "user1", username = "testUser1") // Duplicate to test de-duplication
        )

        coEvery {
            databaseSource.queryDocumentsByPrefix(Collections.USERS, Fields.USERNAME, query.lowercase(), User::class.java)
        } returns usernameResults

        coEvery {
            databaseSource.queryDocumentsByPrefix(Collections.USERS, Fields.FULL_NAME, query.lowercase(), User::class.java)
        } returns fullNameResults

        coEvery {
            databaseSource.queryDocumentsByPrefix(Collections.USERS, Fields.LOCATION, query.lowercase(), User::class.java)
        } returns locationResults

        // Act
        val result = userRepository.searchUsers(query)

        // Assert
        assertEquals(4, result.size)
        assertTrue(result.containsAll(listOf(usernameResults[0], usernameResults[1], fullNameResults[0])))

        coVerify {
            databaseSource.queryDocumentsByPrefix(Collections.USERS, Fields.USERNAME, query.lowercase(), User::class.java)
            databaseSource.queryDocumentsByPrefix(Collections.USERS, Fields.FULL_NAME, query.lowercase(), User::class.java)
            databaseSource.queryDocumentsByPrefix(Collections.USERS, Fields.LOCATION, query.lowercase(), User::class.java)
        }
    }
}