package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_notiDto
import com.omnilab.micrm.model.table.Tblmi_tbl_listDto
import org.apache.ibatis.type.Alias

@Alias("Noti_searchDto")
class Noti_searchDto : Tblmi_notiDto() {
    var pageNo : Int? = null
    var searchType : String? = null
    var searchValue : String? = null
    var firstIndex : Int?= null
    var recordCountPerPage : Int?= null
    var usr_email : String?=null
}