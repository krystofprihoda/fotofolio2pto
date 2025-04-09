package application.routes

import cz.cvut.fit.application.mapper.RequestParser
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
                try {
                    val multipart = call.receiveMultipart()
                    val portfolioDto = requestParser.parseCreatePortfolioDTO(multipart)

                    val portfolioId = portfolioRepository.createPortfolio(portfolioDto)

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
                    val portfolioIds = requestParser.parseCommaSeparatedList(portfolioIdsParam)
                    val categories = requestParser.parseCommaSeparatedList(categoryParams)

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
                    val portfolioId = call.parameters["portfolioId"] as String
                    val requestBody = call.receive<Map<String, String>>()

                    val updateDTO = requestParser.parseUpdatePortfolioDTO(portfolioId, requestBody)

                    val updatedPortfolio = portfolioRepository.updatePortfolio(updateDTO)

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