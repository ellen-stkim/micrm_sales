package com.omnilab.micrm.service.impl

import com.google.gson.JsonParser
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.Program_SearchDto
import com.omnilab.micrm.model.SendReportDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CampaignDao
import com.omnilab.micrm.repository.CampaignReportDao
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
    private lateinit var sysSettingDao: SysSettingDao;

    @Autowired
    private lateinit var campaignDao: CampaignDao

    @Autowired
    private lateinit var commonService: com.omnilab.micrm.service.CommonService

    @Autowired
    private lateinit var campaignReportDao: CampaignReportDao


    override fun getReportLst(usr_grp_cd: String): Map1<String, Any?> {
        val re_map = HashMap<String, Any?>()
        val tableau_url = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_URL", usr_grp_cd))?.cd_val

        return if (tableau_url.isNullOrEmpty()) {
            re_map
        } else {
            val map = LinkedMultiValueMap<String, String>()
            map["username"] = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_ID", usr_grp_cd))?.cd_val
            val response = commonService.getRest("${tableau_url}/trusted", "POST", map)
            if (response.body.isNullOrEmpty()) {
                re_map
            } else {
                re_map["tableauUrl"] = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_REP_PAGE",
                    usr_grp_cd))?.cd_val?.replace("{ticket}", response.body!!)
                re_map
            }
        }
    }


    override fun getCampMstTotalDetail(contSeqs: Array<String>): kotlin.collections.MutableMap<String, Any> {
        val map = HashMap<String, Any>()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val temp = HashMap<String, Any>()

        userInfo.usr_grp_cd?.let { temp.put("usr_grp_cd", it) }
        contSeqs?.let { temp.put("list", it) }

        val totalResult: Tblmire_camp_mstDto = campaignReportDao.getCampMstTotalDetail(temp)
        val programLst = campaignReportDao.getCampMstTotalList(temp)

        map["totalResult"] = totalResult
        map["programLst"] = campListToTotal(programLst)

        return map;
    }


    override fun getTotalCampMstList(pdto: Tblmicp_programDto): MutableMap<String, Any> {

        val map = HashMap<String, Any>()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val usr_grp_cd = userInfo.usr_grp_cd
        pdto.usr_grp_cd = usr_grp_cd
        val dto = pdto as Program_SearchDto
        when (dto.searchType) {
            "pro_nm" -> dto.pro_nm = dto.searchValue
            "camp_nm" -> dto.camp_nm = dto.searchValue
            "camp_ch" -> dto.camp_ch = dto.searchValue
            "pro_st" -> dto.pro_st = dto.searchValue
        }

        val paginationInfo = UsefulUtils.makePage(dto.pageNo, 10, 5)
        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = campaignReportDao.getCampMstSearchCnt(dto)
        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["listCnt"] = paginationInfo.totalRecordCount

        val list = campaignReportDao.getCampMstList(dto)
        if (list.isEmpty()) {
            map["programLst"] = listOf<Any>()
            return map
        }

        val programLst = campListToTotal(list)
        map["programLst"] = programLst
        return map

    }

    override fun getSucTab(contSeqs: Array<String>): List<SendReportDto> {

        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val temp = HashMap<String, Any>()
        userInfo.usr_grp_cd?.let { temp.put("usr_grp_cd", it) }
        temp["seq_list"] = contSeqs
        temp["send_rst"] = 1

        return campaignReportDao.getSendHstDetail(temp)
    }

    override fun getDetOpenDet(seqs: Array<String>): List<Any> {
        val response: MutableList<Any> = ArrayList()
        val map = HashMap<String, Any>()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        map["usr_grp_cd"] = userInfo.usr_grp_cd!!
        map["list"] = seqs

        val open_times = campaignReportDao.openTimingResult(map)
        val open_result = HashMap<String, HashMap<String, Any?>>()
        val open_title_map = HashMap<String, MutableList<Any>>()
        val tot: MutableList<HashMap<String, Any?>> = ArrayList()
        var total = 0
        for (open_time in open_times) {

            if (open_time != null) {

                val tm = TreeMap(open_time)
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

                        result["OPEN_CNT"] = open_time[key]
                        val tempOpen = open_result.get(key)?.get("OPEN_CNT")
                        if (tempOpen != null && tempOpen.toString() != "0") {
                            result["OPEN_CNT"] =
                                open_time[key].toString().toInt() + open_result.get(key)?.get("OPEN_CNT").toString()
                                    .toInt()
                        }

                        // 오픈 데이터가 있는 캠페인명 리스트
                        if (!"0".equals(open_time[key].toString())) {
                            var open_title_lst = open_title_map.get(key)
                            if (open_title_lst == null) {
                                open_title_lst = ArrayList()
                            }
                            val titleMap = mutableMapOf<String, String>()
                            titleMap.put("camp_nm", open_time.get("CAMP_NM").toString())
                            titleMap.put("open_cnt", open_time[key].toString())
                            open_title_lst?.add(titleMap)
                            open_title_map.put(key, open_title_lst)
                        }
                        open_result.put(key, result)
                        total += open_time[key].toString().toInt()
                    }
                }
            }
        }
        val t = HashMap<String, Any?>()
        t["total"] = total
        tot.add(t)

        response.add(tot)
        response.add(TreeMap(open_result))
        response.add(open_title_map)

        return response
    }

    override fun getClickList(cont_id: Int): MutableList<HashMap<String, Any?>> {
        var mapLst = mutableListOf<HashMap<String, Any?>>()

        if (cont_id == null) {
            return mapLst
        }

        val searchCont = Tblmicp_cont_lstDto()
        searchCont.cont_cd = cont_id
        val contentDtoLst = campaignDao.sel_tblmicp_cont_lst(searchCont)

        for (contentDto in contentDtoLst) {

            var map = HashMap<String, Any?>()
            val dto = campaignReportDao.getContentsLst(contentDto.seq)
            dto.cardSize = '1'.toString();
            if (dto.cont_tp.equals("DMTP04")) {
                jsonOneContentsParsing(dto)
            }
            map["dto"] = dto
            map["url"] = campaignReportDao.getLinkClickCnt(contentDto.seq)
            mapLst.add(map)

        }
        return mapLst
    }

    private fun jsonOneContentsParsing(dto: Content_view_Dto) {
        // 수정 페이지 json 파싱하기

        val jsonParser = JsonParser()
        val rcsMsgTp = dto.msg_tp

        if (rcsMsgTp.equals("DMCH207") || rcsMsgTp.equals("DMCH208") || rcsMsgTp.equals("DMCH209") || rcsMsgTp.equals("DMCH210")) {
            // 가로, 세로형 이라면 cont_body Json 형태 파싱
            if (dto.cont_body != null) {
                val jsonObject = jsonParser.parse(dto.cont_body).asJsonObject
                dto.cont_body = jsonObject.get("description").toString()
                    .replace("\\\\r\\\\n", "<br/>")
                    .replace("\\r\\n", "<br/>")
                    .replace("\"", "")
            }
        }
        if (rcsMsgTp.equals("DMCH211") || rcsMsgTp.equals("DMCH212")) {

            val slideJsonObject = jsonParser.parse(dto.cont_body).asJsonObject
            val len = slideJsonObject.size() / 2  // title과 description이 하나의 쌍이 되기에 나눠준다
            dto.cardSize = len.toString()

            var idx = 0
            for (i in 0 until len) {
                idx++

                val title = "title" + idx
                val description = "description" + idx

                dto.slideTitle.add(slideJsonObject.get(title).toString()
                    .replace("\\\\r\\\\n", "<br/>")
                    .replace("\\r\\n", "<br/>")
                    .replace("\"", ""))

                dto.slideBody.add(slideJsonObject.get(description).toString()
                    .replace("\\\\r\\\\n", "<br/>")
                    .replace("\\r\\n", "<br/>")
                    .replace("\"", ""))

            }
        }
    }


    override fun getCampMstContIdByProId(proId: String): MutableList<String>? {

        return campaignReportDao.getCampMstContIdByProId(proId)
    }

    fun campListToTotal(programDtoList: List<kotlin.collections.Map<String, Any>>): MutableList<Any> {

        var programLst = mutableListOf<Any>()
        var tempProgram = mutableListOf<Any>()
        var ch_total = ""
        var t_total = 0
        var s_total = 0
        var o_total = 0
        var cli_total = 0
        var rowCnt = 1
        var pro_id = ""
        var ch_nm = ""
        val listSize = programDtoList.size

        for ((i, program) in programDtoList.withIndex()) {
            rowCnt++
            t_total += program.get("total_cnt").toString().toInt()
            s_total += program.get("suc_cnt").toString().toInt()
            o_total += program.get("open_cnt").toString().toInt()
            cli_total += program.get("click_cnt").toString().toInt()
            pro_id = program.get("pro_id") as String

            ch_nm = program.get("camp_ch").toString()
            if ("CH01".equals(ch_nm)) {
                ch_nm = "이메일"
            } else if ("CH02".equals(ch_nm)) {
                ch_nm = "문자"
            } else {
                ch_nm = "세일즈포스"
            }

            if (ch_total.indexOf(ch_nm) == -1) {
                if (!"".equals(ch_total)) {
                    ch_total += "/"
                }
                ch_total += ch_nm   //  CH00  => 이메일/문자
            }
            tempProgram.add(program)

            if (i < listSize-1) {
                if (pro_id.contentEquals(programDtoList[i+1].get("pro_id").toString())) {
                    continue
                }
            }

            val tempTotal = HashMap<String, Any>()
            tempTotal["ch_total"] = ch_total
            tempTotal["t_cnt"] = t_total
            tempTotal["s_cnt"] = s_total
            tempTotal["o_cnt"] = o_total
            tempTotal["c_cnt"] = cli_total
            tempTotal["rowCnt"] = rowCnt
            tempTotal["pro_id"] = pro_id

            tempTotal["pro_nm"] = program.get("pro_nm").toString()
            tempTotal["pro_st_nm"] = program.get("pro_st_nm").toString()
            tempTotal["start_dt"] = program.get("start_dt").toString()

            var tempRowMap = HashMap<String, Any>()
            tempRowMap["total"] = tempTotal
            tempRowMap["program"] =  tempProgram
            programLst.add(tempRowMap)

            ch_total = ""
            t_total = 0;
            s_total = 0;
            o_total = 0;
            cli_total = 0;
            rowCnt = 1;

            tempProgram = mutableListOf<Any>()
        }
        return programLst
    }

    override fun getCampMstList(pdto: Tblmicp_programDto): kotlin.collections.MutableMap<String, Any> {

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
}
