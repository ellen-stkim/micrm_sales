package com.omnilab.micrm.controller

import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.service.ContentService
import com.omnilab.micrm.service.SysSettingService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

@Controller
@RequestMapping("/sf")
class SalesforceController {

    val logger = LoggerFactory.getLogger(this::class.java)

    // Installed Packages - JWT Signing Secret
    private val secretKey = "DhnXzuGdfn2ibIlzs1_4S8X1FgztsKv7Bf1_0FtQgx3cf_CXXIA4gzATZGQ4lA6zDK3ZRagm_vges7YqDQKRnnhUjmJWNM-mOdo3jd5s6BDUox_lSyTr0GvMosQvS17KWWtdhEsctd7YeSK9qH4C-ju0nfmrjmvy8nHDiwc04AJRCzM-5XvZ0ZWmbpz3brcyYXhf0NTB4Q6Szft0Fe_ihxvT0nwuR6atdmQjTxH36FGukpqMPFFzoSe2n5aHQQ2"

    //@Autowired
    //lateinit var salesforceService: SalesforceService;

    @Autowired(required = true)
    @Qualifier("MobileContentServiceImpl")
    private lateinit var mobileContentService: ContentService

    @ResponseBody
    @GetMapping("/config.json")
    fun configJson(): String {
        return "{\n" +
                "  \"workflowApiVersion\": \"1.1\",\n" +
                "  \"metaData\": {\n" +
                "    \"icon\": \"image/ico_new.png\",\n" +
                "    \"category\": \"message\"\n" +
                "  },\n" +
                "  \"type\": \"REST\",\n" +
                "  \"lang\": {\n" +
                "    \"en-US\": {\n" +
                "      \"name\": \"miCRM\",\n" +
                "      \"description\": \"miCRM\"\n" +
                "    }\n" +
                "  },\n" +
                "  \"arguments\": {\n" +
                "    \"execute\": {\n" +
                "      \"url\": \"https://sales.milvusapp.com/sf/execute\",\n" +
                "      \"useJwt\": true\n" +
                "    }\n" +
                "  },\n" +
                "  \"configurationArguments\": {\n" +
                "    \"save\": {\n" +
                "      \"url\": \"https://sales.milvusapp.com/sf/save\"\n" +
                "    },\n" +
                "    \"publish\": {\n" +
                "      \"url\": \"https://sales.milvusapp.com/sf/publish\"\n" +
                "    },\n" +
                "    \"validate\": {\n" +
                "      \"url\": \"https://sales.milvusapp.com/sf/validate\"\n" +
                "    },\n" +
                "    \"stop\": {\n" +
                "      \"url\": \"https://sales.milvusapp.com/sf/stop\"\n" +
                "    }\n" +
                "  },\n" +
                "  \"wizardSteps\": [\n" +
                "    { \"label\": \"Step 1\", \"key\": \"step1\" }\n" +
                "  ],\n" +
                "  \"userInterfaces\": {\n" +
                "    \"configModal\": {\n" +
                "      \"height\": 600,\n" +
                "      \"width\": 800,\n" +
                "      \"fullscreen\": true\n" +
                "    }\n" +
                "  }\n" +
                "}"
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
    @GetMapping("/index.html")
    fun mdmCreate(): ModelAndView {
        val view = ModelAndView("cont/salesforce")

        // TODO: usr_grp_cd 값을 DB 에서 조회 후 페이지에서 ajax 로 조회해야함
        val sptpDto = SetLst_searchDto()
        sptpDto.usr_grp_cd = "04"   // 테스트용 세일즈포스 테스트 그룹
        sptpDto.list_tp_id = "CH03"
        sptpDto.list_dt_id = "SPTP01"
        val sptpMap = mobileContentService.selectMappingList(sptpDto)

        // 개인화 변수 추가하기
        view.addObject("mappingList", sptpMap["list"]);

        return view
    }

    @ResponseBody
    @PostMapping("/save")
    fun save() {
        logger.info("save")
    }

    @ResponseBody
    @PostMapping("/publish")
    fun publish(@RequestBody data: String?) {
        logger.info("publish")
    }

    @ResponseBody
    @PostMapping("/validate")
    fun validate(@RequestBody data: String?) {
        logger.info("validate")
    }

    @ResponseBody
    @PostMapping("/stop")
    fun stop() {
        logger.info("stop")
    }

    // done 동작
    @ResponseBody
    @PostMapping("/execute")
    fun execute() {
        logger.info("execute")
    }

    @GetMapping("/error")
    fun error(): String {
        logger.error("error")

        return "index"
    }

}