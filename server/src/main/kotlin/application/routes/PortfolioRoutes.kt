package application.routes

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.http.content.*
import java.io.ByteArrayOutputStream
import io.ktor.utils.io.jvm.javaio.toInputStream
import kotlin.io.copyTo
import domain.repository.PortfolioRepository
import org.koin.ktor.ext.inject

fun Application.portfolioRoutes() {
    val portfolioRepository by inject<PortfolioRepository>()

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

                    // Parse all data and gather images
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

                    val portfolioId = portfolioRepository.createPortfolio(
                        creatorId = creatorId!!,
                        name = name!!,
                        description = description!!,
                        category = category,
                        photos = photoBytesList
                    )

                    call.respond(HttpStatusCode.Created, mapOf("id" to portfolioId))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error: ${e.localizedMessage}")
                }
            }

            get("/portfolio") {
                try {
                    val categoryParams = call.request.queryParameters["category"]
                    val sortByParam = call.request.queryParameters["sortBy"] // "timestamp" or "rating"
                    val portfolioIdsParam = call.request.queryParameters["id"]

                    // Parse portfolio IDs from comma-separated string
                    val portfolioIds = portfolioIdsParam?.split(",")?.map { it.trim() }?.filter { it.isNotEmpty() }
                    val categories = categoryParams?.split(",")?.map { it.trim() }?.filter { it.isNotEmpty() }

                    val portfolios = portfolioRepository.searchPortfolios(
                        categories = categories,
                        portfolioIds = portfolioIds,
                        sortBy = sortByParam
                    )

                    call.respond(HttpStatusCode.OK, portfolios)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/portfolio/{portfolioId}") {
                try {
                    val id = call.parameters["portfolioId"] as String
                    val portfolio = portfolioRepository.getPortfolioById(id)
                    call.respond(HttpStatusCode.OK, portfolio)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            put("/portfolio/{portfolioId}") {
                try {
                    val requestBody = call.receive<Map<String, String>>()

                    val portfolioId = call.parameters["portfolioId"] as String
                    val name = requestBody["name"]
                    val description = requestBody["description"]
                    val categoryRaw = requestBody["category"]
                    val photoURLsRaw = requestBody["photoURLs"]

                    if (name == null || description == null || categoryRaw == null || photoURLsRaw == null) {
                        call.respond(HttpStatusCode.BadRequest, "Missing one or more required fields")
                        return@put
                    }

                    val category = categoryRaw.split(",").map { it.trim() }
                    val updatedPhotoURLs = photoURLsRaw.split(",").map { it.trim() }

                    val updatedPortfolio = portfolioRepository.updatePortfolio(
                        portfolioId = portfolioId,
                        name = name,
                        description = description,
                        category = category,
                        photoURLs = updatedPhotoURLs
                    )

                    call.respond(HttpStatusCode.OK, updatedPortfolio)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, "Error: ${e.localizedMessage}")
                }
            }

            delete("/portfolio/{portfolioId}") {
                try {
                    val portfolioId = call.parameters["portfolioId"] as String
                    val success = portfolioRepository.deletePortfolio(portfolioId)

                    if (success) {
                        call.respond(HttpStatusCode.OK, "Portfolio deleted successfully")
                    } else {
                        call.respond(HttpStatusCode.InternalServerError, "Error deleting portfolio")
                    }
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.InternalServerError, "Error: ${e.localizedMessage}")
                }
            }
        }
    }
}