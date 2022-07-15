package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.WorkSearch_Dto
import com.omnilab.micrm.model.table.Tblmi_workDto
import com.omnilab.micrm.repository.SysWorkDao
import com.omnilab.micrm.service.SysWorkService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service


@Service("SysWorkServiceImpl")
class SysWorkServiceImpl: SysWorkService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var sysWorkDao : SysWorkDao;

    override fun getWorkList(workDto: Tblmi_workDto): MutableMap<String, Any>{
        val map : MutableMap<String, Any> = HashMap()

        val dto = workDto as WorkSearch_Dto
        if(dto.searchType == "seq") {
            if(!CommonUtils.isEmptyObject(dto.searchValue)){
                dto.seq = dto.searchValue?.toInt()
            }else {
                dto.seq = null
            }
        } else if(dto.searchType == "work_type") {
           dto.work_type = dto.searchValue
        } else if(dto.searchType == "work_stat") {
            dto.work_stat = dto.searchValue
        } else if(dto.searchType == "usr_email") {
            dto.usr_email = dto.searchValue
        }
        dto.work_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(dto.pageNo,10,10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysWorkDao.getWorkListCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysWorkDao.getWorkList(dto);
        return map;
    }
}
