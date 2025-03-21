package application.routes

import domain.repository.PortfolioRepository
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import org.koin.ktor.ext.inject

fun Application.portfolioRoutes() {
    val portfolioRepository by inject<PortfolioRepository>()

    routing {
        get("/portfolio") {
            call.respond(HttpStatusCode.OK, portfolioRepository.getPortfolios())
        }
    }
}