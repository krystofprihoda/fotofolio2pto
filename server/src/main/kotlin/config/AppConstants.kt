package cz.cvut.fit.config

/**
 * Application-wide constants categorized by their purpose.
 * This file centralizes magic strings and constants used throughout the application.
 */
object AppConstants {

    /**
     * Database collection names
     */
    object Collections {
        const val USERS = "user"
        const val USERNAMES = "username"
        const val CREATORS = "creator"
        const val PORTFOLIOS = "portfolio"
        const val CHATS = "chat"
        const val MESSAGES = "message"
    }

    /**
     * Common field names used in database operations
     */
    object Fields {
        // Common fields
        const val ID = "id"
        const val TIMESTAMP = "timestamp"

        // User fields
        const val USER_ID = "userId"
        const val USERNAME = "username"
        const val FULL_NAME = "fullName"
        const val LOCATION = "location"
        const val PROFILE_PICTURE = "profilePicture"
        const val RATING = "rating"
        const val CREATOR_ID = "creatorId"

        // Creator fields
        const val YEARS_EXPERIENCE = "yearsOfExperience"
        const val DESCRIPTION = "description"
        const val PORTFOLIO_IDS = "portfolioIds"

        // Portfolio fields
        const val NAME = "name"
        const val PRICE = "price"
        const val CATEGORY = "category"
        const val PHOTOS = "photos"

        // Message fields
        const val CHAT_ID = "chatId"

        // Chat fields
        const val CHAT_OWNER_IDS = "chatOwnerIds"
        const val MESSAGE_IDS = "messageIds"
        const val LAST_UPDATED = "lastUpdated"
        const val LAST_MESSAGE = "lastMessage"
        const val LAST_SENDER_ID = "lastSenderId"
        const val READ_BY_IDS = "readByIds"
    }

    /**
     * File storage related constants
     */
    object Storage {
        const val CONTENT_TYPE_JPEG = "image/jpeg"
        const val DEFAULT_FILE_NAME_FORMAT = "image_%s.jpg"

        // Path patterns
        const val USER_PROFILE_PATH = "user/%s/profilepicture.jpeg"
        const val PORTFOLIO_PHOTO_PATH = "user/%s/creator/portfolio/%s/%s"
    }

    /**
     * Common messages
     */
    object Messages {
        // Success messages
        const val USER_UPDATED = "User updated successfully"
        const val CREATOR_UPDATED = "Creator updated successfully"
        const val PORTFOLIO_DELETED = "Portfolio deleted successfully"
        const val RATING_SAVED = "Rating saved"

        // Error messages
        const val USER_NOT_FOUND = "User not found"
        const val CREATOR_NOT_FOUND = "Creator not found"
        const val PORTFOLIO_NOT_FOUND = "Portfolio not found"
        const val PORTFOLIO_CREATOR_NOT_FOUND = "Portfolio creator not found"
        const val PORTFOLIO_USER_NOT_FOUND = "Portfolio user/author not found"
        const val CHAT_NOT_FOUND = "Chat not found"

        const val NO_FIELDS_TO_UPDATE = "No valid fields to update"
        const val MISSING_USER_ID = "Missing userId"
        const val MISSING_RECEIVER_ID = "Missing receiverId"
        const val MISSING_CREATOR_ID = "Missing creatorId"
        const val MISSING_PORTFOLIO_ID = "Missing portfolioId"
        const val MISSING_CHAT_ID = "Missing chat ID"
        const val MISSING_IMAGE_DATA = "Missing image data"
        const val USERNAME_TAKEN = "Username is already taken"
        const val UNAUTHORIZED = "Unauthorized"
        const val UNAUTHORIZED_ACCESS = "You are not authorized to access this chat"
        const val UNAUTHORIZED_SEND = "You are not authorized to send messages in this chat"

        // ValidationMessages
        const val NAME_REQUIRED = "'name' is required"
        const val DESCRIPTION_REQUIRED = "'description' is required"
        const val CREATOR_ID_REQUIRED = "'creatorId' is required"
        const val PRICE_REQUIRED = "'price' is required"
        const val CATEGORY_REQUIRED = "'category' is required"
        const val PHOTO_URLS_REQUIRED = "'photoURLs' is required"
        const val MESSAGE_REQUIRED = "Message is required"
        const val RECEIVER_ID_REQUIRED = "Receiver ID is required"
        const val RATING_REQUIRED = "Valid rating value is required"
        const val INVALID_PRICE = "'price' must be a valid integer"

