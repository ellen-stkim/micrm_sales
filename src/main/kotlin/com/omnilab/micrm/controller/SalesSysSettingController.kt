package com.omnilab.micrm.controller

import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.service.KkoRestApiService
import com.omnilab.micrm.service.SysSettingService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*


@Controller
@RequestMapping("/sf/{usr_cd}/sys/setting")
class SalesSysSettingController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var sysSettingService: SysSettingService;

    @Autowired
    @Qualifier("KkoRestApiServiceImpl")
    lateinit var kkoRestApiService: KkoRestApiService

    @Autowired
    lateinit var fileUpload: FileUploadUtils;


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
     * @Method Name  : insertRejectText
     * @Since    : 2023. 01. 05
     * @author   : Belisa
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 수신 거부 문자 INSERT 하기
     * @title : 수신 거부 문자 INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertRejectText.ajax")
    fun insertRejectText(lstDto : Tblmi_set_lstDto) : Int {
        return sysSettingService.insertRejectText(lstDto)
    }
}
