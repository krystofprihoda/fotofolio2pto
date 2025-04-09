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

import com.google.firebase.FirebaseApp

object FirebaseInitializer {
    private var initialized = false
    private val lock = Any()

    fun initialize() {
        if (initialized) return

        synchronized(lock) {
            if (!initialized) {
                try {
                    // Just check if Firebase is already initialized
                    FirebaseApp.getInstance()
                    println("[SETUP] Firebase is already initialized")
                } catch (e: Exception) {
                    // Do NOT initialize here, let the auth provider do it
                    println("[SETUP] Firebase will be initialized by auth provider")
                }
                initialized = true
            }
        }
    }

    // Add this method to check if Firebase is initialized without trying to initialize it
    fun isInitialized(): Boolean {
        return try {
            FirebaseApp.getInstance()
            true
        } catch (e: Exception) {
            false
        }
    }
}

fun Application.configureFrameworks() {
    install(Koin) {
        println("[SETUP] Initializing Koin Modules")
        slf4jLogger()
        modules(appModule)
    }

    install(ContentNegotiation) {
        json()
    }
}
