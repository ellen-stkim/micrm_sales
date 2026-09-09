package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_ban_word_hstDto")
open class Tblmi_ban_word_hstDto {

    var seq: Int? = null
    var blk_tp: String? = null      // 차단 시점 (SAVE : 콘텐츠 저장, SEND : 발송)
    var ban_rule: String? = null    // 차단 규칙 ID (tblmi_comm_cd.par_id)
    var ban_tp: String? = null      // 금칙어 종류 (KEYWORD : 키워드, URL : URL, TEL : 전화번호)
    var ban_word: String? = null    // 검출된 금칙어
    var cont_cd: Int? = null        // 콘텐츠 마스터 번호
    var camp_id: Int? = null        // 캠페인 번호 (발송 시)
    var send_to: String? = null     // 수신번호 (발송 시)
    var cont_sub: String? = null    // 차단된 문자 제목
    var cont_body: String? = null   // 차단된 문자 본문
    var usr_grp_cd: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}
