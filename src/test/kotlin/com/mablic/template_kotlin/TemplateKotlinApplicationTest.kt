package com.mablic.template_kotlin


import com.exacttarget.fuelsdk.*
import com.omnilab.micrm.MicrmApplication
import com.omnilab.micrm.service.SalesforceSoapService
import org.junit.Test
import org.junit.runner.RunWith
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit4.SpringRunner
import org.springframework.test.context.web.WebAppConfiguration

//@RunWith(SpringRunner::class)
//@SpringBootTest

@RunWith(SpringRunner::class)
@SpringBootTest(classes = [MicrmApplication::class])
@WebAppConfiguration
class TemplateKotlinApplicationTests {

    private val logger: Logger = LoggerFactory.getLogger(TemplateKotlinApplicationTests::class.java)

    @Autowired
    private lateinit var salesforceSoapService: SalesforceSoapService

    @Test
    fun contextLoads() {
        salesforceSoapService.getDataExtention("cce071c7-4680-ed11-ba43-5cba2c19aa40")
    }
}

