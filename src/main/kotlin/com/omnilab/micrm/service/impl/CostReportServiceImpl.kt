package com.omnilab.micrm.service.impl

import com.google.gson.GsonBuilder
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.SearchSendCostDto
import com.omnilab.micrm.model.SendCostDto
import com.omnilab.micrm.repository.CostReportDao
import com.omnilab.micrm.service.CostReportService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import java.math.BigDecimal
import java.text.SimpleDateFormat
import java.util.*
import java.util.function.Function
import java.util.stream.Collectors.groupingBy
import java.util.stream.Collectors.toMap


@Service("CostReportServiceImpl")
class CostReportServiceImpl : CostReportService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("CostReportDaoImpl")
    private lateinit var costReportDao : CostReportDao

    override fun getCostReport(dto : SearchSendCostDto): HashMap<String, Any?> {
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val searchDto = setDateDefault(dto)   // 조회 날짜 체크 후 기본값 설정

        val totalLst : List<SendCostDto> = costReportDao.selSendCostLst(searchDto)

        // 발송 건수, 비용 월별 합계
        val groupMap = totalLst.stream().collect(groupingBy(SendCostDto::send_mon))

        val sendMap = mutableMapOf<String,Any>()
        val totalMap = mutableMapOf<String,Any>()
        for(data in groupMap){
            val mon = data.key as String
            val list = data.value

            var totalCost =  BigDecimal("0")
            var totalCnt =  0
            val sendTypeMap = hashMapOf<String,HashMap<String,Any?>>()
            for(dto in list){
                sendTypeMap[dto.msg_tp!!] = hashMapOf( "total_cnt" to dto.total_cnt
                                                        ,"total_cost" to dto.total_cost )
                totalCost = totalCost.plus(dto.total_cost!!)
                totalCnt += dto.total_cnt!!
            }
            sendMap[mon] = sendTypeMap
            totalMap[mon] = mapOf("totalCost" to totalCost
                                    ,"totalCnt" to totalCnt)
        }

        // 그래프
        val gson = GsonBuilder().create()
        val jsonMap = gson.toJson(sendMap)

//         총합 계산
        val typeTotalMap = mutableMapOf<String,Any>()
        val typeTotal = totalLst.stream().collect(groupingBy(SendCostDto::msg_tp))
        var allTotalCost  =  BigDecimal("0")
        var allTotalCnt  = 0
        for(data in typeTotal){
            val type = data.key as String
            val list = data.value

            var totalCost =  BigDecimal("0")
            var totalCnt  = 0
            for(dto in list){
                totalCost = totalCost.plus(dto.total_cost!!)
                totalCnt += dto.total_cnt!!
            }

            typeTotalMap[type] = mapOf("total_cost" to totalCost
                                        ,"total_cnt" to totalCnt )

            allTotalCost = allTotalCost.plus(totalCost)
            allTotalCnt += totalCnt
        }

        typeTotalMap["ALL"] = mapOf("total_cost" to allTotalCost
                                    ,"total_cnt" to allTotalCnt )


//        프로그램 당 발송 디테일
        val prgMap = getProgramCostLst(searchDto)

        return hashMapOf( "jsonMap" to jsonMap
                        ,"startDt" to searchDto.start_dt
                        ,"endDt" to searchDto.end_dt
                        ,"sendMap" to sendMap
                        ,"totalMap" to totalMap
                        ,"typeTotalMap" to typeTotalMap
                        ,"programMap" to prgMap["programMap"]
                        ,"page" to prgMap["page"] )
    }


    override fun getPrgCostReport(dto: SearchSendCostDto): HashMap<String, Any?> {
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val searchDto = setDateDefault(dto)

        return getProgramCostLst(searchDto)
    }

    private fun getProgramCostLst(searchDto: SearchSendCostDto): HashMap<String, Any?> {
//        프로그램 당 발송 디테일
        val paginationInfo = UsefulUtils.makePage(searchDto.pageNo, searchDto.pageSize, searchDto.recordCountPerPage)
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        paginationInfo.totalRecordCount = costReportDao.selPrgSendCostLstCnt(searchDto)

        val programLst: List<SendCostDto> = costReportDao.selPrgSendCostLst(searchDto)
        val programMap = programLst.stream().collect(
            groupingBy(
                SendCostDto::pro_id, toMap(SendCostDto::msg_tp, Function.identity())
            )
        )

        return hashMapOf( "programMap" to programMap
                            , "page" to paginationInfo
                            )
    }

    private fun setDateDefault(searchDto: SearchSendCostDto): SearchSendCostDto {
        val cal = Calendar.getInstance()
        val format = SimpleDateFormat("yyyy-MM-dd")

        if (CommonUtils.isEmptyObject(searchDto.start_dt)) {
            if (CommonUtils.isEmptyObject(searchDto.end_dt)) {
                cal.time = Date() // 오늘 날짜
                searchDto.end_dt = format.format(cal.time)

                cal.add(Calendar.MONTH, -1)
                searchDto.start_dt = format.format(cal.time)
            } else {
                cal.time =  format.parse(searchDto.end_dt) //end 기준
                cal.add(Calendar.MONTH, -1)
                searchDto.start_dt = format.format(cal.time)
            }
        } else if (CommonUtils.isEmptyObject(searchDto.end_dt)) {
            cal.time =  format.parse(searchDto.start_dt)  // start기준
            cal.add(Calendar.MONTH, 1)
            searchDto.end_dt = format.format(cal.time)
        }

        return searchDto
    }


}

