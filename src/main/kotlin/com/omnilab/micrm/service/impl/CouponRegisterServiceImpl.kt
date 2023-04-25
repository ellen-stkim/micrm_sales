package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.*
import com.omnilab.micrm.config.error.CouponException
import com.omnilab.micrm.model.coupon.CouponRegisterDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmicou_categoryDto
import com.omnilab.micrm.model.table.Tblmicou_img_fileDto
import com.omnilab.micrm.repository.CouponDao
import com.omnilab.micrm.service.CouponRegisterService
import org.apache.commons.io.FilenameUtils
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.awt.Image
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO
import javax.servlet.http.HttpServletRequest

@Service
class CouponRegisterServiceImpl: CouponRegisterService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${upload.content}")
    private val filePath: String? = null

    @Autowired
    private lateinit var couponDao: CouponDao

    @Autowired
    private lateinit var fileUploadUtils: FileUploadUtils

    override fun getCategory(grp_cd: String): MutableList<Tblmicou_categoryDto> {
        return couponDao.selectCategory(grp_cd)
    }


    override fun registerCoupon(dto: CouponRegisterDto, request: HttpServletRequest) {

        // 유효성
        validationCouponDto(dto, "register")

        val user = UsefulUtils.sessionUser()
        uploadAndSaveCouponImage(dto, request, user)

        // 쿠폰 정보 입력
        dto.reg_id = user.usr_id.toString()
        dto.usr_grp_cd = user.usr_grp_cd.toString()
        couponDao.insertCoupon(dto)
    }

    override fun updateCoupon(dto: CouponRegisterDto, request: HttpServletRequest) {

        validationCouponDto(dto, "update") // 이미지파일 유효성은 여기서 제외되어야 함.

        val user = UsefulUtils.sessionUser()
        dto.seq = decodingSeq(dto.encodedSeq!!)

        if (!CommonUtils.isEmptyObject(dto.imgFile)) {
            couponDao.deleteImageFile(dto.img_file_seq!!)

            uploadAndSaveCouponImage(dto, request, user)
        }

        dto.upd_id = user.usr_id.toString()
        dto.usr_grp_cd = user.usr_grp_cd.toString()
        couponDao.updateCoupon(dto)
    }

    override fun deleteCoupon(deleteCouponSeq: List<String>) {

        // 복호화
        val decodedCouponSeq: MutableList<Int> = ArrayList()

        deleteCouponSeq.forEach {
            decodedCouponSeq.add(decodingSeq(it))
        }

        couponDao.deleteCoupon(decodedCouponSeq, UsefulUtils.sessionUser().usr_id!!)
    }

    private fun decodingSeq(encodedSeq: String) = AES256.AES_Decode(encodedSeq, GlobalValues.encKey).toInt()

    private fun uploadAndSaveCouponImage(dto: CouponRegisterDto, request: HttpServletRequest, user: Tblmi_usrDto) {
        // 이미지 로컬 저장
        val map = fileUploadUtils.upload(user.usr_grp_cd.toString(), dto.imgFile!!, request)

        // 이미지 resize
        imageResize(dto.imgFile!!, user.usr_grp_cd!!, map)

        // 이미지 정보 DB 수정
        val imgDto = Tblmicou_img_fileDto(
            user.usr_id.toString(),
            map["fileName"].toString(),
            map["file_nm"].toString(),
            map["url"].toString()
        )
        couponDao.insertCouponImage(imgDto)
        dto.img_file_seq = imgDto.seq
    }

    private fun imageResize(file: MultipartFile, usr_grp_cd: String, map: MutableMap<String, Any>) {
        val contentFilePath = "$filePath/$usr_grp_cd"
        val fileName = map["file_nm"]
        val image : BufferedImage = ImageIO.read(file.inputStream)
        val imageWidth: Int = image.width
        val imageHeight: Int = image.height

        val newWidth = 500
        val newHeight = 500
        val ratio: Double
        val w: Int
        var h: Int

        if (imageWidth > imageHeight) {
            ratio = newWidth.toDouble() / imageWidth.toDouble()
            w = (imageWidth * ratio).toInt()
            h = (imageHeight * ratio).toInt()

        } else if (imageHeight > imageWidth) {
            ratio = newHeight.toDouble() / imageHeight.toDouble()
            w = (imageWidth * ratio).toInt()
            h = (imageHeight * ratio).toInt()
        } else {
            w = newWidth
            h = newHeight
        }
//            if (h < 250) {
//                h = 250
//            }
        val resizeImage = image.getScaledInstance(w, h, Image.SCALE_SMOOTH)
        val newImage = BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)
        val g = newImage.graphics
        g.drawImage(resizeImage, 0, 0, null)
        g.dispose()

        ImageIO.write(newImage, "jpg", File(FilenameUtils.getFullPath("$contentFilePath/$fileName"), FilenameUtils.getName("$contentFilePath/$fileName")))
        resizeImage.flush()
        image.flush()
    }

    private fun validationCouponDto(dto: CouponRegisterDto, type: String) {
        if (dto.nm.isNullOrBlank()) throw CouponException(HttpStatus.BAD_REQUEST, "쿠폰명을 입력해주세요.")
        if (CommonUtils.isEmptyObject(dto.category_seq)) throw CouponException(HttpStatus.BAD_REQUEST, "카테고리를 선택해주세요.")
        if (type != "update") {
            if (CommonUtils.isEmptyObject(dto.imgFile)) throw CouponException(HttpStatus.BAD_REQUEST, "이미지를 등록해주세요.")
            else if (!isImageFile(dto.imgFile!!)) { throw CouponException(HttpStatus.BAD_REQUEST, "이미지 형식 파일을 등록해주세요.") }
        } else if (!CommonUtils.isEmptyObject(dto.imgFile) && !isImageFile(dto.imgFile!!)) {
            throw CouponException(HttpStatus.BAD_REQUEST, "이미지 형식 파일을 등록해주세요.")
        }
        if (dto.title.isNullOrBlank()) throw CouponException(HttpStatus.BAD_REQUEST, "Title을 입력해주세요.")
        if (dto.descr.isNullOrBlank()) throw CouponException(HttpStatus.BAD_REQUEST, "Description을 입력해주세요.")
        if (dto.notice.isNullOrBlank()) throw CouponException(HttpStatus.BAD_REQUEST, "Temps & Condition을 입력해주세요.")
        if (CommonUtils.isEmptyObject(dto.expire_date)) throw CouponException(HttpStatus.BAD_REQUEST,"Expiry Date를 선택해주세요.")
        if (CommonUtils.isEmptyObject(dto.expire_time)) throw CouponException(HttpStatus.BAD_REQUEST, "Expiry Time을 선택해주세요.")
        if (CommonUtils.isEmptyObject(dto.daily_start_time)) throw CouponException(HttpStatus.BAD_REQUEST, "Daily Start Time을 선택해주세요.")
        if (CommonUtils.isEmptyObject(dto.daily_end_time)) throw CouponException(HttpStatus.BAD_REQUEST, "Daily End Time을 선택해주세요.")
        if (dto.daily_start_time!!.replace(":", "") > dto.daily_end_time!!.replace(":", "")) {
            throw CouponException(HttpStatus.BAD_REQUEST, "Daily Start Time이 Daily End Time보다 먼저로 수정해주세요.")
        }
        if (dto.daily_start_time!!.replace(":", "") == dto.daily_end_time!!.replace(":", "")) {
            throw CouponException(HttpStatus.BAD_REQUEST, "Daily Time의 시간 간격이 없습니다.")
        }
        if (CommonUtils.isEmptyObject(dto.available_day)) throw CouponException(HttpStatus.BAD_REQUEST, "Date를 선택해주세요.")
        if (dto.content.isNullOrBlank()) throw CouponException(HttpStatus.BAD_REQUEST, "문자 메시지 내용을 입력해주세요.")
        if (!(dto.content ?: "").contains("{쿠폰링크}")) throw CouponException(HttpStatus.BAD_REQUEST, "쿠폰링크를 삽입해주세요.")

    }

    private fun isImageFile(file: MultipartFile): Boolean {
        // content-type 검사
        val imageContentType = listOf("jpeg","jpg","png","bmp","gif")

        // 확장자 검사
        val extPos = file.originalFilename!!.lastIndexOf(".")
        val ext = file.originalFilename!!.substring(extPos + 1).lowercase()

        // 이미지 content-type 검사
        var isImageContentType =  false
        imageContentType.forEach {
            if (file.contentType == "image/${it}") isImageContentType = true
        }
        // 파일 확장자 검사
        var isImageExt = imageContentType.contains(ext)

        return isImageContentType && isImageExt
    }


}