package cz.cvut.fit

import com.kborowy.authprovider.firebase.firebase
import fotofolio.serverModule
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.plugins.contentnegotiation.*
import org.koin.ktor.plugin.Koin
import org.koin.logger.slf4jLogger
import java.io.File

fun Application.configureFrameworks() {
    install(Koin) {
        slf4jLogger()
        modules(serverModule)
    }

    install(ContentNegotiation) {
        json()
    }

    install(Authentication) {
        firebase {
            adminFile = File("fotofolio-3-firebase-key.json")
            realm = "fotofolio"

            validate {}
        }
    }
}
