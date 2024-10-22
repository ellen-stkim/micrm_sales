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

    //log.error("{}", enc.decrypt("/hDJCGL/qLXfzqNWh9JNtvJ/yx09TBJsVLkI5CDqmhRrrnKhorJrLTcTMB6kxffMIxX7AM83GiHQ+e2MpWU1kTsVs1Zhj5r5njm3DDrk3bE="))
    //log.error("{}", enc.decrypt("UCDTUfq9eiO9WAwR1j/Lnuk2DGIgaBKt3NfR17fgv1EpW5nvZ27plSQiHS/ZcxckGE7nN4m70wZozqh/JKwNTWxcYTflIDQiMBkPqTJwQ+E="))

    //log.error("{}", CommonUtils.sha512("childfund2024#!"))
    //log.error("{}", CommonUtils.sha512("milvus20241#!"))
    //log.error("{}", CommonUtils.sha512("9K32STixIJoaSFGUgF0X"))
    //log.error("{}", CommonUtils.sha512("rf8idAFl6KELpzx"))

    //log.error("{}", enc.decrypt("OAzWhy70Vw4p8WNRGn+whiGGezD0BY0BgG6u6t3eR3JVY7u4ub5YVibzA0XuxB9p"))
    //log.error("{}", enc.decrypt("TRqGjSlXD7/biRbDz+gQf0hNigs8KR2j/cZBHy3b1wczYHpmPlfZQmnVcOEqmcXbmn06RlnFfSa54ibk5cfXxA=="))


    log.error("{}", enc.decrypt("afj8cs+6Pu5N3QxxzmoJrfTQH/i8QlAvH7ksBC+8hnox9+XJipm7gvaazTE4YY3WxLNukWfHx1cuOfhEdipU26OWyQqPAlNudUYj4jx8hDg="))
    log.error("{}", enc.decrypt("5shKqWIPCaA/mzgZVUfFzRBOIaoHlwiYbLEGTa8fsQmHA2n+cb5gXpsj2hKgWOAq"))
    log.error("{}", enc.decrypt("OoT4GmRV2TcFVppu/UMiyIKgoo81pfWeCCmQ58YDUfrt3B8VRgPlTeaYwT62VYp1"))
}