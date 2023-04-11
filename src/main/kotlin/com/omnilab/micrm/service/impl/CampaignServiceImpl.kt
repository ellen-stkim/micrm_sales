package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.Program_SearchDto
import com.omnilab.micrm.model.SendResult_lstDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.*
import com.omnilab.micrm.task.ThreadPool
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.text.SimpleDateFormat
import java.util.*
import java.util.stream.Collectors

@Service("CampaignServiceImpl")
class CampaignServiceImpl : com.omnilab.micrm.service.CampaignService {

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
    private lateinit var sysSettingDao: SysSettingDao

    @Autowired
    private lateinit var campaignReportDao: CampaignReportDao

    @Autowired
    private lateinit var commonService: com.omnilab.micrm.service.CommonService


    override fun programSend(pro_id: String, auto_tp: Boolean) {
        /*
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
         */
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
        val list = campaignDao.sel_ContentsList(Contents_searchDto(contMstDto!!.cont_seq))
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

    override fun getProgramSearch(pdto: Tblmicp_programDto): Map<String, Any> {
        pdto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val dto = pdto as Program_SearchDto

        when (dto.searchType) {
            "pro_nm" -> dto.pro_nm = dto.searchValue
            "usr_nm" -> dto.usr_nm = dto.searchValue
            "cd_nm" -> dto.cd_nm = dto.searchValue
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

            val campLSt = campaignDao.sel_campaign_data(Tblmicp_campaignDto(pro_id))
            map["campaignLst"] = campLSt

            val contMap = HashMap<String, Any>()
            for (camp in campLSt) {
                val tempDt = campaignDao.sel_camp_cont_mst(Tblmicp_cont_mstDto(camp.cont_id!!, usr_grp_cd, null))
                val tempTblDto = campaignDao.sel_ContentsList(Contents_searchDto(tempDt?.cont_seq))
                if (!tempTblDto.isNullOrEmpty()) {
                    contMap[camp.cont_id.toString()] = tempTblDto[0]
                }
            }
            map["contDto"] = contMap

            map["sendCnt"] = campaignDao.sel_send_status_cnt(pro_id)
            map["sendCnt"] = campaignDao.sel_send_status_cnt(pro_id)
            map["openCnt"] = campaignDao.sel_tarck_open_cnt(pro_id)
            map["trackCnt"] = campaignDao.sel_tarck_url_cnt(pro_id)

            val cdDto = Tblmi_comm_cdDto()
            cdDto.cd_id = usr_grp_cd
            cdDto.grp_id = "API_PRICE"
            val priceLst = sysSettingDao.getCommCDLst(cdDto)
            val priceMap = priceLst.stream().collect(
                Collectors.toMap(Tblmi_comm_cdDto::cd_val, Tblmi_comm_cdDto::cd_desc))

            map["priceMap"] = priceMap
        }
        return map
    }

    override fun getCampContentPreview(dto: Tblmi_cont_mstDto): Tblmi_cont_lstDto {
        val contentLst = campaignDao.sel_camp_ContentsList(dto)
        return if (contentLst.isNullOrEmpty()) {
            Tblmi_cont_lstDto()
        } else {
            contentLst[0]
        }
    }


    override fun getContentPreview(searchCont: Tblmicp_cont_mstDto): MutableList<HashMap<String, Any?>> {
        var mapLst = mutableListOf<HashMap<String, Any?>>()

        val contentDtoLst = campaignDao.getContentsViewList(searchCont)

        for (contentDto in contentDtoLst) {

            var map = HashMap<String, Any?>()
            contentDto.cardSize = '1'.toString()
            if (contentDto.cont_tp.equals("DMTP04")) {
                commonService.jsonOneContentsParsing(contentDto)
            }
            map["dto"] = contentDto
            mapLst.add(map)
        }

        return mapLst
    }

    override fun getProgramSendResultExcel(pro_id: String, type: String?, usr_grp_cd: String): MutableMap<String, Any> {
        val reMap = HashMap<String, Any>()
        val labelList = mutableListOf<String>();
        labelList.add("캠페인명")
        labelList.add("발송상세")
        labelList.add("회원번호")
        labelList.add("이메일/모바일")
        labelList.add("원인")
        labelList.add("발송시간")
        labelList.add("발송기준정보")

        val book = commonService.createExcel(labelList)
        labelList.clear()

        val proDto = Tblmicp_programDto(pro_id)
        proDto.usr_grp_cd = usr_grp_cd
        val pro = campaignDao.sel_tblmicp_programOne(proDto)
        reMap["name"] = "${pro.pro_nm}"
        reMap["book"] = book

        val lstDto = SendResult_lstDto(pro_id, usr_grp_cd)
        lstDto.send_rst = type

        campaignDao.sel_send_program_rstLstExcel(book, lstDto)
        return reMap
    }

}