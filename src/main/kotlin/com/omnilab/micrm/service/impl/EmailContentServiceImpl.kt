package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.ContentDao
import com.omnilab.micrm.service.ContentService
import com.omnilab.micrm.service.ImgParsing
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.apache.commons.io.FilenameUtils
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.io.File
import java.io.IOException
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

@Service("EmailContentServiceImpl")
class EmailContentServiceImpl : ContentService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${upload.content}")
    private val filePath: String? = null

    @Autowired
    @Qualifier("ContentDaoImpl")
    private lateinit var contentDao: ContentDao

    @Autowired
    private val img: ImgParsing? = null

    override fun selectContentView(dto: Tblmi_cont_mstDto):Map<String,Any>{
        val viewDto = dto as Contents_searchDto

        // SearchValue 설정
        if(viewDto.searchType == "cont_nm") {
            viewDto.cont_nm = viewDto.searchValue
        } else if(viewDto.searchType == "cont_sub") {
            viewDto.cont_sub = viewDto.searchValue
        }

        val map: MutableMap<String, Any> = HashMap()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        viewDto.cont_grp_cd = userInfo.usr_grp_cd
        viewDto.ch_tp = "CH01"
        viewDto.cont_tp = "DMTP01"
        var paginationInfo = UsefulUtils.makePage(viewDto.pageNo, 4, 4)
        val paramMap: MutableMap<String, Any> = HashMap()
        viewDto.firstIndex = paginationInfo.firstRecordIndex
        viewDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.getEmdListCnt(viewDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        val result_list = contentDao.getEmdList(viewDto)
        for(i in result_list){
            i.cont_body = i.cont_body?.replace("&lt;", "<")
            i.cont_body = i.cont_body?.replace("&gt;", ">")
            i.cont_body = i.cont_body?.replace("&amp;nbsp;", " ")
            i.cont_body = i.cont_body?.replace("&quot;", "\"")
        }
        paramMap["list"] = result_list
        paramMap["listCnt"] =  paginationInfo.totalRecordCount

        //더보기 버튼을 위한 다음 페이지 내용 유무 확인
        paramMap["nextCk"] = paginationInfo.currentPageNo != paginationInfo.lastPageNo
        return paramMap

    }

    override fun selectOneContentView(dto:Tblmi_cont_mstDto):Map<String,Any>{
        val viewDto = dto as Contents_searchDto
        val map: MutableMap<String, Any> = HashMap()
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        viewDto.cont_grp_cd = userInfo.usr_grp_cd
        viewDto.ch_tp = "CH01"
        viewDto.cont_tp = "DMTP01"

        val result_list = contentDao.getEmdOne(viewDto)
        result_list.cont_body = result_list.cont_body?.replace("&lt;", "<")
        result_list.cont_body = result_list.cont_body?.replace("&gt;", ">")
        result_list.cont_body = result_list.cont_body?.replace("&amp;nbsp;", " ")
        result_list.cont_body = result_list.cont_body?.replace("&quot;", "\"")
        val paramMap: MutableMap<String, Any> = HashMap()

        paramMap["list"] = result_list
        return paramMap

    }

    override fun updateContentMst(dto: Tblmi_cont_mstDto) :Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        dto.cont_grp_cd = userInfo.usr_grp_cd
        dto.upd_id = userInfo.usr_id
        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["updateCnt"]=  contentDao.updateEdmMstList(dto)
        return paramMap
    }

    override fun updateContentsMstDelYn(list: MutableList<Int>): MutableMap<String,Any>{
        val temp_dto: Tblmi_cont_mstDto = Tblmi_cont_mstDto()
        val use_id = UsefulUtils.sessionUser().usr_id
        var updateCnt = 0;
        for (i in list) {
            temp_dto.seq = i
            temp_dto.del_yn = "Y"
            temp_dto.upd_id = use_id
            contentDao.updateEdmMstList(temp_dto)
            updateCnt++
        }
        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["message"] = updateCnt
        return paramMap
    }

    override fun insertContentList(dto: Tblmi_cont_lstDto): Map<String, Any> {
        val tblmiContLstdto = dto as Content_list_CreateDto
        val map: MutableMap<String, Any> = HashMap();
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val usr_id = userInfo.usr_id
        val usr_grp_cd = userInfo.usr_grp_cd
        val tblmiContMstdto : Tblmi_cont_mstDto = Tblmi_cont_mstDto()
        try {
            tblmiContMstdto.reg_id = usr_id
            tblmiContMstdto.cont_grp_cd = usr_grp_cd
            tblmiContMstdto.ch_tp = "CH01"
            tblmiContMstdto.cont_nm = dto.cont_nm
            if (contentDao.insertContentMaster(tblmiContMstdto) == 0) {
                //master table 저장 오류시
                map["result"] = false
            } else {
                tblmiContLstdto.cont_cd = tblmiContMstdto.seq
                tblmiContLstdto.reg_id = usr_id
                tblmiContLstdto.cont_grp_cd = usr_grp_cd
                tblmiContLstdto.cont_tp = "DMTP01"
                tblmiContLstdto.msg_tp = "DMCH101"
                if (tblmiContLstdto.br_yn == null) {
                    tblmiContLstdto.br_yn = "N"
                }
                if (tblmiContLstdto.sup_yn == null) {
                    tblmiContLstdto.sup_yn = "N"
                }
                map["br_yn"] = tblmiContLstdto.br_yn.toString()
                map["sup_yn"] = tblmiContLstdto.sup_yn.toString()
                map["cont_top_body"] = tblmiContLstdto.cont_top_body.toString()
                val thumbfilePath = "$filePath/thumbnail/$usr_grp_cd"

                var f = File(FilenameUtils.normalize(thumbfilePath))
                if (!f.exists()) {
                    f.mkdirs()
                }
                val temp_path: String = "$filePath/temp/$usr_grp_cd"
                f = File(FilenameUtils.normalize(temp_path))
                if (!f.exists()) {
                    f.mkdirs()
                }
                var filename =filePath +"/thumbnail/$usr_grp_cd/" + CommonUtils.getRandString16() + ".png";
                map["filename"] = filename

                filename = "/"+filename.substring(filename.lastIndexOf("image"))
                tblmiContLstdto.thm_url = filename
                tblmiContLstdto.use_yn = "Y"
                contentDao.insertContent(tblmiContLstdto)
                val lstSeq = tblmiContLstdto.seq
                if(!tblmiContLstdto.url.isNullOrEmpty()){
                    val len = tblmiContLstdto.url!!.size -1

                    for (i: Int in 0 ..len) {
                        val contUrlDto : Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                        contUrlDto.cont_lst_cd = lstSeq
                        contUrlDto.url = tblmiContLstdto.url!![i]
                        contUrlDto.url_id = tblmiContLstdto.url_id!![i]
                        contUrlDto.url_tag = tblmiContLstdto.url_tag!![i]
                        //현재 미사용
                        //contUrlDto.url_type = tblmiContLstdto.url_type!![i]
                        contentDao.insertContentUrl(contUrlDto)
                    }
                }
                map["result"] = true
                if (tblmiContLstdto.cont_body != null) {
                    var return_body = tblmiContLstdto.cont_body!!.replace("&lt;", "<")
                    return_body = return_body.replace("&gt;", ">")
                    return_body = return_body.replace("&amp;nbsp;", " ")
                    return_body = return_body.replace("&quot;", "\"")
                    map["cont_body"] = return_body
                    val partMap = img!!.parse(return_body, temp_path) !!
                    map["temp"] = partMap["temp"] as Any
                    map["list"] = partMap["list"] as Any
                } else {
                    map["result"] = false
                }
            }
            return map
        } catch (e: Exception) {
            if (tblmiContLstdto.seq!! > 0) {
                //delete mst, list
            }
            map["result"] = false
            return map
        }

    }

   override fun updateContentLst(dto: Tblmi_cont_lstDto): MutableMap<String, Any> {
       val tblmiContLstdto = dto as Content_list_CreateDto
        val map: MutableMap<String, Any> = HashMap();
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val usr_id = userInfo.usr_id
        val usr_grp_cd = userInfo.usr_grp_cd
        try {
            var tempMstDto : Tblmi_cont_mstDto = Tblmi_cont_mstDto()
            tempMstDto.reg_id = usr_id
            tempMstDto.cont_grp_cd = dto.cont_grp_cd
            tempMstDto.upd_id = usr_id
            tempMstDto.seq = dto.seq
            tempMstDto.cont_nm = dto.cont_nm
            //TODO 업데이트
            if (contentDao.updateEdmMstList(tempMstDto) == 0) {
                //master table 저장 오류시
                map["result"] = 0
            } else {
                map["result"] = 2 //body 변경없음 또는 null
                val listEmdList = contentDao.getEmdOne(tempMstDto)
                tblmiContLstdto.seq = dto.list_seq?.get(0)
                tblmiContLstdto.cont_cd = tempMstDto.seq
                tblmiContLstdto.upd_id = usr_id
                if(!listEmdList.cont_body.equals(tblmiContLstdto.cont_body) || !listEmdList.br_yn.equals(tblmiContLstdto.br_yn)||!listEmdList.sup_yn.equals(tblmiContLstdto.sup_yn)||!listEmdList.cont_top_body.equals(tblmiContLstdto.cont_top_body)){
                    map["br_yn"] = tblmiContLstdto.br_yn.toString()
                    map["sup_yn"] = tblmiContLstdto.sup_yn.toString()
                    map["cont_top_body"] = tblmiContLstdto.cont_top_body.toString()
                    val thumbfilePath = "$filePath/thumbnail/$usr_grp_cd"

                    var f = File(FilenameUtils.normalize(thumbfilePath))
                    if (!f.exists()) {
                        f.mkdirs()
                    }
                    val temp_path: String = "$filePath/temp/$usr_grp_cd"
                    f = File(FilenameUtils.normalize(temp_path))
                    if (!f.exists()) {
                        f.mkdirs()
                    }
                    var filename =filePath +"/thumbnail/$usr_grp_cd/" + CommonUtils.getRandString16() + ".png";
                    map["filename"] = filename

                    filename = "/"+filename.substring(filename.lastIndexOf("image"))
                    tblmiContLstdto.thm_url = filename

                    if (tblmiContLstdto.cont_body != null) {
                        var return_body = tblmiContLstdto.cont_body!!.replace("&lt;", "<")
                        return_body = return_body.replace("&gt;", ">")
                        return_body = return_body.replace("&amp;nbsp;", " ")
                        return_body = return_body.replace("&quot;", "\"")
                        map["cont_body"] = return_body
                        val partMap = img!!.parse(return_body, temp_path)
                        map["temp"] = partMap!!["temp"] as Any
                        map["list"] = partMap["list"] as Any
                        map["result"] = 1
                    }

                    map["br_yn"] = tblmiContLstdto.br_yn.toString()
                    map["sup_yn"] = tblmiContLstdto.sup_yn.toString()
                    map["cont_top_body"] = tblmiContLstdto.cont_top_body.toString()
                }
                contentDao.updateEdmList(tblmiContLstdto)

                val lstSeq = tblmiContLstdto.seq
                if(!tblmiContLstdto.url.isNullOrEmpty()){
                    val len = tblmiContLstdto.url!!.size -1

                    for (i: Int in 0 ..len) {
                        val contUrlDto : Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                        contUrlDto.cont_lst_cd = lstSeq
                        contUrlDto.url = tblmiContLstdto.url!![i]
                        contUrlDto.url_id = tblmiContLstdto.url_id!![i]
                        contUrlDto.url_tag = tblmiContLstdto.url_tag!![i]
                        //현재 미사용
                        //contUrlDto.url_type = tblmiContLstdto.url_type!![i]

                        contentDao.insertContentUrl(contUrlDto)
                    }
                }
            }
            return map
        } catch (e: Exception) {
            logger.error("[" + CommonUtils.getDateTimeNow().toString() + "] ", e)
            map["result"] = 0
            return map
        }

    }

    override fun checkContNm(dto:Tblmi_cont_mstDto):Int {
        dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return contentDao.checkContNm(dto);
    }

    /**
     * @Method Name  : selectSenderList
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : tblmiSetLstDto: Tblmi_set_lstDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 발신자 리스트 가져오기
     * @title : 발신자 리스트 가져오기
     */
    override fun selectSenderList(dto: Tblmi_set_lstDto): Map<String, Any> {

        val searchDto = dto as SetLst_searchDto
        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(searchDto.pageNo, 10, 5)

        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.selectSenderListCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = contentDao.selectSenderList(searchDto)
        paramMap["listCnt"] = contentDao.selectSenderListCnt(searchDto)

        return paramMap
    }

    override fun isCheckSender():Map<String,Any>{
        val paramMap: MutableMap<String, Any> = HashMap()
        return paramMap
    }

    override fun contentsThumbnailSave(map: MutableMap<String, Any>): Boolean {
        try {
            val file = map["file"] as MultipartFile?
            val path = FilenameUtils.getFullPath(map["filename"].toString())
            val filename = FilenameUtils.getName(map["filename"].toString())
            /*if (CommonUtils.isEmptyObject(filename)) {
            }*/
            val f = File(FilenameUtils.getFullPath(path), FilenameUtils.getName(filename))
            val forder = File(FilenameUtils.normalize(path))
            if (!forder.exists()) {
                forder.mkdirs()
            }
            if (f.exists()) {
                if(!f.delete()){
                    logger.error("${f.name} 파일이 존재 하지 않습니다.")
                }
            }
            file!!.transferTo(f)
        } catch (e: IllegalStateException) {
            logger.error("IllegalStateException 썸네일 저장 실패 : $e")
            return false
        } catch (e: IOException) {
            logger.error("IOException 썸네일 저장 실패 : $e")
            return false
        }
        val templist: List<String>? = map["templist"] as ArrayList<String>?
        var f: File?
        for (a in templist!!) {
            f = File(FilenameUtils.normalize(a))
            if (f.exists()) {
                if(!f.delete()){
                    logger.error("${f.name} 파일이 존재 하지 않습니다.")
                }
            }
        }
        return true
    }

    override fun selectRejectTextList(smsDto: SetLst_searchDto): Map<String, Any> {
        TODO("Not yet implemented")
    }

    override fun previewJsonService(dto: Tblmi_cont_lstDto): Map<String, Any> {
        TODO("Not yet implemented")
    }

}