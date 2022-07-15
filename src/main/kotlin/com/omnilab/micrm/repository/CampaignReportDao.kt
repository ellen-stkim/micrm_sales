package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*

interface CampaignReportDao {
    fun getCampMstSearchCnt(dto:Tblmicp_programDto): Int
    fun getCampMstList(pdto: Tblmicp_programDto): List<Map<String,Any>>
    fun getCampMst(proId: String): List<Tblmire_camp_mstDto>
    fun getCampMstTotalDetail(map: HashMap<String, Any>): Tblmire_camp_mstDto
    fun getCampMstTotalList(map: HashMap<String, Any>): List<Map<String,Any>>
    fun getSnedResultDetail(map: HashMap<String, Any>): List<Map<String,Any>>
    fun openTimingResult(temp: HashMap<String, Any>): List<HashMap<String, Any>>
    fun getCampMstContIdByProId(proId: String): MutableList<String>?
    fun getLinkClickCnt(seq: Int?): MutableList<java.util.HashMap<String, Any?>>
    fun getContentsLst(seq: Int?): Content_view_Dto
}