package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_group_listDto

class Group_SearchDto : Tblmi_group_listDto() {

    var reg_dt_range: String? = null
    var upd_dt_range: String? = null
    var pageNo: Int = 1
    var firstIndex: Int?= null
    var recordCountPerPage: Int = 0
    var searchValue : String? = null
    var searchType : String? = null

    override fun toString(): String {
        return "Group_SearchDto(reg_dt_range=$reg_dt_range, pageNo=$pageNo, firstIndex=$firstIndex, recordCountPerPage=$recordCountPerPage, searchValue=$searchValue, searchType=$searchType)"
    }

}