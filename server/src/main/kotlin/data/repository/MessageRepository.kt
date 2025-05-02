package data.repository

import data.source.FirestoreSource
import domain.model.Chat
import domain.model.Message
import domain.model.toMap
import domain.repository.MessageRepository
import com.google.cloud.firestore.Query
import cz.cvut.fit.config.*
import cz.cvut.fit.config.AppConstants.Collections
import cz.cvut.fit.config.AppConstants.Fields
import cz.cvut.fit.config.AppConstants.Messages

class MessageRepositoryImpl(
    private val firestoreSource: FirestoreSource
) : MessageRepository {

    override suspend fun createChat(senderId: String, receiverId: String, message: String): Chat {
        val sortedParticipants = listOf(senderId, receiverId).sorted()

        // Check if chat already exists
        val chats = firestoreSource.getDocumentsWhereArrayContains(
            Collections.CHATS,
            Fields.CHAT_OWNER_IDS,
            senderId,
            Chat::class.java
        )
        val existingChat = chats.find { it.chatOwnerIds.sorted() == sortedParticipants }

        if (existingChat != null) {
            return existingChat
        }

        // Create new chat
        val newChat = Chat(
            chatOwnerIds = sortedParticipants,
            lastUpdated = System.currentTimeMillis()
        )

        val chatId = firestoreSource.createDocument(Collections.CHATS, newChat.toMap())

        // Create first message
        val messageObj = Message(
            chatId = chatId,
            from = senderId,
            to = receiverId,
            body = message,
            timestamp = System.currentTimeMillis()
        )

        val messageId = firestoreSource.createDocument(Collections.MESSAGES, messageObj.toMap())

        // Update chat with message info
        if (!firestoreSource.updateDocument(
                Collections.CHATS,
                chatId,
                mapOf(
                    Fields.MESSAGE_IDS to listOf(messageId),
                    Fields.LAST_UPDATED to messageObj.timestamp,
                    Fields.LAST_MESSAGE to messageObj.body,
                    Fields.LAST_SENDER_ID to senderId,
                    Fields.READ_BY_IDS to listOf(senderId)
                )
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_CHAT)
        }

        // Get updated chat
        return firestoreSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            ?: throw InternalServerException(Messages.FAILED_FETCH_CHAT)
    }

    override suspend fun sendMessage(chatId: String, senderId: String, message: String): Chat {
        val chat = firestoreSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            ?: throw NotFoundException(Messages.CHAT_NOT_FOUND)

        if (!chat.chatOwnerIds.contains(senderId)) {
            throw UnauthorizedException(Messages.UNAUTHORIZED_SEND)
        }

        val messageObj = Message(
            chatId = chatId,
            from = senderId,
            to = chat.chatOwnerIds.first { it != senderId }, // Send to the other participant
            body = message,
            timestamp = System.currentTimeMillis()
        )

        val messageId = firestoreSource.createDocument(Collections.MESSAGES, messageObj.toMap())

        val updatedMessageIds = chat.messageIds + messageId
        if (!firestoreSource.updateDocument(
                Collections.CHATS,
                chatId,
                mapOf(
                    Fields.MESSAGE_IDS to updatedMessageIds,
                    Fields.LAST_UPDATED to messageObj.timestamp,
                    Fields.LAST_MESSAGE to messageObj.body,
                    Fields.LAST_SENDER_ID to senderId,
                    Fields.READ_BY_IDS to listOf(senderId)
                )
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_CHAT_MESSAGE)
        }

        return firestoreSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            ?: throw InternalServerException(Messages.FAILED_FETCH_CHAT)
    }

    override suspend fun getChat(userId: String, receiverId: String): Chat {
        val chats = firestoreSource.getDocumentsWhereArrayContains(
            Collections.CHATS,
            Fields.CHAT_OWNER_IDS,
            userId,
            Chat::class.java
        )
        val chat = chats.find { it.chatOwnerIds.sorted() == listOf(userId, receiverId).sorted() }

        if (chat == null) {
            return Chat()
        }

        return chat
    }

    override suspend fun getChats(userId: String): List<Chat> {
        val chats = firestoreSource.getDocumentsWhereArrayContains(
            Collections.CHATS,
            Fields.CHAT_OWNER_IDS,
            userId,
            Chat::class.java
        )
        return chats.sortedByDescending { it.lastUpdated }
    }

    override suspend fun getChatById(chatId: String, userId: String): Chat {
        val chat = firestoreSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            ?: throw NotFoundException(Messages.CHAT_NOT_FOUND)

        if (!chat.chatOwnerIds.contains(userId)) {
            throw UnauthorizedException(Messages.UNAUTHORIZED_ACCESS)
        }

        return chat
    }

    override suspend fun getChatMessages(chatId: String, userId: String): List<Message> {
        val chat = getChatById(chatId, userId)

        val messages = firestoreSource.getDocumentsWhereOrdered(
            collection = Collections.MESSAGES,
            field = Fields.CHAT_ID,
            value = chatId,
            orderField = Fields.TIMESTAMP,
            direction = Query.Direction.ASCENDING,
            clazz = Message::class.java
        )

        updateChatRead(chatId = chatId, userId)
        return messages
    }

    override suspend fun updateChatRead(chatId: String, userId: String) {
        val chat = firestoreSource.getDocument(Collections.CHATS, chatId, Chat::class.java)
            ?: throw NotFoundException(Messages.CHAT_NOT_FOUND)

        if (!chat.chatOwnerIds.contains(userId)) {
            throw UnauthorizedException(Messages.UNAUTHORIZED_ACCESS)
        }

        if (chat.readByIds.contains(userId)) { return }
        val updatedIds = chat.readByIds + userId

        if (!firestoreSource.updateDocument(
                Collections.CHATS,
                chatId,
                mapOf(Fields.READ_BY_IDS to updatedIds)
            )) {
            throw InternalServerException(Messages.FAILED_UPDATE_CHAT_READ)
        }
    }
}