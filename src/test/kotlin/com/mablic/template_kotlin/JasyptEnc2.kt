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

    log.error("=========================")
    log.error("{}", enc.decrypt("6qa4jW8TavX1b+I7GOHnd6XxTS+knHUjaxhzpzCJfe/PjwqeAkyvsONjE1GRn7/YAu3SmAz8dr0jnIsS+Dk32FCA4dVPixOFZKEthm4nTVWqorCMLVmwUf5vKtqS0L/COtTWWmgtxZ3mcxpFhCS3vMYOoDgKBhF4CS7/6WhL8kBgATwcPBuhasgPIlZ29X45Rl+Ny9syaHEYH2dlzC0bSmJLslxaqJN9pbYVLJzbQMk="))
    log.error("{}", enc.encrypt("jdbc:mariadb://121.78.144.83:3306/db_reebok_raffle?useSSL=false&useUnicode=yes&characterEncoding=UTF-8&serverTimezone=UTC&autoReconnection=true&allowMultiQueries=true"))
    log.error("=========================")

}