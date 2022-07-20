package com.omnilab.micrm.service

import com.omnilab.micrm.model.Tblmi_tbl_searchDto
import com.omnilab.micrm.model.table.*
import org.springframework.web.multipart.MultipartFile

interface MemberService {

    //fun insertGroup(groupListDto : Tblmi_group_listDto) : MutableMap<String,String>

    fun insertGroup(groupListDto : Tblmi_group_listDto) : String

//    fun insertGroupUser(grpUserData: MultipartFile , groupSeq : Int) : MutableMap<String,String>

    fun insertGroupUser(groupListDto : Tblmi_group_listDto) : String

    // 타겟 유저 엑셀 업로드
    //fun insertTargetGrp(file : MultipartFile , groupUserDto: Tblmi_group_usrDto) : Map<String,Any>

    fun getTblTblSum() : Map<String, Any>
}