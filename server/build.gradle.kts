val ktor_version = "2.3.0"
val koin_version = "3.4.0"
val junit_version = "5.9.3"
val kotlin_version = "1.8.10" // stable Kotlin version that should work with the rest of dependencies

plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.ktor)
    kotlin("plugin.serialization") version "2.1.0"
}

group = "cz.cvut.fit"
version = "1.0.1"

application {
    mainClass = "cz.cvut.fit.ApplicationKt"
    val isDevelopment = false
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core:$ktor_version")
    implementation("io.ktor:ktor-server-netty:$ktor_version")
    implementation("io.ktor:ktor-server-swagger:$ktor_version")
    implementation("io.swagger.core.v3:swagger-core:2.2.8")
    implementation("io.swagger.core.v3:swagger-jaxrs2:2.2.8")
    implementation("io.insert-koin:koin-ktor:$koin_version")
    implementation("io.insert-koin:koin-logger-slf4j:$koin_version")
    implementation(libs.ktor.server.auth)
    implementation(libs.logback.classic)
    implementation(libs.ktor.server.config.yaml)
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktor_version")
    implementation("io.ktor:ktor-server-content-negotiation:$ktor_version")
    implementation("com.google.firebase:firebase-admin:9.2.0")
    implementation("com.kborowy:firebase-auth-provider:1.5.0")
    implementation("io.ktor:ktor-server-status-pages:$ktor_version")

    // Test dependencies
    testImplementation(libs.ktor.server.test.host)
    testImplementation("org.junit.jupiter:junit-jupiter-api:$junit_version")
    testImplementation("org.junit.jupiter:junit-jupiter-engine:$junit_version")
    testImplementation("org.junit.jupiter:junit-jupiter-params:$junit_version")
    testImplementation("org.junit.platform:junit-platform-launcher:1.9.3")
    testImplementation("io.mockk:mockk:1.13.5")
    testImplementation("io.ktor:ktor-server-tests-jvm:$ktor_version")

    // JUnit 5 style
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5:$kotlin_version")

    // Excluding kotlin-test-junit to avoid conflicts
    testImplementation("io.insert-koin:koin-test:$koin_version") {
        exclude(group = "org.jetbrains.kotlin", module = "kotlin-test-junit")
    }
    testImplementation("io.insert-koin:koin-test-junit5:$koin_version") {
        exclude(group = "org.jetbrains.kotlin", module = "kotlin-test-junit")
    }
}

tasks {
    shadowJar {
        archiveBaseName.set("fotofolio")
        archiveClassifier.set("")
        archiveVersion.set("")

        manifest {
            attributes["Main-Class"] = application.mainClass.get()
        }

        mergeServiceFiles()
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
    testLogging {
        events("passed", "skipped", "failed")
        exceptionFormat = org.gradle.api.tasks.testing.logging.TestExceptionFormat.FULL
        showCauses = true
        showExceptions = true
        showStackTraces = true
    }
}