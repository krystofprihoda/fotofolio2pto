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
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.Params

fun Application.messageRoutes() {
    val messageRepository by inject<MessageRepository>()

    routing {
        authenticate {
            // Create chat with a message
            post("/chat") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException(Messages.UNAUTHORIZED)
                    val requestBody = call.receive<Map<String, String>>()

                    val messageBody = requestBody["message"] ?: throw BadRequestException(Messages.MESSAGE_REQUIRED)
                    val receiverId = requestBody[Params.RECEIVER_ID] ?: throw BadRequestException(Messages.RECEIVER_ID_REQUIRED)

                    val chat = messageRepository.createChat(principalId, receiverId, messageBody)

                    call.respond(HttpStatusCode.Created, chat)
                }
            }

            post("/chat/{chatId}/read") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException(Messages.UNAUTHORIZED)
                    val chatId = call.parameters["chatId"] ?: throw BadRequestException(Messages.MISSING_CHAT_ID)

                    messageRepository.updateChatRead(chatId = chatId, principalId)

                    call.respond(HttpStatusCode.OK)
                }
            }

            // Send a message in an existing chat
            post("/chat/{chatId}/message") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException(Messages.UNAUTHORIZED)

                    val chatId = call.parameters["chatId"] ?: throw BadRequestException(Messages.MISSING_CHAT_ID)
                    val requestBody = call.receive<Map<String, String>>()
                    val messageBody = requestBody[Params.MESSAGE] ?: throw BadRequestException(Messages.MESSAGE_REQUIRED)

                    val updatedChat = messageRepository.sendMessage(chatId, principalId, messageBody)

                    call.respond(HttpStatusCode.Created, updatedChat)
                }
            }

            // Get a chat between two users
            get("/chat") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException(Messages.UNAUTHORIZED)
                    val receiverId = call.request.queryParameters[Params.RECEIVER_ID]

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
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException(Messages.UNAUTHORIZED)
                    val chatId = call.parameters["chatId"] ?: throw BadRequestException(Messages.MISSING_CHAT_ID)

                    val chat = messageRepository.getChatById(chatId, principalId)

                    call.respond(HttpStatusCode.OK, chat)
                }
            }

            // Get all messages for a chat
            get("/chat/{chatId}/message") {
                tryOrThrow {
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException(Messages.UNAUTHORIZED)
                    val chatId = call.parameters["chatId"] ?: throw BadRequestException(Messages.MISSING_CHAT_ID)

                    val messages = messageRepository.getChatMessages(chatId, principalId)

                    call.respond(HttpStatusCode.OK, messages)
                }
            }
        }
    }
}