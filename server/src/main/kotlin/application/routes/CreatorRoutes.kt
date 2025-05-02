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
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.ResponseKeys
import cz.cvut.fit.config.AppConstants.Fields

fun Application.creatorRoutes() {

    val creatorRepository by inject<CreatorRepository>()
    val portfolioRepository by inject<PortfolioRepository>()

    routing {
        authenticate {
            post("/creator") {
                tryOrThrow {
                    val creatorData = call.receive<Creator>()
                    val creatorId = creatorRepository.createCreator(creatorData)

                    call.respond(HttpStatusCode.OK, mapOf(ResponseKeys.CREATOR_ID to creatorId))
                }
            }

            get("/creator/{creatorId}") {
                tryOrThrow {
                    val id = call.parameters["creatorId"] ?: throw BadRequestException(Messages.MISSING_CREATOR_ID)
                    val creator = creatorRepository.getCreatorById(id)

                    call.respond(HttpStatusCode.OK, creator)
                }
            }

            get("/creator/{creatorId}/user") {
                tryOrThrow {
                    val id = call.parameters["creatorId"] ?: throw BadRequestException(Messages.MISSING_CREATOR_ID)
                    val user = creatorRepository.getUserByCreatorId(id)

                    call.respond(HttpStatusCode.OK, user)
                }
            }

            get("/creator/{creatorId}/portfolio") {
                tryOrThrow {
                    val creatorId = call.parameters["creatorId"] ?: throw BadRequestException(Messages.MISSING_CREATOR_ID)
                    val portfolios = portfolioRepository.getPortfoliosByCreatorId(creatorId)

                    call.respond(HttpStatusCode.OK, portfolios)
                }
            }

            put("/creator/{creatorId}}") {
                tryOrThrow {
                    val creatorId = call.parameters["creatorId"] ?: throw BadRequestException(Messages.MISSING_CREATOR_ID)
                    val updatedCreatorData = call.receive<Creator>()

                    val success = creatorRepository.updateCreator(creatorId, updatedCreatorData)
                    if (success) {
                        call.respond(HttpStatusCode.OK, mapOf(
                            ResponseKeys.MESSAGE to Messages.CREATOR_UPDATED,
                            ResponseKeys.CREATOR_ID to creatorId
                        ))
                    } else {
                        throw InternalServerException(Messages.FAILED_UPDATE_CREATOR)
                    }
                }
            }

            patch("/creator/{creatorId}") {
                tryOrThrow {
                    val creatorId = call.parameters["creatorId"] ?: throw BadRequestException(Messages.MISSING_CREATOR_ID)

                    val body = call.receive<Map<String, String>>()

                    // Prepare updates map with appropriate types
                    val updates = mutableMapOf<String, Any>()

                    body[Fields.YEARS_EXPERIENCE]?.let {
                        updates[Fields.YEARS_EXPERIENCE] = it.toIntOrNull()
                            ?: throw BadRequestException(Messages.INVALID_YOE)
                    }

                    body[Fields.DESCRIPTION]?.let {
                        updates[Fields.DESCRIPTION] = it
                    }

                    if (updates.isEmpty()) {
                        throw BadRequestException(Messages.NO_FIELDS_TO_UPDATE)
                    }

                    val success = creatorRepository.updateCreatorFields(creatorId, updates)
                    if (success) {
                        call.respond(HttpStatusCode.OK, Messages.CREATOR_UPDATED)
                    } else {
                        throw InternalServerException(Messages.FAILED_UPDATE_CREATOR)
                    }
                }
            }
        }
    }
}