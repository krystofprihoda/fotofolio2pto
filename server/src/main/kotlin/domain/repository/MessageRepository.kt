package domain.repository

import domain.model.Chat
import domain.model.Message

interface MessageRepository {
    suspend fun createChat(senderId: String, receiverId: String, message: String): Chat
    suspend fun sendMessage(chatId: String, senderId: String, message: String): Chat
    suspend fun getChat(userId: String, receiverId: String? = null): Any
    suspend fun getChatById(chatId: String, userId: String): Chat
    suspend fun getChatMessages(chatId: String, userId: String): List<Message>
}