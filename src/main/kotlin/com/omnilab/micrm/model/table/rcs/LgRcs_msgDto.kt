package com.omnilab.micrm.model.table.rcs

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("LgRcs_msgDto")
class LgRcs_msgDto {

    var msgkey: Int? = null
    var status: String? = null
    var sendable: String? = null
    var reqdate: String? = null
    var rptdate: String? = null
    var phone: String? = null
    var callback: String? = null
    var rslt: String? = null
    var rsltdesc: String? = null
    var type: String? = null
    var msg_header: String? = null
    var msg_title: String? = null
    var msg: String? = null
    var msg_footer: String? = null
    var msg_copyallowed: String? = null
    var fallback_yn: String? = null
    var fallback_type: String? = null
    var fallback_title: String? = null
    var fallback_msg: String? = null
    var fallback_reason: String? = null
    var fallback_reason_desc: String? = null
    var img_group_key: String? = null
    var img_group_cnt: String? = null
    var msgbase_id: String? = null
    var brand_id: String? = null
    var rcs_object: String? = null
    var btn_object: String? = null
    var btn_cnt: String? = null
    var btn_insert_type: String? = null
    var btn_text_1: String? = null
    var btn_type_1: String? = null
    var btn_contents_1: String? = null
    var btn_text_2: String? = null
    var btn_type_2: String? = null
    var btn_contents_2: String? = null
    var btn_text_3: String? = null
    var btn_type_3: String? = null
    var btn_contents_3: String? = null
    var etc1: String? = null
    var etc2: String? = null
    var etc3: String? = null
    var etc4: String? = null
    var etc5: String? = null
    var etc6: String? = null
    var route_id: String? = null
    var product_code: String? = null
    var wt_prd_code: String? = null
    var wt_regdate: String? = null
    var wt_reg_user_id: String? = null
    var wt_send_grp: String? = null
    var telco: String? = null
    var dept_code: String? = null
    var campaign_id: String? = null

    var m_server: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}