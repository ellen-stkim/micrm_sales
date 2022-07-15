package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_tbl_listDto
import org.apache.ibatis.type.Alias

@Alias("Tblmi_tbl_searchDto")
class Tblmi_tbl_searchDto :Tblmi_tbl_listDto {

    var tbl_id: String? = null
    var totalCnt: Int? = null
    var mdm_agree_cnt: Int? = null
    var edm_agree_cnt: Int? = null
    var columnValue: String? = null
    var columnNm: List<String>? = null
    var tblList : List<Tblmi_tbl_listDto>? = null

    var pageNo : Int? = null
    var searchType : String? = null
    var searchValue : String? = null
    var firstIndex : Int?= null
    var recordCountPerPage : Int?= null
    var reg_dt_range: String? = null


    constructor() : super()

    override fun toString(): String {
        return "Tblmi_tbl_searchDto(tbl_id=$tbl_id, totalCnt=$totalCnt, mdm_agree_cnt=$mdm_agree_cnt, edm_agree_cnt=$edm_agree_cnt, columnValue=$columnValue, columnNm=$columnNm, tblList=$tblList, pageNo=$pageNo, searchType=$searchType, searchValue=$searchValue, firstIndex=$firstIndex, recordCountPerPage=$recordCountPerPage, reg_dt_range=$reg_dt_range)"
    }


}