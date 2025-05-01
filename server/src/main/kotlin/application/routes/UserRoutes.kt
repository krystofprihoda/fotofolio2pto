package application.routes

import io.ktor.utils.io.jvm.javaio.toInputStream
import domain.repository.UserRepository
import io.ktor.http.*
import org.koin.ktor.ext.inject
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.http.content.*
import java.io.ByteArrayOutputStream
import domain.model.User
import cz.cvut.fit.config.*

fun Application.userRoutes() {
    val userRepository by inject<UserRepository>()

    routing {
        get("/user/available") {
            tryOrThrow {
                val username = call.request.queryParameters["username"]
                    ?: throw BadRequestException("Missing or empty 'username' query parameter")

                if (username.isBlank()) {
                    throw BadRequestException("Missing or empty 'username' query parameter")
                }

                if (userRepository.isUsernameAvailable(username)) {
                    call.respond(HttpStatusCode.NoContent) // username available
                } else {
                    throw ConflictException("Username is already taken")
                }
            }
        }

        authenticate {
            post("/user") {
                tryOrThrow {
                    val userData = call.receive<User>()
                    val createdUser = userRepository.createUser(userData)
                    call.respond(HttpStatusCode.OK, createdUser)
                }
            }

            post("/user/{userId}/profilepicture") {
                tryOrThrow {
                    val userId = call.parameters["userId"] ?: throw BadRequestException("Missing userId")

                    val multipart = call.receiveMultipart()
                    var profilePicBytes: ByteArray? = null

                    multipart.forEachPart { part ->
                        if (part is PartData.FileItem && part.name == "profilepicture") {
                            val byteChannel = part.provider()
                            val inputStream = byteChannel.toInputStream()
                            val outputStream = ByteArrayOutputStream()
                            inputStream.copyTo(outputStream)
                            profilePicBytes = outputStream.toByteArray()
                        }
                        part.dispose()
                    }

                    if (profilePicBytes == null) {
                        throw BadRequestException("Missing image data")
                    }

                    val downloadUrl = userRepository.uploadProfilePicture(userId, profilePicBytes!!)
                    call.respond(HttpStatusCode.OK, mapOf("profilePictureUrl" to downloadUrl))
                }
            }

            post("/user/{receiverId}/rating") {
                tryOrThrow {
                    val receiverId = call.parameters["receiverId"] ?: throw BadRequestException("Missing receiverId")
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException("Unauthorized")
                    val requestBody = call.receive<Map<String, String>>()
                    val rating = requestBody["rating"]?.toIntOrNull() ?: throw BadRequestException("Valid rating value is required")

                    userRepository.rateUser(receiverId, principalId, rating)
                    call.respond(HttpStatusCode.OK, "Rating saved")
                }
            }

            get("/user") {
                tryOrThrow {
                    val searchQuery = call.request.queryParameters["query"]
                    val users = userRepository.searchUsers(searchQuery)
                    call.respond(HttpStatusCode.OK, users)
                }
            }

            get("/user/{userId}") {
                tryOrThrow {
                    val id = call.parameters["userId"] ?: throw BadRequestException("Missing userId")
                    val user = userRepository.getUserById(id)
                    call.respond(HttpStatusCode.OK, user)
                }
            }

            patch("/user/{userId}") {
                tryOrThrow {
                    val userId = call.parameters["userId"] ?: throw BadRequestException("Missing userId")

                    val updateData = call.receive<Map<String, String>>()

                    if (updateData.isEmpty()) {
                        throw BadRequestException("No fields to update")
                    }

                    val success = userRepository.updateUserFields(userId, updateData)
                    if (success) {
                        call.respond(HttpStatusCode.OK, "User updated successfully")
                    } else {
                        throw BadRequestException("No valid fields to update")
                    }
                }
            }
        }
    }
}