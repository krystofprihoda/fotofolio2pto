package domain.model

import kotlinx.serialization.Serializable

@Serializable
data class User(val id: String, val username: String) {
    companion object {
        fun mocks(): List<User> {
            return List(5) { User("id$it", "name$it") }
        }
    }

}