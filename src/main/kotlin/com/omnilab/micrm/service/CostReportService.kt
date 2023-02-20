package com.omnilab.micrm.service

import com.omnilab.micrm.model.SearchSendCostDto
import com.omnilab.micrm.model.SendCostDto
import com.omnilab.micrm.model.SendReportDto
import com.omnilab.micrm.model.table.Tblmicp_programDto
import com.omnilab.micrm.model.table.Tblmire_send_hstDto
import java.util.*
import kotlin.collections.HashMap

interface CostReportService {
    fun getCostReport(hstDto: SearchSendCostDto): HashMap<String, Any?>
    fun getPrgCostReport(dto: SearchSendCostDto): HashMap<String, Any?>
    fun costReportDownloadExcel(dto: SearchSendCostDto): java.util.HashMap<String, Any>
}