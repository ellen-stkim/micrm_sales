package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Content_list_CreateDto
import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.ContentDao
import com.omnilab.micrm.repository.SysSettingDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("ContentDaoImpl")
class ContentDaoImpl : ContentDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    @Autowired
    private lateinit var sysSettingDao : SysSettingDao

    override fun insertContentMaster(tblmiContMstdto: Tblmi_cont_mstDto): Int {
       return sqlSession.insert("insertContentMaster",tblmiContMstdto)
    }

    override fun insertContent(tblmiContLstdto: Tblmi_cont_lstDto): Int {
        return sqlSession.insert("insertContent",tblmiContLstdto)
    }

    override fun insertContentUrl(urlDto: Tblmi_cont_url_lstDto):Int {
        return sqlSession.insert("insertContentUrl", urlDto)
    }
    override fun isCheckMoblieContentNm(tblmiContMstdto: Tblmi_cont_mstDto) : Int {
        return sqlSession.selectOne("isCheckMobileContentNm",tblmiContMstdto)
    }

    override fun selectSenderList(tblmiSetLstDto: Tblmi_set_lstDto): List<Tblmi_set_lstDto> {
        return sqlSession.selectList("selectSetList",tblmiSetLstDto)
    }

    override fun selectSenderListCnt(tblmiSetLstDto: Tblmi_set_lstDto): Int {
        return sqlSession.selectOne("selectSetListCnt",tblmiSetLstDto)
    }

    override fun contentUpload(dto: Tblmi_cont_imgDto) : Int{
        return sqlSession.insert("contentUpload", dto)
    }

   /* override fun selectMobileContent(tblmiContMstdto: Tblmi_cont_mstDto): List<Content_view_Dto> {
        return sqlSession.selectList("selectMobileContent",tblmiContMstdto)
    }*/

    override fun selectMobileContent(tblmiContMstdto: Tblmi_cont_mstDto): List<Tblmi_cont_lstDto> {
        return sqlSession.selectList("selectMobileContent",tblmiContMstdto)
    }

    override fun selectMobileContentCnt(tblmiContMstdto: Tblmi_cont_mstDto): Int {
        return sqlSession.selectOne("selectMobileContentCnt",tblmiContMstdto)
    }

    override fun deleteMobileContent(tblmiContMstdto: Tblmi_cont_mstDto): Int {
        return sqlSession.update("deleteMobileContent", tblmiContMstdto)
    }

    override fun updateMobileUseYn(tblmiContMstdto: Tblmi_cont_mstDto): Int {
        return sqlSession.update("updateMobileUseYn",tblmiContMstdto)
    }

    override fun getImgListCnt(dto: Tblmi_cont_imgDto) : Int{
        return sqlSession.selectOne("getImgListCnt", dto)
    }

    override fun getImgList(dto: Tblmi_cont_imgDto) : List<Tblmi_cont_imgDto>{
        return sqlSession.selectList("getImgList", dto)
    }

    override fun updateImgList(dto: Tblmi_cont_imgDto) : Int{
        return sqlSession.update("updateImgList", dto)
    }

    override fun getEmdList(dto: Tblmi_cont_mstDto) : List<Content_view_Dto>{
        return sqlSession.selectList("getEmdList", dto)
    }

    override fun getEmdOne(dto: Tblmi_cont_mstDto) : Content_view_Dto{
        return sqlSession.selectOne("getEmdOne", dto)
    }

    override fun getEmdListCnt(dto: Tblmi_cont_mstDto) : Int{
        return sqlSession.selectOne("getEmdListCnt", dto)
    }

    override fun updateEdmMstList(dto : Tblmi_cont_mstDto) : Int {
        return sqlSession.update("updateEdmMstList", dto)
    }

    override fun updateEdmList(dto : Tblmi_cont_lstDto) : Int{
        return sqlSession.update("updateEdmList", dto)
    }
    override fun selectMobileContentUseTitle(tblmiContMstdto: Tblmi_cont_mstDto): List<Content_view_Dto> {
        return sqlSession.selectList("selectMobileContentUseTitle",tblmiContMstdto)
    }

    override fun updateImgYn(dto: Tblmi_cont_imgDto) : Int{
       return sqlSession.update("updateImgYn", dto)
    }

    override fun selectImgValue(dto: Tblmi_cont_lstDto): Tblmi_cont_imgDto? {
        val imageDto : Tblmi_cont_imgDto?= sqlSession.selectOne("selectImgValue",dto)
        return imageDto
    }

    override fun detailMobileContent(dto: Tblmi_cont_mstDto): List<Content_view_Dto> {
        return sqlSession.selectList("detailMobileContents",dto)
    }

    override fun checkContNm(dto: Tblmi_cont_mstDto) : Int{
        return sqlSession.selectOne("checkContNm", dto)
    }

    override fun updateMobileMst(dto: Tblmi_cont_mstDto): Int {
        return sqlSession.update("updateMobileContentMst", dto)
    }

    override fun updateMobileContent(dto: Tblmi_cont_lstDto): Int {
        return sqlSession.update("updateMobileContent", dto)
    }

    override fun deleteRealContMst(dto: Tblmi_cont_mstDto): Int {
        return sqlSession.delete("deleteRealContMst", dto)
    }

    override fun deleteRealContLst(dto: Tblmi_cont_lstDto): Int {
        return sqlSession.delete("deleteRealContLst", dto)
    }

    override fun deleteRealContUrl(dto: Tblmi_cont_url_lstDto): Int {
        return sqlSession.delete("deleteRealContUrl",dto)
    }

    override fun selectLstSeq(dto: Tblmi_cont_lstDto): List<Tblmi_cont_lstDto> {
        return sqlSession.selectList("selectLstSeq",dto)
    }
    override fun getImgNmCh(dto: Tblmi_cont_imgDto) : Int{
        return sqlSession.selectOne("getImgNmCh", dto)
    }

    override fun selectMappingList(tblmiSetLstDto: Tblmi_set_lstDto): List<Tblmi_set_lstDto> {
        return sqlSession.selectList("selectMappingList",tblmiSetLstDto)
    }
}