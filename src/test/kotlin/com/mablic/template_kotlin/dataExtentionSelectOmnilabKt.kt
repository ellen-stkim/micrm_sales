package com.mablic.template_kotlin

import com.exacttarget.fuelsdk.*
import org.slf4j.LoggerFactory

object dataExtentionSelectOmnilabKt {
    @Throws(ETSdkException::class)
    @JvmStatic
    fun main(args: Array<String>) {
        val logger = LoggerFactory.getLogger("testSdk")
        val configuration = ETConfiguration()
        configuration["clientId"] = "dpt70jlizqdloq86kzngeqt5"
        configuration["clientSecret"] = "BgrW1BbgWbltuFw5Ik63xpQW"
        configuration["authEndpoint"] = "https://mcjfm2d4ywsykrff1y2x8rgtvtm0.auth.marketingcloudapis.com/"
        configuration["endpoint"] = "https://mcjfm2d4ywsykrff1y2x8rgtvtm0.rest.marketingcloudapis.com/"
        configuration["soapEndpoint"] = "https://mcjfm2d4ywsykrff1y2x8rgtvtm0.soap.marketingcloudapis.com/"
        configuration["useOAuth2Authentication"] = "true"
        /*
        configuration["clientId"] = "gqx22xm7en2e0uficums7cut"
        configuration["clientSecret"] = "qnxivHhJnaUinosSXaz4stQu"
        configuration["authEndpoint"] = "https://mc82m0sycp8ynx4fqynw-63lx470.auth.marketingcloudapis.com/"
        configuration["endpoint"] = "https://mc82m0sycp8ynx4fqynw-63lx470.rest.marketingcloudapis.com/"
        configuration["soapEndpoint"] = "https://mcjfm2d4ywsykrff1y2x8rgtvtm0.soap.marketingcloudapis.com/"
        configuration["useOAuth2Authentication"] = "true"
        */
        val client = ETClient(configuration)

        val etf = ETFilter()
        etf.addProperty("id")
        etf.addProperty("key")
        etf.addProperty("name")
        etf.addProperty("description")
        etf.addProperty("folderId")
        etf.addProperty("isSendable")
        etf.addProperty("isTestable")
        val exp = ETExpression()
        exp.property = "id"
        exp.setOperator("=")
        exp.value = "cce071c7-4680-ed11-ba43-5cba2c19aa40"
        etf.expression = exp

        println("---------------------ETDataExtension------------------------")
        val response = client.retrieve(ETDataExtension::class.java, "id=3411bb9a-d2b9-ee11-a5c5-5cba2c19a5e8")
        val result = response.result
        val dataExtension = result.getObject()
        val res = dataExtension.select()
        println(res.getObject().columnNames)
        println("---------------------ETDataExtension------------------------")
    }
}