package com.omnilab.micrm.service

import com.omnilab.micrm.model.Content_list_CreateDto
import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.table.*
import javax.servlet.http.HttpSession

interface SalesforceSoapService {

    fun getDataExtention(extentionId: String): List<String>
}