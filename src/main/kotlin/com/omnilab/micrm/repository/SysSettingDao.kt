package com.omnilab.micrm.repository

import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.*

interface SysSettingDao {

    fun insertNoticeFile(dto: Tblmi_noti_fileDto) : Int

    fun getMailSettingListCnt(dto: Tblmi_set_lstDto) : Int

    fun getMailSettingList(dto: Tblmi_set_lstDto) : List<Tblmi_set_lstDto>

    fun getCommCD(dto: Tblmi_comm_cdDto) : Tblmi_comm_cdDto?

    fun getCommCDList(dto: Tblmi_comm_cdDto) : List<Tblmi_comm_cdDto>

    fun getCommCdKeyValueNull (dto: Tblmi_comm_cdDto) : Tblmi_comm_cdDto?

    fun getCommCDLst(dto: Tblmi_comm_cdDto) : List<Tblmi_comm_cdDto>

    fun updateSetLstYn(dto : Tblmi_set_lstDto) : Int

    fun insertSetLst(dto : Tblmi_set_lstDto) : Int

    fun isExistAddress (dto : Tblmi_set_lstDto) : Int

    fun isExistModifyAddress(dto : Tblmi_set_lstDto) : Int

    fun deleteSetLst(dto : Tblmi_set_lstDto) : Int

    fun updateSetDefultYn(dto : Tblmi_set_lstDto) : Int

    fun getSettingList(dto : Tblmi_set_lstDto) : List<Tblmi_set_lstDto>

    fun getSettingListCnt(dto: Tblmi_set_lstDto) : Int

    fun getDetailLst(dto : Tblmi_set_lstDto) : Tblmi_set_lstDto

    fun updateSetLst(dto: Tblmi_set_lstDto) : Int

    fun getMappingSettingListCnt(dto: Tblmi_set_lstDto) : Int

    fun getMappingSettingList(dto : Tblmi_set_lstDto) : List<Tblmi_set_lstDto>

    fun isExistMapping (dto : Tblmi_set_lstDto) : Int

    fun isExistModifyMapping(dto : Tblmi_set_lstDto) : Int

}