package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmicp_send_hstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("SendResult_lstDto")
class SendResult_lstDto: Tblmicp_send_hstDto {

    var camp_nm: String? = null
    var cd_desc: String? = null
    var firstIndex: Int? = null
    var recordCountPerPage: Int? = null

    constructor()
    constructor(pro_id: String?, usr_grp_cd: String?){
        this.pro_id = pro_id
        this.usr_grp_cd = usr_grp_cd
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}