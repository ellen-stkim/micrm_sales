package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_kko_at_tmplDto")
open class Tblmi_kko_at_tmplDto {
    var seq: Int? = null
    var send_key: String? = null
    var tmpl_cd: String? = null
    var tmpl_nm: String? = null
    var tmpl_cont: String? = null
    var img_seq: Int? = null
    var secur_flag: String? = null
    var tmpl_status: String? = null
    var kep_status: String? = null
    var tmpl_dormant: String? = null
    var tmpl_block: String? = null
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
    var item_img_seq: Int? = null
    var item_json: String? = null
    var cmt_json: String? = null

    var etc_1: String? = null
    var etc_2: String? = null
    var etc_3: String? = null
    var etc_4: String? = null
    var etc_5: String? = null
    var etc_6: String? = null
    var etc_7: String? = null
    var etc_8: String? = null
    var etc_9: String? = null
    var etc_10: String? = null

    var use_yn: String? = null
    var del_yn: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()


    constructor(send_key: String?, tmpl_cd: String?) {
        this.send_key = send_key
        this.tmpl_cd = tmpl_cd
    }
    constructor(img_seq:Int?,item_img_seq:Int?){
        this.img_seq = img_seq
        this.item_img_seq = item_img_seq
    }

    constructor(seq:Int?,upd_id:String?,use_yn:String?){
        this.seq = seq
        this.upd_id = upd_id
        this.use_yn = use_yn
    }

    constructor(seq:Int?,tmpl_status:String?,kep_status:String?,tmpl_dormant:String?,tmpl_block:String?){
        this.seq = seq
        this.tmpl_status = tmpl_status
        this.kep_status = kep_status
        this.tmpl_dormant = tmpl_dormant
        this.tmpl_block = tmpl_block
    }







    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}