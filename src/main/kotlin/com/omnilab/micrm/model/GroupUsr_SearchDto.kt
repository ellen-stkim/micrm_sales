package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_group_usrDto

class GroupUsr_SearchDto : Tblmi_group_usrDto() {

    var grp_nm : String?= null
    var work_seq : Int?= null
    var reg_dt_range: String? = null
    var pageNo: Int = 1
    var firstIndex: Int?= null
    var recordCountPerPage: Int = 0
    var searchValue : String? = null
    var searchType : String? = null

    override fun toString(): String {
        return "GroupUsr_SearchDto(reg_dt_range=$reg_dt_range, pageNo=$pageNo, firstIndex=$firstIndex, recordCountPerPage=$recordCountPerPage, searchValue=$searchValue, searchType=$searchType)"
    }

}