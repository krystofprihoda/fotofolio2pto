package data.source

import java.util.*
import java.net.URLEncoder
import com.google.firebase.cloud.StorageClient

interface StorageSource {
    suspend fun uploadFile(path: String, data: ByteArray, contentType: String): String
    suspend fun deleteFile(path: String): Boolean
}

class FirebaseStorageSource : StorageSource {
    private val bucket = StorageClient.getInstance().bucket("fotofolio-3.firebasestorage.app")

    override suspend fun uploadFile(path: String, data: ByteArray, contentType: String): String {
        val blob = bucket.create(path, data, contentType)

        val accessToken = UUID.randomUUID().toString()
        val metadata = blob.toBuilder()
            .setMetadata(mapOf("firebaseStorageDownloadTokens" to accessToken))
            .build()
            .update()

        val token = metadata.metadata?.get("firebaseStorageDownloadTokens")
        val encodedPath = URLEncoder.encode(path, "UTF-8")

        return "https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/$encodedPath?alt=media&token=$token"
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