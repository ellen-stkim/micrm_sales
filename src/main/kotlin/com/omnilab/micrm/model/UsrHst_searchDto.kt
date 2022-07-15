package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_usr_hstDto
import org.apache.ibatis.type.Alias

@Alias("UsrHst_searchDto")
class UsrHst_searchDto : Tblmi_usr_hstDto()  {
    var pageNo: Int = 1
    var firstIndex: Int?= null
    var recordCountPerPage: Int = 0
    var searchValue : String? = null
    var searchType : String? = null
    var usr_nm : String? = null
    var cd_nm : String? = null


}