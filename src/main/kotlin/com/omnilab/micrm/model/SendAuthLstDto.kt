package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_usr_authDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("SendAuthLstDto")
class SendAuthLstDto: Tblmi_usr_authDto {

    var usr_grp_cd: String? = null
    var roleLst: List<String>? = null

    constructor()
    constructor(usr_grp_cd: String?, roleLst: List<String>){
        this.usr_grp_cd = usr_grp_cd
        this.roleLst = roleLst
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}