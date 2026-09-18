package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Group_SearchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.service.MemberService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import kotlin.collections.HashMap

@Service("MemberServiceImpl")
class MemberServiceImpl : MemberService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("MemberDaoImpl")
    private lateinit var memberDao: MemberDao

    override fun getTblTblSum() : Map<String, Any>{
        val map: MutableMap<String, Any> = HashMap()
        val tblmstDto = Tblmi_tbl_mstDto()
        tblmstDto.tbl_grp = UsefulUtils.sessionUser().usr_grp_cd
        val resultTblmst = memberDao.getTblmimst(tblmstDto)
        if(resultTblmst != null){
            //member table 정보(total cnt, send cnt 정보등 가져오기) (tblmi_tbl_sum)
            val tblSumDto = Tblmi_tbl_sumDto()
            tblSumDto.tbl_id = resultTblmst.tbl_id
            val sumCheck = memberDao.getTblTblSum(tblSumDto)
            if(sumCheck != null){
                map["tblSum"] = sumCheck
                map["tblSumCk"] = true
            }else{
                map["tblSumCk"] = false
            }
        }else{
            map["tblSumCk"] = false
        }
        return map
    }
    
    
    override fun selectGroupList(groupListDto: Tblmi_group_listDto): MutableMap<String, Any> {
        val groupListDtoCopy = groupListDto as Group_SearchDto

        if (groupListDtoCopy.pageNo == null) {
            groupListDtoCopy.pageNo = 1
        }

        // SearchType 에 따른 값 설정
        if (groupListDtoCopy.searchType == "grp_nm") {
            groupListDtoCopy.grp_nm = groupListDtoCopy.searchValue
        } else if (groupListDtoCopy.searchType == "use_yn") {
            groupListDtoCopy.use_yn = groupListDtoCopy.searchValue
        }

        groupListDtoCopy.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(groupListDtoCopy.pageNo, 10, 10)

        groupListDtoCopy.firstIndex = paginationInfo.firstRecordIndex
        groupListDtoCopy.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = memberDao.selectGroupListCnt(groupListDtoCopy)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = memberDao.selectGroupList(groupListDtoCopy)
        paramMap["listCnt"] = paginationInfo.totalRecordCount

        return paramMap
    }
    
    override fun selectGroupListCnt(groupListDto: Tblmi_group_listDto): Int {
        groupListDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return memberDao.selectGroupListCnt(groupListDto)
    }
}








