package com.omnilab.micrm.model.table.edm

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Camp_send_edm_tableDto")
class Camp_send_edm_tableDto {
     var program_id: String? = null
     var camp_id: String? = null
     var contents_seq: String? = null
     var send_target_seq: String? = null
     var send_year: String? = null
     var send_month: String? = null
     var send_result: String? = null
     var result: String? = null
     var mail_to: String? = null
     var domain: String? = null
     var send_reg_time: String? = null
     var send_rep_time: String? = null
     var send_time: String? = null
     var mail_title: String? = null
     var mail_body: String? = null
     var from_name: String? = null
     var from_to: String? = null
     var reply_to: String? = null
     var atch_file: String? = null
     var usr_email: String? = null
     var usr_grp_cd: String? = null
     var reg_dt: String? = null
     var gubun: String? = null
     var m_server: String? = null
     var return_path: String? = null
     var retry_cnt: String? = null

     var ab: String? = null
     var ab_real: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}