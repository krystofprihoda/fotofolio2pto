package cz.cvut.fit

import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.serialization.kotlinx.json.*
import org.koin.ktor.plugin.Koin
import org.koin.logger.slf4jLogger
import fotofolio.serverModule

fun Application.configureFrameworks() {
    install(Koin) {
        slf4jLogger()
        modules(serverModule)
    }

    install(ContentNegotiation) {
        json()
    }
}
