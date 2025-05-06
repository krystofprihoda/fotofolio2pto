package config

import io.ktor.server.application.*
import io.ktor.server.plugins.swagger.*
import io.ktor.server.routing.*
import io.ktor.server.http.content.*

fun Application.openAPIRoutes() {
    routing {
        swaggerUI(path = "api/docs", swaggerFile = "openapi/documentation.yaml")

        // Raw OpenAPI file
        staticResources("/api", "openapi") {
            default("documentation.yaml")
        }
    }
}