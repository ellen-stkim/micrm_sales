package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tmpl_kko_at_tmplDto")
open class Tblmi_kko_at_tmplDto {
    var seq: Int? = null
    var send_key: String? = null
    var tmpl_cd: String? = null
    var tmpl_nm: String? = null
    var tmpl_cont: String? = null
    var tmpl_img_nm: String? = null
    var tmpl_img_url: String? = null
    var chan_id: String? = null
    var secur_flag: String? = null
    var tmpl_status: String? = null
    var kep_status: String? = null
    var tmpl_msg_tp: String? = null
    var tmpl_ext: String? = null
    var tmpl_ad: String? = null
    var tmpl_tit: String? = null
    var tmpl_subtit: String? = null
    var tmpl_empsize_tp: String? = null

    var cate_cd: String? = null
    var tmpl_header: String? = null
    var button_json: String? = null
    var quick_repl_json: String? = null
    var item_highlight_json: String? = null
    var item_json: String? = null

    var use_yn: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null



    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}