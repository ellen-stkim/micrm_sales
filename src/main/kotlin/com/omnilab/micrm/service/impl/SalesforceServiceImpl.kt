package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.BtnValueUtils.url
import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.service.SalesforceService
import oracle.net.aso.e
import org.apache.http.HttpEntity
import org.apache.http.HttpStatus
import org.apache.http.StatusLine
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpGet
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClients
import org.apache.http.util.EntityUtils
import org.json.simple.JSONObject
import org.json.simple.parser.JSONParser
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class SalesforceServiceImpl : SalesforceService {

    val logger = LoggerFactory.getLogger(this::class.java)

//    @Autowired
//    lateinit var salesforceDao: SalesforceDao

    override fun getUser(dto: SalesforceDto): Map<String, Any> {
        val returnMap: MutableMap<String, Any> = HashMap()
        var status: String = "false"

        val host: String = dto.host as String
        val token: String = dto.token as String

        try {
            val client: HttpClient = HttpClients.createDefault()
            val httpGet = HttpGet("$host/platform/v1/tokenContext")
            httpGet.addHeader("Content-type", "application/json")
            httpGet.addHeader("Authorization", "Bearer $token")
            val response: CloseableHttpResponse = client.execute(httpGet) as CloseableHttpResponse
            val entity: HttpEntity = response.entity
            val responseBody = EntityUtils.toString(entity, "UTF-8")
            val statusLine: StatusLine = response.statusLine
            logger.info("StatusCode: " + statusLine.getStatusCode())
            if (statusLine.getStatusCode() === HttpStatus.SC_OK) {
                val jsonParser = JSONParser()
                val jsonObj = jsonParser.parse(responseBody) as JSONObject
                val enterprise = jsonObj["enterprise"] as JSONObject
                val organization = jsonObj["organization"] as JSONObject
                val user = jsonObj["user"] as JSONObject
                val enterpriseId = enterprise["id"] as Long
                val organizationId = organization["id"] as Long
                val userId = user["id"] as Long
                logger.info("\nenterpriseId: $enterpriseId\norganizationId: $organizationId\nuserId: $userId")

                // TODO: usr_grp_cd 조회하기
                dto.enterpriseId = enterpriseId
                dto.organizationId = organizationId
                dto.userId = userId
                dto.list_tp_id = "CH03"
                dto.list_dt_id = "SPTP01"
                // returnMap["usr_grp_cd"] = salesforceDao.getUsrGrpCd(dto)
                returnMap["usr_grp_cd"] = "04"  // 테스트용 세일즈포스 테스트 그룹
                status = "true"
            } else {
                logger.error("tokenContext fail: $responseBody")
            }
        } catch(e: Exception) {
            logger.error("salesforce getUser :", e)
        }

        returnMap["status"] = status
        return returnMap
    }

}