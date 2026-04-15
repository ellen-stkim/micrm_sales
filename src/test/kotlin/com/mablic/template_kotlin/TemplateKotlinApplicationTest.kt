package com.mablic.template_kotlin

import com.omnilab.micrm.MicrmApplication
import com.omnilab.micrm.service.SalesforceService
import org.junit.Test
import org.junit.runner.RunWith
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit4.SpringRunner
import org.springframework.test.context.web.WebAppConfiguration

@RunWith(SpringRunner::class)
@SpringBootTest(classes = [MicrmApplication::class])
@WebAppConfiguration
class TemplateKotlinApplicationTests {

    private val logger: Logger = LoggerFactory.getLogger(TemplateKotlinApplicationTests::class.java)

    @Autowired
    private lateinit var salesforceService: SalesforceService

    @Test
    fun contextLoads() {
        salesforceService.getDataExtention("03","cce071c7-4680-ed11-ba43-5cba2c19aa40", "")
    }
    
    
    /**
     * pom.xml에 추가 후 테스트 가능
     * <!-- https://mvnrepository.com/artifact/org.codehaus.woodstox/stax2-api -->
    <dependency>
    <groupId>org.codehaus.woodstox</groupId>
    <artifactId>stax2-api</artifactId>
    <version>4.2.1</version>
    </dependency>
     
     */
}

