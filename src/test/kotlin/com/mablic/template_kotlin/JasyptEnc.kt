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
    config.password = "milvussteve"
    config.algorithm = "PBEWITHHMACSHA512ANDAES_256"
    config.poolSize = 1
    config.setSaltGeneratorClassName("org.jasypt.salt.RandomSaltGenerator")
    config.setIvGeneratorClassName("org.jasypt.iv.RandomIvGenerator")
    config.stringOutputType = "base64"
    enc.setConfig(config)


    log.error("{}", enc.decrypt("efak8s6OtnO1z0mOGwCyo/a+yiM65h/enJmKbCqzsFrs10qYFsd8L3TxthlGn6cxTHLcD0UlV7aFEmESsFS6MEsVZ3W9WGscDoPATSsQoLo="))
    log.error("{}", enc.decrypt("DZbycoCjudmjzCgeTsX8t3E/UAk/w5PtYNLwB+lCilsLJ0vsnpQVT4YAFoT5Z9G8"))
    log.error("{}", enc.decrypt("Dpat/neh+q4uSsO++MsBzkJtUXi9W5+byXZiysSMPeYwtr6Ba8V3j5Il01DKLNiFxOECzZkAmGyY4/YZScXY3Q=="))

}