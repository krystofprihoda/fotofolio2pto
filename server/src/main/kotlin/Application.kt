package cz.cvut.fit

import io.ktor.server.application.*
import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import java.io.FileInputStream

fun main(args: Array<String>) {
    io.ktor.server.netty.EngineMain.main(args)
}

fun Application.module() {
    configureFrameworks()
    configureHTTP()
    configureSecurity()
    configureRouting()
    // initializeFirebase()
}

fun initializeFirebase() {
    val keyPath = "/Users/prihokry/Data/Projects/Personal/fotofolio2pto/server/fotofolio-3-firebase-key.json"
    try {
        val serviceAccount = FileInputStream(keyPath)

        val options = FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .setProjectId("fotofolio-3")
            .build()

        FirebaseApp.initializeApp(options)
        println("Firebase initialized successfully")
    } catch (e: Exception) {
        println("Error initializing Firebase: ${e.message}")
    }
}

fun remoteInitializeFirebase() {
    val keyPath = "/Users/prihokry/Data/Projects/Personal/fotofolio2pto/server/fotofolio-3-firebase-key.json"

    // 1. Try loading the service account from a file in the resources directory.
    //    This is suitable for development and testing.
    val keyStream = object {}.javaClass.getResourceAsStream(keyPath)

    // 2. If the file isn't found in resources (e.g., in a deployed environment),
    //    try loading it from an environment variable.
    val options = if (keyStream != null) {
        // Load from resources directory
        FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.fromStream(keyStream))
            .setProjectId("fotofolio-3")
            .build()
    } else {
        // Load from environment variable (e.g., GOOGLE_APPLICATION_CREDENTIALS)
        // This is commonly used in production environments.
        val optionsBuilder = FirebaseOptions.builder()
        try {
            optionsBuilder.setCredentials(GoogleCredentials.getApplicationDefault())
        } catch (e: Exception) {
            // If you're not running in a Google Cloud environment and haven't
            // set the GOOGLE_APPLICATION_CREDENTIALS environment variable,
            // you'll need to handle this exception and provide the path to
            // your service account key file explicitly.
            println("Error getting default credentials: ${e.message}")

            // Example of explicitly loading from a file path (less secure, use with caution):
            val serviceAccountPath = System.getenv("GOOGLE_APPLICATION_CREDENTIALS") ?: keyPath
            val serviceAccountFileInputStream = FileInputStream(serviceAccountPath)
            optionsBuilder.setCredentials(GoogleCredentials.fromStream(serviceAccountFileInputStream))
        }
        optionsBuilder.setProjectId("fotofolio-3").build()
    }

    try {
        FirebaseApp.initializeApp(options)
        println("Firebase initialized successfully")
    } catch (e: IllegalStateException) {
        // Firebase is already initialized
        println("Firebase already initialized: ${e.message}")
    } catch (e: Exception) {
        println("Error initializing Firebase: ${e.message}")
    }
}
