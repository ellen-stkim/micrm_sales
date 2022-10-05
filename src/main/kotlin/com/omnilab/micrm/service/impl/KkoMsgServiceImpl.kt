package com.omnilab.micrm.service.impl

import com.google.gson.GsonBuilder
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


    override fun selectAtTemplViewLst(dto: AtTmpl_searchDto): Map<String, Any> {
        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(dto.pageNo, 10, 4)

        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.firstIndex = paginationInfo.firstRecordIndex

        when (dto.searchType) {
            "tmpl_nm" -> dto.tmpl_nm = dto.searchValue
            "chan_id" -> dto.chan_id = dto.searchValue
            "kep_status" -> dto.kep_status = dto.searchValue
            "use_yn" -> dto.use_yn = dto.searchValue
            "tmpl_status" -> dto.tmpl_status = dto.searchValue
        }

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
        map.put("tmplSt",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id = "KEP_ST"
        map.put("kepSt",kkoAtTmplDao.getTmplSearchLst(searchDto))



        return map
    }

    override fun tmplCreateLst(): Map<String, Any> {
        val map : MutableMap<String,Any> = mutableMapOf()
        val searchDto = Tblmi_comm_cdDto()
        searchDto.grp_id= "KAKAO_TMPL"

        searchDto.cd_id ="CATE"
        map.put("cateLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id ="CATE_SUB"
        map.put("cateSubLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id ="MSG_TP"
        map.put("msgTpLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id ="EMP_TP"
        map.put("empTpLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id ="CATE_SUB_GID"
        map.put("cateSubGidLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id ="TMPL_BTN_LINK_TP"
        map.put("btnLinkLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id ="TMPL_BTN_TP"
        map.put("btnLst",kkoAtTmplDao.getTmplSearchLst(searchDto))

        return map
    }

    override fun getKkoAtTmplDto(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto? {
        return kkoAtTmplDao.selKkoAtTmpl(dto)
    }

    override fun createTmpl(dto: Kko_at_tmplDto, regId: String): Map<String, Any> {

        val map :MutableMap<String,Any> = mutableMapOf()
        // 카카오 api 호풀
        val result:MutableMap<String,Any> = kkoRestApiService.createAtTmpl(dto)
        val data:MutableMap<String,Any> = result.get("data") as MutableMap<String, Any>

        try {
            if(result.get("result") as Boolean){
                if("API_200".equals(data.get("code"))){

                    // tmplDto 저장
                    val tmplDto = getTmplDtoByKkoDto(dto,regId)
                    kkoAtTmplDao.insNewTmplDto(tmplDto);

                    map.put("status",HttpServletResponse.SC_OK)
                    map.put("msg", "알림톡 템플릿이 생성되었습니다.")

                }else{
                    logger.error("카카오 알림톡 템플릿 생성 데이터 에러")
                    logger.error("data : {}",result)

                    val code :String = data.get("code")?.toString()!!.replace("API_","")
                    map.put("status", code.toInt())
                    map.put("msg", data.get("message")!!)
                }
            }else{
                logger.error("카카오 알림톡 템플릿 생성 API 에러")
                logger.error("data : {}",result)

                val code :String = data.get("code")?.toString()!!.replace("API_","")
                map.put("status", code.toInt())
                map.put("msg", data.get("message")!!)
            }
        }catch (e:Exception){
            logger.error("",e)
            map.put("status", HttpServletResponse.SC_INTERNAL_SERVER_ERROR)
            map.put("msg", "템플릿 등록에 실패했습니다. 관리자에게 문의 바랍니다.")
        }

        return map
    }

    override fun selTmplDataBySeq(seq: Int): AtTmpl_viewDto {
        val tmplDto :Tblmi_kko_at_tmplDto = Tblmi_kko_at_tmplDto(seq,null,"Y")
        return  kkoAtTmplDao.selTmplViewByTmplDto(tmplDto)
    }

    override fun updateTmpl(dto: Kko_at_tmplDto, tmplDto: Tblmi_kko_at_tmplDto): Map<String, Any> {
        val map :MutableMap<String,Any> = mutableMapOf()

        val newDto: Kko_at_tmplDto = getNewAtTmpl(dto,tmplDto)

        val result:MutableMap<String,Any> = kkoRestApiService.updateAtTmpl(newDto)
        logger.error("{}",newDto)
        logger.error("{}",result)
        //at_tmplDto 변경

        // api 업데이트
        // db 업데이트

        return map
    }

    private fun getNewAtTmpl(dto: Kko_at_tmplDto, tmplDto: Tblmi_kko_at_tmplDto): Kko_at_tmplDto {
        val curDto:AtTmpl_viewDto = kkoAtTmplDao.selTmplBytmplDto(tmplDto)
        dto.templateName =  curDto.tmpl_nm
        dto.templateCode =  curDto.tmpl_cd
        dto.templateContent =  curDto.tmpl_cont
        dto.securityFlag =  curDto.secur_flag
        dto.templateStatus =  curDto.tmpl_status
        dto.kepStatus =  curDto.kep_status
        dto.templateMessageType =  curDto.tmpl_msg_tp
        dto.templateExtra =  curDto.tmpl_ext
        dto.templateAd =  curDto.tmpl_ad

        dto.templateTitle =  curDto.tmpl_tit
        dto.templateSubtitle =  curDto.tmpl_subtit
        dto.templateEmphasizeType =  curDto.tmpl_empsize_tp
        dto.categoryCode =  curDto.cate_cd
        dto.templateHeader =  curDto.tmpl_header

            return dto
    }

    private fun getTmplDtoByKkoDto(dto: Kko_at_tmplDto, regId: String): Tblmi_kko_at_tmplDto {
        val gson = GsonBuilder().create()
        val tmplDto = Tblmi_kko_at_tmplDto()
        tmplDto.tmpl_nm = dto.templateName
        tmplDto.tmpl_cd = dto.templateCode
        tmplDto.send_key = dto.send_key
        tmplDto.tmpl_cont = dto.templateContent
        /*tmplDto.tmpl_img_nm = dto.templateImageName   //이미지 시퀀스로 변경
        tmplDto.tmpl_img_url = dto.templateImageUrl*/
        tmplDto.secur_flag = dto.securityFlag
        tmplDto.tmpl_status = dto.templateStatus
        tmplDto.kep_status = "N"
        tmplDto.tmpl_msg_tp = dto.templateMessageType
        tmplDto.tmpl_ext = dto.templateExtra
        tmplDto.tmpl_ad = dto.templateAd
        tmplDto.tmpl_tit = dto.templateTitle
        tmplDto.tmpl_subtit = dto.templateSubtitle
        tmplDto.tmpl_empsize_tp = dto.templateEmphasizeType
        tmplDto.cate_cd = dto.categoryCode
        tmplDto.tmpl_header = dto.templateHeader
        tmplDto.button_json = gson.toJson(dto.buttons)
        tmplDto.quick_repl_json = gson.toJson(dto.quickReplies)
        tmplDto.item_highlight_json = gson.toJson(dto.templateItemHighlight)
        tmplDto.item_json =  gson.toJson(dto.templateItem)
        tmplDto.reg_id = regId

        return tmplDto
    }
}
