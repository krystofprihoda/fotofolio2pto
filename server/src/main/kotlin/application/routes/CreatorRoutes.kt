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
import cz.cvut.fit.config.*

fun Application.creatorRoutes() {

    val creatorRepository by inject<CreatorRepository>()
    val portfolioRepository by inject<PortfolioRepository>()

    routing {
        authenticate {
            post("/creator") {
                tryOrThrow {
                    val creatorData = call.receive<Creator>()
                    val creatorId = creatorRepository.createCreator(creatorData)

                    call.respond(HttpStatusCode.OK, mapOf("creatorId" to creatorId))
                }
            }

            get("/creator/{creatorId}") {
                tryOrThrow {
                    val id = call.parameters["creatorId"] ?: throw BadRequestException("Missing creatorId")
                    val creator = creatorRepository.getCreatorById(id)

                    call.respond(HttpStatusCode.OK, creator)
                }
            }

            get("/creator/{creatorId}/user") {
                tryOrThrow {
                    val id = call.parameters["creatorId"] ?: throw BadRequestException("Missing creatorId")
                    val user = creatorRepository.getUserByCreatorId(id)

                    call.respond(HttpStatusCode.OK, user)
                }
            }

            get("/creator/{creatorId}/portfolio") {
                tryOrThrow {
                    val creatorId = call.parameters["creatorId"] ?: throw BadRequestException("Missing creatorId")
                    val portfolios = portfolioRepository.getPortfoliosByCreatorId(creatorId)

                    call.respond(HttpStatusCode.OK, portfolios)
                }
            }

            put("/creator/{creatorId}") {
                tryOrThrow {
                    val creatorId = call.parameters["creatorId"] ?: throw BadRequestException("Missing creatorId")
                    val updatedCreatorData = call.receive<Creator>()

                    val success = creatorRepository.updateCreator(creatorId, updatedCreatorData)
                    if (success) {
                        call.respond(HttpStatusCode.OK, mapOf(
                            "message" to "Creator updated successfully",
                            "creatorId" to creatorId
                        ))
                    } else {
                        throw InternalServerException("Failed to update creator")
                    }
                }
            }

            patch("/creator/{creatorId}") {
                tryOrThrow {
                    val creatorId = call.parameters["creatorId"] ?: throw BadRequestException("Missing creatorId")

                    val body = call.receive<Map<String, String>>()

                    // Prepare updates map with appropriate types
                    val updates = mutableMapOf<String, Any>()

                    body["yearsOfExperience"]?.let {
                        updates["yearsOfExperience"] = it.toIntOrNull() ?: throw BadRequestException("Invalid yearsOfExperience value")
                    }

                    body["description"]?.let {
                        updates["description"] = it
                    }

                    if (updates.isEmpty()) {
                        throw BadRequestException("No valid fields to update")
                    }

                    val success = creatorRepository.updateCreatorFields(creatorId, updates)
                    if (success) {
                        call.respond(HttpStatusCode.OK, "Creator updated successfully")
                    } else {
                        throw InternalServerException("Failed to update creator")
                    }
                }
            }
        }
    }
}