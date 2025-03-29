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
data class Portfolio(
    val id: String = "",
    val authorUsername: String = "",
    val creatorId: String = "",
    val name: String = "",
    val photos: List<String> = listOf(), // Assuming photo references/URLs
    val description: String = "",
    val category: List<String> = listOf(),
    val timestamp: Long = System.currentTimeMillis() / 1000
)

fun Application.portfolioRoutes() {
    routing {
        authenticate {
            get("/portfolio") {
                try {
                    val db = FirestoreClient.getFirestore()

                    val portfolios = db.collection("portfolio").get().await().documents.mapNotNull { document ->
                        document.toObject(Portfolio::class.java).copy(id = document.id)
                    }

                    print(portfolios)
                    call.respond(HttpStatusCode.OK, portfolios)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/portfolio/{portfolioId}") {
                try {
                    val id = call.parameters["portfolioId"] as String

                    val db = FirestoreClient.getFirestore()

                    val res = db
                        .collection("portfolio")
                        .document(id)
                        .get()
                        .await()
                        .toObject(Portfolio::class.java) ?: throw Exception("Portfolio not found")

                    call.respond(HttpStatusCode.OK, res)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            put("/portfolio/{portfolioId}") {
                try {
                    val portfolioId = call.parameters["portfolioId"] as String
                    val updatedPortfolioData = call.receive<Portfolio>()

                    val db = FirestoreClient.getFirestore()

                    // Update the existing portfolio document
                    db.collection("portfolio")
                        .document(portfolioId)
                        .set(updatedPortfolioData)
                        .await()

                    call.respond(HttpStatusCode.OK, mapOf("message" to "Portfolio updated successfully"))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            delete("/portfolio/{portfolioId}") {
                try {
                    val portfolioId = call.parameters["portfolioId"] as String

                    val db = FirestoreClient.getFirestore()

                    // Delete the portfolio document
                    db.collection("portfolio")
                        .document(portfolioId)
                        .delete()
                        .await()

                    call.respond(HttpStatusCode.OK, mapOf("message" to "Portfolio deleted successfully"))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }
        }
    }
}