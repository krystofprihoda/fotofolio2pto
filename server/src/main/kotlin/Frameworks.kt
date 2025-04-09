package cz.cvut.fit

import appModule
import com.kborowy.authprovider.firebase.firebase
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.plugins.contentnegotiation.*
import org.koin.ktor.plugin.Koin
import org.koin.logger.slf4jLogger
import java.io.File

fun Application.configureFrameworks() {
    install(Authentication) {
        firebase {
            adminFile = File("fotofolio-3-firebase-key.json")
            realm = "fotofolio"

            validate { credential ->
                UserIdPrincipal(credential.uid)
            }
        }
    }

    install(Koin) {
        slf4jLogger()
        modules(appModule)
    }

    install(ContentNegotiation) {
        json()
    }
}
