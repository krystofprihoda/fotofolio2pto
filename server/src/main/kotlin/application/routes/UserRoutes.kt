package application.routes

import domain.repository.PortfolioRepository
import domain.repository.UserRepository
import io.ktor.http.*
import org.koin.ktor.ext.inject
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.userRoutes() {
    val userRepository by inject<UserRepository>()
    val portfolioRepository by inject<PortfolioRepository>()

    routing {
        get("/user") {
            call.respond(HttpStatusCode.OK, userRepository.getUsers())
        }
        get("/user/{userId}") {
            val id = (call.parameters["userId"] as String)
            val user = userRepository.getUserById(id)
            call.respond(HttpStatusCode.OK, user ?: "User not found")
        }
        get("/user/{userId}/portfolio") {
            val userId = (call.parameters["userId"] as String)
            val portfolios = portfolioRepository.getPortfoliosForUser(userId)
            call.respond(HttpStatusCode.OK, portfolios)
        }
    }
}