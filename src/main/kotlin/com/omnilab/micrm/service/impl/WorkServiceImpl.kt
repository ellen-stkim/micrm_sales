package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmi_workDto
import com.omnilab.micrm.repository.WorkDao
import com.omnilab.micrm.service.WorkService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import javax.servlet.http.HttpServletRequest

@Service("WorkServiceImpl")
class WorkServiceImpl : WorkService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("WorkHistoryDaoImpl")
    private lateinit var workDao: WorkDao

    @Autowired(required = true)
    private lateinit var request: HttpServletRequest

    override fun insertWorkHistory(workDto : Tblmi_workDto) {
        workDao.insertWorkHistory(workDto);
    }

    override fun updateWorkHistory(workDto: Tblmi_workDto) {
        workDao.updateWorkHistory(workDto)
    }

}