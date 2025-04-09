package domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Message(
    val id: String = "",
    val chatId: String = "",
    val from: String = "",
    val to: String = "",
    val body: String = "",
    val timestamp: Long = System.currentTimeMillis()
)

fun Message.toMap(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "chatId" to chatId,
        "from" to from,
        "to" to to,
        "body" to body,
        "timestamp" to timestamp
    )
}