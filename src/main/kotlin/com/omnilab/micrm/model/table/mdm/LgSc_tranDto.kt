package com.omnilab.micrm.model.table.mdm

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("LgSc_tranDto")
class LgSc_tranDto {
    var tr_num: Int? = null
    var tr_senddate: String? = null
    var tr_id: String? = null
    var tr_sendstat: String? = null
    var tr_rsltstat: String? = null
    var tr_msgtype: String? = null
    var tr_phone: String? = null
    var tr_callback: String? = null
    var tr_rsltdate: String? = null
    var tr_modified: String? = null
    var tr_msg: String? = null
    var tr_net: String? = null
    var tr_etc1: String? = null
    var tr_etc2: String? = null
    var tr_etc3: String? = null
    var tr_etc4: String? = null
    var tr_etc5: String? = null
    var tr_etc6: String? = null
    var tr_routeid: String? = null
    var tr_realsenddate: String? = null

    var m_server: String? = null

    constructor()
    constructor(tr_senddate: String?, tr_sendstat: String?, tr_msgtype: String?, tr_phone: String?, tr_callback: String?, tr_msg: String?, tr_etc1: String?, tr_etc2: String?, tr_etc3: String?, m_server: String?, tr_id: String?){
        this.tr_senddate = tr_senddate
        this.tr_sendstat = tr_sendstat
        this.tr_msgtype = tr_msgtype
        this.tr_phone = tr_phone
        this.tr_callback = tr_callback
        this.tr_msg = tr_msg
        this.tr_etc1 = tr_etc1
        this.tr_etc2 = tr_etc2
        this.tr_etc3 = tr_etc3
        this.m_server = m_server
        this.tr_id = tr_id
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}