package com.omnilab.micrm.controller

import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.service.ContentService

import org.apache.http.HttpEntity
import org.apache.http.HttpStatus
import org.apache.http.StatusLine
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpGet
import org.apache.http.util.EntityUtils
import org.json.simple.JSONArray
import org.json.simple.JSONObject
import org.json.simple.parser.JSONParser
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView
import java.io.InputStreamReader
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.impl.crypto.DefaultJwtSignatureValidator;
import org.eclipse.jdt.internal.compiler.parser.Parser.name
import org.springframework.beans.factory.annotation.Value
import java.util.*
import javax.crypto.spec.SecretKeySpec


@Controller
@RequestMapping("/sf")
class SalesforceController {

    val logger = LoggerFactory.getLogger(this::class.java)

    // Installed Packages - JWT Signing Secret


    @Value("\${upload.content}")
    private val secretKey: String? = null
    //@Autowired
    //lateinit var salesforceService: SalesforceService;

    @Autowired(required = true)
    @Qualifier("MobileContentServiceImpl")
    private lateinit var mobileContentService: ContentService

    @ResponseBody
    @GetMapping("/config.json")
    fun configJson(): JSONObject {
        val resource: Resource = ClassPathResource("static/config.json")
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
        val view = ModelAndView("cont/salesforce")

        // TODO: usr_grp_cd 값을 DB 에서 조회 후 페이지에서 ajax 로 조회해야함
        val sptpDto = SetLst_searchDto()
        sptpDto.usr_grp_cd = "04"   // 테스트용 세일즈포스 테스트 그룹
        sptpDto.list_tp_id = "CH03"
        sptpDto.list_dt_id = "SPTP01"
        val sptpMap = mobileContentService.selectMappingList(sptpDto)

        // 개인화 변수 추가하기
        view.addObject("mappingList", sptpMap["list"]);
        // TODO: 끝

        return view
    }

    @ResponseBody
    @PostMapping("/save.service")
    fun save() {
        logger.info("save")
    }

    @ResponseBody
    @PostMapping("/publish.service")
    fun publish() {
        logger.info("publish")
    }

    @ResponseBody
    @PostMapping("/validate.service")
    fun validate() {
        logger.info("validate")
    }

    @ResponseBody
    @PostMapping("/stop.service")
    fun stop() {
        logger.info("stop")
    }

    // done 동작
    @ResponseBody
    @PostMapping("/execute.service")
    fun execute(@RequestBody data : String) {
        logger.info("execute")

        var response: CloseableHttpResponse? = null

        try {
            // jwt
            val chunks: List<String> = data.split("\\.")
            val decoder: Base64.Decoder = Base64.getUrlDecoder()
            val payload: String = String(decoder.decode(chunks[1]))
            logger.info("payload: $payload")
            val sa: SignatureAlgorithm = SignatureAlgorithm.HS256
            val secretKeySpec = SecretKeySpec(secretKey?.toByteArray() ?: null, sa.jcaName)
            val tokenWithoutSignature = chunks[0] + "." + chunks[1]
            val signature = chunks[2]
            val validator = DefaultJwtSignatureValidator(sa, secretKeySpec)

            // jwt 확인
            if (!validator.isValid(tokenWithoutSignature, signature)) {
                logger.info("Could not verify JWT token integrity!")
            } else {
                val jsonParser = JSONParser()
                var jsonObj = jsonParser.parse(payload) as JSONObject
                val inArguments: JSONArray = jsonObj["inArguments"] as JSONArray
                val argument: JSONObject = inArguments.get(0) as JSONObject
                val host = argument["host"] as String
                val token = argument["token"] as String
                val phone = argument["phone"] as String
                logger.info("phone: $phone\nhost: $host\ntoken: $token")

                // 토큰정보 조회 - enterpriseId, organizationId, userId
                /**
                val httpGet = HttpGet("$host/platform/v1/tokenContext")
                httpGet.addHeader("Content-type", "application/json")
                httpGet.addHeader("Authorization", "Bearer $token")
                response = httpClient.execute(httpGet)
                val entity: HttpEntity = response.entity
                val responseBody = EntityUtils.toString(entity, "UTF-8")
                val statusLine: StatusLine = response.statusLine
                logger.info("StatusCode: " + statusLine.getStatusCode())
                if (statusLine.getStatusCode() === HttpStatus.SC_OK) {
                    jsonObj = jsonParser.parse(responseBody) as JSONObject
                    val enterprise = jsonObj["enterprise"] as JSONObject
                    val organization = jsonObj["organization"] as JSONObject
                    val user = jsonObj["user"] as JSONObject
                    val enterpriseId = enterprise["id"] as Long
                    val organizationId = organization["id"] as Long
                    val userId = user["id"] as Long
                    logger.info("\nenterpriseId: $enterpriseId\norganizationId: $organizationId\nuserId: $userId")
                } else {
                    logger.error("tokenContext fail: $responseBody")
                }
                */
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    @GetMapping("/error")
    fun error(): String {
        logger.error("error")

        return "index"
    }

}