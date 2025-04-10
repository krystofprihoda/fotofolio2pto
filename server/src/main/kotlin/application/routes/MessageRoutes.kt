package application.routes

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import domain.repository.MessageRepository
import org.koin.ktor.ext.inject

fun Application.messageRoutes() {
    val messageRepository by inject<MessageRepository>()

    routing {
        authenticate {
            // Create chat with a message
            post("/chat") {
                try {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val requestBody = call.receive<Map<String, String>>()

                    val messageBody = requestBody["message"] ?: throw Exception("Message is required")
                    val receiverId = requestBody["receiverId"] ?: throw Exception("Receiver ID is required")

                    val chat = messageRepository.createChat(principalId, receiverId, messageBody)

                    call.respond(HttpStatusCode.Created, chat)
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

                    val updatedChat = messageRepository.sendMessage(chatId, principalId, messageBody)

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

                    if (receiverId != null) {
                        val chat = messageRepository.getChat(principalId, receiverId)
                        call.respond(HttpStatusCode.OK, chat)
                        return@get
                    }

                    val chats = messageRepository.getChats(principalId)
                    call.respond(HttpStatusCode.OK, chats)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            // Get chat by ID
            get("/chat/{chatId}") {
                try {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val chatId = call.parameters["chatId"] ?: throw Exception("Missing chat ID")

                    val chat = messageRepository.getChatById(chatId, principalId)

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

                    val messages = messageRepository.getChatMessages(chatId, principalId)

                    call.respond(HttpStatusCode.OK, messages)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error: ${e.localizedMessage}")
                }
            }
        }
    }
}