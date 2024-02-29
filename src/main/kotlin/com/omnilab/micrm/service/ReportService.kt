package com.omnilab.micrm.service

import com.omnilab.micrm.model.SendReportDto
import com.omnilab.micrm.model.table.Tblmicp_programDto
import java.util.*

interface ReportService {

    fun getReportLst(usr_grp_cd: String): Map<String, Any?>
//    fun getCampList(dto: Tblmicp_programDto): MutableMap<String,Any>

    fun getCampMstTotalDetail(pdto: Array<String>): MutableMap<String, Any>
    fun getCampMstList(seqs: Tblmicp_programDto): MutableMap<String, Any>
    fun getTotalCampMstList(dto: Tblmicp_programDto): MutableMap<String, Any>
    fun getSucTab(seqs: Array<String>): List<SendReportDto>
    fun getDetOpenDet(seqs: Array<String>): List<Any>
    fun getClickList(contId: Int): MutableList<HashMap<String, Any?>>
    fun getCampMstContIdByProId(proId: String): MutableList<String>?
}