package config

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
                    println("[SETUP] Firebase will be initialized by AuthProvider")
                }
                initialized = true
            }
        }
    }

    fun isInitialized(): Boolean {
        return try {
            FirebaseApp.getInstance()
            true
        } catch (e: Exception) {
            false
        }
    }
}