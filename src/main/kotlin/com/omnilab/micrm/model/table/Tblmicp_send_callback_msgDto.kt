package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias
import java.util.*

@Alias("Tblmicp_send_callback_msgDto")
class Tblmicp_send_callback_msgDto {

    var hst_seq: Int? = null
    var send_to: String? = null
    var kko_tp: String? = null
    var kko_from_to: String? = null
    var kko_body: String? = null
    var kko_key: String? = null
    var kko_btn: String? = null
    var kko_img_path: String? = null
    var kko_img_url: String? = null
    var kko_server: String? = null
    var rcs_tp: String? = null
    var rcs_from_to: String? = null
    var rcs_sub: String? = null
    var rcs_body: String? = null
    var rcs_brn_id: String? = null
    var rcs_msg_id: String? = null
    var rcs_msg_header: String? = null
    var rcs_btn_ins_tp: String? = null
    var rcs_btn_cnt: String? = null
    var rcs_btn_obj: String? = null
    var rcs_btn_1: String? = null
    var rcs_btn_tp_1: String? = null
    var rcs_btn_cont_1: String? = null
    var rcs_btn_2: String? = null
    var rcs_btn_tp_2: String? = null
    var rcs_btn_cont_2: String? = null
    var rcs_btn_3: String? = null
    var rcs_btn_tp_3: String? = null
    var rcs_btn_cont_3: String? = null
    var rcs_footer: String? = null
    var rcs_img_cnt: String? = null
    var rcs_img_cd_1: String? = null
    var rcs_img_cd_2: String? = null
    var rcs_img_cd_3: String? = null
    var rcs_img_cd_4: String? = null
    var rcs_img_cd_5: String? = null
    var rcs_img_cd_6: String? = null
    var rcs_server: String? = null
    var mdm_tp: String? = null
    var mdm_from_to: String? = null
    var mdm_sub: String? = null
    var mdm_body: String? = null
    var mdm_img_cnt: String? = null
    var mdm_img_cd_1: String? = null
    var mdm_img_cd_2: String? = null
    var mdm_img_cd_3: String? = null
    var mdm_img_cd_4: String? = null
    var mdm_img_cd_5: String? = null
    var mdm_img_cd_6: String? = null
    var mdm_server: String? = null
    var usr_grp_cd: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}