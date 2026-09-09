package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.BanWordHst_searchDto
import com.omnilab.micrm.model.Program_SearchDto
import com.omnilab.micrm.model.SendReportDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CampaignDao
import com.omnilab.micrm.repository.CampaignReportDao
import com.omnilab.micrm.repository.CommonDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.ReportService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.util.LinkedMultiValueMap
import java.util.*
import kotlin.collections.Map as Map1


@Service("ReportServiceImpl")
class ReportServiceImpl : ReportService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sysSettingDao: SysSettingDao

    @Autowired
    private lateinit var campaignDao: CampaignDao

    @Autowired
    private lateinit var commonService: com.omnilab.micrm.service.CommonService

    @Autowired
    private lateinit var campaignReportDao: CampaignReportDao

    @Autowired
    private lateinit var commonDao: CommonDao

    override fun getReportLst(usr_grp_cd: String): Map1<String, Any?> {
        val re_map = HashMap<String, Any?>()
        val tableau_url = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_URL", usr_grp_cd))?.cd_val

        return if (tableau_url.isNullOrBlank()) {
            re_map
        } else {
            val map = LinkedMultiValueMap<String, String>()
            map["username"] = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_ID", usr_grp_cd))?.cd_val
            val response = commonService.getRest("${tableau_url}/trusted", "POST", map)
            if (response.body.isNullOrBlank()) {
                re_map
            } else {
                re_map["tableauUrl"] = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_REP_PAGE",
                    usr_grp_cd))?.cd_val?.replace("{ticket}", response.body!!)
                re_map
            }
        }
    }

    override fun getCampMstTotalDetail(pdto: Array<String>): MutableMap<String, Any> {
        val map = HashMap<String, Any>()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val temp = HashMap<String, Any>()

        userInfo.usr_grp_cd?.let { temp.put("usr_grp_cd", it) }
        pdto.let { temp.put("list", it) }

        val totalResult: Tblmire_camp_mstDto = campaignReportDao.getCampMstTotalDetail(temp)
        val programLst = campaignReportDao.getCampMstTotalList(temp)

        map["totalResult"] = totalResult
        map["programLst"] = campListToTotal(programLst)
        return map
    }

    override fun getTotalCampMstList(dto: Tblmicp_programDto): MutableMap<String, Any> {
        val map = HashMap<String, Any>()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val usr_grp_cd = userInfo.usr_grp_cd
        dto.usr_grp_cd = usr_grp_cd
        val dto1 = dto as Program_SearchDto
        when (dto1.searchType) {
            "pro_nm" -> dto1.pro_nm = dto1.searchValue
            "camp_nm" -> dto1.camp_nm = dto1.searchValue
            "camp_ch" -> dto1.camp_ch = dto1.searchValue
            "pro_st" -> dto1.pro_st = dto1.searchValue
        }

        val paginationInfo = UsefulUtils.makePage(dto1.pageNo, 10, 5)
        dto1.firstIndex = paginationInfo.firstRecordIndex
        dto1.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = campaignReportDao.getCampMstSearchCnt(dto1)
        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["listCnt"] = paginationInfo.totalRecordCount

        val list = campaignReportDao.getCampMstList(dto1)
        if (list.isEmpty()) {
            map["programLst"] = listOf<Any>()
            return map
        }

        val programLst = campListToTotal(list)
        map["programLst"] = programLst
        return map

    }

    override fun getSucTab(seqs: Array<String>): List<SendReportDto> {
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val temp = HashMap<String, Any>()
        userInfo.usr_grp_cd?.let { temp.put("usr_grp_cd", it) }
        temp["seq_list"] = seqs
        temp["send_rst"] = 1
        return campaignReportDao.getSendHstDetail(temp)
    }

    override fun getDetOpenDet(seqs: Array<String>): List<Any> {
        val response: MutableList<Any> = ArrayList()
        val map = HashMap<String, Any>()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        map["usr_grp_cd"] = userInfo.usr_grp_cd!!
        map["list"] = seqs

        val openTimes = campaignReportDao.openTimingResult(map)
        val openResult = HashMap<String, HashMap<String, Any?>>()
        val openTitleMap = HashMap<String, MutableList<Any>>()
        val tot: MutableList<HashMap<String, Any?>> = ArrayList()
        var total = 0
        for (openTime in openTimes) {
            val tm = TreeMap(openTime)
            val set: Set<String> = tm.keys

            for (key in set) {
                val result = HashMap<String, Any?>()
                if (key.length == 3) {
                    val week = key.substring(0, 1)
                    when (week) {
                        "A" -> result["WEEK_DAY"] = "0"
                        "B" -> result["WEEK_DAY"] = "1"
                        "C" -> result["WEEK_DAY"] = "2"
                        "D" -> result["WEEK_DAY"] = "3"
                        "E" -> result["WEEK_DAY"] = "4"
                        "F" -> result["WEEK_DAY"] = "5"
                        "G" -> result["WEEK_DAY"] = "6"
                    }
                    result["TIME_BAND"] = key.substring(1)

                    result["OPEN_CNT"] = openTime[key]
                    val tempOpen = openResult[key]?.get("OPEN_CNT")
                    if (tempOpen != null && tempOpen.toString() != "0") {
                        result["OPEN_CNT"] =
                            openTime[key].toString().toInt() + openResult.get(key)?.get("OPEN_CNT").toString()
                                .toInt()
                    }

                    // 오픈 데이터가 있는 캠페인명 리스트
                    if ("0" != openTime[key].toString()) {
                        var openTitleLst = openTitleMap[key]
                        if (openTitleLst == null) {
                            openTitleLst = ArrayList()
                        }
                        val titleMap = mutableMapOf<String, String>()
                        titleMap["camp_nm"] = openTime.get("CAMP_NM").toString()
                        titleMap["open_cnt"] = openTime[key].toString()
                        openTitleLst.add(titleMap)
                        openTitleMap[key] = openTitleLst
                    }
                    openResult[key] = result
                    total += openTime[key].toString().toInt()
                }
            }
        }
        val t = HashMap<String, Any?>()
        t["total"] = total
        tot.add(t)
        response.add(tot)
        response.add(TreeMap(openResult))
        response.add(openTitleMap)
        return response
    }

    override fun getClickList(contId: Int): MutableList<HashMap<String, Any?>> {
        val mapLst = mutableListOf<HashMap<String, Any?>>()
        val searchCont = Tblmicp_cont_mstDto(contId)
        val contentDtoLst = campaignDao.getContentsViewList(searchCont)
        for (dto in contentDtoLst) {
            val map = HashMap<String, Any?>()
            dto.cardSize = '1'.toString()
            if (dto.cont_tp.equals("DMTP04")) {
                commonService.jsonOneContentsParsing(dto)
            }
            // 와이드 리스트형: 항목 JSON 파싱하여 프리뷰용 리스트 구성
            if (dto.msg_tp.equals("DMCH220") && !dto.kko_item_json.isNullOrBlank()) {
                val type = object : com.google.gson.reflect.TypeToken<List<Map1<String, Any?>>>() {}.type
                map["wideItemList"] = com.google.gson.Gson().fromJson<List<Map1<String, Any?>>>(dto.kko_item_json, type)
            }
            map["dto"] = dto
            map["url"] = campaignReportDao.getLinkClickCnt(dto.list_seq)
            mapLst.add(map)
        }
        return mapLst
    }

    override fun getCampMstContIdByProId(proId: String): MutableList<String>? {
        return campaignReportDao.getCampMstContIdByProId(proId)
    }

    fun campListToTotal(programDtoList: List<kotlin.collections.Map<String, Any>>): MutableList<Any> {
        val programLst = mutableListOf<Any>()
        var tempProgram = mutableListOf<Any>()
        var chTotal = ""
        var tTotal = 0
        var sTotal = 0
        var oTotal = 0
        var cliTotal = 0
        var rowCnt = 1
        var proId = ""
        var chNm = ""
        val listSize = programDtoList.size

        for ((i, program) in programDtoList.withIndex()) {
            rowCnt++
            tTotal += program["total_cnt"].toString().toInt()
            sTotal += program["suc_cnt"].toString().toInt()
            oTotal += program["open_cnt"].toString().toInt()
            cliTotal += program["click_cnt"].toString().toInt()
            proId = program["pro_id"] as String
            chNm = program["camp_ch"].toString()

            chNm = when (chNm) {
                "CH01" -> {
                    "이메일"
                }
                "CH02" -> {
                    "문자"
                }
                else -> {
                    "세일즈포스"
                }
            }

            if (chTotal.indexOf(chNm) == -1) {
                if ("" != chTotal) {
                    chTotal += "/"
                }
                chTotal += chNm   //  CH00  => 이메일/문자
            }
            tempProgram.add(program)

            if (i < listSize-1) {
                if (proId.contentEquals(programDtoList[i+1]["pro_id"].toString())) {
                    continue
                }
            }

            val tempTotal = HashMap<String, Any>()
            tempTotal["ch_total"] = chTotal
            tempTotal["t_cnt"] = tTotal
            tempTotal["s_cnt"] = sTotal
            tempTotal["o_cnt"] = oTotal
            tempTotal["c_cnt"] = cliTotal
            tempTotal["rowCnt"] = rowCnt
            tempTotal["pro_id"] = proId

            tempTotal["pro_nm"] = program["pro_nm"].toString()
            tempTotal["pro_st_nm"] = program["pro_st_nm"].toString()
            tempTotal["start_dt"] = program["start_dt"].toString()

            val tempRowMap = HashMap<String, Any>()
            tempRowMap["total"] = tempTotal
            tempRowMap["program"] =  tempProgram
            programLst.add(tempRowMap)

            chTotal = ""
            tTotal = 0
            sTotal = 0
            oTotal = 0
            cliTotal = 0
            rowCnt = 1
            tempProgram = mutableListOf()
        }
        return programLst
    }

    override fun getCampMstList(pdto: Tblmicp_programDto): MutableMap<String, Any> {

        val map = HashMap<String, Any>()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val usr_grp_cd = userInfo.usr_grp_cd
        pdto.usr_grp_cd = usr_grp_cd
        val dto = pdto as Program_SearchDto
        when (dto.searchType) {

            "pro_nm" -> dto.pro_nm = dto.searchValue
            "camp_ch" -> dto.camp_ch = dto.searchValue
            "target_nm" -> {
                dto.target_nm = dto.searchValue
            }
        }

        val paginationInfo = UsefulUtils.makePage(dto.pageNo, 10, 5)
        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = campaignReportDao.getCampMstSearchCnt(dto)

        map["programLst"] = campaignReportDao.getCampMstList(dto)
        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["listCnt"] = paginationInfo.totalRecordCount
        return map
    }

    /**
     * @Method Name  : getBanWordHstList
     * @param    : dto: BanWordHst_searchDto
     * @return   : MutableMap<String, Any>
     * @Method Decription : 로그인 사용자 그룹의 금칙어 차단 이력 목록을 조회한다.
     * @title : 금칙어 차단 이력 조회
     */
    override fun getBanWordHstList(dto: BanWordHst_searchDto): MutableMap<String, Any> {
        val map = HashMap<String, Any>()

        when (dto.searchType) {
            "ban_word" -> dto.ban_word = dto.searchValue
            "send_to" -> dto.send_to = dto.searchValue
        }

        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val paginationInfo = UsefulUtils.makePage(dto.pageNo, 10, 10)
        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = commonDao.sel_tblmi_ban_word_hstCnt(dto)

        map["list"] = commonDao.sel_tblmi_ban_word_hst(dto)
        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        return map
    }
}
