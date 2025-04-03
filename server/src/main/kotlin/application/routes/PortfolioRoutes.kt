package application.routes

import com.google.cloud.firestore.FieldPath
import com.google.cloud.firestore.Query
import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.FirebaseToken
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
                    val categoryParams = call.request.queryParameters["category"]
                    val sortByParam = call.request.queryParameters["sortBy"] // "timestamp" or "rating"
                    val portfolioIdsParam = call.request.queryParameters["id"]

                    var portfoliosQuery: Query = db.collection("portfolio")

                    // Parse portfolio IDs from comma-separated string
                    val portfolioIds = portfolioIdsParam?.split(",")?.map { it.trim() }?.filter { it.isNotEmpty() }
                    val categories = categoryParams?.split(",")?.map { it.trim() }?.filter { it.isNotEmpty() }

                    if (!portfolioIds.isNullOrEmpty()) {
                        // Firestore has a limit of 10 IDs for `whereIn`
                        if (portfolioIds.size > 10) {
                            throw Exception("Cannot query more than 10 portfolio IDs at a time")
                        }
                        portfoliosQuery = portfoliosQuery.whereIn(FieldPath.documentId(), portfolioIds)
                    }

                    if (!categories.isNullOrEmpty() && portfolioIds.isNullOrEmpty()) {
                        portfoliosQuery = portfoliosQuery.whereArrayContainsAny("category", categories)
                    }

                    val portfolios = portfoliosQuery.get().await().documents.mapNotNull { document ->
                        document.toObject(Portfolio::class.java).copy(id = document.id)
                    }

                    val sortedPortfolios = if (portfolioIds.isNullOrEmpty()) {
                        when (sortByParam) {
                            "timestamp" -> portfolios.sortedBy { it.timestamp }
                            "rating" -> {
                                val portfoliosWithRatings = portfolios.map { portfolio ->
                                    val creator = db.collection("user")
                                        .document(portfolio.creatorId)
                                        .get()
                                        .await()
                                        .toObject(Creator::class.java) ?: throw Exception("Portfolio creator not found")

                                    val user = creator.userId.let { userId ->
                                        db.collection("user")
                                            .document(userId)
                                            .get()
                                            .await()
                                            .toObject(User::class.java) ?: throw Exception("Portfolio user/author not found")
                                    }

                                    val avgRating = user.rating.values.average()
                                    portfolio to avgRating
                                }

                                portfoliosWithRatings.sortedByDescending { it.second }.map { it.first }
                            }
                            else -> portfolios // No sorting
                        }
                    } else {
                        portfolios // No sorting when fetching by IDs
                    }

                    call.respond(HttpStatusCode.OK, sortedPortfolios)
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