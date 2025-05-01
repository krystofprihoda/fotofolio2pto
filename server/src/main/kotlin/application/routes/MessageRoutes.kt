package application.routes

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import domain.repository.MessageRepository
import org.koin.ktor.ext.inject
import cz.cvut.fit.config.*

fun Application.messageRoutes() {
    val messageRepository by inject<MessageRepository>()

    routing {
        authenticate {
            // Create chat with a message
            post("/chat") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException("Unauthorized")
                    val requestBody = call.receive<Map<String, String>>()

                    val messageBody = requestBody["message"] ?: throw BadRequestException("Message is required")
                    val receiverId = requestBody["receiverId"] ?: throw BadRequestException("Receiver ID is required")

                    val chat = messageRepository.createChat(principalId, receiverId, messageBody)

                    call.respond(HttpStatusCode.Created, chat)
                }
            }

            post("/chat/{chatId}/read") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException("Unauthorized")
                    val chatId = call.parameters["chatId"] ?: throw BadRequestException("Missing chat ID")

                    messageRepository.updateChatRead(chatId = chatId, principalId)

                    call.respond(HttpStatusCode.OK)
                }
            }

            // Send a message in an existing chat
            post("/chat/{chatId}/message") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException("Unauthorized")

                    val chatId = call.parameters["chatId"] ?: throw BadRequestException("Missing chat ID")
                    val requestBody = call.receive<Map<String, String>>()
                    val messageBody = requestBody["message"] ?: throw BadRequestException("Message is required")

                    val updatedChat = messageRepository.sendMessage(chatId, principalId, messageBody)

                    call.respond(HttpStatusCode.Created, updatedChat)
                }
            }

            // Get a chat between two users
            get("/chat") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException("Unauthorized")
                    val receiverId = call.request.queryParameters["receiverId"]

                    if (receiverId != null) {
                        val chat = messageRepository.getChat(principalId, receiverId)
                        call.respond(HttpStatusCode.OK, chat)
                        return@get
                    }

                    val chats = messageRepository.getChats(principalId)
                    call.respond(HttpStatusCode.OK, chats)
                }
            }

            // Get chat by ID
            get("/chat/{chatId}") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException("Unauthorized")
                    val chatId = call.parameters["chatId"] ?: throw BadRequestException("Missing chat ID")

                    val chat = messageRepository.getChatById(chatId, principalId)

                    call.respond(HttpStatusCode.OK, chat)
                }
            }

            // Get all messages for a chat
            get("/chat/{chatId}/message") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException("Unauthorized")
                    val chatId = call.parameters["chatId"] ?: throw BadRequestException("Missing chat ID")

                    val messages = messageRepository.getChatMessages(chatId, principalId)

                    call.respond(HttpStatusCode.OK, messages)
                }
            }
        }
    }
}