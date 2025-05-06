package cz.cvut.fit.data.repository

import com.google.cloud.firestore.Query
import cz.cvut.fit.config.InternalServerException
import cz.cvut.fit.config.NotFoundException
import cz.cvut.fit.config.UnauthorizedException
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import data.repository.MessageRepositoryImpl
import data.source.DatabaseSource
import domain.model.Chat
import domain.model.Message
import io.mockk.*
import io.mockk.impl.annotations.MockK
import kotlinx.coroutines.runBlocking
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows

class MessageRepositoryTest {

    @MockK
    private lateinit var databaseSource: DatabaseSource

    private lateinit var messageRepository: MessageRepositoryImpl

    @BeforeEach
    fun setUp() {
        MockKAnnotations.init(this)
        messageRepository = MessageRepositoryImpl(databaseSource)
    }

    @Test
    fun `createChat creates new chat when none exists`() = runBlocking {
        // Arrange
        val senderId = "sender123"
        val receiverId = "receiver123"
        val messageBody = "Hello!"
        val chatId = "chat123"
        val messageId = "message123"

        val sortedParticipants = listOf(receiverId, senderId).sorted()
        val existingChats = emptyList<Chat>()

        coEvery {
            databaseSource.getDocumentsWhereArrayContains(
                Collections.CHATS,
                Fields.CHAT_OWNER_IDS,
                senderId,
                Chat::class.java
            )
        } returns existingChats

        coEvery { databaseSource.createDocument(Collections.CHATS, any()) } returns chatId
        coEvery { databaseSource.createDocument(Collections.MESSAGES, any()) } returns messageId

        coEvery {
            databaseSource.updateDocument(
                Collections.CHATS,
                chatId,
                match { updates ->
                    updates[Fields.MESSAGE_IDS] == listOf(messageId) &&
                            updates[Fields.LAST_MESSAGE] == messageBody &&
                            updates[Fields.LAST_SENDER_ID] == senderId &&
                            updates[Fields.READ_BY_IDS] == listOf(senderId)
                }
            )
        } returns true

        val expectedChat = Chat(
            id = chatId,
            chatOwnerIds = sortedParticipants,
            messageIds = listOf(messageId),
            lastMessage = messageBody,
            lastSenderId = senderId,
            readByIds = listOf(senderId)
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns expectedChat

        // Act
        val result = messageRepository.createChat(senderId, receiverId, messageBody)

        // Assert
        assertEquals(expectedChat, result)

        coVerify {
            databaseSource.getDocumentsWhereArrayContains(Collections.CHATS, Fields.CHAT_OWNER_IDS, senderId, Chat::class.java)
            databaseSource.createDocument(Collections.CHATS, any())
            databaseSource.createDocument(Collections.MESSAGES, any())
            databaseSource.updateDocument(Collections.CHATS, chatId, any())
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        }
    }

    @Test
    fun `createChat returns existing chat when one exists`() = runBlocking {
        // Arrange
        val senderId = "sender123"
        val receiverId = "receiver123"
        val messageBody = "Hello!"
        val chatId = "chat123"

        val sortedParticipants = listOf(receiverId, senderId).sorted()
        val existingChat = Chat(
            id = chatId,
            chatOwnerIds = sortedParticipants
        )

        val existingChats = listOf(
            existingChat,
            Chat(id = "otherChat", chatOwnerIds = listOf("sender123", "other456"))
        )

        coEvery {
            databaseSource.getDocumentsWhereArrayContains(
                Collections.CHATS,
                Fields.CHAT_OWNER_IDS,
                senderId,
                Chat::class.java
            )
        } returns existingChats

        // Act
        val result = messageRepository.createChat(senderId, receiverId, messageBody)

        // Assert
        assertEquals(existingChat, result)

        coVerify {
            databaseSource.getDocumentsWhereArrayContains(Collections.CHATS, Fields.CHAT_OWNER_IDS, senderId, Chat::class.java)
        }

        coVerify(exactly = 0) {
            databaseSource.createDocument(any(), any())
            databaseSource.updateDocument(any(), any(), any())
        }
    }

    @Test
    fun `createChat throws exception when update fails`() = runBlocking {
        // Arrange
        val senderId = "sender123"
        val receiverId = "receiver123"
        val messageBody = "Hello!"
        val chatId = "chat123"
        val messageId = "message123"

        coEvery {
            databaseSource.getDocumentsWhereArrayContains(
                Collections.CHATS,
                Fields.CHAT_OWNER_IDS,
                senderId,
                Chat::class.java
            )
        } returns emptyList()

        coEvery { databaseSource.createDocument(Collections.CHATS, any()) } returns chatId
        coEvery { databaseSource.createDocument(Collections.MESSAGES, any()) } returns messageId

        coEvery { databaseSource.updateDocument(Collections.CHATS, chatId, any()) } returns false

        // Act & Assert
        assertThrows<InternalServerException> {
            messageRepository.createChat(senderId, receiverId, messageBody)
        }

        coVerify {
            databaseSource.getDocumentsWhereArrayContains(Collections.CHATS, Fields.CHAT_OWNER_IDS, senderId, Chat::class.java)
            databaseSource.createDocument(Collections.CHATS, any())
            databaseSource.createDocument(Collections.MESSAGES, any())
            databaseSource.updateDocument(Collections.CHATS, chatId, any())
        }

        coVerify(exactly = 0) { databaseSource.getDocument(any(), any(), Chat::class.java) }
    }

    @Test
    fun `sendMessage successfully sends message to existing chat`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val senderId = "sender123"
        val receiverId = "receiver123"
        val messageBody = "New message"
        val messageId = "message456"

        val existingChat = Chat(
            id = chatId,
            chatOwnerIds = listOf(senderId, receiverId),
            messageIds = listOf("oldMessage123")
        )

        val updatedChat = existingChat.copy(
            messageIds = existingChat.messageIds + messageId,
            lastMessage = messageBody,
            lastSenderId = senderId,
            readByIds = listOf(senderId)
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns existingChat

        coEvery { databaseSource.createDocument(Collections.MESSAGES, any()) } returns messageId

        coEvery {
            databaseSource.updateDocument(
                Collections.CHATS,
                chatId,
                match { updates ->
                    val messageIds = updates[Fields.MESSAGE_IDS] as List<*>
                    messageIds.contains(messageId) && messageIds.contains("oldMessage123") &&
                            updates[Fields.LAST_MESSAGE] == messageBody &&
                            updates[Fields.LAST_SENDER_ID] == senderId
                }
            )
        } returns true

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns updatedChat

        // Act
        val result = messageRepository.sendMessage(chatId, senderId, messageBody)

        // Assert
        assertEquals(updatedChat, result)

        coVerify {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            databaseSource.createDocument(Collections.MESSAGES, any())
            databaseSource.updateDocument(Collections.CHATS, chatId, any())
        }
    }

    @Test
    fun `sendMessage throws NotFoundException when chat not found`() = runBlocking {
        // Arrange
        val chatId = "nonExistentChat"
        val senderId = "sender123"
        val messageBody = "Hello"

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            messageRepository.sendMessage(chatId, senderId, messageBody)
        }

        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }

