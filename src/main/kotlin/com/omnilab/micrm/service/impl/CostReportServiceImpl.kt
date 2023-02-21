package com.omnilab.micrm.service.impl

import com.google.gson.GsonBuilder
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.SearchSendCostDto
import com.omnilab.micrm.model.SendCostDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.repository.CostReportDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.CommonService
import com.omnilab.micrm.service.CostReportService
import org.apache.poi.ss.util.CellRangeAddress
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import java.math.BigDecimal
import java.text.SimpleDateFormat
import java.util.*
import java.util.function.Function
import java.util.stream.Collectors.*


@Service("CostReportServiceImpl")
class CostReportServiceImpl : CostReportService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("CostReportDaoImpl")
    private lateinit var costReportDao : CostReportDao

    @Autowired
    private lateinit var commonService: CommonService

    @Autowired
    @Qualifier("SysSettingDaoImpl")
    lateinit var sysSettingDao : SysSettingDao

    override fun getCostReport(dto : SearchSendCostDto): HashMap<String, Any?> {
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val searchDto = setDateDefault(dto)   // 조회 날짜 체크 후 기본값 설정

        val totalLst : List<SendCostDto> = costReportDao.selSendCostLst(searchDto)

        // 발송 건수, 비용 월별 합계
        val groupMap = totalLst.stream().collect(groupingBy(SendCostDto::send_mon, { TreeMap() }, toList()))

        val sendMap = mutableMapOf<String,Any>()
        val totalMap = mutableMapOf<String,Any>()
        for(data in groupMap){
            val mon = data.key as String
            val list = data.value

            var totalCost =  BigDecimal("0")
            var totalCnt =  0L
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
        var allTotalCnt  = 0L
        for(data in typeTotal){
            val type = data.key as String
            val list = data.value

            var totalCost =  BigDecimal("0")
            var totalCnt  = 0L
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


        val cal = Calendar.getInstance()
        val format = SimpleDateFormat("yyyy-MM")
        if(!CommonUtils.isEmptyObject(searchDto.monthly_dt)){
            cal.time =  format.parse(searchDto.monthly_dt)
            format.format(cal.time)
        }

        return hashMapOf( "jsonMap" to jsonMap
                        ,"startDt" to searchDto.start_dt
                        ,"endDt" to searchDto.end_dt
                        ,"monthlyDt" to  cal.time
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

    override fun costReportDownloadExcel(dto: SearchSendCostDto): HashMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val labelList = mutableListOf("발송요청일"
                                    , "알림톡", "친구톡(txt)", "친구톡(img)", "친구톡(wid)"
                                    , "RCS SMS", "RCS LMS", "RCS MMS", "RCS 템플릿"
                                    , "SMS", "LMS", "MMS")
        // 파일 생성
        val book = commonService.createExcel(labelList)
        labelList.clear()

        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val searchDto = setDateDefault(dto)   // 조회 날짜 체크 후 기본값 설정

        val dailyTotalLst : List<SendCostDto> = costReportDao.selDailySendCostLst(searchDto)
        // 발송 건수, 비용 월별 합계
        val groupMap = dailyTotalLst.stream().collect(groupingBy(SendCostDto::send_mon, { TreeMap() }, toList()))

        val sendMap = mutableMapOf<String,Any>()
        for(data in groupMap){
            val mon = data.key as String
            val list = data.value

            var totalCost =  BigDecimal("0")
            var totalCnt =  0L
            val sendTypeMap = hashMapOf<String,Long?>()
            for(dto in list){
                sendTypeMap[dto.msg_tp!!] = dto.total_cnt
                totalCost = totalCost.plus(dto.total_cost!!)
                totalCnt += dto.total_cnt!!
            }
            sendMap[mon] = sendTypeMap
        }


        val sheet = book.getSheet("sheet1")
        var i = sheet.lastRowNum + 1

        // 일별 발송건수
        for(group in sendMap){
            val row = sheet.createRow(i++)
            val value = group.value as Map<String,Long>

            row.createCell(0).setCellValue(group.key)
            row.createCell(1).setCellValue(if (value["KKO_AT"] != null)  value["KKO_AT"].toString() else "0")
            row.createCell(2).setCellValue(if (value["KKO_FT_TXT"] != null)  value["KKO_FT_TXT"]?.toString() else "0")
            row.createCell(3).setCellValue(if (value["KKO_FT_IMG"] != null)  value["KKO_FT_IMG"]?.toString() else "0")
            row.createCell(4).setCellValue(if (value["KKO_FT_WID"] != null)  value["KKO_FT_WID"]?.toString() else "0")
            row.createCell(5).setCellValue(if (value["RCS_SMS"] != null)  value["RCS_SMS"]?.toString() else "0")
            row.createCell(6).setCellValue(if (value["RCS_LMS"] != null)  value["RCS_LMS"]?.toString() else "0")
            row.createCell(7).setCellValue(if (value["RCS_MMS"] != null)  value["RCS_MMS"]?.toString() else "0")
            row.createCell(8).setCellValue(if (value["RCS_TEPLATE"] != null)  value["RCS_TEPLATE"]?.toString() else "0")
            row.createCell(9).setCellValue(if (value["SMS"] != null)  value["SMS"]?.toString() else "0")
            row.createCell(10).setCellValue(if (value["LMS"] != null)  value["LMS"]?.toString() else "0")
            row.createCell(11).setCellValue(if (value["MMS"] != null)  value["MMS"]?.toString() else "0")
        }

        // 타입별 총 발송 건수 / 타입별 총 발송 비용
        var totalCost =  BigDecimal("0")
        var totalCnt =  0L

        val totalLst : List<SendCostDto> = costReportDao.selTotalSendCost(searchDto)

        val totalmap = mutableMapOf<String,Any>()
        for(total in totalLst){
            totalmap[total.msg_tp.toString()] = total.total_cnt!!

            totalCnt += total.total_cnt!!
            totalCost = totalCost.add(total.total_cost)

        }

        val typeTotalRow = sheet.createRow(i++)
        typeTotalRow.createCell(0).setCellValue("총합")
        typeTotalRow.createCell(1).setCellValue(if (totalmap["KKO_AT"] != null)  totalmap["KKO_AT"].toString() else "0")
        typeTotalRow.createCell(2).setCellValue(if (totalmap["KKO_FT_TXT"] != null)  totalmap["KKO_FT_TXT"]?.toString() else "0")
        typeTotalRow.createCell(3).setCellValue(if (totalmap["KKO_FT_IMG"] != null)  totalmap["KKO_FT_IMG"]?.toString() else "0")
        typeTotalRow.createCell(5).setCellValue(if (totalmap["RCS_SMS"] != null)  totalmap["RCS_SMS"]?.toString() else "0")
        typeTotalRow.createCell(4).setCellValue(if (totalmap["KKO_FT_WID"] != null)  totalmap["KKO_FT_WID"]?.toString() else "0")
        typeTotalRow.createCell(6).setCellValue(if (totalmap["RCS_LMS"] != null)  totalmap["RCS_LMS"]?.toString() else "0")
        typeTotalRow.createCell(7).setCellValue(if (totalmap["RCS_MMS"] != null)  totalmap["RCS_MMS"]?.toString() else "0")
        typeTotalRow.createCell(8).setCellValue(if (totalmap["RCS_TEPLATE"] != null)  totalmap["RCS_TEPLATE"]?.toString() else "0")
        typeTotalRow.createCell(9).setCellValue(if (totalmap["SMS"] != null)  totalmap["SMS"]?.toString() else "0")
        typeTotalRow.createCell(10).setCellValue(if (totalmap["LMS"] != null)  totalmap["LMS"]?.toString() else "0")
        typeTotalRow.createCell(11).setCellValue(if (totalmap["MMS"] != null)  totalmap["MMS"]?.toString() else "0")


        // 발송 단가
        var rowInx = i++
        var row = sheet.createRow(rowInx)
        val cdDto = Tblmi_comm_cdDto()
        cdDto.cd_id = searchDto.usr_grp_cd
        cdDto.grp_id = "API_PRICE"
        val priceLst = sysSettingDao.getCommCDLst(cdDto)

        val priceMap = priceLst.associateBy({it.cd_val}, {it.cd_desc})
        row.createCell(0).setCellValue("판가")
        row.createCell(1).setCellValue(priceMap["KKO_AT"].toString())
        row.createCell(2).setCellValue(priceMap["KKO_FT_TXT"].toString())
        row.createCell(3).setCellValue(priceMap["KKO_FT_IMG"].toString())
        row.createCell(4).setCellValue(priceMap["KKO_FT_WID"].toString())
        row.createCell(5).setCellValue(priceMap["RCS_SMS"].toString())
        row.createCell(6).setCellValue(priceMap["RCS_LMS"].toString())
        row.createCell(7).setCellValue(priceMap["RCS_MMS"].toString())
        row.createCell(8).setCellValue(priceMap["RCS_TEPLATE"].toString())
        row.createCell(9).setCellValue(priceMap["SMS"].toString())
        row.createCell(10).setCellValue(priceMap["LMS"].toString())
        row.createCell(11).setCellValue(priceMap["MMS"].toString())

        // 총 발송 건수 / 총 발송 비용
        rowInx = i++
        row = sheet.createRow(rowInx)
        row.createCell(0).setCellValue("총 발송 건수")
        row.createCell(1).setCellValue(totalCnt.toString())
        sheet.addMergedRegion(CellRangeAddress(rowInx, rowInx, 1, 11))

        rowInx = i++
        row = sheet.createRow(rowInx)
        row.createCell(0).setCellValue("총 발송 비용")
        row.createCell(1).setCellValue(totalCost.toString())
        sheet.addMergedRegion(CellRangeAddress(rowInx, rowInx, 1, 11))

        re_map["name"] = "총 발송 비용"
        re_map["book"] = book

        return re_map
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

        if(!CommonUtils.isEmptyObject(searchDto.monthly_dt)){
            searchDto.monthly_dt = searchDto.monthly_dt + "-01"
            return searchDto
        }

        if (CommonUtils.isEmptyObject(searchDto.start_dt)) {
            if (CommonUtils.isEmptyObject(searchDto.end_dt)) {
                cal.time = Date() // 오늘 날짜
                cal.add(Calendar.MONTH, -1)
                searchDto.monthly_dt = format.format(cal.time)   // 전월 데이터 조회
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

