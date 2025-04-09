package cz.cvut.fit

import config.FirebaseInitializer
import io.ktor.server.application.*

fun main(args: Array<String>) {
    io.ktor.server.netty.EngineMain.main(args)
}

fun Application.module() {
    FirebaseInitializer.initialize()

    configureFrameworks()
    configureHTTP()
    configureSecurity()
    configureRouting()
}