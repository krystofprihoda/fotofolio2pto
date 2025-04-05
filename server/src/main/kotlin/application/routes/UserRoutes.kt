package application.routes

import com.google.firebase.auth.FirebaseAuth
import domain.repository.PortfolioRepository
import domain.repository.UserRepository
import io.ktor.http.*
import org.koin.ktor.ext.inject
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable
import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await

// temporary location
@Serializable
data class User(
    val userId: String = "",
    val username: String = "",
    val email: String = "",
    val fullName: String = "",
    val location: String = "",
    val profilePicture: String = "",
    val rating: Map<String, Int> = emptyMap(),
    val creatorId: String = ""
)

fun Application.userRoutes() {
    val userRepository by inject<UserRepository>()
    val portfolioRepository by inject<PortfolioRepository>()

    routing {
        authenticate {
            post("/user") {
                try {
                    // Decode the received JSON body
                    val userData = call.receive<User>()

                    val db = FirestoreClient.getFirestore()

                    db.collection("user")
                        .document(userData.userId)
                        .set(userData)

                    val res = db
                        .collection("user")
                        .document(userData.userId)
                        .get()
                        .await()
                        .toObject(User::class.java) ?: throw Exception("Creating user failed")

                    call.respond(HttpStatusCode.OK, res)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/user") {
                try {
                    val searchQuery = call.request.queryParameters["query"]
                    val db = FirestoreClient.getFirestore()

                    // If no query provided, return all users
                    if (searchQuery.isNullOrBlank()) {
                        val snapshot = db.collection("user")
                            .get()
                            .await()

                        val users = snapshot.toObjects(User::class.java)
                        call.respond(HttpStatusCode.OK, users)
                        return@get
                    }

                    // Perform case-insensitive substring searches across multiple fields
                    val searchQueryLower = searchQuery.lowercase()

                    // Perform multiple queries and collect unique results
                    val usernameQuery = db.collection("user")
                        .whereGreaterThanOrEqualTo("username", searchQueryLower)
                        .whereLessThan("username", searchQueryLower + "\uf8ff")
                        .get()
                        .await()

                    val fullnameQuery = db.collection("user")
                        .whereGreaterThanOrEqualTo("fullName", searchQueryLower)
                        .whereLessThan("fullName", searchQueryLower + "\uf8ff")
                        .get()
                        .await()

                    val locationQuery = db.collection("user")
                        .whereGreaterThanOrEqualTo("location", searchQueryLower)
                        .whereLessThan("location", searchQueryLower + "\uf8ff")
                        .get()
                        .await()

                    // Combine and deduplicate results
                    val combinedUsers = mutableSetOf<User>()

                    usernameQuery.toObjects(User::class.java).forEach { combinedUsers.add(it) }
                    fullnameQuery.toObjects(User::class.java).forEach { combinedUsers.add(it) }
                    locationQuery.toObjects(User::class.java).forEach { combinedUsers.add(it) }

                    // Convert to list and respond
                    val uniqueUsers = combinedUsers.toList()
                    call.respond(HttpStatusCode.OK, uniqueUsers)

                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error searching users: ${e.localizedMessage}")
                }
            }

            get("/user/{userId}") {
                try {
                    val id = (call.parameters["userId"] as String)

                    val db = FirestoreClient.getFirestore()

                    val res = db
                        .collection("user")
                        .document(id)
                        .get()
                        .await()
                        .toObject(User::class.java) ?: throw Exception("User not found")

                    call.respond(HttpStatusCode.OK, res)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            put("/user/{userId}") {
                try {
                    val userId = call.parameters["userId"] as String

                    // Receive the updated user data
                    val updatedUserData = call.receive<User>()

                    val db = FirestoreClient.getFirestore()

                    // Check if the user exists first
                    val userRef = db.collection("user").document(userId)
                    val existingUserSnapshot = userRef.get().await()

                    if (!existingUserSnapshot.exists()) {
                        throw Exception("User not found")
                    }

                    // Update the user document
                    // Use set() to replace the entire document with the new data
                    userRef.set(updatedUserData).await()

                    // Retrieve the updated user to confirm and return
                    val updatedUser = userRef
                        .get()
                        .await()
                        .toObject(User::class.java) ?: throw Exception("Failed to retrieve updated user")

                    // Respond with the updated user
                    call.respond(HttpStatusCode.OK, updatedUser)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error updating user: ${e.localizedMessage}")
                }
            }
        }
    }
}