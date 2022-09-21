package com.omnilab.micrm.service.impl

import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import com.omnilab.micrm.repository.KkoAtTmplDao
import com.omnilab.micrm.service.KkoRestApiService
import org.json.simple.JSONObject
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.*
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import java.net.HttpURLConnection
import kotlin.collections.HashMap


@Service("KkoRestApiServiceImpl")
class KkoRestApiServiceImpl : KkoRestApiService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${variable.biz-url}")
    private lateinit var url: String

    @Value("\${variable.biz-version}")
    private lateinit var version: String

    @Value("\${variable.biz-Auth}")
    private lateinit var auth: String

    @Autowired
    @Qualifier("restTemplate")
    private lateinit var restTemplate: RestTemplate


    @Autowired
    @Qualifier("KkoAtTmplDaoImpl")
    private lateinit var kkoAtTmplDao: KkoAtTmplDao


    private fun getToken(): String {

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.set("Authorization", auth)
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        val map: MutableMap<String, Any> = HashMap()
        map["grant_type"] = "api"

        val gson = GsonBuilder().create()
        val urlString = "$url/$version/oauth/token"
        val re_map: MutableMap<String, Any> =
            restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(map), headers));

        val data = re_map["data"] as MutableMap<String, Any>

        return data["access_token"] as String
    }


    private fun restExchange( urlString: String, method: HttpMethod, httpEntity: HttpEntity<Any>, ): MutableMap<String, Any> {

        val result: ResponseEntity<String> = restTemplate.exchange(urlString, method, httpEntity, String::class.java)
        val status = result.statusCode.value()
        val re_map: MutableMap<String, Any> = HashMap()
        re_map["result"] = status >= HttpURLConnection.HTTP_OK && status < HttpURLConnection.HTTP_MULT_CHOICE
        if (result.body == null) {
            re_map["data"] = ""
        } else {
            val body = result.body!!
            var bodyMap: Map<String, Any> =
                GsonBuilder().create().fromJson(body, object : TypeToken<Map<String, Any>>() {}.type)
            re_map["data"] = bodyMap

        }
        return re_map
    }

    override fun createAtTmpl(dto: Kko_at_tmplDto) {
        val token = getToken();

        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        //  dto로 받아와서 확인

        var urlString = "$url/$version/resell/template/create/${dto.send_key}"
        val gson = GsonBuilder().create()


        val re_map: MutableMap<String, Any> =
            restExchange(urlString!!, HttpMethod.POST, HttpEntity(gson.toJson(dto), headers))


        logger.error("{}",re_map);

    }

    private fun getTmplObjByDto(dto: Kko_at_tmplDto): Any {
        val jsonObj = JSONObject()
       /* jsonObj.put("client_id", dto.client_id)
        jsonObj.put("message_type", dto.message_type)
        jsonObj.put("sender_key", dto.sender_key)
        jsonObj.put("phone_number", dto.phone_number)
        jsonObj.put("message", dto.message)
        jsonObj.put("sms_message", dto.sms_message)
        jsonObj.put("sms_type", dto.sms_type)

        jsonObj.put("etc1", dto.etc1)
        jsonObj.put("sender_no", dto.sender_no)

        if (!CommonUtils.isEmptyObject(dto!!.button_json)) {
            var button = JSONObject(dto!!.button_json).get("button")
            jsonObj.put("button", button)
        }
        if (!CommonUtils.isEmptyObject(dto!!.image_json)) {
            var image = JSONObject(dto!!.image_json).get("image_json")
            jsonObj.put("image", image)
        }*/
        return jsonObj
    }


}
