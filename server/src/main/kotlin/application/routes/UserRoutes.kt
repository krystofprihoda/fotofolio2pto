package application.routes

import domain.repository.UserRepository
import io.ktor.http.*
import org.koin.ktor.ext.inject
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.userRoutes() {
    val userRepository by inject<UserRepository>()

    routing {
        get("/users") {
            call.respond(HttpStatusCode.OK, userRepository.getUsers())
        }
        get("/users/{id}") {
            val id = (call.parameters["id"] as String)
            call.respond(HttpStatusCode.OK, userRepository.getUserById(id) ?: "User not found")
        }
    }
}