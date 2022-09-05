package com.omnilab.micrm.controller

import com.google.gson.GsonBuilder
import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import com.omnilab.micrm.model.table.Tblmicp_cont_mstDto
import com.omnilab.micrm.repository.SalesforceDao
import com.omnilab.micrm.service.ContentService
import com.omnilab.micrm.service.ImageService
import com.omnilab.micrm.service.SalesforceService
import com.omnilab.micrm.service.SysSettingService
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.impl.crypto.DefaultJwtSignatureValidator
import org.apache.commons.io.FilenameUtils
import org.json.simple.JSONObject
import org.json.simple.parser.JSONParser
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.servlet.ModelAndView
import java.awt.Image
import java.awt.image.BufferedImage
import java.io.File
import java.io.InputStreamReader
import java.util.*
import javax.crypto.spec.SecretKeySpec
import javax.imageio.ImageIO
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession


@Controller
@RequestMapping("/sf")
class SalesforceController {

    val logger = LoggerFactory.getLogger(this::class.java)


    @Value("\${journey-builder.jwt}")
    private val secretKey: String? = null

    @Autowired
    lateinit var salesforceService: SalesforceService;

    @Autowired(required = true)
    @Qualifier("MobileContentServiceImpl")
    private lateinit var mobileContentService: ContentService

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    lateinit var sysSettingService: SysSettingService

    @Autowired(required = true)
    @Qualifier("ImageServiceImpl")
    private lateinit var imageService: ImageService

    @Autowired
    lateinit var fileUpload: FileUploadUtils;

    @Autowired
    @Qualifier("SalesforceDaoImpl")
    lateinit var salesforceDao : SalesforceDao


    @Value("\${upload.content}")
    private val filePath: String? = null

    @ResponseBody
    @GetMapping("/config.json")
    fun configJson(): JSONObject {
        val resource: Resource = ClassPathResource("static/sf/config.json")
        val json: JSONObject = JSONParser().parse(InputStreamReader(resource.inputStream, "UTF-8")) as JSONObject
        return json
    }

    /**
     * @Method Name  : salesIndex.html
     * @Since    : 2022. 08. 03.
     * @author   : SSW
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 세일즈포스 뷰 페이지 조회
     * @title : 세일즈포스 뷰 페이지
     */
    @GetMapping("/index.mi")
    fun mdmCreate(): ModelAndView {
        val view =  ModelAndView("cont/salesforce")
        return view
    }

    // =================================================== Mobile ========================================================= //

    /**
     * @Method Name  : insertMoblieContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : content_list_dto: Content_list_CreateDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 생성하기
     * @title : 모바일 컨텐츠 생성하기
     */

    @ResponseBody
    @PostMapping("/mobileInsert.service")
    fun insertMoblieContent(@ModelAttribute content_list_dto: Content_list_CreateDto, response: HttpServletResponse): Map<String, Any> {
        content_list_dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val statusMap = salesforceService.insertContentList(content_list_dto)
        return statusMap;
    }

    /**
     * @Method Name  : updateMoblieContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : content_list_dto: Content_list_CreateDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 수정하기
     * @title : 모바일 컨텐츠 수정하기
     */

    @ResponseBody
    @PostMapping("/mobileUpdate.service")
    fun updateMoblieContent(@ModelAttribute content_list_dto: Content_list_CreateDto, response: HttpServletResponse): Map<String, Any> {
        content_list_dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val statusMap = salesforceService.updateContentList(content_list_dto)
        return statusMap;
    }

    @ResponseBody
    @PostMapping("/mobileInfo.ajax")
    fun selectMobileContent(@ModelAttribute dto: SalesforceDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = hashMapOf()

        val tblmiContMstdto = Tblmi_cont_mstDto()
        tblmiContMstdto.seq = dto.seq

        val listMap: Map<String, Any> = mobileContentService.selectOneContentView(tblmiContMstdto)
        val cntMap = mobileContentService.isCheckSender()

        statusMap["list"] = listMap["list"] as List<Content_view_Dto>
        statusMap["kakaoCnt"] = cntMap["kakaoCnt"] as Any
        statusMap["smsCnt"] = cntMap["smsCnt"] as Any
        statusMap["rcsCnt"] = cntMap["rcsCnt"] as Any

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
        statusMap["filePath"] = uploadPrefix?.cd_val as String
        return statusMap
    }

