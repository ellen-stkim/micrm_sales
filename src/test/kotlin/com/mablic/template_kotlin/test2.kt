package com.mablic.template_kotlin

import com.google.gson.GsonBuilder
import com.omnilab.micrm.common.CommonUtils
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.impl.crypto.DefaultJwtSignatureValidator
import org.slf4j.LoggerFactory
import java.util.*
import javax.crypto.spec.SecretKeySpec

class test2 {

}

fun main() {
    val logger = LoggerFactory.getLogger("test2")

    val data = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ew0KICAiaW5Bcmd1bWVudHMiOiBbDQogICAgew0KICAgICAgInNlcSI6ICIzOSINCiAgICB9DQogIF0sDQogICJhY3Rpdml0eU9iamVjdElEIjogImUyM2JmNWI0LWMwOTAtNGRlNi1iODU0LTRiZjY4ZTUyMWU2ZiIsDQogICJqb3VybmV5SWQiOiAiZGQzMzA3ZTQtZjg5Ny00NjM0LTg2ZWItMzNjOTYyYjRlYjc4IiwNCiAgImFjdGl2aXR5SWQiOiAiZTIzYmY1YjQtYzA5MC00ZGU2LWI4NTQtNGJmNjhlNTIxZTZmIiwNCiAgImRlZmluaXRpb25JbnN0YW5jZUlkIjogImE0ODI5NjQ3LTIxZjItNGQ2ZC1hYTk1LWY4NWYyNTY2ZDBlMCIsDQogICJhY3Rpdml0eUluc3RhbmNlSWQiOiAiYjJjZmQ5ODMtZjdlMS00ZGVmLWJiM2EtZmMwN2QwMzczNzc1IiwNCiAgImtleVZhbHVlIjogIjAxMDMzOTY2Nzk1IiwNCiAgIm1vZGUiOiAwDQp9.YiQRWqK1oT_Bvi4yildTJq4ZQYmtE2Xk7kvAFv4iZbc"
    val secretKey = "FAdGJr3sA4jIsvPT94_hQxxVUHE_M6SbLuE-wL-Jh5FYdz2QhDR6fFUs5CkkYvBuccNG8ECLV7GRXxjgbMymkV5DNX9UOrib1vARlIz2c1MaGUuMpRrHfFHPPJS-W1OsdNLPK3IkmSn3DyuW1LMtB52JDDQJOX5T0kaatJtzsxPyYC_gThSwa3xfJCTb1yCcvimr0mQzI-gWgXzCTr_KrIDnxkrBlB9GoNdrk6iubwi7k1MZRitzYoxsWl8ORg2"
    val chunks: List<String> = data.split(".")
    val decoder: Base64.Decoder = Base64.getUrlDecoder()
    val payload = String(decoder.decode(chunks[1]))
    //logger.info("payload: $payload")

    val sa: SignatureAlgorithm = SignatureAlgorithm.HS256
    val secretKeySpec = SecretKeySpec(secretKey.toByteArray(), sa.jcaName)
    val tokenWithoutSignature = chunks[0] + "." + chunks[1]
    val signature = chunks[2]
    val validator = DefaultJwtSignatureValidator(sa, secretKeySpec)

    // jwt 확인
    if (!validator.isValid(tokenWithoutSignature, signature)) {
        logger.error("Could not verify JWT token integrity!")
    } else {
        val gson = GsonBuilder().create()
        val data = gson.fromJson(payload, Map::class.java)
        logger.error("{}", data)
    }

    logger.error("{}", CommonUtils.sha512("010-3396-6795"))
}