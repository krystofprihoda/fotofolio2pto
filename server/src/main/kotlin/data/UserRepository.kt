package data

import domain.model.User
import domain.repository.UserRepository
import com.google.firebase.cloud.FirestoreClient

internal class UserRepositoryImpl : UserRepository {
    override suspend fun getUsers(): List<User> {
        val db = FirestoreClient.getFirestore()
        val document = db.collection("user").listDocuments().first()

        return User.mocks()
    }

    override suspend fun getUserById(id: String): User? {
        return User.mocks().find { user -> user.id == id }
    }

    override suspend fun createUser(username: String): User {
        return User.mocks().first()
    }

}