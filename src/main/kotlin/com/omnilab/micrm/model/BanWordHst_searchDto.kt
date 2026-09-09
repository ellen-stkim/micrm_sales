package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_ban_word_hstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("BanWordHst_searchDto")
class BanWordHst_searchDto : Tblmi_ban_word_hstDto() {

    var pageNo: Int = 1
    var firstIndex: Int? = null
    var recordCountPerPage: Int? = null
    var searchType: String? = null
    var searchValue: String? = null
    var st_dt: String? = null
    var end_dt: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}
