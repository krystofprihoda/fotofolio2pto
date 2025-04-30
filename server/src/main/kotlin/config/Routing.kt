package cz.cvut.fit.config

import config.openAPIRoutes
import application.routes.creatorRoutes
import application.routes.messageRoutes
import application.routes.portfolioRoutes
import application.routes.userRoutes
import io.ktor.server.application.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    routing {
        openAPIRoutes()
        userRoutes()
        creatorRoutes()
        portfolioRoutes()
        messageRoutes()
    }
}
