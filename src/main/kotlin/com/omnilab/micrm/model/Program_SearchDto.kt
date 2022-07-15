package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmicp_programDto
import org.apache.ibatis.type.Alias

@Alias("Program_SearchDto")
class Program_SearchDto: Tblmicp_programDto() {
    var pageNo: Int = 1
    var firstIndex: Int = 0
    var recordCountPerPage: Int = 0
    var searchType : String? = null
    var searchValue : String? = null
    var pro_st_nm : String? = null
    var pro_tg_tp_nm: String? = null
    var target_nm : String? = null
    var usr_nm : String? = null
    var usr_email : String? = null
    var start_dt : String? = null
    var camp_nm : String? = null
    var camp_ch : String? = null

    var st_dt : String? = null
    var end_dt : String? = null


}