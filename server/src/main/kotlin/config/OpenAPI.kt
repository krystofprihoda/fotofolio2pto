package config

import io.ktor.server.application.*
import io.ktor.server.plugins.swagger.*
import io.ktor.server.routing.*
import io.ktor.server.http.content.*

fun Application.openAPIRoutes() {
    routing {
        // Serve the Swagger UI
        swaggerUI(path = "api/docs", swaggerFile = "openapi/documentation.yaml")

        // Serve the raw OpenAPI file
        staticResources("/api", "openapi") {
            // You can add additional configuration here if needed
            // e.g., default file to serve
            default("documentation.yaml")
        }
    }
}