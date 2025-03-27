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
            get("/user") {
                call.respond(HttpStatusCode.OK, userRepository.getUsers())
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
                    println("Received: $userData")

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
        }
    }
}