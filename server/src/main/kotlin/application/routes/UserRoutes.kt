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
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.Params
import cz.cvut.fit.config.AppConstants.FormFields
import cz.cvut.fit.config.AppConstants.ResponseKeys

fun Application.userRoutes() {
    val userRepository by inject<UserRepository>()

    routing {
        get("/user/available") {
            tryOrThrow {
                val username = call.request.queryParameters[Params.USERNAME]
                    ?: throw BadRequestException(Messages.MISSING_USERNAME)

                if (username.isBlank()) {
                    throw BadRequestException(Messages.EMPTY_USERNAME)
                }

                if (userRepository.isUsernameAvailable(username)) {
                    call.respond(HttpStatusCode.NoContent) // Username available
                } else {
                    throw ConflictException(Messages.USERNAME_TAKEN)
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
                    val userId = call.parameters["userId"] ?: throw BadRequestException(Messages.MISSING_USER_ID)

                    val multipart = call.receiveMultipart()
                    var profilePicBytes: ByteArray? = null

                    multipart.forEachPart { part ->
                        if (part is PartData.FileItem && part.name == FormFields.PROFILE_PICTURE) {
                            val byteChannel = part.provider()
                            val inputStream = byteChannel.toInputStream()
                            val outputStream = ByteArrayOutputStream()
                            inputStream.copyTo(outputStream)
                            profilePicBytes = outputStream.toByteArray()
                        }
                        part.dispose()
                    }

                    if (profilePicBytes == null) {
                        throw BadRequestException(Messages.MISSING_IMAGE_DATA)
                    }

                    val downloadUrl = userRepository.uploadProfilePicture(userId, profilePicBytes!!)
                    call.respond(HttpStatusCode.OK, mapOf(ResponseKeys.PROFILE_PICTURE_URL to downloadUrl))
                }
            }

            post("/user/{receiverId}/rating") {
                tryOrThrow {
                    val receiverId = call.parameters["receiverId"] ?: throw BadRequestException(Messages.MISSING_RECEIVER_ID)
                    val principalId = call.principal<UserIdPrincipal>()?.name ?: throw UnauthorizedException(Messages.UNAUTHORIZED)
                    val requestBody = call.receive<Map<String, String>>()
                    val rating = requestBody[Params.SORT_BY_RATING]?.toIntOrNull() ?: throw BadRequestException(Messages.RATING_REQUIRED)

                    userRepository.rateUser(receiverId, principalId, rating)
                    call.respond(HttpStatusCode.OK, Messages.RATING_SAVED)
                }
            }

            get("/user") {
                tryOrThrow {
                    val searchQuery = call.request.queryParameters[Params.QUERY]
                    val users = userRepository.searchUsers(searchQuery)
                    call.respond(HttpStatusCode.OK, users)
                }
            }

            get("/user/{userId}") {
                tryOrThrow {
                    val id = call.parameters["userId"] ?: throw BadRequestException(Messages.MISSING_USER_ID)
                    val user = userRepository.getUserById(id)
                    call.respond(HttpStatusCode.OK, user)
                }
            }

            patch("/user/{userId}") {
                tryOrThrow {
                    val userId = call.parameters["userId"] ?: throw BadRequestException(Messages.MISSING_USER_ID)

                    val updateData = call.receive<Map<String, String>>()

                    if (updateData.isEmpty()) {
                        throw BadRequestException(Messages.NO_FIELDS_TO_UPDATE)
                    }

                    val success = userRepository.updateUserFields(userId, updateData)
                    if (success) {
                        call.respond(HttpStatusCode.OK, Messages.USER_UPDATED)
                    } else {
                        throw BadRequestException(Messages.NO_FIELDS_TO_UPDATE)
                    }
                }
            }
        }
    }
}