    /** @Method Name  : previewService
     * @Since    : 2021. 05. 31.
     * @author   : Grayson
     * @param    : dto : ContentListCreateDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 프리뷰 페이지
     * @title : RCS 프리뷰 페이지
     */

    @PostMapping("/preview.ajax")
    fun previewService(@ModelAttribute dto : Content_list_CreateDto) : ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/mdmPreview")
        //logger.error("preview Dto : " + dto.toString());
        //logger.error("kakaoUrl : " + dto.kko_view_img_url);
        //logger.error("rcsUrl : " + dto.rcs_img_url_1);

        /**
         * RCS의 Json 데이터는 Model 값으로 jsonContent 값을 뿌려준다
         *      (Content_list_CreateDto로 넘어온 값 재 파싱 후 Contents_lstDto 값 )
         * 그 외의 데이터는 Model 값으로 "content" 값을 뿌려 준다
         *      (Content_list_CreateDto 로 넘어온 값 )
         */

        val formatList = dto.formatType
        if(formatList!!.contains("rcs")) {
            // 넘어 오는 Preview 데이터에 RCS가 있으면 파싱후 뿌려 준다 -> RCS Json Parsing
            val map = mobileContentService.previewJsonService(dto);
            //logger.error("jsonContent : " + map["jsonContent"])
            view.addObject("jsonContent", map["jsonContent"])
        }
        view.addObject("content", dto);

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view;
    }

    /**
     * @Method Name  : isCheckTemplateName
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : contMstdto: Tblmi_cont_mstDto
     * @return   : HashMap<String,String>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 이름 중복 체크하기
     * @title : 모바일 컨텐츠 이름 중복 체크 하기
     */
    @ResponseBody
    @PostMapping("/isCheckTmplateNm.ajax")
    fun isCheckTemplateName(@ModelAttribute contMstdto: Tblmi_cont_mstDto) : HashMap<String,String>{

        val result = salesforceService.checkContNm(contMstdto)
        val statusMap = HashMap<String,String>()

        if(result == 0) {
            statusMap["status"] = "true"
            statusMap["message"] = "모바일 컨텐츠 저장이 완료 되었습니다"
        } else {
            statusMap["status"] = "false"
            statusMap["message"] = "중복된 컨텐츠 이름이 존재합니다"
        }
        return statusMap
    }

    /**
     * @Method Name  : selectSenderMobileList
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : tblmiSetLstdto: Tblmi_set_lstDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 발신자 리스트 가져오기
     * @title : 모바일 발신자 리스트 가져오기
     */
    @PostMapping("/senderMobileList.ajax")
    fun selectSenderMobileList(@ModelAttribute dto : SetLst_searchDto): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/senderMobileListAjax")
        val senderMap = salesforceService.selectSenderList(dto)

        view.addObject("list", senderMap["list"])
        view.addObject("page", senderMap["page"])
        view.addObject("pageNo", senderMap["pageNo"])
        view.addObject("listCnt", senderMap["listCnt"])

        return view
    }

    /**
     * @Method Name  : selectSenderList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : tblmiSetLstDto: : SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 팝업 리스트 가져오기
     * @title : 이미지 팝업 리스트 가져오기
     */
    @PostMapping("/mobileImgList.ajax")
    fun selectImgListForPopUp(@ModelAttribute tblmiContImgdto: Image_searchDto): ModelAndView {

        val view = ModelAndView("cont/mobile/ajax/mdmImgListAjax")
        val senderMap = salesforceService.selectImgForPopup(tblmiContImgdto)

        view.addObject("list", senderMap["list"])
        view.addObject("page", senderMap["page"])
        view.addObject("pageNo", senderMap["pageNo"])
        view.addObject("listCnt", senderMap["listCnt"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
    }

    /**
     * @Method Name  : rcsText
     * @Since    : 2021. 05. 11.
     * @author   : Dana
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 텍스트형 페이지
     * @title : RCS 텍스트형 페이지
     */
    @GetMapping("/rcsText.ajax")
    fun rcsText(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/rcsText")
        return view
    }

    /** @Method Name  : rcsVertical
     * @Since    : 2021. 05. 11.
     * @author   : Dana
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 세로형 페이지
     * @title : RCS 세로형 페이지
     */
    @GetMapping("/rcsVertical.ajax")
    fun rcsVertical(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/rcsVertical")
        return view
    }

    /** @Method Name  : rcsSlide
     * @Since    : 2021. 05. 11.
     * @author   : Dana
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 슬라이드형 페이지
     * @title : RCS 슬라이드형 페이지
     */
    @GetMapping("/rcsSlide.ajax")
    fun rcsSlide(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/rcsSlide")
        return view
    }

    /**
     * @Method Name  : contentUpload
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : file: : MultipartFile
     * @param    : dto : Tblmi_cont_imgDto
     * @param    : request : HttpServletRequest
     * @return   :
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 업로드 하기
     * @title : 이미지 업로드
     */
    @ResponseBody
    @RequestMapping("/contentUpload.ajax")
    fun contentUpload(@RequestParam("file") file: MultipartFile?, @ModelAttribute dto: Tblmi_cont_imgDto, request: HttpServletRequest): Map<String, Any> {
        var map: MutableMap<String, Any> = hashMapOf()
        //이미지명 중복 체크 추가.
        val imgNmCh = salesforceService.getImgNmCh(dto)
        if(imgNmCh > 0 ){
            map["imgCheck"] = 0
            map["imgCheckErr"] = "중복된 이미지명입니다."
            return map;
        }
        if (file != null) {
            map["imgCheck"] = 1
            val userInfo = UsefulUtils.sessionUser()
            val contentFilePath = filePath + "/"+ userInfo.usr_grp_cd
            map = fileUpload.upload(contentFilePath, file, request);
            if(map["uploaded"].toString() == "0"){
                logger.info("File Upload fail")
            }else{
                if(dto.ch_tp != "IMGTP01"){
                    val fileName = map["file_nm"]
                    val image : BufferedImage = ImageIO.read(file.inputStream)
                    val imageWidth: Int = image.width
                    val imageHeight: Int = image.width
                    if(imageWidth < 500 || imageHeight < 250) {
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
                        if(h < 250){
                            h = 250
                        }
                        val resizeImage = image.getScaledInstance(w, h, Image.SCALE_SMOOTH)
                        val newImage = BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)
                        val g = newImage.graphics
                        g.drawImage(resizeImage, 0, 0, null)
                        g.dispose()

                        ImageIO.write(newImage, "jpg", File(FilenameUtils.getFullPath(contentFilePath + "/" + fileName), FilenameUtils.getName(contentFilePath + "/" + fileName)))
                        resizeImage.flush()
                        image.flush()
                    }
                }
            }

            dto.reg_id = userInfo.usr_id
            dto.usr_grp_cd = userInfo.usr_grp_cd
            dto.img_org_nm = map["fileName"].toString()
            dto.img_file_nm = map["file_nm"].toString()
            dto.img_url = map["url"].toString()
            val returnMap = imageService.contentUpload(dto)
            if(returnMap["message"].toString() == "0"){
                map["uploaded"] = 0
                map["message"] = "파일 저장에 실패하였습니다."
                logger.info("File DB insert fail")
            }
        }
        return map
    }

    // =================================================== Salesforce ===================================================== //

    /**
     * @Method Name  : getUser
     * @Since    : 2022. 08. 04.
     * @author   : SSW
     * @param    : dto: SalesforceDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 사용자 조회
     * @title : 사용자 조회
     */
    @ResponseBody
    @PostMapping("/getUser.ajax")
    fun getUser(@ModelAttribute dto: SalesforceDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): Map<String, Any> {
        return salesforceService.getUser(dto, session)
    }

    /**
     * @Method Name  : mappingLst
     * @Since    : 2022. 08. 04.
     * @author   : SSW
     * @param    : dto: SalesforceDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 사용자 조회
     * @title : 사용자 조회
     */
    @ResponseBody
    @PostMapping("/mappingLst.ajax")
    fun mappingLst(@ModelAttribute dto: SalesforceDto, session: HttpSession): Map<String, Any> {
        return salesforceService.mappingLst(dto)
    }

    @ResponseBody
    @PostMapping("/save.service")
    fun save(@RequestBody data : MutableMap<String, Any>): ResponseEntity<Any> {
        logger.info("/save.service data: $data")
        val dto = Tblmi_cont_mstDto()
        dto.avo_id = data["activityObjectID"].toString()
        dto.inten_id = data["interactionId"].toString()
        dto.orig_id = data["originalDefinitionId"].toString()
        dto.inta_key = data["interactionKey"].toString()
        dto.inta_ve = data["interactionVersion"].toString()
        val save = salesforceDao.upd_tblmi_cont_mst(dto)
        return if(save == 1){
            ResponseEntity(null, HttpStatus.OK)
        }else{
            ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/publish.service")
    fun publish(@RequestBody data : MutableMap<String, Any>): ResponseEntity<Any> {
        logger.info("/publish.service data: $data")
        val dto = Tblmicp_cont_mstDto()
        dto.avo_id = data["activityObjectID"].toString()
        dto.inten_id = data["interactionId"].toString()
        dto.orig_id = data["originalDefinitionId"].toString()
        dto.inta_key = data["interactionKey"].toString()
        dto.inta_ve = data["interactionVersion"].toString()
        dto.pub_yn = if(data["isPublished"] as Boolean) { "Y" } else { "N" }
        val cont = salesforceService.campaingContent(dto)
        return if(cont) {
            val save = salesforceService.publish(dto)
            if(save){
                ResponseEntity(null, HttpStatus.OK)
            }else{
                ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
            }
        }else{
            ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/unpublish.service")
    fun unpublish(@RequestBody data : MutableMap<String, Any>): ResponseEntity<Any> {
        logger.info("/unpublish.service data: $data")
        val dto = Tblmicp_cont_mstDto()
        dto.avo_id = data["activityObjectID"].toString()
        dto.inten_id = data["interactionId"].toString()
        dto.orig_id = data["originalDefinitionId"].toString()
        dto.inta_key = data["interactionKey"].toString()
        dto.inta_ve = data["interactionVersion"].toString()
        dto.pub_yn = if(data["isPublished"] as Boolean) { "Y" } else { "N" }
        val save = salesforceService.publish(dto)
        return if(save){
            ResponseEntity(null, HttpStatus.OK)
        }else{
            ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/validate.service")
    fun validate(@RequestBody data : MutableMap<String, Any>): ResponseEntity<Any> {
        logger.info("/validate.service data: $data")
        return ResponseEntity(null, HttpStatus.OK)
    }

    @ResponseBody
    @PostMapping("/stop.service")
    fun stop(@RequestBody data : MutableMap<String, Any>) {
        logger.info("/stop.service data: $data")
    }

    @ResponseBody
    @PostMapping("/TestSave.service")
    fun TestSave(@RequestBody data : MutableMap<String, Any>) {
        logger.info("/TestSave.service data: $data");
    }

    // done 동작
    @ResponseBody
    @PostMapping("/execute.service")
    fun execute(req: HttpServletRequest, rep: HttpServletResponse, @RequestBody data: String): ResponseEntity<Any> {
        logger.info("/execute.service data: $data");
        try {
            // jwt
            val chunks: List<String> = data.split(".")
            val decoder: Base64.Decoder = Base64.getUrlDecoder()
            val payload = String(decoder.decode(chunks[1]))
            //logger.info("payload: $payload")

            val sa: SignatureAlgorithm = SignatureAlgorithm.HS256
            val secretKeySpec = SecretKeySpec(secretKey?.toByteArray(), sa.jcaName)
            val tokenWithoutSignature = chunks[0] + "." + chunks[1]
            val signature = chunks[2]
            val validator = DefaultJwtSignatureValidator(sa, secretKeySpec)

            // jwt 확인
            if (!validator.isValid(tokenWithoutSignature, signature)) {
                logger.error("Could not verify JWT token integrity!")
            } else {
                val gson = GsonBuilder().create()
                val data = gson.fromJson(payload, Map::class.java)
                salesforceService.sendCampaign(data as MutableMap<String, Any>)
            }
            //return ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
            return ResponseEntity(null, HttpStatus.OK)
        } catch (e: Exception) {
            logger.error("execute.service", e)
            return ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @GetMapping("/error")
    fun error(): String {
        logger.error("error")

        return "index"
    }

}