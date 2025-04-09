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

fun Application.userRoutes() {
    val userRepository by inject<UserRepository>()

    routing {
        get("/user/available") {
            try {
                val username = call.request.queryParameters["username"]

                if (username.isNullOrBlank()) {
                    throw Exception("Missing or empty 'username' query parameter")
                }

                if (userRepository.isUsernameAvailable(username)) {
                    call.respond(HttpStatusCode.NoContent) // username available
                } else {
                    call.respond(HttpStatusCode.Conflict, "Username is already taken")
                }
            } catch (e: Exception) {
                call.respond(HttpStatusCode.InternalServerError, "Error checking availability: ${e.message}")
            }
        }

        authenticate {
            post("/user") {
                try {
                    val userData = call.receive<User>()
                    val createdUser = userRepository.createUser(userData)
                    call.respond(HttpStatusCode.OK, createdUser)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            post("/user/{userId}/profilepicture") {
                try {
                    val userId = call.parameters["userId"] ?: return@post call.respond(
                        HttpStatusCode.BadRequest, "Missing userId"
                    )

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
                        call.respond(HttpStatusCode.BadRequest, "Missing image data")
                        return@post
                    }

                    val downloadUrl = userRepository.uploadProfilePicture(userId, profilePicBytes!!)
                    call.respond(HttpStatusCode.OK, mapOf("profilePictureUrl" to downloadUrl))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, "Error: ${e.localizedMessage}")
                }
            }

            post("/user/{receiverId}/rating") {
                try {
                    val receiverId = call.parameters["receiverId"] ?: throw Exception("Missing receiverId")
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw Exception("Unauthorized")
                    val requestBody = call.receive<Map<String, String>>()
                    val rating = requestBody["rating"]?.toIntOrNull() ?: throw Exception("Valid rating value is required")

                    userRepository.rateUser(receiverId, principalId, rating)
                    call.respond(HttpStatusCode.OK, "Rating saved")
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error saving rating: ${e.localizedMessage}")
                }
            }

            get("/user") {
                try {
                    val searchQuery = call.request.queryParameters["query"]
                    val users = userRepository.searchUsers(searchQuery)
                    call.respond(HttpStatusCode.OK, users)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error searching users: ${e.localizedMessage}")
                }
            }

            get("/user/{userId}") {
                try {
                    val id = call.parameters["userId"] as String
                    val user = userRepository.getUserById(id)
                    call.respond(HttpStatusCode.OK, user)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            patch("/user/{userId}") {
                try {
                    val userId = call.parameters["userId"] ?: return@patch call.respond(
                        HttpStatusCode.BadRequest, "Missing userId"
                    )

                    val updateData = call.receive<Map<String, String>>()

                    if (updateData.isEmpty()) {
                        call.respond(HttpStatusCode.BadRequest, "No fields to update")
                        return@patch
                    }

                    val success = userRepository.updateUserFields(userId, updateData)
                    if (success) {
                        call.respond(HttpStatusCode.OK, "User updated successfully")
                    } else {
                        call.respond(HttpStatusCode.BadRequest, "No valid fields to update")
                    }
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, "Error updating user data: ${e.localizedMessage}")
                }
            }
            }
    }
}