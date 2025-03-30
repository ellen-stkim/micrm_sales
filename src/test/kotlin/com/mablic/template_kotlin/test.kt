package com.mablic.template_kotlin

import com.omnilab.micrm.common.CommonUtils
import io.jsonwebtoken.SignatureAlgorithm
import org.apache.geronimo.mail.util.Base64
import org.slf4j.LoggerFactory
import javax.crypto.spec.SecretKeySpec

class test {

    fun containsTemplateVariable(input: String): Boolean {
        // 정규표현식
        val regex = Regex("""\{\{[^{}]*\}\}""")

        // 패턴 존재 여부 확인
        return regex.containsMatchIn(input)
    }
}

fun main() {
    val logger = LoggerFactory.getLogger("main")

    val data = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ew0KICAiaW5Bcmd1bWVudHMiOiBbDQogICAgew0KICAgICAgImlkIjogInRlcyIsDQogICAgICAibW9iaWxlIjogIjAxMDMzOTY2Nzk1IiwNCiAgICAgICJwaG9uZSI6ICIwMTAzMzk2Njc5NSIsDQogICAgICAic2VxIjogMTk2OCwNCiAgICAgICLCp2V4dGVudGlvbl9jbnTCpyI6IDEsDQogICAgICAiwqdkYXRhX2V4dGVuc2lvbl9pZMKnIjogIjc0MDA5MjgwLTY3ZmQtZWYxMS1hNWNlLTVjYmEyYzFhNTM1OCINCiAgICB9DQogIF0sDQogICJhY3Rpdml0eU9iamVjdElEIjogIjIzODIxYmRkLWZjZWItNDRkZC05NmQzLTk0ZDc0NWJjMmFhYyIsDQogICJqb3VybmV5SWQiOiAiOGJhYjFlZWMtMDVlYi00ZGVjLWE0MzYtOTBlNmU4Y2E3MTg2IiwNCiAgImFjdGl2aXR5SWQiOiAiMjM4MjFiZGQtZmNlYi00NGRkLTk2ZDMtOTRkNzQ1YmMyYWFjIiwNCiAgImRlZmluaXRpb25JbnN0YW5jZUlkIjogImUyNGQ3MDQ0LWIyMzEtNGI1OS1hN2ViLWQ3NjZiMjk0MmMzOSIsDQogICJhY3Rpdml0eUluc3RhbmNlSWQiOiAiNzhlMjdjZDYtNDYyMC00ZmJkLTliOGYtNzE3YjI1YWM2NTNkIiwNCiAgImtleVZhbHVlIjogInRlcyIsDQogICJtb2RlIjogMA0KfQ.ntBrVJdgKHHMjbocFB4FzOF5iniMzvsSCPLJVUqTy_o"

    val jwtCode = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ew0KICAiaW5Bcmd1bWVudHMiOiBbDQogICAgew0KICAgICAgImlkIjogInRlcyIsDQogICAgICAibW9iaWxlIjogIjAxMDMzOTY2Nzk1IiwNCiAgICAgICJwaG9uZSI6ICIwMTAzMzk2Njc5NSIsDQogICAgICAic2VxIjogMTk2OCwNCiAgICAgICLCp2V4dGVudGlvbl9jbnTCpyI6IDEsDQogICAgICAiwqdkYXRhX2V4dGVuc2lvbl9pZMKnIjogIjc0MDA5MjgwLTY3ZmQtZWYxMS1hNWNlLTVjYmEyYzFhNTM1OCINCiAgICB9DQogIF0sDQogICJhY3Rpdml0eU9iamVjdElEIjogIjIzODIxYmRkLWZjZWItNDRkZC05NmQzLTk0ZDc0NWJjMmFhYyIsDQogICJqb3VybmV5SWQiOiAiOGJhYjFlZWMtMDVlYi00ZGVjLWE0MzYtOTBlNmU4Y2E3MTg2IiwNCiAgImFjdGl2aXR5SWQiOiAiMjM4MjFiZGQtZmNlYi00NGRkLTk2ZDMtOTRkNzQ1YmMyYWFjIiwNCiAgImRlZmluaXRpb25JbnN0YW5jZUlkIjogImUyNGQ3MDQ0LWIyMzEtNGI1OS1hN2ViLWQ3NjZiMjk0MmMzOSIsDQogICJhY3Rpdml0eUluc3RhbmNlSWQiOiAiNzhlMjdjZDYtNDYyMC00ZmJkLTliOGYtNzE3YjI1YWM2NTNkIiwNCiAgImtleVZhbHVlIjogInRlcyIsDQogICJtb2RlIjogMA0KfQ.ntBrVJdgKHHMjbocFB4FzOF5iniMzvsSCPLJVUqTy_o"

    val chunks: List<String> = data.split(".")
    val decoder: java.util.Base64.Decoder = java.util.Base64.getUrlDecoder()
    var payload = String(decoder.decode(chunks[1]))

    val sa: SignatureAlgorithm = SignatureAlgorithm.HS256
    //val secretKeySpec = SecretKeySpec(secretKey?.toByteArray(), sa.jcaName)
    val tokenWithoutSignature = chunks[0] + "." + chunks[1]
    val signature = chunks[2]

    logger.info("payload : $payload")
    logger.info("signature : $signature")

}