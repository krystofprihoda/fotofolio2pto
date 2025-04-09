package cz.cvut.fit

import config.FirebaseInitializer
import config.configureFrameworks
import config.configureHTTP
import cz.cvut.fit.config.configureRouting
import cz.cvut.fit.config.configureSecurity
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