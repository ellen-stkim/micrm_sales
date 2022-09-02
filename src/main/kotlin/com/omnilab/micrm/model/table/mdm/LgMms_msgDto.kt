package com.omnilab.micrm.model.table.mdm

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("LgMms_msgDto")
class LgMms_msgDto {
    var msgkey: Int? = null
    var subject: String? = null
    var phone: String? = null
    var callback: String? = null
    var status: String? = null
    var reqdate: String? = null
    var msg: String? = null
    var file_cnt: Int? = null
    var file_cnt_real: Int? = null
    var file_path1: String? = null
    var file_path1_siz: Int? = null
    var file_path2: String? = null
    var file_path2_siz: Int? = null
    var file_path3: String? = null
    var file_path3_siz: Int? = null
    var file_path4: String? = null
    var file_path4_siz: Int? = null
    var file_path5: String? = null
    var file_path5_siz: Int? = null
    var expiretime: String? = null
    var sentdate: String? = null
    var rsltdate: String? = null
    var reportdate: String? = null
    var terminateddate: String? = null
    var rslt: String? = null
    var type: String? = null
    var telcoinfo: String? = null
    var route_id: String? = null
    var id: String? = null
    var post: String? = null
    var etc1: String? = null
    var etc2: String? = null
    var etc3: String? = null
    var etc4: Int? = null
    var multi_seq: String? = null
    var template_key: String? = null
    var bar_code: String? = null
    var bar_code_merge_txt: String? = null

    var m_server: String? = null

    constructor()
    constructor(subject: String?, phone: String?, callback: String?, status: String?, reqdate: String?, msg: String?, type: String?, etc1: String?, etc2: String?, etc3: String?, m_server: String?, id: String?, post: String?){
        this.subject = subject
        this.phone = phone
        this.callback = callback
        this.status = status
        this.reqdate = reqdate
        this.msg = msg
        this.type = type
        this.etc1 = etc1
        this.etc2 = etc2
        this.etc3 = etc3
        this.m_server = m_server
        this.id = id
        this.post = post
    }
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}