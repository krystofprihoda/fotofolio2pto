package cz.cvut.fit.config

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*
import kotlinx.serialization.Serializable

// Define custom exception classes for different error types
sealed class ApiException(
    val statusCode: HttpStatusCode,
    override val message: String
) : Exception(message)

class NotFoundException(message: String) : ApiException(HttpStatusCode.NotFound, message)
class BadRequestException(message: String) : ApiException(HttpStatusCode.BadRequest, message)
class UnauthorizedException(message: String) : ApiException(HttpStatusCode.Unauthorized, message)
class ForbiddenException(message: String) : ApiException(HttpStatusCode.Forbidden, message)
class ConflictException(message: String) : ApiException(HttpStatusCode.Conflict, message)
class InternalServerException(message: String) : ApiException(HttpStatusCode.InternalServerError, message)

// Define standard error response format
@Serializable
data class ErrorResponse(
    val status: Int,
    val message: String,
    val error: String
)

// Configure status pages for global error handling
fun Application.configureErrorHandling() {
    install(StatusPages) {
        // Handle our custom API exceptions
        exception<ApiException> { call, exception ->
            val errorResponse = ErrorResponse(
                status = exception.statusCode.value,
                message = exception.message,
                error = exception.statusCode.description
            )
            call.respond(exception.statusCode, errorResponse)
        }

        // Handle general exceptions
        exception<Exception> { call, exception ->
            val errorResponse = ErrorResponse(
                status = HttpStatusCode.InternalServerError.value,
                message = exception.localizedMessage ?: "An unexpected error occurred",
                error = HttpStatusCode.InternalServerError.description
            )
            call.respond(HttpStatusCode.InternalServerError, errorResponse)
        }
    }
}

// Extension function to handle try/catch in routes more elegantly
inline fun <T> tryOrThrow(block: () -> T): T {
    return try {
        block()
    } catch (e: ApiException) {
        // Just rethrow our custom exceptions
        throw e
    } catch (e: Exception) {
        // Map to appropriate ApiException or throw InternalServerException
        when {
            e.message?.contains("not found", ignoreCase = true) == true ->
                throw NotFoundException(e.localizedMessage ?: "Resource not found")
            e.message?.contains("unauthorized", ignoreCase = true) == true ->
                throw UnauthorizedException(e.localizedMessage ?: "Unauthorized")
            e.message?.contains("already") == true || e.message?.contains("conflict", ignoreCase = true) == true ->
                throw ConflictException(e.localizedMessage ?: "Resource conflict")
            e.message?.contains("missing", ignoreCase = true) == true ->
                throw BadRequestException(e.localizedMessage ?: "Invalid request")
            else -> throw InternalServerException(e.localizedMessage ?: "An unexpected error occurred")
        }
    }
}