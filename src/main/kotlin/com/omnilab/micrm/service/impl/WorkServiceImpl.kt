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

    override fun makeGrpUserWork() : Tblmi_workDto {
        // 업로드 그룹 유저 Insert 로그 생성 -> 후에 하나로 커스텀이 필요할 듯
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val workDto = Tblmi_workDto()

        workDto.work_type = "회원 업로드"
        workDto.work_usr_id = userInfo.usr_id

        val ip = CommonUtils.clientip(request)
        if (ip == "0:0:0:0:0:0:0:1")
            workDto.work_usr_ip = "127.0.0.1"
        else{
            workDto.work_usr_ip = ip
        }

        workDto.work_stat = "0"
        workDto.work_msg = "업로드 그룹 배치처리 작업 진행중입니다"

        workDto.work_grp_cd = userInfo.usr_grp_cd

        workDto.reg_id = userInfo.usr_id

        return workDto
    }


}