package cz.cvut.fit

import application.routes.portfolioRoutes
import application.routes.userRoutes
import io.ktor.server.application.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    routing {
        userRoutes()
        portfolioRoutes()
    }
}
