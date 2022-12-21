package template_kotlin

import com.exacttarget.fuelsdk.*
import org.slf4j.LoggerFactory

object dataExtentionSelectOmnilabKt {
    @Throws(ETSdkException::class)
    @JvmStatic
    fun main(args: Array<String>) {
        val logger = LoggerFactory.getLogger("testSdk")
        val configuration = ETConfiguration()
        configuration["clientId"] = "3k9fq4ivxzmbqjybxfnmiemk"
        configuration["clientSecret"] = "Pffpsqx9jkM0bFb77kEdGM18"
        configuration["authEndpoint"] = "https://mcrhrh7j3bl6xd1n35nt5lxc5tk4.auth.marketingcloudapis.com"
        configuration["endpoint"] = "https://mcrhrh7j3bl6xd1n35nt5lxc5tk4.auth.marketingcloudapis.com"
        configuration["soapEndpoint"] = "https://mcrhrh7j3bl6xd1n35nt5lxc5tk4.auth.marketingcloudapis.com/service.asmx"
        configuration["useOAuth2Authentication"] = "true"
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

//        ETClient client  = new ETClient("/fuelSdk.properties");
        println("---------------------ETDataExtension------------------------")
        val response = client.retrieve(ETDataExtension::class.java, "id=cce071c7-4680-ed11-ba43-5cba2c19aa40")
        val result = response.result
        val dataExtension = result.getObject()
        val res = dataExtension.select()
        println(res.getObject().columnNames)
        println("---------------------ETDataExtension------------------------")
    }
}