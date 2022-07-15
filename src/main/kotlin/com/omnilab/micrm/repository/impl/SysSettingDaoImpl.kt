package com.omnilab.micrm.repository.impl

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

    override fun getNoticeListCnt(dto: Tblmi_notiDto): Int {
        return sqlSession.selectOne("getNoticeListCnt", dto);
    }

    override fun getNoticeList(dto: Tblmi_notiDto): List<Tblmi_notiDto> {
        return sqlSession.selectList("getNoticeList", dto);
    }

    override fun saveNotice(dto: Tblmi_notiDto) : Int{
        return sqlSession.insert("saveNotice", dto);
    }

    override fun deleteNotice(dto: Tblmi_notiDto) : Int{
        return sqlSession.delete("deleteNotice", dto);
    }

    override fun updateNotice(dto: Tblmi_notiDto) : Int{
        return sqlSession.update("updateNotice", dto);
    }

    override fun insertNoticeFile(dto: Tblmi_noti_fileDto) : Int {
        return sqlSession.insert("insertNoticeFile", dto)
    }

    override fun updateNotiFile(dto: Tblmi_noti_fileDto) : Int{
        return sqlSession.update("updateNotiFile", dto)
    }
    
    override fun getNoticeFileList(dto: Tblmi_noti_fileDto) : List<Tblmi_noti_fileDto>{
        return sqlSession.selectList("getNoticeFileList", dto)
    }

    override fun deleteNoticeFile(dto: Tblmi_noti_fileDto) : Int {
        return sqlSession.delete("deleteNoticeFile", dto)
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

    override fun getSmsSettingList(dto: Tblmi_set_lstDto): List<Tblmi_set_lstDto> {
        return sqlSession.selectList("getMailSettingList", dto);
    }

    override fun getSmsSettingListCnt(dto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("getMailSettingListCnt", dto)
    }

    override fun getDetailLst(dto: Tblmi_set_lstDto): Tblmi_set_lstDto {
        return sqlSession.selectOne("detailLst",dto)
    }

    override fun updateSetLst(dto: Tblmi_set_lstDto): Int {
        return sqlSession.update("updateSetLst",dto)
    }

    override fun selectTestGrpLst(dto: Tblmite_target_grp): List<Tblmite_target_grp> {
        return sqlSession.selectList("selectTestGroupLst", dto)
    }

    override fun selectTestGrpLstCnt(dto: Tblmite_target_grp): Int {
        return sqlSession.selectOne("selectTestGroupLstCnt", dto)
    }

    override fun updateTestGrp(dto: Tblmite_target_grp): Int {
        return sqlSession.update("updateTestGrp", dto)
    }

    override fun detailTestGrp(dto: Tblmite_target_grp): Tblmite_target_grp {
        return sqlSession.selectOne("detailTestGrp", dto)
    }

    override fun selectTestTargetLst(dto: Tblmite_target_lst): List<Tblmite_target_lst> {
        return sqlSession.selectList("selectTestTargetLst",dto)
    }

    override fun selectTestTargetLstCnt(dto: Tblmite_target_lst): Tblmite_target_grp {
        return sqlSession.selectOne("selectTestTargetLstCnt",dto)
    }

    override fun insertTestGrp(dto: Tblmite_target_grp) : Int {
        return sqlSession.insert("insertTestGroup",dto)
    }

    override fun insertTestTarget(testTargetLst: List<Tblmite_target_lst>) {

        val splitNum = 300
        val roopNum = Math.ceil((testTargetLst.size.toFloat() / splitNum).toDouble()).toInt()
        var lastNum: Int

        var paramMap: MutableMap<String, List<Tblmite_target_lst>> = HashMap<String, List<Tblmite_target_lst>>()

        for (i in 0 until roopNum) {
            lastNum = splitNum * (i + 1)
            if (lastNum > testTargetLst.size) lastNum = testTargetLst.size
            logger.warn(lastNum.toString() + " / " + testTargetLst.size)
            paramMap["testTargetLst"] = testTargetLst.subList(i * splitNum, lastNum)
            sqlSession.insert("insertTestTarget", paramMap)
        }
    }

    override fun exceptionDeleteTarget(dto: Tblmite_target_lst) : Int {
        return sqlSession.delete("exceptionDeleteTarget",dto)
    }

    override fun updateTestTarget(dto: Tblmite_target_lst): Int {
        return sqlSession.update("updateTestTarget",dto)
    }

    override fun updateTestTargetLstOne(dto: Tblmite_target_lst): Int {
        return sqlSession.update("updateTestTargetLstOne",dto)
    }

    override fun insertTargetLstOne(dto: Tblmite_target_lst): Int {
        return sqlSession.insert("insertTargetLstOne", dto)
    }

    override fun detailTestTarget(dto: Tblmite_target_lst): Tblmite_target_lst {
        return sqlSession.selectOne("detailTestTarget",dto)
    }

    override fun selectTestTargetMobEdmCnt(dto: Tblmite_target_lst): Tblmite_target_grp {
        return sqlSession.selectOne("selectTestTargetMobEdmCnt", dto)
    }

}