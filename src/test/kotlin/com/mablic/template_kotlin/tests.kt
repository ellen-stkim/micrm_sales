package com.mablic.template_kotlin

import org.apache.commons.codec.binary.Base64
import org.slf4j.LoggerFactory
import org.springframework.web.util.HtmlUtils
import java.net.URLEncoder
import java.nio.charset.StandardCharsets
import java.security.NoSuchAlgorithmException
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec

class tests {
    fun AES_Encode(str: String, key: String): String? {
        val logger = LoggerFactory.getLogger("aaa")
        return try {
            val textBytes = str.toByteArray(StandardCharsets.UTF_8)
            val newKey = SecretKeySpec(key.toByteArray(StandardCharsets.UTF_8), "AES")
            val cipher = Cipher.getInstance("AES/ECB/PKCS5Padding")
            cipher.init(Cipher.ENCRYPT_MODE, newKey)
            Base64.encodeBase64String(cipher.doFinal(textBytes))
        } catch (e: Exception) {
            logger.error("AES_ENCODE", e)
            null
        }
    }

    fun AES_Decode(str: String?, key: String): String? {
        val logger = LoggerFactory.getLogger("aaa")
        return try {
            val textBytes = Base64.decodeBase64(str)
            val newKey = SecretKeySpec(key.toByteArray(StandardCharsets.UTF_8), "AES")
            val cipher = Cipher.getInstance("AES/ECB/PKCS5Padding")
            cipher.init(Cipher.DECRYPT_MODE, newKey)
            String(cipher.doFinal(textBytes), StandardCharsets.UTF_8)
        } catch (e: NoSuchAlgorithmException) {
            logger.error("AES_DECODE", e)
            null
        }
    }
}

fun main(args: Array<String>) {
    val logger = LoggerFactory.getLogger("aaa")
    /*
    val t = tests()
    val str = "textte"
    val key = "Sr8iEd30psDL8lIeCECLgDprWXbbBIR8"

    logger.error("{}", t.AES_Encode(str, key))
    logger.error("{}", t.AES_Decode("DHtOma7mcZWE51Z8VgcSsA", key))
    */

    val filename = "[MMS]_마캠_2023christmas_MMS,친구톡(4차)_고유란_231206_live"
    logger.error("{}", String(filename.toByteArray(Charsets.UTF_8), Charsets.ISO_8859_1))
    logger.error("{}", HtmlUtils.htmlEscape(filename))
    logger.error("{}", String(filename.replace(",", "%2C").toByteArray(Charsets.UTF_8), Charsets.ISO_8859_1))

}