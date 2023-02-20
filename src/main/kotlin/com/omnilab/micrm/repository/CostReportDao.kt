package com.omnilab.micrm.repository

import com.omnilab.micrm.model.SearchSendCostDto
import com.omnilab.micrm.model.SendCostDto

interface CostReportDao {
    fun selSendCostLst(hstDto: SearchSendCostDto?): List<SendCostDto>
    fun selPrgSendCostLst(hstDto: SendCostDto?): List<SendCostDto>
    fun selPrgSendCostLstCnt(searchDto: SearchSendCostDto?): Int
    fun selDailySendCostLst(searchDto: SearchSendCostDto): List<SendCostDto>
    fun selTotalSendCost(searchDto: SearchSendCostDto): List<SendCostDto>
}
