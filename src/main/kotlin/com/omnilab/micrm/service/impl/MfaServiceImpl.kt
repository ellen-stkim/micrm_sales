package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.model.Tblmi_mfa
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.mdm.LgSc_tranDto
import com.omnilab.micrm.repository.MfaDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.MfaService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@Service
class MfaServiceImpl: MfaService {

    private val log = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var mfaDao: MfaDao

    @Autowired
    lateinit var sysSettingDao: SysSettingDao

    var formatter: DateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")

    override fun sendVerificationCode(usrId: String, phone: String, usrGprCd:String): MutableMap<String, Any> {
        val reMap = HashMap<String, Any>()
        try {
            val dto = Tblmi_mfa(null, usrId, phone, null, LocalDateTime.now().format(formatter), null, "N", null, null, null, null)
            val selMfaDto = mfaDao.selTblmiMfa(dto)
            if(selMfaDto != null){
                reMap["result"] = false
                reMap["msg"] = "이미 인증 번호가 발송되었습니다.<br/>${selMfaDto.expired_at} 후에 다시 시도해주세요."
            } else {
                val mdminfo = sysSettingDao.getCommCD(Tblmi_comm_cdDto("MDM_DB", usrGprCd))
                val expireTime: LocalDateTime = LocalDateTime.now().plusMinutes(2)
                val formattedTime: String = expireTime.format(formatter)
                val code = CommonUtils.generateZeroPaddedCode()
                val mfaDto = Tblmi_mfa(null, usrId, phone, code, formattedTime, 1, "N","SYSTEM", null, "SYSTEM", null)
                mfaDao.insTblmiMfa(mfaDto)
                val lgDto = LgSc_tranDto(LocalDateTime.now().format(formatter), "0", "0", phone, "02-3288-1331", "본인인증번호 [$code] 를 입력해주세요", "인증문자", null, null, mdminfo!!.cd_val, "milvus")
                mfaDao.insSmsLg(lgDto)
                reMap["result"] = true
            }
        }catch (e: Exception){
            log.error("sendVerificationCode", e)
            reMap["result"] = false
            reMap["msg"] = "시스템 오류"
        }
        return reMap
    }

    override fun codeCheck(usrId: String, phone: String, code: String): Boolean {
        try{
            val dto = Tblmi_mfa(null, usrId, phone, code, LocalDateTime.now().format(formatter), null, "N", null, null, null, null)
            val selMfaDto = mfaDao.selTblmiMfa(dto)
            if (selMfaDto != null) {
                selMfaDto.use_yn = "Y"
                mfaDao.updTblmiMfa(selMfaDto)
                return true
            } else {
                return false
            }
        }catch (e: Exception){
            log.error("codeCheck", e)
            return false
        }
    }
}