package data.source

import java.util.*
import java.net.URLEncoder
import com.google.firebase.cloud.StorageClient
import cz.cvut.fit.config.AppConstants.Config

interface StorageSource {
    suspend fun uploadFile(path: String, data: ByteArray, contentType: String): String
    suspend fun deleteFile(path: String): Boolean
}

class CloudStorageSource : StorageSource {
    private val bucket by lazy {
        try {
            StorageClient.getInstance().bucket(Config.FIREBASE_BUCKET_NAME)
        } catch (e: Exception) {
            throw IllegalStateException(e.message)
        }
    }

    override suspend fun uploadFile(path: String, data: ByteArray, contentType: String): String {
        val blob = bucket.create(path, data, contentType)

        val accessToken = UUID.randomUUID().toString()
        val metadata = blob.toBuilder()
            .setMetadata(mapOf(Config.FIREBASE_DOWNLOAD_TOKENS to accessToken))
            .build()
            .update()

        val token = metadata.metadata?.get(Config.FIREBASE_DOWNLOAD_TOKENS)
        val encodedPath = URLEncoder.encode(path, "UTF-8")

        return String.format(Config.STORAGE_DOWNLOAD_URL, encodedPath, token)
    }

    override suspend fun deleteFile(path: String): Boolean {
        return try {
            val blob = bucket.get(path)
            blob?.delete() ?: false
        } catch (e: Exception) {
            false
        }
    }
}