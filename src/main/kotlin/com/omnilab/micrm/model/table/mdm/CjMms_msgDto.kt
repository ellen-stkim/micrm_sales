package com.omnilab.micrm.model.table.mdm

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("CjMms_msgDto")
class CjMms_msgDto {
    var msgkey: Int? = null
    var serialnum:Int? = null
    var id: String? = null
    var status: String? = null
    var phone: String? = null
    var callback: String? = null
    var type: String? = null
    var repcnt: Int? = null
    var reqdate: String? = null
    var sentdate: String? = null
    var rsltdate: String? = null
    var reportdate: String? = null
    var rslt: String? = null
    var net: String? = null
    var subject: String? = null
    var msg: String? = null
    var file_cnt: Int? = null
    var file_cnt_real: Int? = null
    var file_type1: String? = null
    var file_path1: String? = null
    var file_type2: String? = null
    var file_path2: String? = null
    var file_type3: String? = null
    var file_path3: String? = null
    var file_type4: String? = null
    var file_path4: String? = null
    var file_type5: String? = null
    var file_path5: String? = null
    var mms_file_name: String? = null
    var bar_type: String? = null
    var bar_merge_file: Int? = null
    var bar_value: String? = null
    var bar_size_width: Int? = null
    var bar_size_height: Int? = null
    var bar_position_x: Int? = null
    var bar_position_y: Int? = null
    var bar_file_name: Int? = null
    var etc1: String? = null
    var etc2: String? = null
    var etc3: String? = null
    var etc4: Int? = null
    var etc5: String? = null
    var etc6: String? = null

    var m_server: String? = null

    constructor()
    constructor(subject: String?, phone: String?, callback: String?, status: String?, reqdate: String?, msg: String?, type: String?, etc1: String?, etc2: String?, etc3: String?, m_server: String?, id: String?){
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
    }
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}