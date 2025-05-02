package cz.cvut.fit.application.mapper

import cz.cvut.fit.application.dto.portfolio.CreatePortfolioDTO
import cz.cvut.fit.application.dto.portfolio.UpdatePortfolioDTO
import cz.cvut.fit.config.BadRequestException
import cz.cvut.fit.config.AppConstants.Fields
import cz.cvut.fit.config.AppConstants.Messages
import cz.cvut.fit.config.AppConstants.Storage
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
                        Fields.CREATOR_ID -> creatorId = part.value
                        Fields.NAME -> name = part.value
                        Fields.DESCRIPTION -> description = part.value
                        Fields.PRICE -> price = part.value
                        Fields.CATEGORY -> {
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
                    val fileName = part.originalFileName ?: String.format(Storage.DEFAULT_FILE_NAME_FORMAT, System.currentTimeMillis())
                    photoBytesList.add(fileName to fileBytes)
                }

                else -> Unit
            }
            part.dispose()
        }

        // Validate required fields
        if (creatorId == null) {
            throw BadRequestException(Messages.CREATOR_ID_REQUIRED)
        }
        if (name == null) {
            throw BadRequestException(Messages.NAME_REQUIRED)
        }
        if (description == null) {
            throw BadRequestException(Messages.DESCRIPTION_REQUIRED)
        }
        if (price == null) {
            throw BadRequestException(Messages.PRICE_REQUIRED)
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
        val name = requestBody[Fields.NAME] ?: throw BadRequestException(Messages.NAME_REQUIRED)
        val description = requestBody[Fields.DESCRIPTION] ?: throw BadRequestException(Messages.DESCRIPTION_REQUIRED)
        val price = requestBody[Fields.PRICE] ?: throw BadRequestException(Messages.PRICE_REQUIRED)
        val categoryRaw = requestBody[Fields.CATEGORY] ?: throw BadRequestException(Messages.CATEGORY_REQUIRED)
        val photoURLsRaw = requestBody[Fields.PHOTOS] ?: throw BadRequestException(Messages.PHOTO_URLS_REQUIRED)

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
            throw BadRequestException(Messages.INVALID_PRICE)
        }
    }
}