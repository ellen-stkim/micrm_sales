package com.mablic.template_kotlin

import com.exacttarget.fuelsdk.ETSdkException
import com.google.gson.GsonBuilder
import com.google.gson.JsonParser
import com.omnilab.micrm.common.CommonUtils
import org.slf4j.LoggerFactory
import java.util.regex.Pattern

object testSdk {
    @Throws(ETSdkException::class)
    @JvmStatic
    fun main(args: Array<String>) {
        val logger = LoggerFactory.getLogger("this")

        //String btn = "{\"button\":[{\"ordering\":1,\"name\":\"사이트 방문하기\",\"linkType\":\"WL\",\"linkTypeName\":\"웹링크\",\"linkMo\":\"https://#{link}\",\"linkPc\":\"https://#{link}\",\"target\":\"out\"}]}";
        //val btn = "{\"button\":[{\"ordering\":1,\"name\":\"사이트 방문하기\",\"linkType\":\"WL\",\"linkTypeName\":\"웹링크\",\"linkMo\":\"#{link}\",\"linkPc\":\"#{link}\",\"target\":\"out\"}]}"
        val jsonInput = """
           {
             "button": [
               {
                 "ordering": 1,
                 "name": "채널 #{sec}",
                 "linkType": "AC",
                 "linkTypeName": "#{channel}"
               },
               {
                 "ordering": 2,
                 "name": "25주년 후원감사증 받기 #{name}",
                 "linkType": "WL",
                 "linkTypeName": "웹링크",
                 "linkMo": "#{link}",
                 "linkPc": "http://www.naver.com?url=#{url}",
                 "target": "out"
               },
               {
                 "ordering": 3,
                 "name": "#{name}",
                 "linkType": "WL",
                 "linkTypeName": "웹링크",
                 "linkMo": "https://#{link}",
                 "linkPc": "https://#{link}",
                 "target": "out"
               }
             ]
           }
           """.trimIndent()

        val keyMap = mapOf(
            "link" to "aaa",
            "url" to "bbb",
            "name" to "홍길동",
            "channel" to "카카오채널",
            "sec" to "보안"
        )
        val result = processJson(jsonInput, keyMap)

        val gson = GsonBuilder().create()
        val btnData: MutableMap<String, Any> = gson.fromJson(result, MutableMap::class.java) as MutableMap<String, Any>
        logger.error(btnData["button"].toString())
    }

    fun processJson(jsonStr: String, keyMap: Map<String, String>): String {
        val gson = GsonBuilder().setPrettyPrinting().create()
        val jsonObject = JsonParser.parseString(jsonStr).asJsonObject
        val buttons = jsonObject["button"].asJsonArray

        for (button in buttons) {
           val obj = button.asJsonObject
           for ((field, valueElement) in obj.entrySet()) {
               if (!valueElement.isJsonPrimitive || !valueElement.asJsonPrimitive.isString) continue
               val value = valueElement.asString
               val newValue = when (field) {
                   "linkMo", "linkPc" -> processLinkField(value, keyMap)
                   else -> replacePlainTemplate(value, keyMap)
               }
               obj.addProperty(field, newValue)
           }
        }
        return gson.toJson(jsonObject)
    }

    fun processLinkField(value: String, keyMap: Map<String, String>): String {
        val regex = Regex("^(https?://)?#\\{([^}]+)}$")
        val match = regex.matchEntire(value)
        if (match != null) {
            val protocol = match.groupValues[1].ifBlank { null }
            val key = match.groupValues[2]
            return transform(key, protocol, keyMap)
        }
        return replaceTemplateInString(value, keyMap)
    }

    fun replaceTemplateInString(input: String, keyMap: Map<String, String>): String {
        val pattern = Regex("#\\{([^}]+)}")
        return pattern.replace(input) { match ->
            val key = match.groupValues[1]
            val value = keyMap[key] ?: return@replace match.value

            // 앞 문맥 확인 (최대 10자 앞)
            val startIdx = match.range.first
            val prefix = input.substring(0, startIdx).takeLast(10).lowercase()
            // URL 또는 쿼리스트링 내 템플릿이라면 https:// 생략
            return@replace if (prefix.endsWith("=") || prefix.endsWith("?") ||
                prefix.contains("http://") || prefix.contains("https://")) {
                value
            } else {
                "https://$value"
            }
        }
    }

    fun replacePlainTemplate(input: String, keyMap: Map<String, String>): String {
        val pattern = Regex("#\\{([^}]+)}")
        return pattern.replace(input) { match ->
            val key = match.groupValues[1]
            keyMap[key] ?: match.value
        }
    }

    fun transform(key: String, protocol: String?, keyMap: Map<String, String>): String {
        val logger = LoggerFactory.getLogger("this")
        val value = keyMap[key] ?: return "#{$key}"  // 치환값 없으면 그대로 유지

        logger.error("{}, {}", key, value)
        return if (protocol != null) "$protocol$value" else "https://$value"
    }

}
