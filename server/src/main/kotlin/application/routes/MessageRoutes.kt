package application.routes

import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import domain.model.Chat
import domain.model.Message
import com.google.cloud.firestore.Query

fun Application.messageRoutes() {
    routing {
        authenticate {
            // Create chat with a message
            post("/chat") {
                try {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val requestBody = call.receive<Map<String, String>>()
                    val messageBody = requestBody["message"] ?: throw Exception("Message is required")
                    val receiverId = requestBody["receiverId"] ?: throw Exception("Receiver ID is required")

                    val sortedParticipants = listOf(principalId, receiverId).sorted()
                    val db = FirestoreClient.getFirestore()

                    val chatDocs = db.collection("chat")
                        .whereArrayContains("chatOwnerIds", principalId)
                        .get()
                        .await()

                    val existingChat = chatDocs.documents
                        .mapNotNull { it.toObject(Chat::class.java).copy(id = it.id) }
                        .find { it.chatOwnerIds.sorted() == sortedParticipants }

                    if (existingChat != null) {
                        call.respond(HttpStatusCode.OK, existingChat)
                        return@post
                    }

                    // Create new chat
                    val newChat = Chat(
                        chatOwnerIds = sortedParticipants,
                        lastUpdated = System.currentTimeMillis()
                    )

                    val chatRef = db.collection("chat").document()
                    chatRef.set(newChat).await()

                    // Insert the first message
                    val message = Message(
                        chatId = chatRef.id,
                        from = principalId,
                        to = receiverId,
                        body = messageBody,
                        timestamp = System.currentTimeMillis()
                    )

                    val messageRef = db.collection("message").document()
                    messageRef.set(message).await()

                    chatRef.update(
                        "messageIds", listOf(messageRef.id),
                        "lastUpdated", message.timestamp,
                        "lastMessage", message.body,
                        "lastSenderId", principalId
                    ).await()

                    // Retrieve the updated chat from Firestore
                    val updatedChat = chatRef.get().await().toObject(Chat::class.java)?.copy(id = chatRef.id)
                        ?: throw Exception("Failed to fetch updated chat")

                    call.respond(HttpStatusCode.Created, updatedChat)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error: ${e.localizedMessage}")
                }
            }

            // Send a message in an existing chat
            post("/chat/{chatId}/message") {
                try {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val chatId = call.parameters["chatId"] ?: throw Exception("Missing chat ID")
                    val requestBody = call.receive<Map<String, String>>()
                    val messageBody = requestBody["message"] ?: throw Exception("Message is required")

                    val db = FirestoreClient.getFirestore()
                    val chatRef = db.collection("chat").document(chatId)

                    val chat = chatRef.get().await().toObject(Chat::class.java)
                        ?: throw Exception("Chat not found")

                    if (!chat.chatOwnerIds.contains(principalId)) {
                        throw Exception("Unauthorized")
                    }

                    val message = Message(
                        chatId = chatId,
                        from = principalId,
                        to = chat.chatOwnerIds.first { it != principalId }, // Send to the other participant
                        body = messageBody,
                        timestamp = System.currentTimeMillis()
                    )

                    val messageRef = db.collection("message").document()
                    messageRef.set(message).await()

                    val updatedMessageIds = chat.messageIds + messageRef.id

                    chatRef.update(
                        "messageIds", updatedMessageIds,
                        "lastUpdated", message.timestamp,
                        "lastMessage", message.body,
                        "lastSenderId", principalId
                    ).await()

                    val updatedChat = chatRef
                        .get()
                        .await()
                        .toObject(Chat::class.java)?.copy(id = chatRef.id)
                        ?: throw Exception("Failed to fetch updated chat")

                    call.respond(HttpStatusCode.Created, updatedChat)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error: ${e.localizedMessage}")
                }
            }

            // Get a chat between two users
            get("/chat") {
                try {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val receiverId = call.request.queryParameters["receiverId"]

                    val db = FirestoreClient.getFirestore()
                    val chatDocs = db.collection("chat")
                        .whereArrayContains("chatOwnerIds", principalId)
                        .get()
                        .await()

                    val chats = chatDocs.documents.mapNotNull { it.toObject(Chat::class.java).copy(id = it.id) }

                    if (receiverId != null) {
                        // Find the exact chat with the given receiver
                        val chat = chats.find { it.chatOwnerIds.sorted() == listOf(principalId, receiverId).sorted() }

                        if (chat != null) {
                            call.respond(HttpStatusCode.OK, chat) // Return a single chat object
                        } else {
                            call.respond(HttpStatusCode.NotFound, "Chat not found")
                        }
                        return@get
                    }

                    // If no receiverId is provided, return all chats sorted by lastUpdated
                    call.respond(HttpStatusCode.OK, chats.sortedByDescending { it.lastUpdated })
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            // Get chat by ID
            get("/chat/{chatId}") {
                try {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val chatId = call.parameters["chatId"] ?: throw Exception("Missing chat ID")

                    val db = FirestoreClient.getFirestore()
                    val chatDoc = db.collection("chat").document(chatId).get().await()

                    val chat = chatDoc.toObject(Chat::class.java)?.copy(id = chatId)
                        ?: throw Exception("Chat not found")

                    if (!chat.chatOwnerIds.contains(principalId)) {
                        throw Exception("Unauthorized access")
                    }

                    call.respond(HttpStatusCode.OK, chat)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            // Get all messages for a chat
            get("/chat/{chatId}/message") {
                try {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val chatId = call.parameters["chatId"] ?: throw Exception("Missing chat ID")

                    val db = FirestoreClient.getFirestore()
                    val chat = db.collection("chat").document(chatId).get().await().toObject(Chat::class.java)
                        ?: throw Exception("Chat not found")

                    if (!chat.chatOwnerIds.contains(principalId)) {
                        throw Exception("Unauthorized")
                    }

                    val messagesQuery = db.collection("message")
                        .whereEqualTo("chatId", chatId)
                        .orderBy("timestamp", Query.Direction.ASCENDING)
                        .get()
                        .await()

                    val messages = messagesQuery.documents.mapNotNull { it.toObject(Message::class.java)?.copy(id = it.id) }

                    call.respond(HttpStatusCode.OK, messages)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error: ${e.localizedMessage}")
                }
            }
        }
    }
}