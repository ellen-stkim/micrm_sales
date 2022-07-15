package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmite_target_grp
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.springframework.web.multipart.MultipartFile

class TestGroup_SearchDto : Tblmite_target_grp() {

    var excelFile : MultipartFile? = null
    var reg_dt_range: String? = null
    var upd_dt_range: String? = null
    var pageNo: Int = 1
    var firstIndex: Int?= null
    var recordCountPerPage: Int = 0
    var searchValue : String? = null
    var searchType : String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}