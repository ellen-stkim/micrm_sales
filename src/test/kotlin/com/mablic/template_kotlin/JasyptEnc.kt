package com.mablic.template_kotlin

import com.omnilab.micrm.common.CommonUtils
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
    //config.password = "yMIJPg9VBS7OSnM"
    config.algorithm = "PBEWITHHMACSHA512ANDAES_256"
    config.poolSize = 1
    config.setSaltGeneratorClassName("org.jasypt.salt.RandomSaltGenerator")
    config.setIvGeneratorClassName("org.jasypt.iv.RandomIvGenerator")
    config.stringOutputType = "base64"
    enc.setConfig(config)

    //log.error("{}", enc.decrypt("nRCjx04q4+81PK6qOG9qyOzcGclEYYD6hYb3QRuIW+eXkNKe1u7yOTGd421dTYApU67DDe96fty0C/uAa5k2yt6PVM9Q2026T+iVa6MiYCqyRg+K/nswx4LrIpc/P5Nl"))
    //Basic R000000029 R000000029_n6LtN7z7ReeOJaduoQgG+w
    //log.error("{}", enc.decrypt("NgQrA60fspkLGY4ERU5eYFvgfHRpbNQV6zcE0Q7BLdPk8m7/Dsx9NE2FnLCuP3Eo50verDtOlinxyOZzerTijCXh4Bdx7uRYpQqaniY5LNCf0UKMNj4UB9QP/uH7BGo1"))
    //Basic R000000029 R000000029_3eAd3HZqQHSAjKHplkWBXw
    log.error("{}",enc.encrypt("Basic R000000029 R000000029_3eAd3HZqQHSAjKHplkWBXw"))
}