val ktorVersion = "2.3.0"
val koinVersion = "3.4.0"

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
    implementation("io.ktor:ktor-server-core:$ktorVersion")
    implementation("io.ktor:ktor-server-netty:$ktorVersion")
    implementation("io.ktor:ktor-server-swagger:$ktorVersion")
    implementation("io.insert-koin:koin-ktor:$koinVersion")
    implementation("io.insert-koin:koin-logger-slf4j:$koinVersion")
    implementation(libs.ktor.server.auth)
    implementation(libs.logback.classic)
    implementation(libs.ktor.server.config.yaml)
    testImplementation(libs.ktor.server.test.host)
    testImplementation(libs.kotlin.test.junit)
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")
    implementation("io.ktor:ktor-server-content-negotiation:$ktorVersion")
    implementation("com.google.firebase:firebase-admin:9.2.0")
    implementation("com.kborowy:firebase-auth-provider:1.5.0")
}

tasks {
    // Existing shadowJar task to create the fat JAR
    shadowJar {
        archiveBaseName.set("fotofolio")
        archiveClassifier.set("")
        archiveVersion.set("")

        manifest {
            attributes["Main-Class"] = "cz.cvut.fit.ApplicationKt" // or your custom main class
        }

        mergeServiceFiles() // Ensure all service files are merged if needed
    }

    // Add this run configuration to specify the heap size for the fat JAR
    register<JavaExec>("runFatJarHeapMax") {
        group = "application"
        description = "Run the fat JAR with custom heap size"
        mainClass.set("cz.cvut.fit.ApplicationKt")
        classpath = sourceSets["main"].runtimeClasspath

        args = listOf("-jar", "build/libs/fotofolio-all.jar")

        // Set the JVM options for heap size
        jvmArgs = listOf(
            "-Xmx384m", // Max heap size
            "-Xms256m"  // Initial heap size
        )
    }
}