        // Error reasons
        const val FAILED_CREATE_USER = "Failed to create user document"
        const val FAILED_REGISTER_USERNAME = "Failed to register username"
        const val FAILED_UPDATE_USER = "Failed to update user"
        const val FAILED_UPDATE_PROFILE_PIC = "Failed to update profile picture URL"
        const val FAILED_UPDATE_RATING = "Failed to update user rating"
        const val FAILED_UPDATE_CREATOR_ID = "Failed to update user with creator ID"
        const val FAILED_UPDATE_PORTFOLIO = "Failed to update portfolio"
        const val FAILED_UPDATE_CREATOR = "Failed to update creator"
        const val FAILED_DELETE_PORTFOLIO = "Failed to delete portfolio"
        const val FAILED_FETCH_CHAT = "Failed to fetch updated chat"
        const val FAILED_UPDATE_CHAT = "Failed to update chat with message info"
        const val FAILED_UPDATE_CHAT_MESSAGE = "Failed to update chat with new message"
        const val FAILED_UPDATE_CHAT_READ = "Failed to update chat read status"
        const val FAILED_UPLOAD_PORTFOLIO_PHOTOS = "Failed to upload portfolio photos"
        const val FAILED_DELETE_PORTFOLIO_PHOTOS = "Failed to delete portfolio photos"
        const val FAILED_UPDATE_PORTFOLIO_URLS = "Failed to update portfolio with photo URLs"
        const val FAILED_DELETE_UNUSED_PHOTOS = "Failed to delete unused photos"
        const val FAILED_UPDATE_PORTFOLIO_LIST = "Failed to update creator's portfolio list"
        const val QUERY_SIZE = "Cannot query more than ${Config.MAX_PORTFOLIO_IDS_PER_QUERY} portfolio IDs at a time"
        const val FAILED_SEARCH_PORTFOLIOS = "Failed to search portfolios"
        const val FAILED_RETRIEVE_UPDATED_USER = "Failed to retrieve updated user"
        const val MISSING_USERNAME = "Missing 'username' query parameter"
        const val EMPTY_USERNAME = "Empty 'username' query parameter"
        const val INVALID_YOE = "Invalid yearsOfExperience value"

        // Database
        const val CONFIG_NOT_FOUND = "Firebase config not found"
        const val PUBLIC_INIT = "[FIRESTORE] Initializing for public endpoints"
        const val INITIALIZED_ALREADY = "[FIRESTORE] Firebase already initialized"
    }

    /**
     * Parameters and values
     */
    object Params {
        // Sort values
        const val SORT_BY_TIMESTAMP = "timestamp"
        const val SORT_BY_RATING = "rating"

        // Parameter names
        const val SORT_BY = "sortBy"
        const val CATEGORY = "category"
        const val QUERY = "query"
        const val ID = "id"
        const val USERNAME = "username"
        const val MESSAGE = "message"
        const val RECEIVER_ID = "receiverId"
    }

    /**
     * Form field names
     */
    object FormFields {
        const val PROFILE_PICTURE = "profilepicture"
    }

    /**
     * Configuration values
     */
    object Config {
        const val REALM = "fotofolio"
        const val FIREBASE_PROJECT_ID = "fotofolio-3"
        const val FIREBASE_APP_UNAUTHENTICATED = "UNAUTHENTICATED"
        const val FIREBASE_KEY_PATH = "fotofolio-3-firebase-key.json"
        const val FIREBASE_ENV_KEY = "FIREBASE_KEY"
        const val FIREBASE_BUCKET_NAME = "fotofolio-3.firebasestorage.app"
        const val MAX_PORTFOLIO_IDS_PER_QUERY = 10
        const val FIREBASE_DOWNLOAD_TOKENS = "firebaseStorageDownloadTokens"
        const val STORAGE_DOWNLOAD_URL = "https://firebasestorage.googleapis.com/v0/b/$FIREBASE_BUCKET_NAME/o/%s?alt=media&token=%s"
    }
    /**
     * Response keys
     */
    object ResponseKeys {
        const val ID = "id"
        const val CREATOR_ID = "creatorId"
        const val MESSAGE = "message"
        const val PROFILE_PICTURE_URL = "profilePictureUrl"
    }
}