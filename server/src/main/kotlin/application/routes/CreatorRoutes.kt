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
    val description: String = "",
    val portfolioIds: List<String> = emptyList()
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

            get("/creator/{creatorId}") {
                try {
                    val id = (call.parameters["creatorId"] as String)

                    val db = FirestoreClient.getFirestore()

                    val res = db
                        .collection("creator")
                        .document(id)
                        .get()
                        .await()
                        .toObject(Creator::class.java) ?: throw Exception("Creator not found")

                    call.respond(HttpStatusCode.OK, res)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/creator/{creatorId}/user") {
                try {
                    val id = (call.parameters["creatorId"] as String)

                    val db = FirestoreClient.getFirestore()

                    val creator = db
                        .collection("creator")
                        .document(id)
                        .get()
                        .await()
                        .toObject(Creator::class.java) ?: throw Exception("Creator not found")

                    val user = db
                        .collection("user")
                        .document(creator.userId)
                        .get()
                        .await()
                        .toObject(User::class.java) ?: throw Exception("User not found")

                    call.respond(HttpStatusCode.OK, user)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/creator/{creatorId}/portfolio") {
                try {
                    val creatorId = call.parameters["creatorId"] as String

                    val db = FirestoreClient.getFirestore()

                    // Retrieve the creator document
                    val creatorSnapshot = db
                        .collection("creator")
                        .document(creatorId)
                        .get()
                        .await()

                    val creator = creatorSnapshot.toObject(Creator::class.java)
                        ?: throw Exception("Creator not found")

                    // If no portfolio IDs, return an empty list
                    if (creator.portfolioIds.isEmpty()) {
                        call.respond(HttpStatusCode.OK, emptyList<Portfolio>())
                    }

                    // Retrieve portfolios using the stored portfolio IDs
                    val portfolios = db
                        .collection("portfolio")
                        .whereIn("id", creator.portfolioIds)
                        .get()
                        .await()
                        .toObjects(Portfolio::class.java)

                    call.respond(HttpStatusCode.OK, portfolios)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error retrieving portfolios: ${e.localizedMessage}")
                }
            }

            put("/creator/{creatorId}") {
                try {
                    val creatorId = call.parameters["creatorId"] as String

                    // Receive the updated creator data
                    val updatedCreatorData = call.receive<Creator>()

                    val db = FirestoreClient.getFirestore()

                    // Check if the creator exists first
                    val creatorRef = db.collection("creator").document(creatorId)
                    val existingCreatorSnapshot = creatorRef.get().await()

                    if (!existingCreatorSnapshot.exists()) {
                        throw Exception("Creator not found")
                    }

                    // Update the creator document
                    // Use set() to replace the entire document with the new data
                    creatorRef.set(updatedCreatorData).await()

                    // Respond with success message
                    call.respond(HttpStatusCode.OK, mapOf(
                        "message" to "Creator updated successfully",
                        "creatorId" to creatorId
                    ))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error updating creator: ${e.localizedMessage}")
                }
            }
        }
    }
}