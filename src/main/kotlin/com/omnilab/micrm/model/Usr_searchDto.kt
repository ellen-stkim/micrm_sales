package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_usrDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Usr_searchDto")
class Usr_searchDto : Tblmi_usrDto() {
    var pageNo : Int? = null
    var searchType : String? = null
    var searchValue : String? = null
    var firstIndex : Int?= null
    var recordCountPerPage : Int?= null
    var reg_dt_range: String? = null
    var appr_email : String? = null
    var role_cd : String? = null
    var cd_nm : String? = null
    var del_dt : String? = null
    var appr_nm : String? = null
    var usr_pw_old: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }


}