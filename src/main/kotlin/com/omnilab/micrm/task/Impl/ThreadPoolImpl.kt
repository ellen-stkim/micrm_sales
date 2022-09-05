package com.omnilab.micrm.task.Impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.GroupUsr_SearchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CampaignDao
import com.omnilab.micrm.repository.CommonDao
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.repository.SysUserDao
import com.omnilab.micrm.service.*
import com.omnilab.micrm.task.ThreadPool
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.stereotype.Component
import org.springframework.web.multipart.MultipartFile
import java.io.ByteArrayInputStream
import java.io.InputStream

@Component("ThreadPoolImpl")
class ThreadPoolImpl : ThreadPool {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("taskExecutor")
    private lateinit var taskExecutor : ThreadPoolTaskExecutor

    @Autowired
    @Qualifier("MemberServiceImpl")
    private lateinit var memberService: MemberService

    @Autowired
    @Qualifier("WorkServiceImpl")
    private lateinit var workService : WorkService

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService : com.omnilab.micrm.service.CampaignService

    @Autowired
    @Qualifier("MemberDaoImpl")
    private lateinit var memberDao: MemberDao

    @Autowired
    private lateinit var commonService: com.omnilab.micrm.service.CommonService

    @Autowired
    @Qualifier("CampaignDaoImpl")
    private lateinit var campaignDao: CampaignDao

    @Autowired
    @Qualifier("CommonDaoImpl")
    private lateinit var commonDao: CommonDao

    override fun sendHstProgram(programDto: Tblmicp_programDto, auto: Boolean) {
        //logger.error("sendHstProgram [${programDto.pro_id}] Start")
        taskExecutor.submit {
            val programId = programDto.pro_id.toString()
            val apprUser:Tblmi_usrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(programDto.appr_id))
            val regUser:Tblmi_usrDto = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(programDto.reg_id))
            try{
                campaignDao.upd_tblmicp_program(Tblmicp_programDto(programDto.pro_id, "02"))

                var alSubject = "[MICRM] '${programDto.pro_nm}' 타겟추출이 시작 되었습니다."
                var alMsg = StringBuilder()
                alMsg.append("'${programDto.pro_nm}' 타겟추출이 시작 되었습니다.")
                commonService.sendMail(apprUser.usr_email!!, if(apprUser.usr_nm.isNullOrEmpty()) "" else apprUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                commonService.sendMail(regUser.usr_email!!, if(regUser.usr_nm.isNullOrEmpty()) "" else regUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())

                val campLst = campaignDao.ins_programSendHst(programDto)
                for(seq in campLst){
                    campaignDao.upd_tblmicp_camapaign_cnt_hst(Tblmicp_campaignDto(programId, seq))
                }
                campaignDao.upd_tblmicp_program_cnt_hst(programId)

                alSubject = "[MICRM] '${programDto.pro_nm}' 타겟추출이 완료 되었습니다."
                alMsg = StringBuilder()
                alMsg.append("'${programDto.pro_nm}' 타겟추출이 완료 되었습니다.")
                commonService.sendMail(apprUser.usr_email!!, if(apprUser.usr_nm.isNullOrEmpty()) "" else apprUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                commonService.sendMail(regUser.usr_email!!, if(regUser.usr_nm.isNullOrEmpty()) "" else regUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())

                campaignDao.upd_tblmicp_program(Tblmicp_programDto(programDto.pro_id, "03"))

                alSubject = "[MICRM] '${programDto.pro_nm}' 발송 준비가 시작 되었습니다."
                alMsg = StringBuilder()
                alMsg.append("'${programDto.pro_nm}' 발송 준비가 시작 되었습니다.")
                commonService.sendMail(apprUser.usr_email!!, if(apprUser.usr_nm.isNullOrEmpty()) "" else apprUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                commonService.sendMail(regUser.usr_email!!, if(regUser.usr_nm.isNullOrEmpty()) "" else regUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())

                campaignService.programSend(programId, false)

                alSubject = "[MICRM] '${programDto.pro_nm}' 발송 진행 중입니다."
                alMsg = StringBuilder()
                alMsg.append("'${programDto.pro_nm}' 발송 진행 중입니다.")
                commonService.sendMail(apprUser.usr_email!!, if(apprUser.usr_nm.isNullOrEmpty()) "" else apprUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                commonService.sendMail(regUser.usr_email!!, if(regUser.usr_nm.isNullOrEmpty()) "" else regUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                campaignDao.upd_tblmicp_program(Tblmicp_programDto(programId, "03"))

                logger.info("finish $programId sendHstProgram")
            }catch(e:Exception){
                campaignDao.upd_tblmicp_program(Tblmicp_programDto(programId, "99"))
                logger.error("sendHstProgram 쓰레드 에러 " , e)

                val alSubject = "[MICRM] '${programDto.pro_nm}' 발송이 실패 하였습니다."
                val alMsg = StringBuilder()
                alMsg.append("'${programDto.pro_nm}' 발송이 실패 하였습니다.")
                commonService.sendMail(apprUser.usr_email!!, if (apprUser.usr_nm.isNullOrEmpty()) "" else apprUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
                commonService.sendMail(regUser.usr_email!!, if (regUser.usr_nm.isNullOrEmpty()) "" else regUser.usr_nm!!, GlobalValues.sendEdm, alSubject, alMsg.toString())
            }
        }
        //logger.error("sendHstProgram [${programDto.pro_id}] END")
    }

    // insertGroupTask 스케 줄러 처리
    override fun insertGroupTask(groupListDto: Tblmi_group_listDto)   {
        logger.error("[" + CommonUtils.getDateTimeNow().toString() + "] 그룹 리스트 파일 생성 시작")
        taskExecutor.submit {
            try{
                memberService.insertGroupUser(groupListDto) // 그룹 인설트 처리
                logger.error("finish thread");
            }catch(e:Exception){
                logger.error("쓰레드 에러 " , e.printStackTrace())
            }
        }
    }

    // detailTask 스케 줄러 처리
    override fun insertDetailTargetTask(file: MultipartFile, dto: Tblmi_group_usrDto) {
        logger.error("[" + CommonUtils.getDateTimeNow().toString() + "] 타겟 엑셀 리스트 생성 시작")

        val dto = dto as GroupUsr_SearchDto
        val excel_file = file.inputStream

        taskExecutor.submit {
            val excel_file = file.inputStream
            try{
                memberDao.insertTargetGrp(file,excel_file,dto)
            }catch(e : Exception){
                logger.error("쓰레드 에러 {}",e.printStackTrace())
                val failWorkDto = Tblmi_workDto()
                failWorkDto.seq = dto.work_seq
                failWorkDto.upd_id = dto.reg_id
                failWorkDto.work_stat = "2"
                failWorkDto.work_msg = "파일명 : " + file.originalFilename + "<br>" + "그룹 명 : " + dto.grp_nm + "<br>" + "파일 또는 서버 에러  " + e.message
                workService.updateWorkHistory(failWorkDto)
            }
            logger.error("[" + CommonUtils.getDateTimeNow().toString() + "] 타겟 엑셀 리스트 생성 종료")
        }
    }
}