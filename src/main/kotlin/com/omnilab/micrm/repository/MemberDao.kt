package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Tblmi_tbl_searchDto
import com.omnilab.micrm.model.table.*
import org.apache.poi.ss.usermodel.Workbook
import org.springframework.web.multipart.MultipartFile
import java.io.InputStream

interface MemberDao {

    fun insertGroup(groupListDto : Tblmi_group_listDto)

    fun insertGroupUser(groupUserList : List<Tblmi_group_usrDto>)

    // 업로드 그룹 한개 가져오기
    fun selectOneGroup(groupListDto : Tblmi_group_listDto) : Tblmi_group_listDto

    // 업로드 그룹 리스트
    fun selectGroupList(groupListDto : Tblmi_group_listDto) : List<Tblmi_group_listDto>

    fun selectGroupUserList(groupUserDto : Tblmi_group_usrDto) : List<Tblmi_group_listDto>

    fun selectGroupListCnt(groupListDto: Tblmi_group_listDto) : Int

    fun selectGroupUserListCnt(groupUserDto : Tblmi_group_usrDto) : Int

    // 그룹 유저 한개 가져오기
    fun selectOneGroupUser(groupUserDto : Tblmi_group_usrDto) : Tblmi_group_usrDto

    fun isExistGrpNam(groupListDto: Tblmi_group_listDto) : Int

    fun selectGroupUserCnt(groupUserDto: Tblmi_group_usrDto) : Int

    fun updateGroupList(groupListDto: Tblmi_group_listDto)

    fun updateGroupState(groupListDto : Tblmi_group_listDto)

    fun deleteGrpList(groupList: List<Tblmi_group_listDto>)

    fun deleteGrpAllList(groupListDto: Tblmi_group_listDto)

    fun deleteGrpUserList(groupUserList: List<Tblmi_group_usrDto>)

    fun deleteGrpUserAllList(groupUserDto: Tblmi_group_usrDto)

    fun deleteGrpUser(groupUserDto : Tblmi_group_usrDto)

    fun excelDownGrpUserList(book : Workbook , groupUserDto : Tblmi_group_usrDto)

    fun getTblmiSupListCnt(dto : Tblmi_supDto) : Int

    fun getTblmiSupList(dto : Tblmi_supDto) : List<Tblmi_supDto>

    fun saveTblmiSupList(dto : Tblmi_supDto) : Int

    fun saveTblmiSupList(dtoList : List<Tblmi_supDto>) : Int

    fun updateTblmiSupList(dto : Tblmi_supDto) : Int

    fun downloadTblmiSup(book : Workbook, dto : Tblmi_supDto)

    fun getTblmimst(dto : Tblmi_tbl_mstDto) : Tblmi_tbl_mstDto?

    fun getTblInfoList(dto : Tblmi_tbl_infoDto) : List<Tblmi_tbl_infoDto>

    fun getTblTblSum(dto : Tblmi_tbl_sumDto) : Tblmi_tbl_sumDto?

    fun getTblTblList(dto : Tblmi_tbl_listDto) : List<Tblmi_tbl_listDto>

    fun getTblTblListCnt(dto :Tblmi_tbl_listDto) : Int

    fun downloadTblmiList(book : Workbook, dto : Tblmi_tbl_listDto)

    // 그룹 유저 한개 저장하기
    fun insertOneTargetUser(dto : Tblmi_group_usrDto) : Int

    // 트랜잭션 처리를 위한 멤버 타겟 서비스 저장
    fun insertTargetGrp(file : MultipartFile, excel_file: InputStream, dto: Tblmi_group_usrDto) : Map<String,Any>

}