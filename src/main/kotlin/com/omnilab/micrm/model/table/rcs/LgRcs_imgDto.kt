package com.omnilab.micrm.model.table.rcs

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("LgRcs_imgDto")
class LgRcs_imgDto {

    var imgkey: Int? = null
    var group_key: String? = null
    var group_cnt: String? = null
    var status: String? = null
    var rslt: String? = null
    var rsltdesc: String? = null
    var sendable: String? = null
    var brand_id: String? = null
    var img_path: String? = null
    var img_id: String? = null
    var reqdate: String? = null
    var rptdate: String? = null
    var template_yn: String? = null
    var m_server: String? = null


    constructor()


    constructor(group_key: String?, m_server: String?) {
        this.group_key = group_key
        this.m_server = m_server
    }


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}