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

    log.error("{}", enc.decrypt("IMt0uj5cA5Jn8ngwbrDYOwZAjtNpyUzhJLn6m2Luv7vK6v0omE0jukHciL7Wv3ia+db+1Lm71fjPtZvmP86jGy59u4VJghSkjIYXKzEdL4huGyMD8CpL5D80ymgQuyoH"))
    log.error("{}", enc.decrypt("A0ZYn/DIBsy/KBRsYuk/H4TxjU2ScaBDMcGdyqftZ2KEV+Gu+4pG56vHlVN4xhc9Z/PWYPHb1/2UNvKASd908Q=="))
    log.error("{}", enc.decrypt("tqPYqWzxM1x7G+7u5Y+i6wusfb98hCrLM82N21QKDat7NCCfUWc/kAeQwZyUi6sNzSQgbCd+Qt70LxNIHyN02A=="))

}