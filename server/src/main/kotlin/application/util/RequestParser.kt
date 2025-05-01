package cz.cvut.fit.application.mapper

import cz.cvut.fit.application.dto.portfolio.CreatePortfolioDTO
import cz.cvut.fit.application.dto.portfolio.UpdatePortfolioDTO
import cz.cvut.fit.config.BadRequestException
import io.ktor.http.content.*
import io.ktor.utils.io.jvm.javaio.*
import java.io.ByteArrayOutputStream

interface RequestParser {
    fun parseCommaSeparatedList(value: String?): List<String>?
    suspend fun parseCreatePortfolioDTO(multipart: MultiPartData): CreatePortfolioDTO
    suspend fun parseUpdatePortfolioDTO(portfolioId: String, requestBody: Map<String, String>): UpdatePortfolioDTO
}

class DefaultRequestParser : RequestParser {
    override fun parseCommaSeparatedList(value: String?): List<String>? {
        return value?.split(",")?.map { it.trim() }?.filter { it.isNotEmpty() }
    }

    override suspend fun parseCreatePortfolioDTO(multipart: MultiPartData): CreatePortfolioDTO {
        var creatorId: String? = null
        var name: String? = null
        var description: String? = null
        var price: String? = null
        var category: List<String> = emptyList()
        val photoBytesList = mutableListOf<Pair<String, ByteArray>>()

        multipart.forEachPart { part ->
            when (part) {
                is PartData.FormItem -> {
                    when (part.name) {
                        "creatorId" -> creatorId = part.value
                        "name" -> name = part.value
                        "description" -> description = part.value
                        "price" -> price = part.value
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

        // Validate required fields
        if (creatorId == null) {
            throw BadRequestException("creatorId is required")
        }
        if (name == null) {
            throw BadRequestException("name is required")
        }
        if (description == null) {
            throw BadRequestException("description is required")
        }
        if (price == null) {
            throw BadRequestException("price is required")
        }

        return CreatePortfolioDTO(
            creatorId = creatorId!!,
            name = name!!,
            description = description!!,
            price = price!!.toInt(),
            category = category,
            photos = photoBytesList
        )
    }

    override suspend fun parseUpdatePortfolioDTO(portfolioId: String, requestBody: Map<String, String>): UpdatePortfolioDTO {
        val name = requestBody["name"] ?: throw BadRequestException("name is required")
        val description = requestBody["description"] ?: throw BadRequestException("description is required")
        val price = requestBody["price"] ?: throw BadRequestException("price is required")
        val categoryRaw = requestBody["category"] ?: throw BadRequestException("category is required")
        val photoURLsRaw = requestBody["photoURLs"] ?: throw BadRequestException("photoURLs is required")

        val category = parseCommaSeparatedList(categoryRaw) ?: emptyList()
        val photoURLs = parseCommaSeparatedList(photoURLsRaw) ?: emptyList()

        try {
            val priceInt = price.toInt()
            return UpdatePortfolioDTO(
                portfolioId = portfolioId,
                name = name,
                description = description,
                price = priceInt,
                category = category,
                photoURLs = photoURLs
            )
        } catch (e: NumberFormatException) {
            throw BadRequestException("price must be a valid integer")
        }
    }
}