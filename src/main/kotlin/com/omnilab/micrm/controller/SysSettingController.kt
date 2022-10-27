package com.omnilab.micrm.controller

import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.service.SysSettingService
import org.springframework.stereotype.Controller
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpSession


@Controller
@RequestMapping("/sys/setting")
class SysSettingController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${upload.src}")
    private val filePath: String? = null

    @Autowired
    lateinit var sysSettingService: SysSettingService;

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService : com.omnilab.micrm.service.CampaignService

    @Autowired
    lateinit var fileUpload: FileUploadUtils;

    /**
     * @Method Name  : mappingSetting
     * @Since    : 2022. 07. 25
     * @author   : Lisa
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑 정보 설정 페이지 조회
     * @title : 매핑 정보 설정 페이지 조회
     */
    @GetMapping("/mappingSetting.mi")
    fun mappingSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/mappingSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getMappingSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view;
    }

    /**
     * @Method Name  : getMappingSettingList
     * @Since    : 2022. 07. 25
     * @author   : Lisa
     * @param    : lstStDto: SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑 정보 설정 페이지 가져오기
     * @title : 매핑 정보 설정 페이지 가져오기
     */

    @PostMapping("/getMappingSettingList.ajax")
    fun getMappingSettingList(@ModelAttribute("form") lstStDto: SetLst_searchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getMappingSettingList")
        val map = sysSettingService.getMappingSettingList(lstStDto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])
        return view;
    }

    /**
     * 
     */
    @GetMapping("/mailSetting.mi")
    fun mailSetting(): ModelAndView {
        val view = ModelAndView("sys/setting/mailSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getMailSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view
    }


    @ResponseBody
    @RequestMapping("/upload.mi")
    fun upload(@RequestParam("upload") file: MultipartFile, request: HttpServletRequest, session:HttpSession): MutableMap<String, Any> {
        val filePathGrp = filePath+"/"+UsefulUtils.sessionUser().usr_grp_cd
        val map: MutableMap<String, Any> = fileUpload.upload(filePathGrp, file, request);
        if(map["uploaded"].toString() == "0"){
            logger.info("File Upload fail")
        }else{
            val commonCDDto = Tblmi_comm_cdDto()
            commonCDDto.grp_id = "COMMON"
            commonCDDto.cd_id = "UPURL01"
            val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
            val uploadUrl = map["url"].toString()
            map["url"] = uploadPrefix?.cd_val + uploadUrl
        }
        val returnMap = sysSettingService.insertNoticeFile(map)
        if(returnMap["message"].toString() == "0"){
            map["uploaded"] = 0
            map["message"] = "파일 저장에 실패하였습니다."
            logger.info("File DB insert fail")
        }
        return map
    }

    @PostMapping("/getMailSettingList.ajax")
    fun getMailSettingList(@ModelAttribute("form") dto : SetLst_searchDto): ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getMailSettingList")
        val map = sysSettingService.getMailSettingList(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }




    /**
     * @Method Name  : updateSetLstYn
     * @Since    : 2021. 03. 26
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 Use_YN 변경하기
     * @title : 메일 Use_YN 변경하기
     */

    @ResponseBody
    @PostMapping("/updateSetLstYn.ajax")
    fun updateSetLstYn(lstDto: Tblmi_set_lstDto) : Map<String,Any>  {
       return sysSettingService.updateSetLstYn(lstDto)
    }

    /**
     * @Method Name  : insertMail
     * @Since    : 2021. 03. 29
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 INSERT 하기
     * @title : 메일 주소 INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertMail.ajax")
    fun insertMailLst(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.insertMailLst(lstDto)
    }

    /**
     * @Method Name  : isExistMailAddress
     * @Since    : 2021. 03. 29
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 저장시 중복 여부 확인하기
     * @title : 메일 주소 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistMailAddress.ajax")
    fun isExistMailAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMailAddress(lstDto)
    }

    /**
     * @Method Name  : isExistMailAddressModify
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 수정 중복여부 확인하기
     * @title : 메일 주소 수정 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistMailModifyAddress.ajax")
    fun isExistMailAddressModify(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMailAddressModify(lstDto)
    }

    /**
     * @Method Name  : deleteMailAddress
     * @Since    : 2021. 03. 29
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 연락처 삭제하기
     * @title : 연락처 삭제 하기
     */

    @ResponseBody
    @PostMapping("/deleteAddress.ajax")
    fun deleteMailAddress(lstDto: Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.deleteSetLst(lstDto)
    }

    /**
     * @Method Name  : changeDefaultMail
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstStDto: SetLst_searchDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 기본 연락처 값 변경하기
     * @title : 기본 연락처 값 변경하기
     */

    @ResponseBody
    @PostMapping("/changeDefaultLst.ajax")
    fun changeDefaultLst(lstStDto : SetLst_searchDto) : Map<String,Any>{
        return sysSettingService.changeDefaultLst(lstStDto)
    }

    /**
     * @Method Name  : detailLst
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : seq 값으로 detailLst 값 조회 한다.
     * @title : 디테일 메일 값 조회
     */
    @ResponseBody
    @PostMapping("/detailLst.ajax")
    fun detailLst(lstDto : Tblmi_set_lstDto) : Map<String,Any>{
        return sysSettingService.detailLst(lstDto)
    }


    /**
     * @Method Name  : smsSetting
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 문자 정보 설정 페이지 조회
     * @title : 문자 정보 설정 페이지 조회
     */

    @GetMapping("/smsSetting.mi")
    fun smsSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/smsSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getSmsSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view;
    }

    /**
     * @Method Name  : getSmsSettingList
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstStDto: SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 문자 정보 설정 페이지 가져오기
     * @title : 문자 정보 설정 페이지 가져오기
     */

    @PostMapping("/getSmsSettingList.ajax")
    fun getSmsSettingList(@ModelAttribute("form") lstStDto: SetLst_searchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getSmsSettingList")
        val map = sysSettingService.getSmsSettingList(lstStDto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])
        return view;
    }


    /**
     * @Method Name  : insertSmsLst
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : SMS INSERT 하기
     * @title : SMS INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertSms.ajax")
    fun insertSmsLst(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.insertSmsLst(lstDto)
    }


    /**
     * @Method Name  : isExistSmsAddress
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 중복 여부 확인하기
     * @title : 메일 주소 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistSmsAddress.ajax")
    fun isExistSmsAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistSmsAddress(lstDto)
    }

    /**
     * @Method Name  : isExistSmsModifyAddress
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 수정 중복 여부 확인하기
     * @title : 메일 주소 수정 중복 여부 확인하기
     */

    @ResponseBody
    @PostMapping("/isExistSmsModifyAddress.ajax")
    fun isExistSmsModifyAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistSmsAddressModify(lstDto)
    }

    /**
     * @Method Name  : updateLst
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 발신자 수정하기
     * @title : 발신자 수정하기
     */
    @ResponseBody
    @PostMapping("/updateLst.ajax")
    fun updateLst(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.updateLst(lstDto)
    }

    /**
     * @Method Name  : insertMappingLst
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 INSERT 하기
     * @title : 매핑정보 INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertMapping.ajax")
    fun insertMapping(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.insertMappingLst(lstDto)
    }

    /**
     * @Method Name  : isExistMapping
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 중복 여부 확인하기
     * @title : 매핑정보 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistMapping.ajax")
    fun isExistMappingAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMapping(lstDto)
    }

    /**
     * @Method Name  : isExistMappingModify
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 수정 중복 여부 확인하기
     * @title : 매핑정보 수정 중복 여부 확인하기
     */

    @ResponseBody
    @PostMapping("/isExistMappingModify.ajax")
    fun isExistSmsModify(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMappingModify(lstDto)
    }

    /**
     * @Method Name  : deleteMapping
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 삭제하기
     * @title : 매핑정보 삭제하기
     */

    @ResponseBody
    @PostMapping("/deleteMapping.ajax")
    fun deleteMapping(lstDto: Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.deleteSetLst(lstDto)
    }


    @GetMapping("/kkoSetting.mi")
    fun kkoSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/kkoSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getKkoSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view;
    }

}
