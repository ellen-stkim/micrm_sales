package com.mablic.template_kotlin

import org.jasypt.encryption.pbe.PooledPBEStringEncryptor
import org.jasypt.encryption.pbe.config.SimpleStringPBEConfig
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class JasyptEnc2 {

}

private val log: Logger = LoggerFactory.getLogger("JasyptEnc")

fun main(args: Array<String>) {
    val enc = PooledPBEStringEncryptor()
    val config = SimpleStringPBEConfig()
    config.password = "milvussteve"
    config.algorithm = "PBEWithMD5AndDES"
    config.poolSize = 1
    //config.setSaltGeneratorClassName("org.jasypt.salt.RandomSaltGenerator")
    //config.setIvGeneratorClassName("org.jasypt.iv.RandomIvGenerator")
    //config.stringOutputType = "base64"
    enc.setConfig(config)

    log.error("{}", enc.decrypt("zQoP26ubMZ161bF/s+HPpLLp0/OQuBXHum1gXnUEC1PP9X4+IdxpOjZ2ldaQSW3sCz9gMOT1OnNqEd/czycfcmR5CfhDBWDsAjZ5iynk7rI="))
    log.error("{}", enc.decrypt("OAzWhy70Vw4p8WNRGn+whiGGezD0BY0BgG6u6t3eR3JVY7u4ub5YVibzA0XuxB9p"))
    log.error("{}", enc.decrypt("TRqGjSlXD7/biRbDz+gQf0hNigs8KR2j/cZBHy3b1wczYHpmPlfZQmnVcOEqmcXbmn06RlnFfSa54ibk5cfXxA=="))


}