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
    //config.password = "milvuslucas"
    config.password = "milvussteve"
    config.algorithm = "PBEWITHHMACSHA512ANDAES_256"
    config.poolSize = 1
    config.setSaltGeneratorClassName("org.jasypt.salt.RandomSaltGenerator")
    config.setIvGeneratorClassName("org.jasypt.iv.RandomIvGenerator")
    config.stringOutputType = "base64"
    enc.setConfig(config)

    log.error("{}", enc.encrypt("Basic R000000029 R000000029_n6LtN7z7ReeOJaduoQgG+w"))
    //log.error("{}", enc.encrypt("img-royal-2020##"))

    //log.error("{}", enc.decrypt("d5lxtEHn5fou6ly19wPcwaFpFFlvSOWaObcpSLfgzhOwecBPl+rskzDxiXgN6qCLCMnxoyaPZD0gzfOc7QzvdHwOEpLBADJAwgclKlHEAUY="))
    //log.error("{}", enc.decrypt("E61c3eAA5KnRsxfXBjTAlcsCe8QU8ws5Xq38DRBES4UW2yenht4i9bCLsOw5nRurga6Vid3k3PQGs6a85ji6bvXU/XG709kt74MrT0uDLaU="))
    //log.error("{}", enc.decrypt("X6uhU/rJNia1o35WMtm164I1kF1G8nyTy/4K/sQi4EtyCbX0ywbpyhUji9TWs4NvG/NbMNNfkEmccYAEN9gWHmdt0oB4yWUtDNl2UMXwDJ2iw80QIBE3mrDDGhHhSAJX"))

}