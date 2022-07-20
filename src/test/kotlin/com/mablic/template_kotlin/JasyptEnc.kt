package com.mablic.template_kotlin

import org.jasypt.encryption.pbe.PooledPBEStringEncryptor
import org.jasypt.encryption.pbe.config.SimpleStringPBEConfig
import org.slf4j.Logger
import org.slf4j.LoggerFactory

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
    log.error(enc.encrypt("jdbc:mariadb://192.168.0.3/test_db_micrm_sales"))
    log.error("=========================")

}