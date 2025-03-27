package application.routes

import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable

@Serializable
data class Creator(
    val userId: String = "",
    val yearsOfExperience: String = "",
    val description: String = ""
)

fun Application.creatorRoutes() {
    routing {
        authenticate {
            post("/creator") {
                try {
                    // Decode the received JSON body
                    val creatorData = call.receive<Creator>()
                    println("Received: $creatorData")

                    val db = FirestoreClient.getFirestore()

                    // Create a new creator document and get the generated ID
                    val creatorRef = db.collection("creator").document()
                    creatorRef.set(creatorData).await() // Ensure Firestore write completes

                    val creatorId = creatorRef.id // Get the newly created document ID
                    println("Created Creator with ID: $creatorId")

                    // Update the user document with the new creatorId
                    val userRef = db.collection("user").document(creatorData.userId)
                    userRef.update("creatorId", creatorId).await()

                    // Respond with success and return the creatorId
                    call.respond(HttpStatusCode.OK, mapOf("creatorId" to creatorId))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }
        }
    }
}