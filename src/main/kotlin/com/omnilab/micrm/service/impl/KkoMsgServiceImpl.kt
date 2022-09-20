package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.repository.KkoAtTmplDao
import com.omnilab.micrm.service.KkoMsgService
import com.omnilab.micrm.service.KkoRestApiService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
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

        // 리스트 조회

        // 이미지??

        kkoRestApiService.createAtTmpl()

//        kkoAtTmplDao.selectAtTmplLst(dto)
        return paramMap
    }

    override fun getTmplSearchLst(): Map<String, Any> {
        val map : MutableMap<String,Any> = mutableMapOf()
        var searchDto : Tblmi_comm_cdDto = Tblmi_comm_cdDto()
        searchDto.grp_id="KAKAO_TMPL"
        searchDto.cd_id = "TMPL_ST"
        map.put("tmplSt",kkoAtTmplDao.getTmplSearchLst(searchDto))

        searchDto.cd_id = "KEP_ST"
        map.put("kepSt",kkoAtTmplDao.getTmplSearchLst(searchDto))

        return map
    }

    override fun createTmplLst(): Map<String, Any> {
        val map : MutableMap<String,Any> = mutableMapOf()
        var searchDto : Tblmi_comm_cdDto = Tblmi_comm_cdDto()
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

        return map
    }
}
