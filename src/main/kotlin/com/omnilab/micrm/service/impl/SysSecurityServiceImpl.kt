package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Block_searchDto
import com.omnilab.micrm.model.UsrHst_searchDto
import com.omnilab.micrm.model.table.Tblmi_block_lstDto
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


    override fun getAdminIpBlock(bDto : Tblmi_block_lstDto):MutableMap<String, Any>{
        val map : MutableMap<String, Any> = HashMap()

        val dto = bDto as Block_searchDto
        dto.block_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(dto.pageNo,10,10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSecurityDao.getAdminIpBlockListCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSecurityDao.getAdminIpBlockList(dto);

        return map;
    }

    override fun updateBlockLst(bDto : Tblmi_block_lstDto):MutableMap<String, Any>{
        val map : MutableMap<String, Any> = HashMap()
        val dto = bDto as Block_searchDto
        dto.block_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.upd_id = UsefulUtils.sessionUser().usr_id
        if(sysSecurityDao.updateBlockLst(dto) > 0){
            map["status"] = true
        }else{
            map["status"] = false
        }
        return map
    }

    override fun saveBlockList(bDto : Tblmi_block_lstDto):MutableMap<String, Any>{
        val map : MutableMap<String, Any> = HashMap()
        val dto = bDto as Block_searchDto
        dto.block_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.reg_id = UsefulUtils.sessionUser().usr_id
        dto.block_reg_usr =  dto.reg_id
        if(sysSecurityDao.saveBlockList(dto) > 0){
            map["status"] = true
            map["message"] = "IP가 추가되었습니다."
        }else{
            map["status"] = false
            map["message"] = "오류가 발생하였습니다. 관리자에게 문의해주세요."
        }
        return map
    }

    override fun getAdminUserLog(uDto : Tblmi_usr_hstDto):MutableMap<String, Any>{
        val map : MutableMap<String, Any> = HashMap()
        val dto = uDto as UsrHst_searchDto
        dto.usr_grp_cd =UsefulUtils.sessionUser().usr_grp_cd
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(dto.pageNo,10,10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSecurityDao.getAdminUserLogCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSecurityDao.getAdminUserLogList(dto);

        return map;
    }

    override fun checkduplicateIp(bDto: Tblmi_block_lstDto):MutableMap<String, Any>{
        val map : MutableMap<String, Any> = HashMap()
        val dto:Block_searchDto = Block_searchDto()
        dto.block_target = bDto.block_target
        val resultList = sysSecurityDao.getIpBlockList(dto);
        if(resultList.size > 0){
                if(resultList[0].block_status.equals("0")){
                    map["status"] = 0
                    map["message"] = "이미 등록된 IP입니다."
                }else if(resultList[0].block_status.equals("2") || resultList[0].block_status.equals("1")){
                    map["status"] = 2
                }
        }else{
            map["status"] = 1
            map["message"] = "중복 없음."
        }
        return map
    }
}
