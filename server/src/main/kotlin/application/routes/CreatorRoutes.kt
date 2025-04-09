package application.routes

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import domain.model.Creator
import domain.repository.CreatorRepository
import domain.repository.PortfolioRepository
import org.koin.ktor.ext.inject

fun Application.creatorRoutes() {

    val creatorRepository by inject<CreatorRepository>()
    val portfolioRepository by inject<PortfolioRepository>()

    routing {
        authenticate {
            post("/creator") {
                try {
                    val creatorData = call.receive<Creator>()
                    val creatorId = creatorRepository.createCreator(creatorData)

                    call.respond(HttpStatusCode.OK, mapOf("creatorId" to creatorId))
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/creator/{creatorId}") {
                try {
                    val id = call.parameters["creatorId"] as String
                    val creator = creatorRepository.getCreatorById(id)

                    call.respond(HttpStatusCode.OK, creator)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/creator/{creatorId}/user") {
                try {
                    val id = call.parameters["creatorId"] as String
                    val user = creatorRepository.getUserByCreatorId(id)

                    call.respond(HttpStatusCode.OK, user)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error processing request: ${e.localizedMessage}")
                }
            }

            get("/creator/{creatorId}/portfolio") {
                try {
                    val creatorId = call.parameters["creatorId"] as String
                    val portfolios = portfolioRepository.getPortfoliosByCreatorId(creatorId)

                    call.respond(HttpStatusCode.OK, portfolios)
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error retrieving portfolios: ${e.localizedMessage}")
                }
            }

            put("/creator/{creatorId}") {
                try {
                    val creatorId = call.parameters["creatorId"] as String
                    val updatedCreatorData = call.receive<Creator>()

                    val success = creatorRepository.updateCreator(creatorId, updatedCreatorData)
                    if (success) {
                        call.respond(HttpStatusCode.OK, mapOf(
                            "message" to "Creator updated successfully",
                            "creatorId" to creatorId
                        ))
                    } else {
                        call.respond(HttpStatusCode.InternalServerError, "Failed to update creator")
                    }
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error updating creator: ${e.localizedMessage}")
                }
            }

            patch("/creator/{creatorId}") {
                try {
                    val creatorId = call.parameters["creatorId"] ?: return@patch call.respond(
                        HttpStatusCode.BadRequest, "Missing creatorId"
                    )

                    val body = call.receive<Map<String, String>>()

                    // Prepare updates map with appropriate types
                    val updates = mutableMapOf<String, Any>()

                    body["yearsOfExperience"]?.let {
                        updates["yearsOfExperience"] = it.toIntOrNull() ?: throw Exception("Invalid yearsOfExperience value")
                    }

                    body["description"]?.let {
                        updates["description"] = it
                    }

                    if (updates.isEmpty()) {
                        call.respond(HttpStatusCode.BadRequest, "No valid fields to update")
                        return@patch
                    }

                    val success = creatorRepository.updateCreatorFields(creatorId, updates)
                    if (success) {
                        call.respond(HttpStatusCode.OK, "Creator updated successfully")
                    } else {
                        call.respond(HttpStatusCode.InternalServerError, "Failed to update creator")
                    }
                } catch (e: Exception) {
                    call.respond(HttpStatusCode.BadRequest, "Error updating creator: ${e.localizedMessage}")
                }
            }
        }
    }
}