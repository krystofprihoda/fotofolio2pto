package data.source

import com.google.auth.oauth2.GoogleCredentials
import com.google.cloud.firestore.Firestore
import com.google.cloud.firestore.FieldPath
import com.google.cloud.firestore.FirestoreOptions
import com.google.cloud.firestore.Query
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.cloud.FirestoreClient
import com.kborowy.authprovider.firebase.await
import config.FirebaseInitializer
import java.io.File
import java.io.FileInputStream

interface FirestoreSource {
    suspend fun <T> getDocument(collection: String, documentId: String, clazz: Class<T>): T?
    suspend fun <T> getDocuments(collection: String, clazz: Class<T>): List<T>
    suspend fun <T> getDocumentsWhere(collection: String, field: String, value: Any, clazz: Class<T>): List<T>
    suspend fun <T> getDocumentsWhereArrayContains(collection: String, field: String, value: Any, clazz: Class<T>): List<T>
    suspend fun <T> getDocumentsWhereIn(collection: String, field: FieldPath, values: List<Any>, clazz: Class<T>): List<T>
    suspend fun checkDocumentExists(collection: String, documentId: String): Boolean
    suspend fun setDocument(collection: String, documentId: String, data: Map<String, Any>): Boolean
    suspend fun createDocument(collection: String, data: Map<String, Any>): String
    suspend fun updateDocument(collection: String, documentId: String, updates: Map<String, Any>): Boolean
    suspend fun deleteDocument(collection: String, documentId: String): Boolean
    suspend fun <T> queryDocumentsByPrefix(collection: String, field: String, prefix: String, clazz: Class<T>): List<T>
    suspend fun <T> getDocumentsOrdered(collection: String, field: String, direction: Query.Direction, clazz: Class<T>): List<T>
}

class FirebaseFirestoreSource : FirestoreSource {
    private val db: Firestore by lazy {
        if (!FirebaseInitializer.isInitialized()) {
            // For unauthenticated endpoints, we need to create a direct Firestore connection
            println("[FIRESTORE] Not yet initialized, creating for public endpoints")

            // Create a direct connection to Firestore for unauthenticated endpoints only
            val serviceAccountFile = File("fotofolio-3-firebase-key.json")
            val options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(FileInputStream(serviceAccountFile)))
                .setProjectId("fotofolio-3")
                .build()

            // Use a different app name to avoid conflicts
            val app = try {
                FirebaseApp.getInstance("UNAUTHENTICATED")
            } catch (e: Exception) {
                FirebaseApp.initializeApp(options, "UNAUTHENTICATED")
            }

            FirestoreOptions.getDefaultInstance()
                .toBuilder()
                .setProjectId(app.options.projectId)
                .build()
                .service
        } else {
            // For authenticated endpoints, use the standard FirestoreClient
            println("[FIRESTORE] Firebase initialized, using FirestoreClient")
            FirestoreClient.getFirestore()
        }
    }

    override suspend fun <T> getDocument(collection: String, documentId: String, clazz: Class<T>): T? {
        return db.collection(collection)
            .document(documentId)
            .get()
            .await()
            .toObject(clazz)
    }

    override suspend fun <T> getDocuments(collection: String, clazz: Class<T>): List<T> {
        return db.collection(collection)
            .get()
            .await()
            .toObjects(clazz)
    }

    override suspend fun <T> getDocumentsWhere(collection: String, field: String, value: Any, clazz: Class<T>): List<T> {
        return db.collection(collection)
            .whereEqualTo(field, value)
            .get()
            .await()
            .toObjects(clazz)
    }

    override suspend fun <T> getDocumentsWhereArrayContains(collection: String, field: String, value: Any, clazz: Class<T>): List<T> {
        return db.collection(collection)
            .whereArrayContains(field, value)
            .get()
            .await()
            .toObjects(clazz)
    }

    override suspend fun <T> getDocumentsWhereIn(collection: String, field: FieldPath, values: List<Any>, clazz: Class<T>): List<T> {
        return db.collection(collection)
            .whereIn(field, values)
            .get()
            .await()
            .toObjects(clazz)
    }

    override suspend fun checkDocumentExists(collection: String, documentId: String): Boolean {
        return db.collection(collection)
            .document(documentId)
            .get()
            .await()
            .exists()
    }

    override suspend fun setDocument(collection: String, documentId: String, data: Map<String, Any>): Boolean {
        return try {
            db.collection(collection)
                .document(documentId)
                .set(data)
                .await()
            true
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun createDocument(collection: String, data: Map<String, Any>): String {
        val docRef = db.collection(collection).document()
        val id = docRef.id
        val dataWithId = data + ("id" to id)

        docRef.set(dataWithId).await()
        return id
    }

    override suspend fun updateDocument(collection: String, documentId: String, updates: Map<String, Any>): Boolean {
        return try {
            db.collection(collection)
                .document(documentId)
                .update(updates)
                .await()
            true
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun deleteDocument(collection: String, documentId: String): Boolean {
        return try {
            db.collection(collection)
                .document(documentId)
                .delete()
                .await()
            true
        } catch (e: Exception) {
            false
        }
    }

    override suspend fun <T> queryDocumentsByPrefix(collection: String, field: String, prefix: String, clazz: Class<T>): List<T> {
        val endPrefix = prefix + "\uf8ff"
        return db.collection(collection)
            .whereGreaterThanOrEqualTo(field, prefix)
            .whereLessThan(field, endPrefix)
            .get()
            .await()
            .toObjects(clazz)
    }

    override suspend fun <T> getDocumentsOrdered(collection: String, field: String, direction: Query.Direction, clazz: Class<T>): List<T> {
        return db.collection(collection)
            .orderBy(field, direction)
            .get()
            .await()
            .toObjects(clazz)
    }
}