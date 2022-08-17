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
    log.error(enc.decrypt("lwia58gbA2la4JVYbb/0GzOeKgRIERGvtqQJH6g+mYkimHuqmnS6nTeF96zr+1pNjeXxiT7mVg/ftj5+r5MP8q643U2xDVE48aDA7KzAm1K2KG/YCrYNnNjkpeWUkanQ"))
    log.error(enc.decrypt("OAzWhy70Vw4p8WNRGn+whiGGezD0BY0BgG6u6t3eR3JVY7u4ub5YVibzA0XuxB9p"))
    log.error(enc.decrypt("TRqGjSlXD7/biRbDz+gQf0hNigs8KR2j/cZBHy3b1wczYHpmPlfZQmnVcOEqmcXbmn06RlnFfSa54ibk5cfXxA=="))

    log.error("=========================")

}