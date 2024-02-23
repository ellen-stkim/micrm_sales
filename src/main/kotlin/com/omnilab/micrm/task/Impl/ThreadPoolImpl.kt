package com.omnilab.micrm.task.Impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.model.GroupUsr_SearchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CampaignDao
import com.omnilab.micrm.repository.CommonDao
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.service.*
import com.omnilab.micrm.task.ThreadPool
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.stereotype.Component
import org.springframework.web.multipart.MultipartFile

@Component("ThreadPoolImpl")
class ThreadPoolImpl : ThreadPool {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("taskExecutor")
    private lateinit var taskExecutor : ThreadPoolTaskExecutor

    @Autowired
    @Qualifier("WorkServiceImpl")
    private lateinit var workService : WorkService

    @Autowired
    @Qualifier("MemberDaoImpl")
    private lateinit var memberDao: MemberDao

    @Autowired
    private lateinit var commonService: CommonService

    @Autowired
    @Qualifier("CampaignDaoImpl")
    private lateinit var campaignDao: CampaignDao

    @Autowired
    @Qualifier("CommonDaoImpl")
    private lateinit var commonDao: CommonDao

    // detailTask 스케 줄러 처리
    override fun insertDetailTargetTask(file: MultipartFile, dto: Tblmi_group_usrDto) {
        logger.error("[" + CommonUtils.getDateTimeNow().toString() + "] 타겟 엑셀 리스트 생성 시작")
        val dt = dto as GroupUsr_SearchDto
        taskExecutor.submit {
            val excelFile = file.inputStream
            try{
                memberDao.insertTargetGrp(file,excelFile,dt)
            }catch(e : Exception){
                logger.error("쓰레드 에러 {}",e.printStackTrace())
                val failWorkDto = Tblmi_workDto()
                failWorkDto.seq = dt.work_seq
                failWorkDto.upd_id = dt.reg_id
                failWorkDto.work_stat = "2"
                failWorkDto.work_msg = "파일명 : " + file.originalFilename + "<br>" + "그룹 명 : " + dt.grp_nm + "<br>" + "파일 또는 서버 에러  " + e.message
                workService.updateWorkHistory(failWorkDto)
            }
            logger.error("[" + CommonUtils.getDateTimeNow().toString() + "] 타겟 엑셀 리스트 생성 종료")
        }
    }
}