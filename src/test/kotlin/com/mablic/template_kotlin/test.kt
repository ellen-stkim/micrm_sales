package com.mablic.template_kotlin

import org.slf4j.LoggerFactory

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
    val t = test()

    val data = HashMap<String, Any>()
    data["code"] = "API_509";
    data["message"] = "요청한 번호가 카카오톡 채널 관리자 알림 설정 되어있는지 확인해주세요."

    logger.error("{}", data["code"]!!.toString().replace("API_",""), );

    logger.error("{}", t.containsTemplateVariable("https://compassion.questionpro.com/KRBeacon?custom16={{param}}"))
    logger.error("{}", t.containsTemplateVariable("https://example.com/no-template"))
    logger.error("{}", t.containsTemplateVariable("https://compassion.questionpro.com/KRBeacon?custom16"))


}