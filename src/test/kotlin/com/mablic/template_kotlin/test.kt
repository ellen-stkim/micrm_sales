package com.mablic.template_kotlin

import com.omnilab.micrm.common.CommonUtils
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


    logger.error("{}", CommonUtils.sha512("hankookilbo20251@#"))
    logger.error("{}", CommonUtils.sha512("milvus20251@#"))

}