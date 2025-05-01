val ktor_version = "2.3.0"
val koin_version = "3.4.0"

plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.ktor)
    kotlin("plugin.serialization") version "2.1.0"
}

group = "cz.cvut.fit"
version = "1.0.1"

application {
    mainClass = "cz.cvut.fit.ApplicationKt" // io.ktor.server.netty.EngineMain

    val isDevelopment = true
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
    testImplementation(libs.ktor.server.test.host)
    testImplementation(libs.kotlin.test.junit)
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktor_version")
    implementation("io.ktor:ktor-server-content-negotiation:$ktor_version")
    implementation("com.google.firebase:firebase-admin:9.2.0")
    implementation("com.kborowy:firebase-auth-provider:1.5.0")
    implementation("io.ktor:ktor-server-status-pages:$ktor_version")
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