package cz.cvut.fit.config

import com.kborowy.authprovider.firebase.firebase
import io.ktor.server.application.*
import io.ktor.server.auth.*
import java.io.File

fun Application.configureSecurity() {
    install(Authentication) {
        firebase {
            println("[SETUP] Initializing Firebase in Frameworks")
            adminFile = File("fotofolio-3-firebase-key.json")
            realm = "fotofolio"

            validate { credential ->
                UserIdPrincipal(credential.uid)
            }
        }
    }
}
