package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_workDto

class WorkSearch_Dto : Tblmi_workDto() {

    var reg_dt_range: String? = null
    var pageNo: Int = 1
    var firstIndex: Int?= 1
    var usr_email : String ?= null
    var recordCountPerPage: Int = 0
    var searchValue : String? = null
    var searchType : String? = null
    var isLimit : Int ?= null

    override fun toString(): String {
        return "WorkSearch_Dto(reg_dt_range=$reg_dt_range, pageNo=$pageNo, firstIndex=$firstIndex, usr_email=$usr_email, recordCountPerPage=$recordCountPerPage, searchValue=$searchValue, searchType=$searchType, isLimit=$isLimit)"
    }

}