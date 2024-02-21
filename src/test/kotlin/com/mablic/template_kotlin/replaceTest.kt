package com.mablic.template_kotlin

import com.omnilab.micrm.common.CommonUtils
import org.jasypt.encryption.pbe.PooledPBEStringEncryptor
import org.jasypt.encryption.pbe.config.SimpleStringPBEConfig
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.regex.Pattern

class replaceTest {

}

fun main(args: Array<String>) {
    val log: Logger = LoggerFactory.getLogger("JasyptEnc")

    val st = "로얄캐닌 건강 케어 프로그램 당첨 안내\n" +
            "\n" +
            "안녕하세요, #{USR_NM}님.\n" +
            "\n" +
            "로얄캐닌의 견종 관리법 확인 프로그램에 참여해 주셔서 감사드리며, #{USR_ETC1} 어덜트 제품에 당첨되신 것을 축하드립니다.\n" +
            "\n" +
            "당첨 상품은 프로그램 참여 시 선택하신 반려견 품종에 따라 제공되며, 배송은 최대 7일 이내 완료됩니다.\n" +
            "\n" +
            "앞으로도 로얄캐닌과 함께 #{USR_PET_NM}(이)의 건강관리를 도와주는 건강 지킴이가 되어주세요!\n" +
            "\n" +
            "▷로얄캐닌 공식 고객센터 : 080-041-5161\n" +
            "평일 9:00 ~ 18:00(점심시간: 12:00~13:00) 주말 및 공휴일 휴무" +
            "\n" +
            "{{key}} {{data}} {{test}}"

    val map = HashMap<String, Any>()

    map["USR_NM"] = "{강선우}"
    map["usr_etc1"] = "{데헷}"
    map["usr_pet_nm"] = "{펫이름}"
    map["data"] = "{데이터}"
    map["key"] = "{키}"
    map["test"] = "{테스트}"

    var re = st
    for(i in map) {
        val reg = Regex("#\\{(?i)${i.key}}")
        val reg2 = Regex("\\{\\{(?i)${i.key}}}")
        log.error("{}, {}", i.key, reg)
        //re = re.replace(reg, CommonUtils.stringValueOf(i.value))
        re = re.replace(reg2, CommonUtils.stringValueOf(i.value))
    }
    log.error("{}", re)

}