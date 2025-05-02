package application.routes

import cz.cvut.fit.application.mapper.RequestParser
import cz.cvut.fit.config.*
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.Params
import cz.cvut.fit.config.AppConstants.ResponseKeys
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import domain.repository.PortfolioRepository
import org.koin.ktor.ext.inject

fun Application.portfolioRoutes() {
    val portfolioRepository by inject<PortfolioRepository>()
    val requestParser by inject<RequestParser>()

    routing {
        authenticate {
            post("/portfolio") {
                tryOrThrow {
                    val multipart = call.receiveMultipart()
                    val portfolioDto = requestParser.parseCreatePortfolioDTO(multipart)

                    val portfolioId = portfolioRepository.createPortfolio(portfolioDto)

                    call.respond(HttpStatusCode.Created, mapOf(ResponseKeys.ID to portfolioId))
                }
            }

            get("/portfolio") {
                tryOrThrow {
                    val idParams = call.request.queryParameters[Params.ID]
                    val categoryParams = call.request.queryParameters[Params.CATEGORY]
                    val sortByParam = call.request.queryParameters[Params.SORT_BY]

                    // Parse portfolio IDs from comma-separated string
                    val ids = requestParser.parseCommaSeparatedList(idParams)

                    val portfolios = if (!ids.isNullOrEmpty()) {
                        // When IDs are provided, get portfolios by IDs
                        portfolioRepository.getPortfoliosByIds(ids)
                    } else {
                        // Otherwise, search by categories and sort
                        val categories = requestParser.parseCommaSeparatedList(categoryParams)
                        portfolioRepository.searchPortfolios(
                            categories = categories,
                            sortBy = sortByParam
                        )
                    }

                    call.respond(HttpStatusCode.OK, portfolios)
                }
            }

            get("/portfolio/{portfolioId}") {
                tryOrThrow {
                    val id = call.parameters["portfolioId"] ?: throw BadRequestException(Messages.MISSING_PORTFOLIO_ID)
                    val portfolio = portfolioRepository.getPortfolioById(id)
                    call.respond(HttpStatusCode.OK, portfolio)
                }
            }

            put("/portfolio/{portfolioId}") {
                tryOrThrow {
                    val portfolioId = call.parameters["portfolioId"] ?: throw BadRequestException(Messages.MISSING_PORTFOLIO_ID)
                    val requestBody = call.receive<Map<String, String>>()

                    val updateDTO = requestParser.parseUpdatePortfolioDTO(portfolioId, requestBody)

                    val updatedPortfolio = portfolioRepository.updatePortfolio(updateDTO)

                    call.respond(HttpStatusCode.OK, updatedPortfolio)
                }
            }

            delete("/portfolio/{portfolioId}") {
                tryOrThrow {
                    val portfolioId = call.parameters["portfolioId"] ?: throw BadRequestException(Messages.MISSING_PORTFOLIO_ID)
                    val success = portfolioRepository.deletePortfolio(portfolioId)

                    if (success) {
                        call.respond(HttpStatusCode.OK, Messages.PORTFOLIO_DELETED)
                    } else {
                        throw InternalServerException(Messages.FAILED_DELETE_PORTFOLIO)
                    }
                }
            }
        }
    }
}