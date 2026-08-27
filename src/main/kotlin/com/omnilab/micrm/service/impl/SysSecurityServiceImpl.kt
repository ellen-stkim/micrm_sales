package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.UsrHst_searchDto
import com.omnilab.micrm.model.table.Tblmi_usr_hstDto
import com.omnilab.micrm.repository.SysSecurityDao
import com.omnilab.micrm.service.SysSecurityService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service


@Service("SysSecurityServiceImpl")
class SysSecurityServiceImpl: SysSecurityService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var sysSecurityDao : SysSecurityDao;

    override fun getAdminUserLog(uDto : Tblmi_usr_hstDto):MutableMap<String, Any>{
        val map : MutableMap<String, Any> = HashMap()
        val dto = uDto as UsrHst_searchDto
        dto.usr_id = UsefulUtils.sessionUser().usr_id
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(dto.pageNo,10,10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSecurityDao.getAdminUserLogCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSecurityDao.getAdminUserLogList(dto)

        return map;
    }
}
