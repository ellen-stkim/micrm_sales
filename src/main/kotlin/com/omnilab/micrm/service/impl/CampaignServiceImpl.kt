package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CampaignDao
import com.omnilab.micrm.repository.CampaignSendDao
import com.omnilab.micrm.repository.CommonDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.CommonService
import com.omnilab.micrm.task.ThreadPool
import io.minio.MinioClient
import io.minio.UploadObjectArgs
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.util.LinkedMultiValueMap
import java.math.BigDecimal
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap
import kotlin.collections.HashSet

@Service("CampaignServiceImpl")
class CampaignServiceImpl : CampaignService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${variable.minio-url}")
    private lateinit var minio_url: String

    @Value("\${variable.minio-username}")
    private lateinit var minio_username: String

    @Value("\${variable.minio-password}")
    private lateinit var minio_password: String

    @Value("\${variable.minio-bucket}")
    private lateinit var minio_bucket: String

    @Value("\${variable.static-path}")
    private lateinit var static_path: String

    @Autowired
    @Qualifier("ThreadPoolImpl")
    private lateinit var pool: ThreadPool

    @Autowired
    @Qualifier("CampaignDaoImpl")
    private lateinit var campaignDao: CampaignDao

    @Autowired
    @Qualifier("CampaignEdmDaoImpl")
    private lateinit var edmSend: CampaignSendDao

    @Autowired
    @Qualifier("CampaignMdmDaoImpl")
    private lateinit var mdmSend: CampaignSendDao

    @Autowired
    @Qualifier("CampaignKakaoDaoImpl")
    private lateinit var kkoSend: CampaignSendDao

    @Autowired
    @Qualifier("CampaignRcsDaoImpl")
    private lateinit var rcsSend: CampaignSendDao

    @Autowired
    @Qualifier("CommonDaoImpl")
    private lateinit var commonDao: CommonDao

    @Autowired
    private lateinit var sysSettingDao: SysSettingDao;

    @Autowired
    private lateinit var commonService: CommonService

    override fun getContentsLst(dto: Tblmi_cont_mstDto): MutableMap<String, Any> {
        val map = HashMap<String, Any>()
        val searchDto = dto as Contents_searchDto
        dto.use_yn = "Y"
        dto.del_yn = "N"

        val paginationInfo = UsefulUtils.makePage(searchDto.pageNo, 4, 4)
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = campaignDao.sel_ContentsListCnt(searchDto)
        map["page"] = paginationInfo

        val list = campaignDao.sel_ContentsList(dto)

        if (searchDto.ch_tp == "CH01") {
            for (i in list) {
                i.cont_body = i.cont_body?.replace("&lt;", "<")
                        ?.replace("&gt;", ">")
                        ?.replace("&amp;nbsp;", " ")
                        ?.replace("&quot;", "\"")
            }
        }
        map["list"] = list
        return map
    }

    override fun getContentPreview(dto: Tblmi_cont_mstDto): Tblmi_cont_lstDto {
        val contentLst = campaignDao.sel_ContentsList(dto)
        return if (contentLst.isNullOrEmpty()) {
            Tblmi_cont_lstDto()
        } else {
            contentLst[0]
        }
    }

    override fun getCampContentPreview(dto: Tblmi_cont_mstDto): Tblmi_cont_lstDto {
        val contentLst = campaignDao.sel_camp_ContentsList(dto)
        return if (contentLst.isNullOrEmpty()) {
            Tblmi_cont_lstDto()
        } else {
            contentLst[0]
        }
    }

    override fun getApprLst(dto: SendAuthLstDto): MutableList<Tblmi_usrDto> {
        return campaignDao.sel_apprLst(dto)
    }

    override fun getProgramInfo(pro_id: String, usr_grp_cd: String, check: Boolean): MutableMap<String, Any> {
        val map = HashMap<String, Any>()
        val searchDto = Tblmicp_programDto(pro_id)
        searchDto.usr_grp_cd = usr_grp_cd

        val programDto = campaignDao.sel_tblmicp_programOne(searchDto)
        map["programDto"] = programDto

        if (check && programDto.pro_st != "98") {
            map["status"] = false
        } else {
            map["status"] = true
            if (programDto.pro_tg_tp == "TG02") {
                map["targetDto"] = campaignDao.sel_tblmi_traget_grp(Tblmi_target_grpDto(programDto.pro_tg_id?.toInt(), usr_grp_cd, null))
            }

            val campLSt = campaignDao.sel_tblmicp_campaign(Tblmicp_campaignDto(pro_id))
            map["campaignLst"] = campLSt

            val contMap = HashMap<String, Any>()
            for (camp in campLSt) {
                val tempDt = campaignDao.sel_camp_cont_mst(Tblmicp_cont_mstDto(camp.cont_id!!, usr_grp_cd, null))
                val tempTblDto = campaignDao.sel_ContentsList(Contents_searchDto(tempDt.cont_seq))
                if (!tempTblDto.isNullOrEmpty()) {
                    contMap[camp.cont_id.toString()] = tempTblDto[0]
                }
            }
            map["contDto"] = contMap

            if (programDto.pro_st == "03") {
                map["sendCnt"] = campaignDao.sel_send_status_cnt(pro_id)
            }
            if (programDto.pro_st == "04") {
                map["sendCnt"] = campaignDao.sel_send_status_cnt(pro_id)
                map["openCnt"] = campaignDao.sel_tarck_open_cnt(pro_id)
                map["trackCnt"] = campaignDao.sel_tarck_url_cnt(pro_id)
            }
        }
        return map
    }

    override fun editProgramSt(pro_id: String, usr_grp_cd: String): Boolean {
        val searchDto = Tblmicp_programDto(pro_id)
        searchDto.usr_grp_cd = usr_grp_cd
        val programDto = campaignDao.sel_tblmicp_programOne(searchDto)
        return if (programDto.pro_st != "00") {
            false;
        } else {
            try {
                val dto = Tblmicp_programDto(pro_id, "98")
                dto.reg_id = UsefulUtils.sessionUser().usr_id
                dto.upd_id = UsefulUtils.sessionUser().usr_id
                campaignDao.upd_tblmicp_program(dto)

                val usrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(programDto.appr_id))
                val alSubject = "[MICRM] '${programDto.pro_nm}' 캠페인 승인 요청 취소"
                val alMsg = StringBuilder()
                alMsg.append("${UsefulUtils.sessionUser().usr_nm} 님이 '${programDto.pro_nm}' 캠페인 발송 승인 요청을 취소 하셨습니다.")
                commonService.sendMail(usrDto.usr_email!!, if (usrDto.usr_nm.isNullOrEmpty()) "" else usrDto.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                true
            } catch (e: Exception) {
                logger.error("editProgramSt", e)
                false
            }
        }
    }

    override fun apprProgramSt(pro_id: String, usr_id: String, usr_grp_cd: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val searchDto = Tblmicp_programDto(pro_id)
        searchDto.usr_grp_cd = usr_grp_cd
        val programDto = campaignDao.sel_tblmicp_programOne(searchDto)

        return try {
            when {
                programDto.pro_st != "00" -> {
                    re_map["status"] = false
                    re_map["message"] = "승인 가능한 캠페인이 아닙니다."
                    re_map
                }
                programDto.appr_id != usr_id -> {
                    re_map["status"] = false
                    re_map["message"] = "캠페인 승인 담당자가 일치 하지 않습니다."
                    re_map
                }
                else -> {
                    pool.sendHstProgram(programDto, false)
                    re_map["status"] = true
                    re_map
                }
            }
        } catch (e: Exception) {
            logger.error("apprProgramSt", e)
            re_map["status"] = false
            re_map["message"] = "시스템 오류가 발생 했습니다.<br/>관리자에게 문의 바랍니다."
            re_map
        }
    }

    override fun cancelProgramSt(pro_id: String, usr_id: String, usr_grp_cd: String, gbn: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val searchDto = Tblmicp_programDto(pro_id)
        searchDto.usr_grp_cd = usr_grp_cd
        val programDto = campaignDao.sel_tblmicp_programOne(searchDto)
        val campLSt = campaignDao.sel_tblmicp_campaign(Tblmicp_campaignDto(pro_id))
        return try {
            when (programDto.pro_st) {
                "01", "02", "03" -> {
                    //우선은 하나만
                    val campDto = campLSt[0]
                    val contLst = campaignDao.sel_tblmicp_cont_lst(Tblmicp_cont_lstDto(campDto.cont_id, campDto.reg_id, usr_grp_cd))
                    val contTpLst = HashMap<String, Contents_lstDto>()
                    for (check in contLst) {
                        contTpLst[check.cont_tp!!] = check
                    }
                    if (CommonUtils.compareDate(CommonUtils.getDateTimeNow(), campDto.start_dt)) {
                        if (campDto.camp_ch == "CH01") { //이메일
                            val map = HashMap<String, Any>()
                            map["program_id"] = pro_id
                            map["camp_id"] = campDto.seq.toString()
                            map["usr_grp_cd"] = usr_grp_cd
                            edmSend.del_send(map)
                        } else {  //문자
                            if (contTpLst["DMTP04"] != null) {
                                val map = HashMap<String, Any>()
                                map["camp_id"] = campDto.seq.toString()
                                map["usr_grp_cd"] = usr_grp_cd
                                rcsSend.del_send(map)
                            } else if (contTpLst["DMTP03"] != null) {
                                val map = HashMap<String, Any>()
                                map["camp_id"] = campDto.seq.toString()
                                map["usr_grp_cd"] = usr_grp_cd
                                kkoSend.del_send(map)
                            } else {
                                val map = HashMap<String, Any>()
                                map["camp_id"] = campDto.seq.toString()
                                map["usr_grp_cd"] = usr_grp_cd
                                map["msgTp"] = contTpLst["DMTP02"]!!.msg_tp.toString()
                                mdmSend.del_send(map)
                            }
                        }
                        campaignDao.del_err_tblmicp_send_hst(campDto.pro_id.toString())
                        val updDto = Tblmicp_programDto(pro_id, "98")
                        updDto.upd_id = usr_id
                        campaignDao.upd_tblmicp_program(updDto)

                        val alSubject = "[MICRM] '${programDto.pro_nm}' 캠페인 발송이 취소 되었습니다."
                        val alMsg = StringBuilder()
                        alMsg.append("${UsefulUtils.sessionUser().usr_nm} 님이 '${programDto.pro_nm}' 캠페인 발송을 취소 하였습니다.")
                        alMsg.append("<br>")
                        alMsg.append("캠페인 발송 페이지 바로가기 : ${GlobalValues.rootUrl}/camp/sendSetting.mi?pid=${programDto.pro_id}")

                        if (gbn == "0") {
                            val apprUser: Tblmi_usrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(programDto.appr_id))
                            commonService.sendMail(apprUser.usr_email!!, if (apprUser.usr_nm.isNullOrEmpty()) "" else apprUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                        } else {
                            val regUser: Tblmi_usrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(programDto.reg_id))
                            commonService.sendMail(regUser.usr_email!!, if (regUser.usr_nm.isNullOrEmpty()) "" else regUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                        }

                        re_map["status"] = true
                        re_map
                    } else {
                        logger.error("{}, {}", CommonUtils.getDateTimeNow(), campDto.start_dt)
                        re_map["status"] = false
                        re_map["message"] = "발송이 진행중인 캠페인은 승인 취소가 불가능 합니다."
                        re_map
                    }
                }
                else -> {
                    re_map["status"] = false
                    re_map["message"] = "승인 취소가 가능한 캠페인이 아닙니다."
                    re_map
                }
            }
        } catch (e: Exception) {
            logger.error("cancelProgramSt", e)
            re_map["status"] = false
            re_map["message"] = "시스템 오류가 발생 했습니다.<br/>관리자에게 문의 바랍니다."
            re_map
        }
    }

    override fun delProgram(pro_id: String, usr_id: String, usr_grp_cd: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        return try {
            val programDto = campaignDao.sel_tblmicp_programOne(Tblmicp_programDto(pro_id))

            if(programDto.pro_st == "98"){
                campaignDao.del_campaign(Tblmicp_campaignDto(pro_id))
                campaignDao.del_err_tblmicp_send_hst(pro_id)
            /*
                if(contMstId != null){
                    campaignDao.del_camp_content(contMstId)
                }
             */
                campaignDao.del_program(programDto)
                re_map["status"] = true
                re_map
            }else{
                re_map["status"] = false
                re_map["message"] = "캠페인이 삭제 가능한 상태가 아닙니다."
                re_map
            }
        } catch (e: Exception) {
            logger.error("delProgram", e)
            re_map["status"] = false
            re_map["message"] = "시스템 오류가 발생 했습니다.<br/>관리자에게 문의 바랍니다."
            re_map
        }
    }

    override fun getProgramSendResult(pro_id: String, type: String?, usr_grp_cd: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val proDto = Tblmicp_programDto(pro_id)
        proDto.usr_grp_cd = usr_grp_cd
        val cntMap = campaignDao.sel_send_program_cnt(proDto)
        re_map["cnt"] = cntMap
        val lstDto = SendResult_lstDto(pro_id, usr_grp_cd)
        lstDto.send_rst = type

        val paginationInfo = UsefulUtils.makePage(1, 10, 4)
        paginationInfo.totalRecordCount = cntMap["cnt"].toString().toInt()

        lstDto.firstIndex = paginationInfo.firstRecordIndex
        lstDto.recordCountPerPage = paginationInfo.recordCountPerPage
        re_map["list"] = campaignDao.sel_send_program_rstLst(lstDto)
        return re_map
    }

    override fun getProgramSendResultExcel(pro_id: String, type: String?, usr_grp_cd: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val labelList = mutableListOf<String>();
        labelList.add("캠페인명")
        labelList.add("발송상세")
        labelList.add("이메일/모바일")
        labelList.add("원인")
        labelList.add("발송시간")
        labelList.add("발송기준정보")

        val book = commonService.createExcel(labelList)
        labelList.clear()

        val proDto = Tblmicp_programDto(pro_id)
        proDto.usr_grp_cd = usr_grp_cd
        val pro = campaignDao.sel_tblmicp_programOne(proDto)
        re_map["name"] = "${pro.pro_nm}"
        re_map["book"] = book

        val lstDto = SendResult_lstDto(pro_id, usr_grp_cd)
        lstDto.send_rst = type

        campaignDao.sel_send_program_rstLstExcel(book, lstDto)
        return re_map
    }

    override fun sendTempProgram(dto: Tblmicp_programDto): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        var programId: String? = if (dto.pro_id.isNullOrEmpty()) null else dto.pro_id
        var campId: String? = null

        return try {
            val dd = dto as SendCampaignDto

            val campLst = dd.camp_id
            val contLst = dd.cont_id
            val stoLst = dd.sto
            val sendTpLst = dd.send_tp
            val sendDtLst = dd.send_dt
            val sendTimeLst = dd.send_time

            val size = if (contLst.isNullOrEmpty()) 0 else contLst.size
            if (programId == null) {
                programId = "PRO${CommonUtils.getDateTimeNowYYYMMDDSSS()}${dd.usr_grp_cd}"
            }
            dd.pro_id = programId
            dd.cont_cnt = if (contLst == null) 0 else contLst.size
            dd.camp_cnt = if (contLst == null) 0 else contLst.size
            dd.pro_st = "98"
            dd.pro_tg_tp = if (dd.pro_tg_tp.isNullOrEmpty()) null else dd.pro_tg_tp
            dd.pro_tg_id = if (dd.pro_tg_id.isNullOrEmpty()) null else dd.pro_tg_id
            dd.grp_cnt = if (dd.grp_cnt == null) 0 else dd.grp_cnt
            dd.plan_cost = if (dd.plan_cost == null) BigDecimal(0) else dd.plan_cost
            dd.off_cost = if (dd.off_cost == null) BigDecimal(0) else dd.off_cost
            dd.dev_cost = if (dd.dev_cost == null) BigDecimal(0) else dd.dev_cost
            dd.des_cost = if (dd.des_cost == null) BigDecimal(0) else dd.des_cost
            campaignDao.ins_program(dto)
            if (size != 0) {
                for (i in contLst!!.indices) {
                    val cont_id = contLst[i]
                    var contMstDto = Tblmicp_cont_mstDto(cont_id.toInt(), dto.usr_grp_cd, dto.reg_id)
                    campaignDao.ins_campaign_cont_mst(contMstDto)
                    contMstDto = campaignDao.sel_camp_cont_mst(contMstDto)

                    val inscontLst = campaignDao.sel_cont_lst(Tblmicp_cont_lstDto(cont_id.toInt(), dto.reg_id, dto.usr_grp_cd, "Y"))

                    for (cont_lst in inscontLst) {
                        val temp = cont_lst
                        val urlLst = campaignDao.sel_cont_url_lst(Tblmi_cont_url_lstDto(temp.seq))
                        val urlInsLst = ArrayList<Tblmicp_cont_url_lstDto>()

                        temp.cont_cd = contMstDto.seq
                        val insLstDto = Tblmicp_cont_lstDto(temp)
                        campaignDao.ins_campaign_cont_lst(insLstDto)

                        for (urlDto in urlLst) {
                            urlDto.cont_lst_cd = insLstDto.seq
                            urlInsLst.add(Tblmicp_cont_url_lstDto(urlDto))
                        }

                        if (urlInsLst.isNotEmpty()) {
                            campaignDao.ins_campaign_cont_url_lst(urlInsLst)
                        }
                    }

                    val campaignDto = Tblmicp_campaignDto(dto.pro_id)
                    if (campLst != null && campLst.size > i) {
                        campaignDto.seq = campLst[i].toInt()
                    }
                    campaignDto.cont_id = contMstDto.seq
                    campaignDto.send_tg_tp = dto.pro_tg_tp
                    campaignDto.send_tg_id = dto.pro_tg_id
                    if (campaignDto.send_tg_tp == "TG02") {
                        campaignDto.tar_cnt = campaignDao.sel_tblmi_traget_grp(Tblmi_target_grpDto(campaignDto.send_tg_id?.toInt(), dto.usr_grp_cd, null)).grp_cnt
                    }
                    campaignDto.camp_st = "00"
                    campaignDto.camp_nm = dto.pro_nm
                    campaignDto.camp_ch = contMstDto.ch_tp
                    campaignDto.usr_grp_cd = dto.usr_grp_cd
                    campaignDto.reg_id = dto.reg_id
                    campaignDto.sto = stoLst?.get(i)
                    if (sendTpLst != null) {
                        if (sendTpLst.getOrNull(i) == "0") {
                            if (sendDtLst?.getOrNull(i) != null && sendTimeLst?.getOrNull(i) != null) {
                                campaignDto.start_dt = CommonUtils.stringDatetimeParse("${sendDtLst[i]} ${sendTimeLst[i]}:00")
                            } else if (sendDtLst?.getOrNull(i) != null) {
                                campaignDto.start_dt = CommonUtils.stringDateParse("${sendDtLst[i]}")
                            }
                        } else {
                            campaignDto.start_dt = null
                        }
                    }
                    campaignDao.ins_campaign(campaignDto)
                    campId = if (campaignDto.seq == null) null else campaignDto.seq.toString()
                }
            }
            re_map["status"] = true
            re_map["pro_id"] = programId
            if (!campId.isNullOrEmpty()) {
                re_map["camp_id"] = campId
            }
            re_map
        } catch (e: Exception) {
            logger.error("sendProgram", e)
            re_map["status"] = false
            re_map["message"] = "시스템 오류가 발생 하였습니다.\n관리자에게 문의 바랍니다."
            re_map
        }
    }

    override fun sendProgram(dto: Tblmicp_programDto): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val programId: String?
        var campId: String? = null
        var contMstId: Int? = null
        var total_cnt = 0

        return try {
            val dd = dto as SendCampaignDto

            val contLst = dd.cont_id
            val stoLst = dd.sto
            val sendTpLst = dd.send_tp
            val sendDtLst = dd.send_dt
            val sendTimeLst = dd.send_time
            var min_start_dt: String? = null
            var max_start_dt: String? = null

            val size = if (contLst.isNullOrEmpty()) 0 else contLst.size

            if (contLst.isNullOrEmpty() || stoLst.isNullOrEmpty() || sendDtLst.isNullOrEmpty() || sendTimeLst.isNullOrEmpty()) {
                re_map["status"] = false
                re_map["message"] = "캠페인 발송 리스트 데이터가 올바르지 않습니다."
            } else if (stoLst.size != size || sendDtLst.size != size || sendTimeLst.size != size) {
                re_map["status"] = false
                re_map["message"] = "캠페인 발송 리스트 데이터가 올바르지 않습니다."
            } else {
                if (dto.pro_id.isNullOrEmpty()) {
                    programId = "PRO${CommonUtils.getDateTimeNowYYYMMDDSSS()}${dd.usr_grp_cd}"
                    dd.pro_id = programId
                } else {
                    programId = dto.pro_id
                }
                dd.cont_cnt = contLst.size
                dd.camp_cnt = contLst.size
                dd.pro_st = "00"
                dd.grp_cnt = if (dd.grp_cnt == null) 0 else dd.grp_cnt
                dd.plan_cost = if (dd.plan_cost == null) BigDecimal(0) else dd.plan_cost
                dd.off_cost = if (dd.off_cost == null) BigDecimal(0) else dd.off_cost
                dd.dev_cost = if (dd.dev_cost == null) BigDecimal(0) else dd.dev_cost
                dd.des_cost = if (dd.des_cost == null) BigDecimal(0) else dd.des_cost
                campaignDao.ins_program(dto)
                campaignDao.del_campaign(Tblmicp_campaignDto(dto.pro_id))

                for (i in contLst.indices) {
                    val cont_id = contLst[i]
                    var contMstDto = Tblmicp_cont_mstDto(cont_id.toInt(), dto.usr_grp_cd, dto.reg_id)
                    campaignDao.ins_campaign_cont_mst(contMstDto)
                    contMstDto = campaignDao.sel_camp_cont_mst(contMstDto)
                    contMstId = contMstDto.seq

                    val inscontLst = campaignDao.sel_cont_lst(Tblmicp_cont_lstDto(cont_id.toInt(), dto.reg_id, dto.usr_grp_cd, "Y"))

                    for (cont_lst in inscontLst) {
                        val temp = cont_lst
                        val urlLst = campaignDao.sel_cont_url_lst(Tblmi_cont_url_lstDto(temp.seq))
                        val urlInsLst = ArrayList<Tblmicp_cont_url_lstDto>()

                        temp.cont_cd = contMstDto.seq
                        val insLstDto = Tblmicp_cont_lstDto(temp)
                        campaignDao.ins_campaign_cont_lst(insLstDto)

                        for (urlDto in urlLst) {
                            urlDto.cont_lst_cd = insLstDto.seq
                            urlInsLst.add(Tblmicp_cont_url_lstDto(urlDto))
                        }

                        if (urlInsLst.isNotEmpty()) {
                            campaignDao.ins_campaign_cont_url_lst(urlInsLst)
                        }
                    }

                    val campaignDto = Tblmicp_campaignDto(dto.pro_id)
                    campaignDto.cont_id = contMstDto.seq
                    campaignDto.send_tg_tp = dto.pro_tg_tp
                    campaignDto.send_tg_id = dto.pro_tg_id
                    if (campaignDto.send_tg_tp == "TG02") {
                        campaignDto.tar_cnt = campaignDao.sel_tblmi_traget_grp(Tblmi_target_grpDto(campaignDto.send_tg_id?.toInt(), dto.usr_grp_cd, null)).grp_cnt
                    }
                    campaignDto.camp_st = "00"
                    campaignDto.camp_nm = dto.pro_nm
                    campaignDto.camp_ch = contMstDto.ch_tp
                    campaignDto.usr_grp_cd = dto.usr_grp_cd
                    campaignDto.reg_id = dto.reg_id
                    campaignDto.sto = stoLst[i]
                    if (sendTpLst!![i] == "0") {
                        campaignDto.send_st_tp = "0"
                        campaignDto.start_dt = CommonUtils.stringDatetimeParse("${sendDtLst[i]} ${sendTimeLst[i]}:00")
                    } else {
                        campaignDto.send_st_tp = "1"
                        campaignDto.start_dt = CommonUtils.getDateTimeNow()
                    }
                    campaignDao.ins_campaign(campaignDto)
                    campId = if (campaignDto.seq != null) null else campaignDto.seq.toString()
                    total_cnt += if (campaignDto.tar_cnt == null) 0 else campaignDto.tar_cnt!!

                    if (min_start_dt.isNullOrEmpty()) {
                        min_start_dt = campaignDto.start_dt
                        max_start_dt = campaignDto.start_dt
                    } else {
                        if (!CommonUtils.compareDate(min_start_dt, campaignDto.start_dt)) {
                            min_start_dt = campaignDto.start_dt
                        }
                        if (CommonUtils.compareDate(max_start_dt, campaignDto.start_dt)) {
                            max_start_dt = campaignDto.start_dt
                        }
                    }
                }

                val usrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(dd.appr_id))
                val alSubject = "[MICRM] '${dd.pro_nm}' 캠페인 발송 승인 요청"
                val alMsg = StringBuilder()
                alMsg.append("${UsefulUtils.sessionUser().usr_nm} 님이 '${dd.pro_nm}' 캠페인 발송 승인 요청 하셨습니다.")
                alMsg.append("<br/>")
                alMsg.append("상세 보기 : ${GlobalValues.rootUrl}/camp/st/sendDetail.mi?pid=$programId")
                alMsg.append("<br/>")
                alMsg.append("캠페인 명 : ${dd.pro_nm}")
                alMsg.append("<br/>")
                alMsg.append("캠페인 타겟 : ${dd.pro_nm} (${total_cnt} 명)")
                alMsg.append("<br/>")
                alMsg.append("컨트롤 그룹 : ${dd.grp_cnt} %")
                alMsg.append("<br/>")
                commonService.sendMail(usrDto.usr_email!!, if (usrDto.usr_nm.isNullOrEmpty()) "" else usrDto.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())

                campaignDao.upd_tblmicp_program(Tblmicp_programDto(programId, total_cnt, "00", dto.reg_id, min_start_dt, max_start_dt))
                re_map["status"] = true
                re_map["message"] = "캠페인 발송 승인 요청 처리 되었습니다."
                re_map["pro_id"] = programId!!
                if (campId != null) {
                    re_map["camp_id"] = campId
                }
            }
            re_map
        } catch (e: Exception) {
            logger.error("sendProgram", e)
            /*
            if(!dto.pro_id.isNullOrEmpty()){
                campaignDao.del_campaign(Tblmicp_campaignDto(dto.pro_id!!))
                campaignDao.del_program(dto)
                if(contMstId != null){
                    campaignDao.del_camp_content(contMstId)
                }
            }
             */
            re_map["status"] = false
            re_map["message"] = "시스템 오류가 발생 하였습니다.\n관리자에게 문의 바랍니다."
            re_map
        }
    }

    override fun sendProgramTargetLst(dto: Tblmicp_programDto): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val programId: String?
        var contMstId: Int?
        var campDto: Tblmicp_campaignDto? = null
        return try {
            val dd = dto as SendTarget_lstDto
            val edmTarget = HashSet<SendTarget_Dto>()
            val mdmTarget = HashSet<SendTarget_Dto>()

            val usrNmLst = dd.usr_nm
            val usrEdmLst = dd.usr_edm
            val usrMobLst = dd.usr_mob
            val contLst = dd.cont_id

            val checkDto = Tblmicp_programDto()
            checkDto.pro_nm = dto.pro_nm

            // 리턴패스 정보
            val returnPath = sysSettingDao.getCommCD(Tblmi_comm_cdDto("RETURN_PATH", dto.usr_grp_cd!!))!!.cd_val


            if (!campaignDao.sel_tblmicp_program(checkDto).isNullOrEmpty()) {
                re_map["status"] = false
                re_map["message"] = "캠페인명이 중복 됩니다."
            } else if (usrNmLst.isNullOrEmpty() || usrEdmLst.isNullOrEmpty() || usrMobLst.isNullOrEmpty()) {
                re_map["status"] = false
                re_map["message"] = "발송 리스트 데이터가 올바르지 않습니다."
            } else if ((dd.usr_nm?.size != dd.usr_edm?.size) || (dd.usr_nm?.size != dd.usr_mob?.size) || (dd.usr_edm?.size != dd.usr_mob?.size)) {
                re_map["status"] = false
                re_map["message"] = "발송 리스트 데이터가 올바르지 않습니다."
            } else if (contLst.isNullOrEmpty()) {
                re_map["status"] = false
                re_map["message"] = "발송 컨텐츠 데이터가 올바르지 않습니다."
            } else {
                for (i in usrNmLst.indices) {
                    edmTarget.add(SendTarget_Dto(usrNmLst[i], usrEdmLst[i]))
                    mdmTarget.add(SendTarget_Dto(usrNmLst[i], usrMobLst[i]))
                }
                programId = "PRO${CommonUtils.getDateTimeNowYYYMMDDSSS()}${dd.usr_grp_cd}"
                dd.pro_id = programId
                dd.cont_cnt = contLst.size
                dd.camp_cnt = contLst.size
                dd.pro_st = "00"
                dd.grp_cnt = if (dd.grp_cnt == null) 0 else dd.grp_cnt
                dd.plan_cost = if (dd.plan_cost == null) BigDecimal(0) else dd.plan_cost
                dd.off_cost = if (dd.off_cost == null) BigDecimal(0) else dd.off_cost
                dd.dev_cost = if (dd.dev_cost == null) BigDecimal(0) else dd.dev_cost
                dd.des_cost = if (dd.des_cost == null) BigDecimal(0) else dd.des_cost
                campaignDao.ins_program(dto)

                for (i in contLst.indices) {
                    val cont_id = contLst[i]
                    var contMstDto = Tblmicp_cont_mstDto(cont_id.toInt(), dto.usr_grp_cd, dto.reg_id)
                    campaignDao.ins_campaign_cont_mst(contMstDto)
                    contMstDto = campaignDao.sel_camp_cont_mst(contMstDto)
                    contMstId = contMstDto.seq

                    val inscontLst = campaignDao.sel_cont_lst(Tblmicp_cont_lstDto(cont_id.toInt(), dto.reg_id, dto.usr_grp_cd, "Y"))

                    for (cont_lst in inscontLst) {
                        val temp = cont_lst
                        val urlLst = campaignDao.sel_cont_url_lst(Tblmi_cont_url_lstDto(temp.seq))
                        val urlInsLst = ArrayList<Tblmicp_cont_url_lstDto>()

                        temp.cont_cd = contMstDto.seq
                        val insLstDto = Tblmicp_cont_lstDto(temp)
                        campaignDao.ins_campaign_cont_lst(insLstDto)

                        for (urlDto in urlLst) {
                            urlDto.cont_lst_cd = insLstDto.seq
                            urlInsLst.add(Tblmicp_cont_url_lstDto(urlDto))
                        }

                        if (urlInsLst.isNotEmpty()) {
                            campaignDao.ins_campaign_cont_url_lst(urlInsLst)
                        }
                    }

                    val campaignDto = Tblmicp_campaignDto(dto.pro_id)
                    campaignDto.cont_id = contMstDto.seq
                    campaignDto.send_tg_tp = dto.pro_tg_tp
                    campaignDto.send_tg_id = "tblmite_target_lst"
                    campaignDto.camp_st = "00"
                    campaignDto.camp_nm = dto.pro_nm
                    campaignDto.camp_ch = contMstDto.ch_tp
                    campaignDto.sto = "01"
                    campaignDto.usr_grp_cd = dto.usr_grp_cd
                    campaignDto.reg_id = dto.reg_id
                    campaignDto.start_dt = CommonUtils.getDateTimeNow()
                    campaignDto.send_st_tp = "1"
                    campaignDao.ins_campaign(campaignDto)
                    campDto = campaignDto

                    val tblSendHstLst = HashSet<Tblmicp_send_hstDto>()
                    for (j in usrNmLst.indices) {
                        if ("CH01" == campaignDto.camp_ch) {
                            val campSendLst = Tblmicp_send_hstDto(programId, campaignDto.seq, contMstId, "tblmite_target_lst", "DIRECT${dto.usr_grp_cd}${campaignDto.seq}${CommonUtils.getDateTimeNowYYYMMDDSSS()}$j", campaignDto.camp_ch, usrEdmLst[j].trim(), usrNmLst[j].trim(), "noreply${campaignDto.seq}${dto.usr_grp_cd}${AES256.AES_Encode(usrEdmLst[j].trim(), GlobalValues.encKey)}@${returnPath}", dto.usr_grp_cd, dto.reg_id)
                            tblSendHstLst.add(campSendLst)
                        } else {
                            val campSendLst = Tblmicp_send_hstDto(programId, campaignDto.seq, contMstId, "tblmite_target_lst", "DIRECT${dto.usr_grp_cd}${campaignDto.seq}${CommonUtils.getDateTimeNowYYYMMDDSSS()}$j", campaignDto.camp_ch, usrMobLst[j].trim(), usrNmLst[j].trim(), null, dto.usr_grp_cd, dto.reg_id)
                            tblSendHstLst.add(campSendLst)
                        }
                    }
                    campaignDao.ins_campaign_send_hst(ArrayList(tblSendHstLst))
                }
                val totalCnt = campaignDao.sel_camp_send_hst_cnt(Tblmicp_send_hstDto(programId))
                campDto!!.upd_id = dto.reg_id
                campDto.tar_cnt = totalCnt
                campaignDao.upd_tblmicp_campaign(campDto)
                campaignDao.upd_tblmicp_program(Tblmicp_programDto(programId, totalCnt, "01", dto.reg_id, campDto.start_dt, campDto.start_dt))
                programSend(programId, false)
                campaignDao.upd_tblmicp_program(Tblmicp_programDto(programId, totalCnt, "03", dto.reg_id))
                re_map["status"] = true
            }
            re_map
        } catch (e: Exception) {
            logger.error("sendProgramTargetLst", e)
            if (!dto.pro_id.isNullOrEmpty()) {
                campaignDao.upd_tblmicp_program(Tblmicp_programDto(dto.pro_id, "99"))
                /*
                campaignDao.del_campaign(Tblmicp_campaignDto(dto.pro_id!!))
                campaignDao.del_program(dto)
                campaignDao.del_err_tblmicp_send_hst(dto.pro_id!!)

                if(contMstId != null){
                    campaignDao.del_camp_content(contMstId)
                }
                 */
            }
            re_map["status"] = false
            re_map["message"] = "시스템 오류가 발생 하였습니다.<br/>관리자에게 문의 바랍니다."
            re_map
        }
    }

    override fun sendReject(pro_id: String, usr_id: String, usr_grp_cd: String, message: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val programDto = campaignDao.sel_tblmicp_programOne(Tblmicp_programDto(pro_id, "00", usr_grp_cd))
        return if (programDto.appr_id == usr_id) {
            programDto.pro_st = "98"
            programDto.upd_id = usr_id
            campaignDao.upd_tblmicp_program(programDto)

            val usrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(programDto.appr_id))
            val regUsrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(programDto.reg_id))

            val alSubject = "[MICRM] '${programDto.pro_nm}' 캠페인 승인이 반려 되었습니다."
            val alMsg = StringBuilder()
            alMsg.append("${usrDto.usr_nm} 님이 '${programDto.pro_nm}' 캠페인 승인을 반려 하였습니다.")
            alMsg.append("<br/>")
            alMsg.append("반려 사유 : $message")
            alMsg.append("<br/>")
            alMsg.append("캠페인 발송 페이지 바로가기 : ${GlobalValues.rootUrl}/camp/sendSetting.mi?pid=${programDto.pro_id}")
            commonService.sendMail(regUsrDto.usr_email!!, if (regUsrDto.usr_nm.isNullOrEmpty()) "" else regUsrDto.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
            0
            re_map["status"] = true
            re_map["message"] = "캠페인 승인이 반려 되었습니다."
            re_map
        } else {
            re_map["status"] = false
            re_map["message"] = "승인담당자 아닙니다"
            re_map
        }
    }

    override fun sendInquiry(map: MutableMap<String, Any>): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()

        val alSubject = "[MICRM] [${map["pro_id"]} 오류 문의] ${map["subject"]}"
        val alMsg = StringBuilder()
        alMsg.append("${map["usr_id"]}/${map["usr_nm"]} 님이 ${map["pro_id"]} 오류 문의 하였습니다.")
        alMsg.append("<br/>")
        alMsg.append(map["msg"])
        alMsg.append("<br/>")
        commonService.sendMail(GlobalValues.sendMstEdm, "관리자", map["usr_email"].toString(), alSubject, alMsg.toString())

        re_map["status"] = true
        re_map["message"] = "캠페인 발송실패 문의 메일이 전송 되었습니다."
        return re_map
    }

    override fun programSend(pro_id: String, auto_tp: Boolean) {
        //val programDto = campaignDao.sel_tblmicp_programOne(Tblmicp_programDto(pro_id, "01"))
        val campaignLst = campaignDao.sel_tblmicp_campaign(Tblmicp_campaignDto(pro_id))

        campaignDao.upd_tblmicp_program(Tblmicp_programDto(pro_id, "02"))

        for (campaignDto in campaignLst) {
            val contLst = campaignDao.sel_tblmicp_cont_lst(Tblmicp_cont_lstDto(campaignDto.cont_id, campaignDto.reg_id, campaignDto.usr_grp_cd))
            val contTpLst = HashMap<String, Contents_lstDto>()
            //val imgPath =  sysSettingDao.getCommCD(Tblmi_comm_cdDto("IMG_PATH", campaignDto.usr_grp_cd.toString())).cd_val
            val minioClient = MinioClient.builder().endpoint(minio_url).credentials(minio_username, minio_password).build()

            for (check in contLst) {
                contTpLst[check.cont_tp.toString()] = check
                if (!check.img_lst.isNullOrEmpty()) {
                    val url_list = check.img_lst!!.split(",")
                    val nm_list = check.img_nm_lst!!.split(",")

                    for (i in url_list.indices) {
                        minioClient.uploadObject(
                                UploadObjectArgs.builder()
                                        .bucket(minio_bucket)
                                        .`object`("${campaignDto.usr_grp_cd.toString()}/${nm_list[i]}")
                                        .filename(static_path + url_list[i])
                                        .build())
                    }
                }
                if (!check.kko_image_url.isNullOrEmpty()) {
                    minioClient.uploadObject(
                            UploadObjectArgs.builder()
                                    .bucket(minio_bucket)
                                    .`object`("${campaignDto.usr_grp_cd.toString()}/${check.kko_image_file_nm}")
                                    .filename(static_path + check.kko_image_url)
                                    .build())
                }
            }
            if (campaignDto.camp_ch == "CH01") { //이메일
                edmSend.ins_send(campaignDto, contTpLst)
                val map = HashMap<String, Any>()
                map["program_id"] = pro_id
                map["camp_id"] = campaignDto.seq.toString()
                map["usr_grp_cd"] = campaignDto.usr_grp_cd.toString()
                map["gubun"] = "99"
                edmSend.upd_send(map)
            } else {  //문자
                when {
                    contTpLst["DMTP04"] != null -> {
                        rcsSend.ins_send(campaignDto, contTpLst)
                        val map = HashMap<String, Any>()
                        map["camp_id"] = campaignDto.seq.toString()
                        map["usr_grp_cd"] = campaignDto.usr_grp_cd.toString()
                        map["gubun"] = "9"
                        rcsSend.upd_send(map)
                    }
                    contTpLst["DMTP03"] != null -> {
                        kkoSend.ins_send(campaignDto, contTpLst)
                        val map = HashMap<String, Any>()
                        map["camp_id"] = campaignDto.seq.toString()
                        map["usr_grp_cd"] = campaignDto.usr_grp_cd.toString()
                        map["gubun"] = "9"
                        kkoSend.upd_send(map)
                    }
                    else -> {
                        mdmSend.ins_send(campaignDto, contTpLst)
                        val map = HashMap<String, Any>()
                        map["camp_id"] = campaignDto.seq.toString()
                        map["usr_grp_cd"] = campaignDto.usr_grp_cd.toString()
                        map["msgTp"] = contTpLst["DMTP02"]!!.msg_tp.toString()
                        map["gubun"] = "9"
                        mdmSend.upd_send(map)
                    }
                }
            }
        }
    }

    override fun getProgramSearch(pdto: Tblmicp_programDto): Map<String, Any> {
        pdto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val dto = pdto as Program_SearchDto

        when (dto.searchType) {
            "pro_nm" -> dto.pro_nm = dto.searchValue
            "usr_nm" -> dto.usr_nm = dto.searchValue
            "target_nm" -> {
                if (dto.pro_tg_tp == "TG02" || dto.pro_tg_tp == "TG99") {
                    dto.target_nm = dto.searchValue
                }
            }
        }
        val paginationInfo = UsefulUtils.makePage(dto.pageNo, 10, 10)
        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = campaignDao.getProgramSearchCnt(dto)

        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = campaignDao.getProgramList(dto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount
        return paramMap
    }

    override fun getAllStatusCnt(pdto: Tblmicp_programDto): Map<String, Any> {
        var paramMap: MutableMap<String, Any> = HashMap()
        val dto = pdto as Program_SearchDto
        if (dto.searchType == "pro_nm") {
            dto.pro_nm = dto.searchValue
        } else if (dto.searchType == "usr_nm") {
            dto.usr_nm = dto.searchValue
        } else if (dto.searchType == "target_nm") {
            if (dto.pro_tg_tp == "TG02" || dto.pro_tg_tp == "TG99") {
                dto.target_nm = dto.searchValue
            }
        }
        var statusCntList: MutableList<Int> = ArrayList<Int>()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        paramMap = campaignDao.getProgramCnt(dto)
        return paramMap
    }

    override fun getTitleProgramCnt(): Map<String, Any> {
        val map: MutableMap<String, Any> = HashMap()
        val userInfo = UsefulUtils.sessionUser()

        val pdto = Tblmicp_programDto()
        pdto.usr_grp_cd = userInfo.usr_grp_cd
        pdto.reg_id = userInfo.usr_id

        val apprPdto = Tblmicp_programDto()
        apprPdto.usr_grp_cd = userInfo.usr_grp_cd
        apprPdto.appr_id = userInfo.usr_id

        val pdtoSendMap = campaignDao.getTitleProgramCnt(pdto)
        val apprMap = campaignDao.getTitleProgramCnt(apprPdto)

        /**
         * 등록자기준 (발송 예정 , 발송 중 )
         * 발송 예정 = 발송대기 + 타겟 추출
         * 발송중 = 발송중
         *
         * 승인자 기준 (승인 대기)
         */
        val waitCnt = pdtoSendMap["wait_cnt"].toString().toInt()    // 발송 대기
        val tarCnt = pdtoSendMap["tar_cnt"].toString().toInt()  // 타겟 추출
        val sendingCnt = pdtoSendMap["send_cnt"].toString().toInt() // 발송중
        val apprCnt = apprMap["send_cnt"].toString().toInt()    // 승인 요청

        val sendExpect = waitCnt + tarCnt

        map["sendExpect"] = sendExpect
        map["sending"] = sendingCnt
        map["apprCnt"] = apprCnt

        //logger.error("pdtoSendMap : " + pdtoSendMap)
        //logger.error("apprMap " + apprMap)

        return map;
    }

    //캠페인 가져오기
    override fun getCampList(cDto: Tblmicp_campaignDto) : Map<String, Any> {
        val map : MutableMap<String, Any> = HashMap()
        cDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        if(cDto.start_dt.isNullOrEmpty()){
            val year = Calendar.getInstance()[Calendar.YEAR]
            val mm = Calendar.getInstance()[Calendar.MONTH] +1
            cDto.start_dt = year.toString()+"-"+ if (mm < 10){ "0$mm"} else {mm.toString()} +"-"+ "01"
            val nextmm = Calendar.getInstance()[Calendar.MONTH] + 2
            cDto.end_dt = year.toString()+"-"+ if (nextmm < 10) {"0$nextmm"} else {nextmm.toString()} +"-"+ "01"
        }else{
            val formY = SimpleDateFormat("yyyy-MM-dd")
            val cal = Calendar.getInstance()
            cal.time = formY.parse(cDto.start_dt)
            var year = cal.get(Calendar.YEAR)
            val mm = cal.get(Calendar.MONTH)+1
            cDto.start_dt = year.toString()+"-"+ if (mm < 10){ "0$mm"} else {mm.toString()} +"-"+ "01"
            var nextmm =cal.get(Calendar.MONTH)+2
            if(nextmm >= 13){
                year += 1
                nextmm = 1
            }
            cDto.end_dt = year.toString()+"-"+ if (nextmm < 10) {"0$nextmm"} else {nextmm.toString()} +"-"+ "01"

        }
        val resultList = campaignDao.sel_tblmicp_campaign(cDto)
        for(j in resultList){
            j.camp_nm = CommonUtils.EscapeTextToHtml(j.camp_nm)
        }
        map["list"] = campaignDao.sel_tblmicp_campaign(cDto)

        return map
    }

    //메인 페이지 camp 미리보기 가져오기
    override fun getMainCampView(dto: Tblmicp_campaignDto) :Map<String, Any> {
        val map : MutableMap<String, Any> = HashMap()
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        val searchDto = Tblmicp_programDto(dto.pro_id)
        searchDto.usr_grp_cd = usr_grp_cd

        /*
        val programDto = campaignDao.sel_tblmicp_programOne(searchDto)
        map["programDto"] = programDto
        if(programDto.pro_tg_tp == "TG02"){
            map["targetDto"] = campaignDao.sel_tblmi_traget_grp(Tblmi_target_grpDto(programDto.pro_tg_id?.toInt(), usr_grp_cd, null))
        }*/

        val contMstDto = campaignDao.sel_camp_cont_mst(Tblmicp_cont_mstDto(dto.cont_id, usr_grp_cd, null))
        val list = campaignDao.sel_ContentsList(Contents_searchDto(contMstDto.cont_seq))
        if(!list.isNullOrEmpty()) {
            map["camp"] = list[0]
        }

        if(dto.camp_st == "03"){
            map["sendCnt"] = campaignDao.sel_send_status_cnt(dto.pro_id!!)
        }
        if(dto.camp_st == "04"){
            map["sendCnt"] = campaignDao.sel_send_status_cnt(dto.pro_id!!)
            map["openCnt"] = campaignDao.sel_tarck_open_cnt(dto.pro_id!!)
            map["trackCnt"] = campaignDao.sel_tarck_url_cnt(dto.pro_id!!)
        }
        return map
    }

    override fun isCheckProNm(dto: Tblmicp_programDto): Map<String, Any> {
        val re_map = HashMap<String, Any>()
        val checkDto = Tblmicp_programDto()
        checkDto.pro_nm = dto.pro_nm

        if (!campaignDao.sel_tblmicp_program(checkDto).isNullOrEmpty()) {
            re_map["status"] = false
            re_map["message"] = "캠페인명이 중복 됩니다."
        }
        return re_map
    }

    override fun getTargetInfo(usr_grp_cd: String): Map<String, Any?> {
        val re_map = HashMap<String, Any?>()
        val tableau_url = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_URL", usr_grp_cd))?.cd_val

        if (tableau_url.isNullOrEmpty()) {
            return re_map
        } else {
            val map = LinkedMultiValueMap<String, String>()
            map["username"] = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_ID", usr_grp_cd))?.cd_val
            val response = commonService.getRest("${tableau_url}/trusted", "POST", map)
            return if (response.body.isNullOrEmpty()) {
                re_map
            } else {
                re_map["tableauUrl"] = sysSettingDao.getCommCD(Tblmi_comm_cdDto("TABLEAU_PAGE", usr_grp_cd))?.cd_val?.replace("{ticket}", response.body!!)
                re_map
            }
        }
    }
}