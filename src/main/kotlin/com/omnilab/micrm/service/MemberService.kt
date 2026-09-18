package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_group_listDto

interface MemberService {
    fun getTblTblSum() : Map<String, Any>
    fun selectGroupList(groupListDto : Tblmi_group_listDto) : MutableMap<String,Any>
    fun selectGroupListCnt(groupListDto: Tblmi_group_listDto) : Int
}