package application.routes

import com.google.cloud.firestore.FieldPath
import com.google.cloud.firestore.Query
import com.google.firebase.cloud.FirestoreClient
import com.google.firebase.cloud.StorageClient
import com.kborowy.authprovider.firebase.await
import domain.model.Portfolio
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.http.content.*
import java.io.ByteArrayOutputStream
import io.ktor.utils.io.jvm.javaio.toInputStream
import java.net.URLEncoder
import java.util.*
import kotlin.io.copyTo

fun Application.portfolioRoutes() {
    routing {
        authenticate {
            post("/portfolio") {
                try {
                    val multipart = call.receiveMultipart()

                    var creatorId: String? = null
                    var name: String? = null
                    var description: String? = null
                    var category: List<String> = emptyList()
                    val photoBytesList = mutableListOf<Pair<String, ByteArray>>() // store filenames and their bytes

                    // First parse all data and gather images
                    multipart.forEachPart { part ->
                        when (part) {
                            is PartData.FormItem -> {
                                when (part.name) {
                                    "creatorId" -> creatorId = part.value
                                    "name" -> name = part.value
                                    "description" -> description = part.value
                                    "category" -> {
                                        category = part.value.split(",").map { it.trim() }
                                    }
                                }
                            }

                            is PartData.FileItem -> {
                                val byteChannel = part.provider()
                                val inputStream = byteChannel.toInputStream()

                                val outputStream = ByteArrayOutputStream()
                                inputStream.use { input ->
                                    outputStream.use { output ->
                                        input.copyTo(output)
                                    }
                                }

                                val fileBytes = outputStream.toByteArray()
                                val fileName = part.originalFileName ?: "image_${System.currentTimeMillis()}.jpg"
                                photoBytesList.add(fileName to fileBytes)
                            }

                            else -> Unit
                        }
                        part.dispose()
                    }

                    if (creatorId == null || name == null || description == null) {
                        call.respond(HttpStatusCode.BadRequest, "Missing fields")
                        return@post
                    }

                    val db = FirestoreClient.getFirestore()

                    // Get the user to fetch their username AND userId (needed for storage path)
                    val usersQuery = db.collection("user")
                        .whereEqualTo("creatorId", creatorId)
                        .limit(1)
                        .get()
                        .await()

                    if (usersQuery.isEmpty) {
                        call.respond(HttpStatusCode.NotFound, "Creator's username not found")
                        return@post
                    }

                    val userDoc = usersQuery.documents.first()
                    val user = userDoc.toObject(User::class.java)
                    val userId = user.userId
                    val authorUsername = user.username

                    // Create Firestore doc to get the portfolioId
                    val portfolioDocRef = db.collection("portfolio").document()
                    val portfolioId = portfolioDocRef.id

                    val bucket = StorageClient.getInstance().bucket("fotofolio-3.firebasestorage.app")
                    val photoUrls = mutableListOf<String>()

                    // Upload each image to the correct path
                    for ((fileName, fileBytes) in photoBytesList) {
                        val contentType = "image/jpeg"
                        val storagePath = "user/$userId/creator/portfolio/$portfolioId/$fileName"

                        val blob = bucket.create(
                            storagePath,
                            fileBytes,
                            contentType
                        )

                        val accessToken = UUID.randomUUID().toString()
                        val metadata = blob.toBuilder()
                            .setMetadata(mapOf("firebaseStorageDownloadTokens" to accessToken))
                            .build()
                            .update()

                        val token = metadata.metadata?.get("firebaseStorageDownloadTokens")

                        val encodedPath = URLEncoder.encode(storagePath, "UTF-8")
                        val downloadUrl = "https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/$encodedPath?alt=media&token=$token"
                        photoUrls.add(downloadUrl)
                    }

                    val portfolio = Portfolio(
                        id = portfolioId,
                        creatorId = creatorId!!,
                        authorUsername = authorUsername,
                        name = name!!,
                        description = description!!,
                        photos = photoUrls,
                        category = category,
                        timestamp = System.currentTimeMillis()
                    )

                    // Save portfolio to Firestore
                    portfolioDocRef.set(portfolio).await()

                    // Update the creator document
                    val creatorRef = db.collection("creator").document(creatorId!!)
                    val creatorSnapshot = creatorRef.get().await()

                    if (creatorSnapshot.exists()) {
                        val creator = creatorSnapshot.toObject(Creator::class.java)
                        val updatedPortfolioIds = creator?.portfolioIds?.toMutableList() ?: mutableListOf()
                        updatedPortfolioIds.add(portfolioId)

                        creatorRef.update("portfolioIds", updatedPortfolioIds).await()
                    } else {
                        call.respond(HttpStatusCode.NotFound, "Creator not found")
                        return@post
                    }

                    call.respond(HttpStatusCode.Created, mapOf("id" to portfolioId))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error: ${e.localizedMessage}")
                }
            }

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
                            "timestamp" -> portfolios.sortedByDescending { it.timestamp }
                            "rating" -> {
                                val portfoliosWithRatings = portfolios.map { portfolio ->
                                    val creator = db.collection("creator")
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