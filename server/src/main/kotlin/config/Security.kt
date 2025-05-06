package cz.cvut.fit.config

import com.kborowy.authprovider.firebase.firebase
import io.ktor.server.application.*
import io.ktor.server.auth.*
import java.io.ByteArrayInputStream
import java.io.File

fun Application.configureSecurity() {
    install(Authentication) {
        firebase {
            val localFile = File(AppConstants.Config.FIREBASE_KEY_PATH)
            val inputStream = if (localFile.exists()) {
                localFile.inputStream()
            } else {
                ByteArrayInputStream(
                    System.getenv(AppConstants.Config.FIREBASE_ENV_KEY)
                        ?.toByteArray()
                    ?: error(AppConstants.Messages.CONFIG_NOT_FOUND)
                )
            }
            adminInputStream = inputStream
            realm = AppConstants.Config.REALM

            validate { credential ->
                UserIdPrincipal(credential.uid)
            }
        }
    }
}
