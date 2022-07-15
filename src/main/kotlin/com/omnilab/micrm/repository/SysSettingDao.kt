package com.omnilab.micrm.repository

import com.omnilab.micrm.model.table.*

interface SysSettingDao {

    fun getNoticeListCnt(dto: Tblmi_notiDto) : Int

    fun getNoticeList(dto: Tblmi_notiDto) : List<Tblmi_notiDto>

    fun saveNotice(dto: Tblmi_notiDto) : Int

    fun deleteNotice(dto: Tblmi_notiDto) : Int

    fun updateNotice(dto: Tblmi_notiDto) : Int

    fun insertNoticeFile(dto: Tblmi_noti_fileDto) : Int

    fun updateNotiFile(dto: Tblmi_noti_fileDto) : Int

    fun getNoticeFileList(dto: Tblmi_noti_fileDto) : List<Tblmi_noti_fileDto>

    fun deleteNoticeFile(dto: Tblmi_noti_fileDto) : Int

    fun getMailSettingListCnt(dto: Tblmi_set_lstDto) : Int

    fun getMailSettingList(dto: Tblmi_set_lstDto) : List<Tblmi_set_lstDto>

    fun getCommCD(dto: Tblmi_comm_cdDto) : Tblmi_comm_cdDto?

    fun getCommCdKeyValueNull (dto: Tblmi_comm_cdDto) : Tblmi_comm_cdDto?

    fun getCommCDLst(dto: Tblmi_comm_cdDto) : List<Tblmi_comm_cdDto>

    fun updateSetLstYn(dto : Tblmi_set_lstDto) : Int

    fun insertSetLst(dto : Tblmi_set_lstDto) : Int

    fun isExistAddress (dto : Tblmi_set_lstDto) : Int

    fun isExistModifyAddress(dto : Tblmi_set_lstDto) : Int

    fun deleteSetLst(dto : Tblmi_set_lstDto) : Int

    fun updateDefultSender(dto : Tblmi_set_lstDto) : Int

    fun getSmsSettingList(dto : Tblmi_set_lstDto) : List<Tblmi_set_lstDto>

    fun getSmsSettingListCnt(dto: Tblmi_set_lstDto) : Int

    fun getDetailLst(dto : Tblmi_set_lstDto) : Tblmi_set_lstDto

    fun updateSetLst(dto: Tblmi_set_lstDto) : Int

    // 테스트 그룹
    fun selectTestGrpLst(dto : Tblmite_target_grp) : List<Tblmite_target_grp>

    fun selectTestGrpLstCnt(dto : Tblmite_target_grp) : Int

    fun updateTestGrp(dto : Tblmite_target_grp) : Int

    fun detailTestGrp(dto : Tblmite_target_grp) : Tblmite_target_grp

    fun selectTestTargetLst(dto : Tblmite_target_lst) : List<Tblmite_target_lst>

    fun selectTestTargetLstCnt(dto : Tblmite_target_lst) : Tblmite_target_grp

    fun insertTestGrp(dto: Tblmite_target_grp) : Int

    fun insertTestTarget(testTargetLst : List<Tblmite_target_lst>)

    // try - catch Exception 발생 시 관련된 TargetLst 데이터 삭제
    fun exceptionDeleteTarget(dto : Tblmite_target_lst) : Int
    
    // 테스트 타겟 그룹 수정 하기
    fun updateTestTarget(dto : Tblmite_target_lst) : Int

    // 테스트 타겟 그룹 회원 수정 하기
    fun updateTestTargetLstOne(dto : Tblmite_target_lst) : Int

    // 테스트 타겟 한 개 저장 하기
    fun insertTargetLstOne(dto : Tblmite_target_lst) : Int

    // 테스트 타겟 그룹 한 개 가져오기
    fun detailTestTarget(dto : Tblmite_target_lst) : Tblmite_target_lst

    // 테스트 타겟 그룹 이메일 , 모바일 카운트 가져 오기
    fun selectTestTargetMobEdmCnt(dto : Tblmite_target_lst) : Tblmite_target_grp


}