package com.omnilab.micrm.service

import com.omnilab.micrm.model.Tblmi_tbl_searchDto
import com.omnilab.micrm.model.table.*
import org.springframework.web.multipart.MultipartFile

interface MemberService {

    //fun insertGroup(groupListDto : Tblmi_group_listDto) : MutableMap<String,String>

    fun insertGroup(groupListDto : Tblmi_group_listDto) : String

//    fun insertGroupUser(grpUserData: MultipartFile , groupSeq : Int) : MutableMap<String,String>

    fun insertGroupUser(groupListDto : Tblmi_group_listDto) : String

    // 업로드 그룹 한개 가져오기
    fun selectOneGroup(groupListDto : Tblmi_group_listDto) : Tblmi_group_listDto

    fun selectGroupList(groupListDto : Tblmi_group_listDto) : MutableMap<String,Any>

    fun selectGroupUserList(groupUserDto : Tblmi_group_usrDto) : MutableMap<String,Any>

    fun isExistGrpNam(groupListDto: Tblmi_group_listDto) : Int

    fun selectGroupListCnt(groupListDto: Tblmi_group_listDto) : Int

    fun selectGroupUserListCnt(groupUserDto : Tblmi_group_usrDto) : Int

    fun updateGroupState(groupListDto : Tblmi_group_listDto) : MutableMap<String,String>

    fun deleteGrpList(grpNoList: MutableList<String>) : MutableMap<String,String>

    fun deleteGrpAllList(groupListDto: Tblmi_group_listDto) : MutableMap<String,String>

    fun deleteGrpUserList(grpNoList: MutableList<String>) : MutableMap<String,String>

    fun deleteGrpUserAllList(groupUserDto : Tblmi_group_usrDto) : MutableMap<String,String>

    fun excelDownGrpUserList(groupUserDto : Tblmi_group_usrDto) : MutableMap<String,Any>

    fun getTblmiSupList(sdto : Tblmi_supDto) : MutableMap<String,Any>

    fun saveTblmiSupList(dto : Tblmi_supDto) : MutableMap<String,Any>

    fun deleteTblmiSupList(sdto : Tblmi_supDto) : MutableMap<String,Any>

    fun deleteTblmiSupList(list : MutableList<Int>) : MutableMap<String,Any>

    fun tblmiSupFormCheck(file : MultipartFile) : MutableMap<String,Any>

    fun saveTblmiSupForm(file : MultipartFile) : MutableMap<String,Any>

    fun downloadTblmiSup(sdto: Tblmi_supDto) : MutableMap<String,Any>

    fun importExcel(file :MultipartFile, groupListDto : Tblmi_group_listDto) : MutableMap<String,Any>

    fun importDetailExcel(file : MultipartFile, groupListDto: Tblmi_group_listDto) : Map<String,Any>

    fun getTblmimst(pdto: Tblmi_tbl_listDto) : MutableMap<String,Any>

    fun getTblTblList(pdto: Tblmi_tbl_listDto) : MutableMap<String,Any>

    fun downloadTblmiList(pdto: Tblmi_tbl_listDto) : MutableMap<String,Any>

    // 타겟 유저 한개 Insert
    fun insertOneTargetUser(dto : Tblmi_group_usrDto) : Map<String,Any>

    fun insertTargetMimeCheck(file : MultipartFile , groupUserDto: Tblmi_group_usrDto) : Map<String,Any>

    // 타겟 유저 엑셀 업로드
    //fun insertTargetGrp(file : MultipartFile , groupUserDto: Tblmi_group_usrDto) : Map<String,Any>

    fun getTblTblSum() : Map<String, Any>
}