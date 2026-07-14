package com.omnilab.micrm.service

import com.omnilab.micrm.model.SearchSendCostDto
import java.util.*
import kotlin.collections.HashMap

interface CostReportService {
    fun getCostReport(hstDto: SearchSendCostDto): HashMap<String, Any?>
    fun getPrgCostReport(dto: SearchSendCostDto): HashMap<String, Any?>
    fun costReportDownloadExcel(dto: SearchSendCostDto): HashMap<String, Any>
    fun costLstDownloadExcel(dto: SearchSendCostDto): HashMap<String, Any>
}