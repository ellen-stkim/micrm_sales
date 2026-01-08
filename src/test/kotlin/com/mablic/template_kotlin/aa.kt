package com.mablic.template_kotlin

import com.google.gson.GsonBuilder
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.model.table.Tblmi_kko_at_tmplDto
import org.slf4j.LoggerFactory

class aa {
}

fun main() {
    val logger = LoggerFactory.getLogger("aa")
    /*
    val tmplDto = Tblmi_kko_at_tmplDto()

    val sttt = "[컴패션] 후원자님, #{param1} 함께했던 #{param2}기억하시나요?\n" +
            "\n" +
            "행사를 통해 어린이의 손을 맞잡아 주신 그날부터, 어린이의 삶에는 조금씩 따뜻한 변화가 쌓여가고 있습니다.\n" +
            "오늘은 그 소중한 인연이 이어진 지 벌써 #{param3)일이 되는 날입니다.\n" +
            "\n" +
            "그날의 마음을 다시 떠올려보실 수 있도록, 당시의 감동을 전해드립니다.\n" +
            "\n" +
            "#{param4}\n" +
            "\n" +
            "✉ 아직 읽지 않은 어린이의 편지가 있어요. 지금 바로 읽어보시고, 따뜻한 마음을 담아 답장도 전해보세요!\n" +
            "https://#{url1}"


    val tempContStrs = sttt.split("#\\{".toRegex())
    val etcArr = mutableListOf<String>()
    var tempCont: String?
    for(idx in 1 until tempContStrs.size){
        logger.error("{}", idx)
        tempCont = tempContStrs[idx]
        logger.error("{}", tempCont)
        logger.error("{}", tempCont.indexOf("}"))
        etcArr.add(tempCont.substring(0, tempCont.indexOf("}")))
        tmplDto.tmpl_cont
    }

    logger.error("aa {}", tmplDto.tmpl_cont)
    */

    logger.error("{}", CommonUtils.sha512("sony2026$!@"))
    logger.error("{}", CommonUtils.sha512("milvus2026$!@"))


    val map = HashMap<String, Any?>()
    map["a"] = "a"
    map["b"] = null

    val g = GsonBuilder().create()
    logger.error("{}", g.toJson(map))

}

