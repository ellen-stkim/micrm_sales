package com.omnilab.micrm.service.impl

import com.omnilab.micrm.model.SendCostDto
import com.omnilab.micrm.repository.CostReportDao
import com.omnilab.micrm.service.CostReportService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import java.util.stream.Collectors


@Service("CostReportServiceImpl")
class CostReportServiceImpl : CostReportService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("CostReportDaoImpl")
    private lateinit var costReportDao : CostReportDao

    override fun getCostReport(): HashMap<String, Any?> {


        // 발송 건수 => report 건수

        // 발송 요청일 기준으로 검색?

        val hstDto  = SendCostDto("05", "2022-01-01","2023-03-01")


        val list :List<SendCostDto>  = costReportDao.selSendCostLst(hstDto)


        val totalMap : MutableMap<String?, MutableList<SendCostDto>>? = list.stream().collect(Collectors.groupingBy(SendCostDto::send_mon))
        val programMap : MutableMap<String?, MutableList<SendCostDto>>? = list.stream().collect(Collectors.groupingBy(SendCostDto::pro_id))

        logger.error("{}",totalMap)
        logger.error("{}",programMap)

        return hashMapOf("totalMap" to totalMap,"programMap" to programMap)

    }

}
