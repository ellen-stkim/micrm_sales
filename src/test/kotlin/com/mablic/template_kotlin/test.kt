package com.mablic.template_kotlin

import org.slf4j.LoggerFactory

class test {
}

fun main() {
    val logger = LoggerFactory.getLogger("main")
    val data = HashMap<String, Any>()
    data["code"] = "API_509";
    data["message"] = "요청한 번호가 카카오톡 채널 관리자 알림 설정 되어있는지 확인해주세요."

    logger.error("{}", data["code"]!!.toString().replace("API_",""), );

}