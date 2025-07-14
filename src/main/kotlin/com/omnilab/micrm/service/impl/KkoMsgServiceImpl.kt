package com.omnilab.micrm.service.impl

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.AtTmpl_viewDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_kko_at_tmplDto
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import com.omnilab.micrm.repository.KkoAtTmplDao
import com.omnilab.micrm.service.KkoMsgService
import com.omnilab.micrm.service.KkoRestApiService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import javax.servlet.http.HttpServletResponse
import kotlin.collections.HashMap


@Service("KkoMsgServiceImpl")
class KkoMsgServiceImpl : KkoMsgService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("KkoAtTmplDaoImpl")
    private lateinit var kkoAtTmplDao: KkoAtTmplDao

    @Autowired
    @Qualifier("KkoRestApiServiceImpl")
    private lateinit var kkoRestApiService: KkoRestApiService

    val gson :Gson = GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create()

    override fun selectAtTemplViewLst(dto: AtTmpl_searchDto): Map<String, Any> {
        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(dto.pageNo, 10, 4)

        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.firstIndex = paginationInfo.firstRecordIndex

        when (dto.searchType) {
            "tmpl_nm" -> dto.tmpl_nm = dto.searchValue
            "chan_id" -> dto.chan_id = dto.searchValue
            "kep_status" -> dto.kep_status = dto.searchValue
            "use_yn" -> dto.tmpl_dormant = dto.searchValue
            "tmpl_status" -> dto.tmpl_status = dto.searchValue
        }
        dto.del_yn = "N"
        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage

        paginationInfo.totalRecordCount =  kkoAtTmplDao.selectTotalAtTmplCnt(dto)
        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["listCnt"] = paginationInfo.totalRecordCount
        paramMap["list"] = kkoAtTmplDao.selectAtTmplLst(dto)

        paramMap["nextCk"] = paginationInfo.currentPageNo != paginationInfo.lastPageNo

        return paramMap
    }

    override fun getTmplSearchLst(): Map<String, Any> {
        val map : MutableMap<String,Any> = mutableMapOf()
        val searchDto = Tblmi_comm_cdDto()
        searchDto.grp_id="KAKAO_TMPL"
        searchDto.cd_id = "TMPL_ST"
        map["tmplSt"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        searchDto.cd_id = "KEP_ST"
        map["kepSt"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        return map
    }

    override fun tmplCreateLst(): MutableMap<String, Any> {
        val map : MutableMap<String,Any> = mutableMapOf()
        val searchDto = Tblmi_comm_cdDto()
        searchDto.grp_id= "KAKAO_TMPL"

        searchDto.cd_id ="CATE"
        map["cateLst"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        searchDto.cd_id ="CATE_SUB"
        map["cateSubLst"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        searchDto.cd_id ="MSG_TP"
        map["msgTpLst"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        searchDto.cd_id ="EMP_TP"
        map["empTpLst"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        searchDto.cd_id ="CATE_SUB_GID"
        map["cateSubGidLst"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        searchDto.cd_id ="TMPL_BTN_LINK_TP"
        map["btnLinkLst"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        searchDto.cd_id ="TMPL_BTN_TP"
        map["btnLst"] = kkoAtTmplDao.getTmplSearchLst(searchDto)

        return map
    }

    override fun tmplDataLst(): MutableMap<String, Any> {
        val map : MutableMap<String,Any> = tmplCreateLst()
        val searchDto = Tblmi_comm_cdDto()
        searchDto.grp_id= "KAKAO_TMPL"
        searchDto.cd_id ="CMT_ST"
        map.put("cmtStLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        return map
    }

    override fun getKkoAtTmplDto(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto? {
        return kkoAtTmplDao.selKkoAtTmpl(dto)
    }

    override fun updTmplDto(dto: Tblmi_kko_at_tmplDto): Int {
        return kkoAtTmplDao.updTmplDtoBySeq(dto)
    }

    override fun createTmpl(dto: Kko_at_tmplDto, tmplDto: Tblmi_kko_at_tmplDto): Map<String, Any> {

        val map :MutableMap<String,Any> = mutableMapOf()

        // 카카오 api 호출
        val result:MutableMap<String,Any> = kkoRestApiService.createAtTmpl(dto)
        val data:MutableMap<String,Any> = result["data"] as MutableMap<String, Any>
        try {
            if(result["result"] as Boolean){
                if("API_200" == data["code"]){
                    // tmplDto 저장
                    val tmplDto1 = getTmplDtoByKkoDto(dto,tmplDto)
                    tmplDto1.use_yn = "Y"
                    tmplDto1.tmpl_status = "N"
                    tmplDto1.kep_status = "I"   // 등록 후 자동 검수 요청

                    //개인화 변수 파싱
                    val tempContStrs = dto.templateContent!!.split("#\\{".toRegex())
                    val etcArr = mutableListOf<String>()
                    var tempCont: String?
                    for(idx in 1 until tempContStrs.size){
                        tempCont = tempContStrs[idx]
                        val ind = tempCont.indexOf("}")
                        if(ind != -1){
                            etcArr.add(tempCont.substring(0, ind))
                        }
                        tmplDto1.tmpl_cont
                    }

                    val size = etcArr.size
                    tmplDto1.etc_1 =  if (size >= 1) etcArr[0] else null
                    tmplDto1.etc_2 = if (size >= 2) etcArr[1] else null
                    tmplDto1.etc_3 = if (size >= 3) etcArr[2] else null
                    tmplDto1.etc_4 = if (size >= 4) etcArr[3] else null
                    tmplDto1.etc_5 = if (size >= 5) etcArr[4] else null
                    tmplDto1.etc_6 = if (size >= 6) etcArr[5] else null
                    tmplDto1.etc_7 = if (size >= 7) etcArr[6] else null
                    tmplDto1.etc_8 = if (size >= 8) etcArr[7] else null
                    tmplDto1.etc_9 = if (size >= 9) etcArr[8] else null
                    tmplDto1.etc_10 = if (size >= 10) etcArr[9] else null

                    kkoAtTmplDao.insNewTmplDto(tmplDto1)

                    map["status"] = HttpServletResponse.SC_OK
                    map["msg"] = "알림톡 템플릿이 생성되었습니다."
                }else{
                    logger.error("카카오 알림톡 템플릿 생성 데이터 에러 {}",result)

                    val code :String = data["code"]?.toString()!!.replace("API_","")
                    map["status"] = code.toInt()
                    map["msg"] = data["message"]!!
                }
            }else{
                logger.error("카카오 알림톡 템플릿 생성 API 에러 {}",result)

                val code :String = data["code"]?.toString()!!.replace("API_","")
                map["status"] = code.toInt()
                map["msg"] = data["message"]!!
            }
        }catch (e:Exception){
            logger.error("createTmpl", e)
            map["status"] = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            map["msg"] = "템플릿 등록에 실패했습니다. 관리자에게 문의 바랍니다."
        }

        return map
    }

    override fun selTmplDataBySeq(seq: Int): AtTmpl_viewDto {
        val usrGrpCd = UsefulUtils.sessionUser().usr_grp_cd
        val tmplDto = AtTmpl_searchDto(seq,usrGrpCd)
        //tmplDto.use_yn = "Y"
        return  kkoAtTmplDao.selTmplViewByTmplDto(tmplDto)
    }

    override fun updateTmpl(dto: Kko_at_tmplDto, searchDto: AtTmpl_searchDto, updDto: Tblmi_kko_at_tmplDto ): Map<String, Any> {
        val map :MutableMap<String,Any> = HashMap()
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val newDto: Kko_at_tmplDto = getAtTmplDataByViewDto(dto, kkoAtTmplDao.selTmplBytmplDto(searchDto))

        // 카카오 템플릿 변경
        val result:MutableMap<String,Any> = kkoRestApiService.updateAtTmpl(newDto)
        val data:MutableMap<String,Any> = result["data"] as MutableMap<String, Any>

        try {
            if(result["result"] as Boolean){
                if("API_200" == data["code"]){
                    //at_tmplDto 변경
                    val tmplDto = getTmplDtoByUpdKkoDto(dto, updDto)  //변경
                    tmplDto.kep_status = "I"   // 수정 후 자동 검수 요청
                    tmplDto.seq = searchDto.seq
                    tmplDto.use_yn = "Y"

                    //개인화 변수 파싱
                    val tempContStrs = dto.templateContent!!.split("#\\{".toRegex())
                    val etcArr = mutableListOf<String>()
                    var tempCont: String?
                    for (idx in 1 until tempContStrs.size) {
                        tempCont = tempContStrs[idx]
                        val ind = tempCont.indexOf("}")
                        if(ind != -1){
                            etcArr.add(tempCont.substring(0, ind))
                        }
                        tmplDto.tmpl_cont
                    }

                    val size = etcArr.size
                    tmplDto.etc_1 = if (size >= 1) etcArr[0] else null
                    tmplDto.etc_2 = if (size >= 2) etcArr[1] else null
                    tmplDto.etc_3 = if (size >= 3) etcArr[2] else null
                    tmplDto.etc_4 = if (size >= 4) etcArr[3] else null
                    tmplDto.etc_5 = if (size >= 5) etcArr[4] else null
                    tmplDto.etc_6 = if (size >= 6) etcArr[5] else null
                    tmplDto.etc_7 = if (size >= 7) etcArr[6] else null
                    tmplDto.etc_8 = if (size >= 8) etcArr[7] else null
                    tmplDto.etc_9 = if (size >= 9) etcArr[8] else null
                    tmplDto.etc_10 = if (size >= 10) etcArr[9] else null

                    kkoAtTmplDao.updTmplDto(tmplDto)

                    map["status"] = HttpServletResponse.SC_OK
                    map["msg"] = "알림톡 템플릿이 수정되었습니다."

                }else{
                    logger.error("카카오 알림톡 템플릿 수정 데이터 에러 {}",result)
                    val code :String = data["code"]?.toString()!!.replace("API_","")
                    map["status"] = code.toInt()
                    map["msg"] = data["message"].toString()
                }
            }else{
                logger.error("카카오 알림톡 템플릿 수정 API 에러 {}",result)
                val code :String = data["code"]?.toString()!!.replace("API_","")
                map["status"] = code.toInt()
                map["msg"] = data["message"].toString()
            }
        }catch (e:Exception){
            logger.error("",e)
            map["status"] = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            map["msg"] = "템플릿 수정에 실패했습니다. 관리자에게 문의 바랍니다."
        }
        return map
    }



    override fun cancleTmplReq(searchDto: AtTmpl_searchDto, updId: String): MutableMap<String, Any> {
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val map :MutableMap<String,Any> = mutableMapOf()
        try {
            // 사용자 권한 확인 select
            val dto: Tblmi_kko_at_tmplDto? = kkoAtTmplDao.selKkoAtTmplByGrpCd(searchDto)

            if (!CommonUtils.isEmptyObject(dto)) {
                // 검수 요청 상태일 경우
                if ("I" == dto!!.kep_status) {
                    // 비즈메세지 요청 취소
                    val tmplResult: MutableMap<String, Any>? = kkoRestApiService.cancleKepReq(dto.tmpl_cd, dto.send_key)

                    if (tmplResult!!["result"] as Boolean) {
                        val data: MutableMap<String, Any> = tmplResult["data"] as MutableMap<String, Any>
                        if ("API_200" == data.get("code")) { // 요청 취소 성공
                            val updDto: Tblmi_kko_at_tmplDto = Tblmi_kko_at_tmplDto(dto.seq, updId, null)
                            updDto.kep_status = "N"
                            kkoAtTmplDao.updTmplDtoBySeq(updDto)

                            map["status"] = HttpServletResponse.SC_OK
                            map["msg"] = "검수요청이 취소되었습니다."
                        }else{
                            logger.error("비즈메세지 검수요청 취소 에러 {}",tmplResult)
                            map["status"] = HttpServletResponse.SC_OK
                            map["msg"] = data["message"] as String
                        }
                    }else{
                        logger.error("비즈메세지 검수요청 취소 에러 {}",tmplResult)
                    }
                }
            }

            if(CommonUtils.isEmptyObject(map["status"])){
                map["status"] = HttpServletResponse.SC_BAD_REQUEST
                map["msg"] = "에러가 발생했습니다. 새로고침 후 다시 시도해주세요."
            }
        } catch (e: Exception) {
            logger.error("", e)
            map["status"] = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            map["msg"] = "검수요청 취소에 실패했습니다. 관리자에게 문의 바랍니다."
        }
        return map
    }

    override fun updAtTmplData(searchDto: AtTmpl_searchDto, updId: String?): MutableMap<String, Any> {
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val map :MutableMap<String,Any> = mutableMapOf()
        try {
            val dto: Tblmi_kko_at_tmplDto? = kkoAtTmplDao.selKkoAtTmplByGrpCd(searchDto)
            if (!CommonUtils.isEmptyObject(dto)) {
                // 비즈메세지 데이터 조회
                val tmplResult: MutableMap<String, Any> = kkoRestApiService.getTmplDetail(dto!!.tmpl_cd, dto.send_key)
                if (tmplResult["result"] as Boolean) {
                    val tempData: MutableMap<String, Any> = tmplResult["data"] as MutableMap<String, Any>
                    if ("API_200" == tempData["code"]) {
                        if(!CommonUtils.isEmptyObject(tempData["data"])){
                            val data: MutableMap<String, Any> = tempData["data"] as MutableMap<String, Any>
                            val cmtLstStr = data["templateComments"]
                            val tmplSt :String = data["templateStatus"] as String
                            val kepSt :String = data["kepStatus"] as String
                            val tmplDormant :String = if(data["templateDormant"] as Boolean) "Y" else "N"  //휴면
                            val tmplBlock :String = if(data["templateBlock"] as Boolean) "Y" else "N"   //차단

                            val updDto = Tblmi_kko_at_tmplDto(dto.seq, tmplSt, kepSt,tmplDormant,tmplBlock)
                            updDto.cmt_json = gson.toJson(cmtLstStr)
                            updDto.upd_id = updId
                            kkoAtTmplDao.updTmplDtoBySeq(updDto)

                            map["status"] = HttpServletResponse.SC_OK
                            map["msg"] = "템플릿 상태가 업데이트 됐습니다."
                        }
                    } else {
                        logger.error("템플릿 업테이트 에러 {}", tmplResult)
                        map["status"] = HttpServletResponse.SC_BAD_REQUEST
                        map["msg"] = tempData["message"] as String
                    }
                } else {
                    logger.error("템플릿 업테이트 에러 {}", tmplResult)
                }
            }

            if(CommonUtils.isEmptyObject(map["status"])){
                map["status"] = HttpServletResponse.SC_BAD_REQUEST
                map["msg"] = "에러가 발생했습니다. 새로고침 후 다시 시도해주세요."
                logger.error("status null {}", map)
            }
        } catch (e: Exception) {
            logger.error("", e)
            map["status"] = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            map["msg"] = "템플릿 상태 업데이트에 실패했습니다. 관리자에게 문의 바랍니다."
        }
        return map
    }

    override fun reqTmplST(searchDto: AtTmpl_searchDto, updId: String?): MutableMap<String, Any> {
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.use_yn = "Y"

        val map :MutableMap<String,Any> = mutableMapOf()
        try {
            val dto: AtTmpl_viewDto = kkoAtTmplDao.selTmplBytmplDto(searchDto)
            if (!CommonUtils.isEmptyObject(dto)) {
                if ("N" == dto.kep_status || "R" == dto.kep_status) {   // 검수 요청 전이거나 반려상태의 경우에만
                    // 템플릿 내용 수정 후 자동 검수요청
                    var updTmpl: Kko_at_tmplDto = getAtTmplDataByViewDto(Kko_at_tmplDto(), dto)
                    updTmpl.send_key = dto.send_key
                    updTmpl = getNewAtTmpl(Kko_at_tmplDto(), updTmpl)

                    logger.error("updTmpl {}", updTmpl)

                    // 검수 요청 상태 반영
                    val updResult:MutableMap<String,Any> = kkoRestApiService.updateAtTmpl(updTmpl)
                    if (updResult["result"] as Boolean) {
                        val tempData :MutableMap<String,Any> = updResult["data"] as MutableMap<String, Any>
                        if ("API_200" == tempData["code"]) {
                            val data :MutableMap<String,Any> = tempData["data"] as MutableMap<String, Any>
                            val tmplSt :String = data["templateStatus"] as String
                            val kepSt :String = data["kepStatus"] as String

                            val updDto = Tblmi_kko_at_tmplDto(dto.seq, updId, null)
                            updDto.tmpl_status = tmplSt
                            updDto.kep_status = kepSt

                            kkoAtTmplDao.updTmplDtoBySeq(updDto)

                            map["status"] = HttpServletResponse.SC_OK
                            map["msg"] = "검수요청이 등록되었습니다."

                        } else {
                            logger.error("템플릿 검수요청 에러 {}", updResult)
                            map["status"] = HttpServletResponse.SC_BAD_REQUEST
                            map["msg"] = tempData["message"] as String
                        }
                    } else {
                        logger.error("템플릿 검수요청 에러 {}", updResult)
                    }
                } else {
                    map["status"] = HttpServletResponse.SC_BAD_REQUEST
                    map["msg"] = "템플릿 검수상태가 등록 또는 반려인 경우에만 요청이 가능합니다"
                }
            }

            if(CommonUtils.isEmptyObject(map["status"])){
                map["status"] = HttpServletResponse.SC_BAD_REQUEST
                map["msg"] = "에러가 발생했습니다. 새로고침 후 다시 시도해주세요."
            }

        } catch (e: Exception) {
            logger.error("", e)
            map["status"] = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            map["msg"] = "검수요청에 실패했습니다. 관리자에게 문의 바랍니다."
        }
        return map
    }

    override fun removeTmpl(searchDto: AtTmpl_searchDto, name: String?): MutableMap<String, Any> {
        val map: MutableMap<String, Any> = mutableMapOf()
        /*searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        try {
            val dto: Tblmi_kko_at_tmplDto? = kkoAtTmplDao.selKkoAtTmplByGrpCd(searchDto)

            // 데이터가 있으면
            if (!CommonUtils.isEmptyObject(dto)) {
                if ("N".equals(dto!!.kep_status) || "R".equals(dto!!.kep_status)) {   // 검수 요청 전이거나 반려상태의 경우에만

                    // 카카오 삭제,
                    val delResult:MutableMap<String,Any> = kkoRestApiService.delTemplate(dto.send_key,dto.tmpl_cd)

                    logger.error("{}",delResult)
                    if (delResult!!.get("result") as Boolean) {
                    } else {
                        logger.error("템플릿 삭제 에러 {}", delResult)
                    }

                } else {
                    map.put("status", HttpServletResponse.SC_BAD_REQUEST)
                    map.put("msg", "")
                }
            }

            if(CommonUtils.isEmptyObject(map.get("status"))){
                map.put("status", HttpServletResponse.SC_BAD_REQUEST)
                map.put("msg", "에러가 발생했습니다. 새로고침 후 다시 시도해주세요.")
            }

        }catch (e:Exception){
            logger.error("removeTmpl : {}",e)
        }*/

        return map
    }

    override fun cancleTmplApp(searchDto: AtTmpl_searchDto, updId: String?): MutableMap<String, Any> {
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val map :MutableMap<String,Any> = mutableMapOf()
        /*try {
            val dto: Tblmi_kko_at_tmplDto? = kkoAtTmplDao.selKkoAtTmplByGrpCd(searchDto)

            if (!CommonUtils.isEmptyObject(dto)) {
                logger.error("{}",dto)
                if(true){
                    // 카카오 승인 취소
                    val appResult:MutableMap<String,Any> = kkoRestApiService.cancleAppTemplate(dto!!.send_key,dto.tmpl_cd)

                    logger.error("{}",appResult)

                    if (appResult!!.get("result") as Boolean) {
                        val tempData :MutableMap<String,Any> = appResult.get("data") as MutableMap<String, Any>
                        if ("API_200".equals(tempData.get("code"))) {

                            // 승인 취소 ?

                            map.put("status", HttpServletResponse.SC_OK)
                            map.put("msg", "승인취소가 요청되었습니다.")

                        } else {
                            logger.error("템플릿 승인취소 에러 {}", appResult)
                            map.put("status", HttpServletResponse.SC_BAD_REQUEST)
                            map.put("msg", tempData.get("message") as String)
                        }
                    } else {
                        logger.error("템플릿 승인취소 에러 {}", appResult)
                    }

                }
            }

            if(CommonUtils.isEmptyObject(map.get("status"))){
                map.put("status", HttpServletResponse.SC_BAD_REQUEST)
                map.put("msg", "에러가 발생했습니다. 새로고침 후 다시 시도해주세요.")
            }

        } catch (e: Exception) {
            logger.error("", e)
            map.put("status", HttpServletResponse.SC_INTERNAL_SERVER_ERROR)
            map.put("msg", "검수요청에 실패했습니다. 관리자에게 문의 바랍니다.")
        }*/
        return map
    }

    override fun delTmplLst(list: MutableList<String>): MutableMap<String, Any> {
        val paramMap = HashMap<String, Any>()
        val deleteMobileDto = Tblmi_kko_at_tmplDto()
        val usrId = UsefulUtils.sessionUser().usr_id
        var delCnt = 0

        for (i in list) {
            deleteMobileDto.tmpl_cd = i
            deleteMobileDto.use_yn = "N"
            deleteMobileDto.del_yn = "Y"
            deleteMobileDto.upd_id = usrId
            kkoAtTmplDao.delTmpl(deleteMobileDto)
            delCnt++
        }
        paramMap["message"] = delCnt.toString() + "개의 모바일 컨텐츠가 삭제 되었습니다"
        paramMap["status"] = "true"
        return paramMap
    }

    private fun getAtTmplDataByViewDto(dto: Kko_at_tmplDto, curDto: AtTmpl_viewDto): Kko_at_tmplDto {
        dto.templateName =  curDto.tmpl_nm
        dto.templateCode =  curDto.tmpl_cd
        dto.templateContent =  curDto.tmpl_cont
        dto.securityFlag =  if("Y" == curDto.secur_flag) "true" else null
        dto.templateStatus =  curDto.tmpl_status
        dto.kepStatus =  curDto.kep_status
        dto.templateMessageType =  curDto.tmpl_msg_tp
        dto.templateExtra =  curDto.tmpl_ext
        dto.templateAd =  curDto.tmpl_ad

        dto.templateImageName = curDto.img_org_nm
        dto.templateImageUrl = curDto.kko_img_url

        dto.templateTitle =  curDto.tmpl_tit
        dto.templateSubtitle =  curDto.tmpl_subtit
        dto.templateEmphasizeType =  curDto.tmpl_empsize_tp
        dto.categoryCode =  curDto.cate_cd
        dto.templateHeader =  curDto.tmpl_header

        dto.templateItem = gson.fromJson(curDto.item_json, object : TypeToken<HashMap<String, Any>>() {}.type)
        dto.templateItemHighlight =  gson.fromJson(curDto.item_highlight_json, object : TypeToken<HashMap<String, Any>>() {}.type)
        dto.buttons = gson.fromJson(curDto.button_json, object : TypeToken<MutableList<HashMap<String, Any>>>() {}.type)
        return dto
    }

    private fun getNewAtTmpl(dto: Kko_at_tmplDto, updDto: Kko_at_tmplDto): Kko_at_tmplDto {
        dto.newTemplateName =  updDto.templateName
        dto.newTemplateCode =  updDto.templateCode
        dto.newTemplateContent =  updDto.templateContent
        dto.newTemplateImageName =  updDto.templateImageName
        dto.newTemplateImageUrl =  updDto.templateImageUrl
//        dto.newSenderKeyType =  updDto.senderKey
        dto.newTemplateMessageType =  updDto.templateMessageType
        dto.newTemplateExtra =  updDto.templateExtra
        dto.newTemplateAd =  updDto.templateAd

        dto.newTemplateEmphasizeType =  updDto.templateEmphasizeType
        dto.newTemplateTitle =  updDto.templateTitle
        dto.newTemplateSubtitle =  updDto.templateSubtitle
        dto.newCategoryCode =  updDto.categoryCode
        dto.newTemplateHeader =  updDto.templateHeader

        dto.newTemplateItemHighlight =  updDto.templateItemHighlight
        dto.newTemplateItem =  updDto.templateItem
        dto.buttons =  updDto.buttons

        return dto
    }

    private fun getTmplDtoByKkoDto(dto: Kko_at_tmplDto, tmplDto: Tblmi_kko_at_tmplDto): Tblmi_kko_at_tmplDto {
        tmplDto.tmpl_nm = dto.templateName
        tmplDto.tmpl_cd = dto.templateCode
        tmplDto.send_key = dto.send_key
        tmplDto.tmpl_cont = dto.templateContent
        tmplDto.tmpl_status = dto.templateStatus
        tmplDto.secur_flag = if ("true" == dto.securityFlag) "Y" else "N"
        tmplDto.tmpl_msg_tp = dto.templateMessageType
        tmplDto.tmpl_ext = dto.templateExtra
        tmplDto.tmpl_ad = dto.templateAd
        tmplDto.tmpl_tit = dto.templateTitle
        tmplDto.tmpl_subtit = dto.templateSubtitle
        tmplDto.tmpl_empsize_tp = dto.templateEmphasizeType
        tmplDto.cate_cd = dto.categoryCode
        tmplDto.tmpl_header = dto.templateHeader
        tmplDto.button_json = if (!CommonUtils.isEmptyObject(dto.buttons)) gson.toJson(dto.buttons) else null
        tmplDto.quick_repl_json = if (!CommonUtils.isEmptyObject(dto.quickReplies)) gson.toJson(dto.quickReplies) else null
        tmplDto.item_highlight_json = if (!CommonUtils.isEmptyObject(dto.templateItemHighlight)) gson.toJson(dto.templateItemHighlight) else null
        tmplDto.item_json = if (!CommonUtils.isEmptyObject(dto.templateItem)) gson.toJson(dto.templateItem) else null

        return tmplDto
    }

    private fun getTmplDtoByUpdKkoDto(dto: Kko_at_tmplDto, tmplDto: Tblmi_kko_at_tmplDto): Tblmi_kko_at_tmplDto {
        tmplDto.tmpl_nm = dto.newTemplateName
        tmplDto.tmpl_cd = dto.newTemplateCode
        tmplDto.send_key = dto.send_key
        tmplDto.tmpl_cont = dto.newTemplateContent
        tmplDto.tmpl_status = dto.templateStatus
        tmplDto.secur_flag = if ("true" == dto.securityFlag) "Y" else "N"
        tmplDto.tmpl_msg_tp = dto.newTemplateMessageType
        tmplDto.tmpl_ext = dto.newTemplateExtra
        tmplDto.tmpl_ad = dto.newTemplateAd
        tmplDto.tmpl_tit = dto.newTemplateTitle
        tmplDto.tmpl_subtit = dto.newTemplateSubtitle
        tmplDto.tmpl_empsize_tp = dto.newTemplateEmphasizeType
        tmplDto.cate_cd = dto.newCategoryCode
        tmplDto.tmpl_header = dto.newTemplateHeader
        tmplDto.button_json = if (!CommonUtils.isEmptyObject(dto.buttons)) gson.toJson(dto.buttons) else null
        tmplDto.quick_repl_json = if (!CommonUtils.isEmptyObject(dto.quickReplies)) gson.toJson(dto.quickReplies) else null
        tmplDto.item_highlight_json = if (!CommonUtils.isEmptyObject(dto.newTemplateItemHighlight)) gson.toJson(dto.newTemplateItemHighlight) else null
        tmplDto.item_json = if (!CommonUtils.isEmptyObject(dto.newTemplateItem)) gson.toJson(dto.newTemplateItem) else null

        return tmplDto

    }
}
