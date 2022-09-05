package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.Image_searchDto
import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import com.omnilab.micrm.repository.ContentDao
import com.omnilab.micrm.service.ImageService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service("ImageServiceImpl")
class ImageServiceImpl : ImageService {

    @Autowired
    @Qualifier("ContentDaoImpl")
    private lateinit var contentDao: ContentDao

    val logger = LoggerFactory.getLogger(this::class.java)

    /**
     * @Method Name  : contentUpload
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto: Tblmi_cont_imgDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 컨텐츠 업로드하기
     * @title : 이미지 컨텐츠 업로드
     */
    override fun contentUpload(dto: Tblmi_cont_imgDto): Map<String, Any> {
        dto.use_yn = "Y"
        dto.del_yn = "N"

        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["message"] = contentDao.contentUpload(dto)
        return paramMap
    }

    /**
     * @Method Name  : getImgList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto: Tblmi_cont_imgDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 리스트 가져오기
     * @title : 이미지 리스트
     */

    override fun getImgList(dto: Tblmi_cont_imgDto): Map<String, Any> {

        val paramMap: MutableMap<String, Any> = HashMap()
        val searchDto = dto as Image_searchDto

        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val paginationInfo = UsefulUtils.makePage(searchDto.pageNo, 4, 4)

        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.getImgListCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = contentDao.getImgList(searchDto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount

        //더보기 버튼을 위한 다음 페이지 내용 유무 확인
        paramMap["nextCk"] = paginationInfo.currentPageNo != paginationInfo.lastPageNo
        return paramMap
    }

    /**
     * @Method Name  : selectImgForPopup
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : tblmiContImgdto: Tblmi_cont_imgDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 선택된 이미지 팝업 띄우기
     * @title : 선택 이미지 팝업
     */
    override fun selectImgForPopup(tblmiContImgdto: Tblmi_cont_imgDto): Map<String, Any> {

        // 클릭 값에 따라 이미지가 다르게 보여져야함
        val searchDto = tblmiContImgdto as Image_searchDto
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val paginationInfo = UsefulUtils.makePage(searchDto.pageNo, 4, 4)
        val paramMap: MutableMap<String, Any> = HashMap()

        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.getImgListCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = contentDao.getImgList(searchDto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount

        return paramMap
    }

    /**
     * @Method Name  : deleteImgList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : list: MutableList<Int>
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 리스트 삭제하기
     * @title : 이미지 리스트 삭제
     */
    override fun deleteImgList(list: MutableList<Int>): Map<String, Any> {
        val temp_dto: Tblmi_cont_imgDto = Tblmi_cont_imgDto()
        val user_id = UsefulUtils.sessionUser().usr_id
        var updateCnt = 0;
        for (i in list) {
            temp_dto.seq = i
            temp_dto.del_yn = "Y"
            temp_dto.upd_id = user_id
            contentDao.updateImgList(temp_dto)
            updateCnt++
        }
        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["message"] = updateCnt
        return paramMap
    }


    /**
     * @Method Name  : updateImgYn
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto: Tblmi_cont_imgDto
     * @return   : Int
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 업데이트 YN
     * @title : 이미지 상태 Update YN
     */
    override fun updateImgYn(dto: Tblmi_cont_imgDto): Int {
        return contentDao.updateImgYn(dto)
    }

    /**
     * @Method Name  : getImgNmCh
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto: Tblmi_cont_imgDto
     * @return   : Int
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 명 중복확인
     * @title : 이미지면 중복확인
     */
    override fun getImgNmCh(dto:Tblmi_cont_imgDto): Int{
        val idto : Tblmi_cont_imgDto = Tblmi_cont_imgDto()
        idto.img_nm = dto.img_nm
        idto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return contentDao.getImgNmCh(idto)

    }
}