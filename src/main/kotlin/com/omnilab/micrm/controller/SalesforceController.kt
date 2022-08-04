package com.omnilab.micrm.controller

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.service.ContentService
import com.omnilab.micrm.service.SalesforceService

import org.apache.http.client.methods.CloseableHttpResponse
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
import org.springframework.beans.factory.annotation.Value
import java.util.*
import javax.crypto.spec.SecretKeySpec


@Controller
@RequestMapping("/sf")
class SalesforceController {

    val logger = LoggerFactory.getLogger(this::class.java)


    @Value("\${upload.content}")
    private val secretKey: String? = null

    @Autowired
    lateinit var salesforceService: SalesforceService;

    @Autowired(required = true)
    @Qualifier("MobileContentServiceImpl")
    private lateinit var mobileContentService: ContentService

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
        return ModelAndView("cont/salesforce")
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
    fun getUser(@ModelAttribute dto: SalesforceDto): Map<String, Any> {
        return salesforceService.getUser(dto)
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
    fun mappingLst(@ModelAttribute dto: SalesforceDto): Map<String, Any> {
        return salesforceService.mappingLst(dto)
    }

    @ResponseBody
    @PostMapping("/save.service")
    fun save() {

    }

    @ResponseBody
    @PostMapping("/publish.service")
    fun publish() {

    }

    @ResponseBody
    @PostMapping("/validate.service")
    fun validate() {

    }

    @ResponseBody
    @PostMapping("/stop.service")
    fun stop() {

    }

    // done 동작
    @ResponseBody
    @PostMapping("/execute.service")
    fun execute(@RequestBody data : String) {
        var response: CloseableHttpResponse? = null

        try {
            // jwt
            val chunks: List<String> = data.split("\\.")
            val decoder: Base64.Decoder = Base64.getUrlDecoder()
            val payload: String = String(decoder.decode(chunks[1]))
            logger.error("payload: $payload")
            val sa: SignatureAlgorithm = SignatureAlgorithm.HS256
            val secretKeySpec = SecretKeySpec(secretKey?.toByteArray() ?: null, sa.jcaName)
            val tokenWithoutSignature = chunks[0] + "." + chunks[1]
            val signature = chunks[2]
            val validator = DefaultJwtSignatureValidator(sa, secretKeySpec)

            // jwt 확인
            if (!validator.isValid(tokenWithoutSignature, signature)) {
                logger.error("Could not verify JWT token integrity!")
            } else {
                val jsonParser = JSONParser()
                var jsonObj = jsonParser.parse(payload) as JSONObject
                val inArguments: JSONArray = jsonObj["inArguments"] as JSONArray
                val argument: JSONObject = inArguments.get(0) as JSONObject
                val host = argument["host"] as String
                val token = argument["token"] as String
                val phone = argument["phone"] as String
                logger.error("phone: $phone\nhost: $host\ntoken: $token")
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