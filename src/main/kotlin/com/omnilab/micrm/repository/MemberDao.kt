package com.omnilab.micrm.repository

import com.omnilab.micrm.model.table.*
import org.springframework.web.multipart.MultipartFile
import java.io.InputStream

interface MemberDao {

    fun insertGroup(groupListDto : Tblmi_group_listDto)

    fun insertGroupUser(groupUserList : List<Tblmi_group_usrDto>)

    fun selectGroupUserListCnt(groupUserDto : Tblmi_group_usrDto) : Int

    fun updateGroupList(groupListDto: Tblmi_group_listDto)

    fun deleteGrpUser(groupUserDto : Tblmi_group_usrDto)

    fun getTblmimst(dto : Tblmi_tbl_mstDto) : Tblmi_tbl_mstDto?

    fun getTblInfoList(dto : Tblmi_tbl_infoDto) : List<Tblmi_tbl_infoDto>

    fun getTblTblSum(dto : Tblmi_tbl_sumDto) : Tblmi_tbl_sumDto?

    // 트랜잭션 처리를 위한 멤버 타겟 서비스 저장
    fun insertTargetGrp(file : MultipartFile, excel_file: InputStream, dto: Tblmi_group_usrDto) : Map<String,Any>

}