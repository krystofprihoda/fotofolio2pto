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
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await

// temporary location
@Serializable
data class User(
    val userId: String,
    val username: String,
    val email: String,
    val fullName: String
)

@Serializable
data class FirebaseUser(
    val username: String = "",
    val email: String = "",
    val fullName: String = ""
)

fun Application.userRoutes() {
    val userRepository by inject<UserRepository>()
    val portfolioRepository by inject<PortfolioRepository>()

    routing {
        authenticate {
            get("/user") {
                call.respond(HttpStatusCode.OK, userRepository.getUsers())
            }

            get("/user/{userId}") {
                val id = (call.parameters["userId"] as String)
                val user = userRepository.getUserById(id)
                call.respond(HttpStatusCode.OK, user ?: "User not found")
            }

            get("/user/{userId}/portfolio") {
                val userId = (call.parameters["userId"] as String)
                val portfolios = portfolioRepository.getPortfoliosForUser(userId)
                call.respond(HttpStatusCode.OK, portfolios)
            }

            post("/user") {
                try {
                    // Decode the received JSON body
                    val userData = call.receive<User>()

                    // Print the received user data
                    println("Received user data:")
                    println("User ID: ${userData.userId}")
                    println("Username: ${userData.username}")
                    println("Email: ${userData.email}")
                    println("Full Name: ${userData.fullName}")

                    val db = FirestoreClient.getFirestore()
                    db.collection("user")
                        .document(userData.userId)
                        .set(mapOf(
                            "username" to userData.username,
                            "email" to userData.email,
                            "fullName" to userData.fullName
                        ))

                    val res = db
                        .collection("user")
                        .document(userData.userId)
                        .get()
                        .await()
                        .toObject(FirebaseUser::class.java)

                    call.respond(HttpStatusCode.OK, res ?: "User not found")
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }
        }
    }
}