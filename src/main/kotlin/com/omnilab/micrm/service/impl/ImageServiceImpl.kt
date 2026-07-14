package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Image_searchDto
import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import com.omnilab.micrm.repository.ContentDao
import com.omnilab.micrm.service.ImageService
import com.omnilab.micrm.service.KkoRestApiService
import org.apache.commons.io.FilenameUtils
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.util.MimeTypeUtils
import org.springframework.web.multipart.MultipartFile
import java.awt.Image
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO

@Service("ImageServiceImpl")
class ImageServiceImpl : ImageService {

    @Autowired
    @Qualifier("ContentDaoImpl")
    private lateinit var contentDao: ContentDao

    @Value("\${upload.content}")
    lateinit var filePath: String

    @Autowired
    lateinit var fileUpload: FileUploadUtils

    @Autowired
    @Qualifier("KkoRestApiServiceImpl")
    lateinit var kkoRestApiService: KkoRestApiService

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
    override fun getImgNmCh(dto: Tblmi_cont_imgDto): Int {
        val idto: Tblmi_cont_imgDto = Tblmi_cont_imgDto()
        idto.img_nm = dto.img_nm
        idto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return contentDao.getImgNmCh(idto)
    }

    override fun mobileUpload(file: MultipartFile, dto: Tblmi_cont_imgDto): Map<String, Any> {
        var map: MutableMap<String, Any> = hashMapOf()

        // 1. 이미지명 중복 체크
        val imgNmCh = getImgNmCh(dto)
        if (imgNmCh > 0) {
            map["imgCheck"] = 0
            map["imgCheckErr"] = "중복된 이미지명입니다."
            return map
        }

        val image: BufferedImage = ImageIO.read(file.inputStream)
        val imgWidth: Int = image.width
        val imgHeight: Int = image.height
        val fileSize = file.size
        val ratioRaw = imgHeight.toDouble() / imgWidth.toDouble()
        val ratio = Math.round(ratioRaw * 1000) / 1000.0

        // 비율 텍스트 계산 (GCD 활용)
        val common = gcd(imgWidth, imgHeight)
        val ratioText = "${imgWidth / common}:${imgHeight / common}"

        var isValid = true
        var errorMsg = ""
        val max2MB = 2 * 1024 * 1024.toLong()

        val isJpgPng =
            file.contentType == MimeTypeUtils.IMAGE_JPEG_VALUE || file.contentType == MimeTypeUtils.IMAGE_PNG_VALUE
        when (dto.ch_tp) {
            "IMGTP03", "IMGTP14", "IMGTP15" -> {
                if (!isJpgPng) {
                    errorMsg = "jpg, png 파일만 업로드 가능합니다."; isValid = false
                } else if (fileSize > max2MB) {
                    errorMsg = "최대 용량은 2MB입니다."; isValid = false
                } else if (imgWidth < 500) {
                    errorMsg = "가로 길이는 최소 500px 이상이어야 합니다."; isValid = false
                } else if (ratio < 0.5 || ratio > 1.333) {
                    errorMsg = "가로:세로 비율이 2:1 ~ 3:4 또는 세로:가로 비율이 1:2 ~ 4:3 이어야 합니다."; isValid = false
                }
            }
            "IMGTP11" -> {
                if (!isJpgPng) {
                    errorMsg = "jpg, png 파일만 업로드 가능합니다."; isValid = false
                } else if (fileSize > max2MB) {
                    errorMsg = "최대 용량은 2MB입니다."; isValid = false
                } else if (imgWidth < 500) {
                    errorMsg = "가로 길이는 최소 500px 이상이어야 합니다."; isValid = false
                } else if (ratio < 0.5 || ratio > 1.0) {
                    errorMsg = "이미지 비율은 2:1(가로형) 또는 1:1(정사각형) 이여야 합니다."; isValid = false
                }
            }
            "IMGTP12" -> {
                // 비율 딱 0.5 (오차범위 0.01 허용)
                if (!isJpgPng) {
                    errorMsg = "jpg, png 파일만 업로드 가능합니다."; isValid = false
                } else if (fileSize > max2MB) {
                    errorMsg = "최대 용량은 2MB입니다."; isValid = false
                } else if (imgWidth < 500) {
                    errorMsg = "가로 길이는 최소 500px 이상이어야 합니다."; isValid = false
                } else if (Math.abs(ratio - 0.5) > 0.01) {
                    errorMsg = "비율(가로:세로) 2:1 (세로/가로 0.5) 이어야 합니다."; isValid = false
                }
            }
            "IMGTP13" -> {
                // 비율 딱 1.0 (오차범위 0.01 허용)
                if (!isJpgPng) {
                    errorMsg = "jpg, png 파일만 업로드 가능합니다."; isValid = false
                } else if (fileSize > max2MB) {
                    errorMsg = "최대 용량은 2MB입니다."; isValid = false
                } else if (imgWidth < 500) {
                    errorMsg = "가로 길이는 최소 500px 이상이어야 합니다."; isValid = false
                } else if (Math.abs(ratio - 1.0) > 0.01) {
                    errorMsg = "비율(가로:세로) 1:1 이어야 합니다."; isValid = false
                }
            }
            "IMGTP01" -> {
                if (file.contentType != MimeTypeUtils.IMAGE_JPEG_VALUE) {
                    errorMsg = "모바일은 jpg 파일만 업로드 가능 합니다."
                    isValid = false
                }
            }
            else -> {
                // 기타 기본 체크
                if (file.contentType != MimeTypeUtils.IMAGE_JPEG_VALUE &&
                    file.contentType != MimeTypeUtils.IMAGE_PNG_VALUE &&
                    file.contentType != MimeTypeUtils.IMAGE_GIF_VALUE
                ) {
                    errorMsg = "jpg, png, gif 파일만 업로드 가능 합니다."
                    isValid = false
                }
            }
        }

        // 유효성 실패 시 에러 반환
        if (!isValid) {
            map["imgCheck"] = 0
            map["imgCheckErr"] = "$errorMsg (현재 해상도: ${imgWidth}x${imgHeight}, 비율: $ratioText)"
            return map
        }

        try {
            map["imgCheck"] = 1
            val userInfo = UsefulUtils.sessionUser()
            val contentFilePath = filePath + "/" + userInfo.usr_grp_cd
            map = fileUpload.upload(userInfo.usr_grp_cd!!, file)

            if (map["uploaded"].toString() == "0") {
                map["uploaded"] = 0
                map["message"] = "파일 저장에 실패하였습니다."
                return map
            } else {
                if (dto.ch_tp != "IMGTP01" && dto.ch_tp != "IMGTP10") {
                    val fileName = map["file_nm"]
                    if (image.width < 500 || image.height < 250) {
                        val newWidth = 500
                        val newHeight = 500
                        val ratio: Double
                        val w: Int
                        var h: Int
                        if (imgWidth > imgHeight) {
                            ratio = newWidth.toDouble() / imgWidth.toDouble()
                            w = (imgWidth * ratio).toInt()
                            h = (imgHeight * ratio).toInt()
                        } else if (imgHeight > imgWidth) {
                            ratio = newHeight.toDouble() / imgHeight.toDouble()
                            w = (imgWidth * ratio).toInt()
                            h = (imgHeight * ratio).toInt()
                        } else {
                            w = newWidth
                            h = newHeight
                        }
                        if (h < 250) {
                            h = 250
                        }
                        val resizeImage = image.getScaledInstance(w, h, Image.SCALE_SMOOTH)
                        val newImage = BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)
                        val g = newImage.graphics
                        g.drawImage(resizeImage, 0, 0, null)
                        g.dispose()
                        ImageIO.write(newImage,"jpg", File(FilenameUtils.getFullPath("$contentFilePath/$fileName"),FilenameUtils.getName("$contentFilePath/$fileName")))
                        resizeImage.flush()
                        image.flush()
                        newImage.flush()
                    }
                }
                var resultMap: MutableMap<String, Any>? = null
                when (dto.ch_tp) {
                    "IMGTP09" -> resultMap = kkoRestApiService.uploadTmplImg(file)
                    "IMGTP10" -> resultMap = kkoRestApiService.uploadTmplItemImg(file)
                    "IMGTP03", "IMGTP11", "IMGTP12", "IMGTP13", "IMGTP14", "IMGTP15" -> {
                        resultMap = kkoRestApiService.uploadFtImg(file, dto.ch_tp!!)
                    }
                }

                if (!CommonUtils.isEmptyObject(resultMap)) {
                    if (resultMap!!["result"] as Boolean) {
                        val data: MutableMap<String, Any> = resultMap["data"] as MutableMap<String, Any>
                        if (data["code"] == "API_200") {
                            dto.kko_img_url = data["image"].toString()
                        } else if (data["code"] == "0000") {
                            if(dto.ch_tp == "IMGTP03" || dto.ch_tp == "IMGTP11" || dto.ch_tp == "IMGTP12"){
                                dto.kko_img_url = (data["data"] as MutableMap<String, Any>)["image"].toString()
                            }else{
                                val resultObj = data["result"] as? Map<*, *>
                                if(resultObj?.get("success") != null){
                                    val successList = resultObj?.get("success") as? List<Map<*, *>>
                                    val firstUrl = successList?.get(0)?.get("url")?.toString() ?: ""
                                    dto.kko_img_url = firstUrl
                                }else{
                                    map["uploaded"] = 0
                                    map["message"] = "파일 저장에 실패하였습니다."
                                    logger.error("File DB insert fail, {}", data)
                                    return map
                                }
                            }
                        } else {
                            map["uploaded"] = 0
                            map["message"] = "파일 저장에 실패하였습니다."
                            logger.error("File DB insert fail, {}", data)
                            return map
                        }
                    } else {
                        map["uploaded"] = 0
                        map["message"] = "파일 저장에 실패하였습니다."
                        logger.error("File DB insert fail resultMap is empty",)
                        return map
                    }
                }
                dto.reg_id = userInfo.usr_id
                dto.usr_grp_cd = userInfo.usr_grp_cd
                dto.img_org_nm = map["fileName"].toString()
                dto.img_file_nm = map["file_nm"].toString()
                dto.img_url = map["url"].toString()
                val returnMap = contentUpload(dto)
                if (returnMap["message"].toString() == "0") {
                    map["uploaded"] = 0
                    map["message"] = "파일 저장에 실패하였습니다."
                    logger.error("파일 저장에 실패하였습니다. returnMap: {}", returnMap)
                }
            }
        } catch (e: Exception) {
            logger.error("파일 저장에 실패하였습니다. Exception", e)
            map["uploaded"] = 0
            map["message"] = "파일 저장에 실패하였습니다."
            return map
        }
        return map
    }

    private fun gcd(a: Int, b: Int): Int {
        return if (b == 0) a else gcd(b, a % b)
    }
}