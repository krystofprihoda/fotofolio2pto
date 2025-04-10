package cz.cvut.fit.config

import com.kborowy.authprovider.firebase.firebase
import io.ktor.server.application.*
import io.ktor.server.auth.*
import java.io.ByteArrayInputStream
import java.io.File

fun Application.configureSecurity() {
    install(Authentication) {
        firebase {
            println("[SETUP] Initializing Firebase in Frameworks")

            val localFile = File("fotofolio-3-firebase-key.json")
            val inputStream = if (localFile.exists()) {
                localFile.inputStream()
            } else {
                ByteArrayInputStream(System.getenv("FIREBASE_KEY")?.toByteArray() ?: error("Firebase config not found"))
            }
            adminInputStream = inputStream
            realm = "fotofolio"

            validate { credential ->
                UserIdPrincipal(credential.uid)
            }
        }
    }
}
