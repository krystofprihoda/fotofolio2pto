package application.routes

import com.google.cloud.firestore.FieldPath
import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await
import domain.model.Portfolio
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable

@Serializable
data class Creator(
    val id: String = "",
    val userId: String = "",
    val yearsOfExperience: Int = 1,
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

                    val db = FirestoreClient.getFirestore()

                    // Create a new creator document and get the generated ID
                    val creatorRef = db.collection("creator").document()
                    creatorRef.set(creatorData).await() // Ensure Firestore write completes

                    val creatorId = creatorRef.id // Get the newly created document ID

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

                    val creator = db
                        .collection("creator")
                        .document(id)
                        .get()
                        .await()
                        .toObject(Creator::class.java) ?: throw Exception("Creator not found")

                    val res = creator.copy(id=id)

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
                    val creator = db
                        .collection("creator")
                        .document(creatorId)
                        .get()
                        .await()
                        .toObject(Creator::class.java) ?: throw Exception("Creator not found")

                    // If no portfolio IDs, return an empty list
                    if (creator.portfolioIds.isEmpty()) {
                        call.respond(HttpStatusCode.OK, emptyList<String>())
                    }

                    // Retrieve portfolios using the stored portfolio IDs
                    val portfolios = db
                        .collection("portfolio")
                        .whereIn(FieldPath.documentId(), creator.portfolioIds)
                        .get()
                        .await()
                        .documents
                        .mapNotNull { document ->
                            document.toObject(Portfolio::class.java).copy(id = document.id)
                        }

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