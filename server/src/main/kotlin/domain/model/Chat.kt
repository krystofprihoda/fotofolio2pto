package domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Chat(
    val id: String = "",
    val chatOwnerIds: List<String> = emptyList(),
    val messageIds: List<String> = emptyList(),
    val lastUpdated: Long = System.currentTimeMillis(),
    val lastMessage: String = "",
    val lastSenderId: String = ""
)

fun Chat.toMap(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "chatOwnerIds" to chatOwnerIds,
        "messageIds" to messageIds,
        "lastUpdated" to lastUpdated,
        "lastMessage" to lastMessage,
        "lastSenderId" to lastSenderId
    )
}