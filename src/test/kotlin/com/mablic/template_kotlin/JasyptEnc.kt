package com.mablic.template_kotlin

import org.jasypt.encryption.pbe.PooledPBEStringEncryptor
import org.jasypt.encryption.pbe.config.SimpleStringPBEConfig
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.MediaType

class JasyptEnc {

}

private val log: Logger = LoggerFactory.getLogger("JasyptEnc")

fun main(args: Array<String>) {
    val enc = PooledPBEStringEncryptor()
    val config = SimpleStringPBEConfig()
    config.password = "milvuslucas"
    config.algorithm = "PBEWITHHMACSHA512ANDAES_256"
    config.poolSize = 1
    config.setSaltGeneratorClassName("org.jasypt.salt.RandomSaltGenerator")
    config.setIvGeneratorClassName("org.jasypt.iv.RandomIvGenerator")
    config.stringOutputType = "base64"
    enc.setConfig(config)

    log.error("=========================")
    log.error("{}", enc.encrypt("https://bizmsg-web.kakaoenterprise.com"))
    log.error("{}", enc.encrypt("Basic R000000029 R000000029_n6LtN7z7ReeOJaduoQgG+w"))
    log.error("{}", enc.decrypt("GDaXkEIOePI8UF3TWrvkF6M1h89wUxi4KjedlrIsrmq4CYSG64Z5iW8P3Ov+rw4sHufwDXtS2Njccl6Uj+g2pcyoyYxFMxM0CJ9bbsO8bIWFsBq+sXdY77spuAE4R0wV"))

    log.error("{}", enc.decrypt("OAzWhy70Vw4p8WNRGn+whiGGezD0BY0BgG6u6t3eR3JVY7u4ub5YVibzA0XuxB9p"))
    log.error("=========================")

}