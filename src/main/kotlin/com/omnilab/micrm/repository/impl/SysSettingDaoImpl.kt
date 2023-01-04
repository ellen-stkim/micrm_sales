package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.SysSettingDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import java.util.HashMap


@Component("SysSettingDaoImpl")
class SysSettingDaoImpl: SysSettingDao{

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun insertNoticeFile(dto: Tblmi_noti_fileDto) : Int {
        return sqlSession.insert("insertNoticeFile", dto)
    }

    override fun getMailSettingListCnt(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("getMailSettingListCnt", dto);
    }

    override fun getMailSettingList(dto: Tblmi_set_lstDto): List<Tblmi_set_lstDto> {
        return sqlSession.selectList("getMailSettingList", dto);
    }

    override fun getCommCD(dto: Tblmi_comm_cdDto) : Tblmi_comm_cdDto?{
        return sqlSession.selectOne("getCommCD", dto)
    }

    override fun getCommCDList(dto: Tblmi_comm_cdDto): List<Tblmi_comm_cdDto> {
        return sqlSession.selectList("getCommCD", dto)
    }

    override fun getCommCdKeyValueNull(dto: Tblmi_comm_cdDto): Tblmi_comm_cdDto? {
        return sqlSession.selectOne("getCommCD", dto)
    }

    override fun getCommCDLst(dto: Tblmi_comm_cdDto): List<Tblmi_comm_cdDto> {
        return sqlSession.selectList("getCommCD", dto)
    }

    override fun updateSetLstYn(dto: Tblmi_set_lstDto): Int {
        return sqlSession.update("updateSetLstYn",dto)
    }

    override fun insertSetLst(dto: Tblmi_set_lstDto): Int {
        return sqlSession.insert("insertSetLst" , dto)
    }

    override fun isExistAddress(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("isExistAddress", dto)
    }

    override fun isExistModifyAddress(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("isExistModifyAddress",dto)
    }

    override fun deleteSetLst(dto: Tblmi_set_lstDto): Int {
        return sqlSession.update("deleteSetLst",dto)
    }

    override fun updateDefultSender(dto: Tblmi_set_lstDto): Int {
        return sqlSession.update("updateDefaultSender",dto)
    }

    override fun getSettingList(dto: Tblmi_set_lstDto): List<Tblmi_set_lstDto> {
        return sqlSession.selectList("getSettingList", dto);
    }

    override fun getSettingListCnt(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("getSettingListCnt", dto)
    }

    override fun getDetailLst(dto: Tblmi_set_lstDto): Tblmi_set_lstDto {
        return sqlSession.selectOne("detailLst",dto)
    }

    override fun updateSetLst(dto: Tblmi_set_lstDto): Int {
        return sqlSession.update("updateSetLst",dto)
    }

    override fun getMappingSettingListCnt(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("getMappingSettingListCnt", dto)
    }

    override fun getMappingSettingList(dto: Tblmi_set_lstDto): List<Tblmi_set_lstDto> {
        return sqlSession.selectList("getMappingSettingList", dto);
    }

    override fun isExistMapping(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("isExistMapping", dto)
    }

    override fun isExistModifyMapping(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("isExistModifyMapping",dto)
    }


}