package data.repository

import data.source.FirestoreSource
import domain.model.Chat
import domain.model.Message
import domain.model.toMap
import domain.repository.MessageRepository
import com.google.cloud.firestore.Query
import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await

class MessageRepositoryImpl(
    private val firestoreSource: FirestoreSource
) : MessageRepository {

    override suspend fun createChat(senderId: String, receiverId: String, message: String): Chat {
        val sortedParticipants = listOf(senderId, receiverId).sorted()

        // Check if chat already exists
        val chats = firestoreSource.getDocumentsWhereArrayContains("chat", "chatOwnerIds", senderId, Chat::class.java)
        val existingChat = chats.find { it.chatOwnerIds.sorted() == sortedParticipants }

        if (existingChat != null) {
            return existingChat
        }

        // Create new chat
        val newChat = Chat(
            chatOwnerIds = sortedParticipants,
            lastUpdated = System.currentTimeMillis()
        )

        val chatId = firestoreSource.createDocument("chat", newChat.toMap())

        // Create first message
        val messageObj = Message(
            chatId = chatId,
            from = senderId,
            to = receiverId,
            body = message,
            timestamp = System.currentTimeMillis()
        )

        val messageId = firestoreSource.createDocument("message", messageObj.toMap())

        // Update chat with message info
        firestoreSource.updateDocument("chat", chatId, mapOf(
            "messageIds" to listOf(messageId),
            "lastUpdated" to messageObj.timestamp,
            "lastMessage" to messageObj.body,
            "lastSenderId" to senderId,
            "readByIds" to listOf(senderId)
        ))

        // Get updated chat
        return firestoreSource.getDocument("chat", chatId, Chat::class.java)
            ?: throw Exception("Failed to fetch updated chat")
    }

    override suspend fun sendMessage(chatId: String, senderId: String, message: String): Chat {
        val chat = firestoreSource.getDocument("chat", chatId, Chat::class.java)
            ?: throw Exception("Chat not found")

        if (!chat.chatOwnerIds.contains(senderId)) {
            throw Exception("Unauthorized")
        }

        val messageObj = Message(
            chatId = chatId,
            from = senderId,
            to = chat.chatOwnerIds.first { it != senderId }, // Send to the other participant
            body = message,
            timestamp = System.currentTimeMillis()
        )

        val messageId = firestoreSource.createDocument("message", messageObj.toMap())

        val updatedMessageIds = chat.messageIds + messageId
        firestoreSource.updateDocument("chat", chatId, mapOf(
            "messageIds" to updatedMessageIds,
            "lastUpdated" to messageObj.timestamp,
            "lastMessage" to messageObj.body,
            "lastSenderId" to senderId,
            "readByIds" to listOf(senderId)
        ))

        return firestoreSource.getDocument("chat", chatId, Chat::class.java)
            ?: throw Exception("Failed to fetch updated chat")
    }

    override suspend fun getChat(userId: String, receiverId: String): Chat {
        val chats = firestoreSource.getDocumentsWhereArrayContains("chat", "chatOwnerIds", userId, Chat::class.java)
        val chat = chats.find { it.chatOwnerIds.sorted() == listOf(userId, receiverId).sorted() }

        if (chat == null) {
            return Chat()
        }

        return chat
    }

    override suspend fun getChats(userId: String): List<Chat> {
        val chats = firestoreSource.getDocumentsWhereArrayContains("chat", "chatOwnerIds", userId, Chat::class.java)
        return chats.sortedByDescending { it.lastUpdated }
    }

    override suspend fun getChatById(chatId: String, userId: String): Chat {
        val chat = firestoreSource.getDocument("chat", chatId, Chat::class.java)
            ?: throw Exception("Chat not found")

        if (!chat.chatOwnerIds.contains(userId)) {
            throw Exception("Unauthorized access")
        }

        return chat
    }

    override suspend fun getChatMessages(chatId: String, userId: String): List<Message> {
        val messages =  firestoreSource.getDocumentsWhereOrdered(
            collection = "message",
            field = "chatId",
            value = chatId,
            orderField = "timestamp",
            direction = Query.Direction.ASCENDING,
            clazz = Message::class.java
        )

        updateChatRead(chatId = chatId, userId)
        return messages
    }

    override suspend fun updateChatRead(chatId: String, userId: String) {
        val chat = firestoreSource.getDocument("chat", chatId, Chat::class.java)
            ?: throw Exception("Chat not found")

        if (!chat.chatOwnerIds.contains(userId)) {
            throw Exception("Unauthorized")
        }

        if (chat.readByIds.contains(userId)) { return }
        val updatedIds = chat.readByIds + userId

        firestoreSource.updateDocument("chat", chatId, mapOf(
            "readByIds" to updatedIds
        ))
    }
}