        coVerify(exactly = 0) {
            databaseSource.createDocument(any(), any())
            databaseSource.updateDocument(any(), any(), any())
        }
    }

    @Test
    fun `sendMessage throws UnauthorizedException when sender not in chat`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val senderId = "unauthorized456"
        val messageBody = "Hello"

        val existingChat = Chat(
            id = chatId,
            chatOwnerIds = listOf("user1", "user2")
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns existingChat

        // Act & Assert
        assertThrows<UnauthorizedException> {
            messageRepository.sendMessage(chatId, senderId, messageBody)
        }

        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }

        coVerify(exactly = 0) {
            databaseSource.createDocument(any(), any())
            databaseSource.updateDocument(any(), any(), any())
        }
    }

    @Test
    fun `getChats returns sorted list of user's chats`() = runBlocking {
        // Arrange
        val userId = "user123"
        val chats = listOf(
            Chat(id = "chat1", lastUpdated = 100),
            Chat(id = "chat2", lastUpdated = 300),
            Chat(id = "chat3", lastUpdated = 200)
        )

        coEvery {
            databaseSource.getDocumentsWhereArrayContains(
                Collections.CHATS,
                Fields.CHAT_OWNER_IDS,
                userId,
                Chat::class.java
            )
        } returns chats

        // Act
        val result = messageRepository.getChats(userId)

        // Assert
        assertEquals(3, result.size)
        // Should be sorted by lastUpdated in descending order
        assertEquals("chat2", result[0].id)
        assertEquals("chat3", result[1].id)
        assertEquals("chat1", result[2].id)

        coVerify {
            databaseSource.getDocumentsWhereArrayContains(Collections.CHATS, Fields.CHAT_OWNER_IDS, userId, Chat::class.java)
        }
    }

    @Test
    fun `getChatMessages returns messages for a chat`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val userId = "user123"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf(userId, "otherUser"),
            readByIds = emptyList()
        )

        val messages = listOf(
            Message(id = "message1", chatId = chatId),
            Message(id = "message2", chatId = chatId)
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns chat

        coEvery {
            databaseSource.getDocumentsWhereOrdered(
                Collections.MESSAGES,
                Fields.CHAT_ID,
                chatId,
                Fields.TIMESTAMP,
                Query.Direction.ASCENDING,
                Message::class.java
            )
        } returns messages

        // Mock updateChatRead call
        coEvery {
            databaseSource.updateDocument(Collections.CHATS, chatId, any())
        } returns true

        // Act
        val result = messageRepository.getChatMessages(chatId, userId)

        // Assert
        assertEquals(messages, result)
        assertEquals(2, result.size)

        coVerify {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            databaseSource.getDocumentsWhereOrdered(
                Collections.MESSAGES,
                Fields.CHAT_ID,
                chatId,
                Fields.TIMESTAMP,
                Query.Direction.ASCENDING,
                Message::class.java
            )
            databaseSource.updateDocument(Collections.CHATS, chatId, any())
        }
    }

    @Test
    fun `getChatById returns chat when found and user is authorized`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val userId = "user123"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf(userId, "otherUser")
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns chat

        // Act
        val result = messageRepository.getChatById(chatId, userId)

        // Assert
        assertEquals(chat, result)

        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }
    }

    @Test
    fun `getChatById throws NotFoundException when chat not found`() = runBlocking {
        // Arrange
        val chatId = "nonExistentChat"
        val userId = "user123"

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            messageRepository.getChatById(chatId, userId)
        }

        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }
    }

    @Test
    fun `getChatById throws UnauthorizedException when user not in chat`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val userId = "unauthorized456"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf("user1", "user2")
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns chat

        // Act & Assert
        assertThrows<UnauthorizedException> {
            messageRepository.getChatById(chatId, userId)
        }

        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }
    }

    @Test
    fun `updateChatRead marks chat as read when user is in chat`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val userId = "user123"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf(userId, "otherUser"),
            readByIds = listOf("otherUser")
        )

        val expectedReadByIds = listOf("otherUser", userId)

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns chat

        coEvery {
            databaseSource.updateDocument(
                Collections.CHATS,
                chatId,
                mapOf(Fields.READ_BY_IDS to expectedReadByIds)
            )
        } returns true

        // Act
        messageRepository.updateChatRead(chatId, userId)

        // Assert
        coVerify {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            databaseSource.updateDocument(Collections.CHATS, chatId, mapOf(Fields.READ_BY_IDS to expectedReadByIds))
        }
    }

    @Test
    fun `updateChatRead does nothing when user already marked as read`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val userId = "user123"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf(userId, "otherUser"),
            readByIds = listOf(userId, "otherUser")
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns chat

        // Act
        messageRepository.updateChatRead(chatId, userId)

        // Assert
        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }
        coVerify(exactly = 0) { databaseSource.updateDocument(any(), any(), any()) }
    }

    @Test
    fun `updateChatRead throws NotFoundException when chat not found`() = runBlocking {
        // Arrange
        val chatId = "nonExistentChat"
        val userId = "user123"

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns null

        // Act & Assert
        assertThrows<NotFoundException> {
            messageRepository.updateChatRead(chatId, userId)
        }

        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }
        coVerify(exactly = 0) { databaseSource.updateDocument(any(), any(), any()) }
    }

    @Test
    fun `updateChatRead throws UnauthorizedException when user not in chat`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val userId = "unauthorized456"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf("user1", "user2")
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns chat

        // Act & Assert
        assertThrows<UnauthorizedException> {
            messageRepository.updateChatRead(chatId, userId)
        }

        coVerify { databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java) }
        coVerify(exactly = 0) { databaseSource.updateDocument(any(), any(), any()) }
    }

    @Test
    fun `updateChatRead throws exception when update fails`() = runBlocking {
        // Arrange
        val chatId = "chat123"
        val userId = "user123"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf(userId, "otherUser"),
            readByIds = emptyList()
        )

        coEvery {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
        } returns chat

        coEvery {
            databaseSource.updateDocument(Collections.CHATS, chatId, any())
        } returns false

        // Act & Assert
        assertThrows<InternalServerException> {
            messageRepository.updateChatRead(chatId, userId)
        }

        coVerify {
            databaseSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            databaseSource.updateDocument(Collections.CHATS, chatId, any())
        }
    }

    @Test
    fun `getChat returns existing chat between users when found`() = runBlocking {
        // Arrange
        val userId = "user123"
        val receiverId = "receiver456"
        val chatId = "chat123"

        val chat = Chat(
            id = chatId,
            chatOwnerIds = listOf(userId, receiverId)
        )

        val allUserChats = listOf(
            chat,
            Chat(id = "otherChat", chatOwnerIds = listOf(userId, "someoneElse"))
        )

        coEvery {
            databaseSource.getDocumentsWhereArrayContains(
                Collections.CHATS,
                Fields.CHAT_OWNER_IDS,
                userId,
                Chat::class.java
            )
        } returns allUserChats

        // Act
        val result = messageRepository.getChat(userId, receiverId)

        // Assert
        assertEquals(chat, result)

        coVerify {
            databaseSource.getDocumentsWhereArrayContains(Collections.CHATS, Fields.CHAT_OWNER_IDS, userId, Chat::class.java)
        }
    }

    @Test
    fun `getChat returns empty chat when no chat exists between users`() = runBlocking {
        // Arrange
        val userId = "user123"
        val receiverId = "receiver456"

        val allUserChats = listOf(
            Chat(id = "otherChat", chatOwnerIds = listOf(userId, "someoneElse"))
        )

        coEvery {
            databaseSource.getDocumentsWhereArrayContains(
                Collections.CHATS,
                Fields.CHAT_OWNER_IDS,
                userId,
                Chat::class.java
            )
        } returns allUserChats

        // Act
        val result = messageRepository.getChat(userId, receiverId)

        // Assert
        assertEquals(Chat(), result) // Should return empty chat

        coVerify {
            databaseSource.getDocumentsWhereArrayContains(Collections.CHATS, Fields.CHAT_OWNER_IDS, userId, Chat::class.java)
        }
    }
}