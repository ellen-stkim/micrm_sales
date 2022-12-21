package com.omnilab.micrm.service.impl

import com.exacttarget.fuelsdk.ETClient
import com.exacttarget.fuelsdk.ETDataExtension
import com.exacttarget.fuelsdk.ETSdkException
import com.omnilab.micrm.service.SalesforceSoapService
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.util.stream.Collectors


@Service("SalesforceSoapServiceImpl")
class SalesforceSoapServiceImpl : SalesforceSoapService {

    val logger: Logger = LoggerFactory.getLogger(this.javaClass)!!

    val FUELSDK_PROPERTIES : String = "/fuelSdk.properties"


    @Throws(ETSdkException::class)
    override fun getDataExtention(extentionId: String) : List<String> {

        logger.error("*------------------------------------------------------------*")
        val client  = ETClient(FUELSDK_PROPERTIES)

        logger.error("{}",ETDataExtension::class.java)
        val response = client.retrieve(ETDataExtension::class.java, "id=$extentionId")
        val dataExtension = response.result.getObject()

        val res = dataExtension.select()

        logger.error("columnName = {}",res.getObject().columnNames)
        logger.error("*------------------------------------------------------------*")
        return res.getObject().columnNames.stream().collect(Collectors.toList())
    }

}