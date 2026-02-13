package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Usr_log_searchDto
import com.omnilab.micrm.model.Usr_searchDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmi_usr_authDto
import com.omnilab.micrm.model.table.Tblmi_usr_log_hstDto
import com.omnilab.micrm.repository.CommonDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.repository.SysUserDao
import com.omnilab.micrm.service.SysUserService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import java.text.SimpleDateFormat
import java.util.regex.Pattern
import kotlin.collections.HashMap
import kotlin.math.log


@Service("SysUserServiceImpl")
class SysUserServiceImpl: SysUserService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var sysUserDao : SysUserDao

    @Autowired
    lateinit var commonDao: CommonDao

    @Autowired
    lateinit var sysSettingDao : SysSettingDao

    val passwordPattern = Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_\\-+=\\[\\]{};:'\\\",.<>/?\\\\|`~])[A-Za-z\\d!@#$%^&*()_\\-+=\\[\\]{};:'\\\",.<>/?\\\\|`~]{8,16}$")

    override fun getUserList(udto: Tblmi_usrDto):MutableMap<String, Any>{
        val dto = udto as Usr_searchDto
        val map : MutableMap<String, Any> = HashMap()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(pageNo,10,10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysUserDao.getUserListCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysUserDao.getUserList(dto);
        return map;
    }

    override fun saveUser(udto: Tblmi_usrDto): MutableMap<String, Any> {
        val dto = udto as Usr_searchDto
        val map: MutableMap<String, Any> = HashMap()
        val userInfo = UsefulUtils.sessionUser()

        val phoneRegex = Regex("""^\d{3}-\d{3,4}-\d{4}$""")
        if (!dto.usr_mob.isNullOrBlank() && !phoneRegex.matches(dto.usr_mob!!)) {
            return mutableMapOf("check" to false, "message" to "핸드폰 번호 형식이 올바르지 않습니다. (000-0000-0000)")
        }
        if (dto.is_mfa == "Y" && dto.usr_mob.isNullOrBlank()) {
            return mutableMapOf("check" to false, "message" to "MFA 설정을 위해서는 핸드폰 번호가 필수입니다.")
        }

        // 1. 기본 데이터 가공 및 초기화
        dto.apply {
            usr_grp_cd = userInfo.usr_grp_cd
            usr_tel = usr_tel?.replace("-", "")
            usr_mob = usr_mob?.replace("-", "")
            is_mfa = if (is_mfa == "Y") "Y" else "N" // 3항 연산자 대체
        }

        if (dto.seq == null) {
            /** [신규 등록 로직] **/
            // 아이디 중복 체크
            if (sysUserDao.duplicationCheckId(dto) > 0) {
                return mutableMapOf("check" to false, "message" to "중복된 로그인 아이디(이메일) 입니다.")
            }
            // 비밀번호 패턴 검증
            if (!passwordPattern.matcher(dto.usr_pw.toString()).matches()) {
                return mutableMapOf("check" to false, "message" to "비밀번호는 8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.")
            }
            // 초기값 설정
            dto.usr_pw = CommonUtils.sha512(dto.usr_pw)
            dto.reg_id = userInfo.usr_id
            dto.access_yn = "1"
            // 신규 USR_ID 생성 로직
            val maxUserDto = sysUserDao.getMaxUser(Tblmi_usrDto().apply { usr_grp_cd = userInfo.usr_grp_cd })
            if (maxUserDto == null) {
                val commDto = sysSettingDao.getCommCD(Tblmi_comm_cdDto().apply {
                    grp_id = "USR_GRP_CD"
                    cd_id = userInfo.usr_grp_cd
                })!!
                dto.usr_id = "${commDto.cd_val}0001"
            } else {
                val maxId = maxUserDto.usr_id!!
                val preId = maxId.substring(0, maxId.length - 4)
                val nextNum = maxUserDto.cnt!! + 1
                dto.usr_id = preId + String.format("%04d", nextNum) // 숫자를 4자리 포맷으로 안전하게 생성
            }
            dto.appr_id = userInfo.usr_id
            val newUsrId = dto.usr_id

            // DB Insert
            if (sysUserDao.insertUser(dto) > 0) {
                val authInserted = sysUserDao.insertUserAuth(Tblmi_usr_authDto().apply {
                    usr_id = newUsrId
                    role_cd = dto.role_cd
                    reg_id = userInfo.usr_id
                })

                map["check"] = authInserted > 0
                map["message"] = if (authInserted > 0) "사용자가 추가 되었습니다." else "저장에 실패하였습니다. 관리자에게 문의해주세요."
            } else {
                map["check"] = false
                map["message"] = "저장에 실패하였습니다. 관리자에게 문의해주세요."
            }

        } else {
            /** [정보 수정 로직] **/
            dto.upd_id = userInfo.usr_id
            // 비밀번호 변경 시도 시 검증
            if (!dto.usr_pw.isNullOrEmpty()) {
                if (!passwordPattern.matcher(dto.usr_pw.toString()).matches()) {
                    return mutableMapOf("check" to false, "message" to "비밀번호는 8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.")
                }
                if (dto.usr_pw_old == null) {
                    return mutableMapOf("check" to false, "message" to "현재 비밀번호를 입력해주세요.")
                }
                val currentPwdInDb = commonDao.sel_tblmi_usrOne(Tblmi_usrDto(dto.usr_id)).usr_pw
                val inputOldPwdSha = CommonUtils.sha512(dto.usr_pw_old)
                val inputNewPwdSha = CommonUtils.sha512(dto.usr_pw)

                if (inputOldPwdSha != currentPwdInDb) {
                    return mutableMapOf("check" to false, "message" to "현재 비밀번호가 올바르지 않습니다.")
                }
                if (currentPwdInDb == inputNewPwdSha) {
                    return mutableMapOf("check" to false, "message" to "현재 비밀번호와 동일한 비밀번호는 사용할 수 없습니다.")
                }
                dto.last_pw_upd_dt = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(System.currentTimeMillis())
                dto.usr_pw = inputNewPwdSha
            }

            // DB Update
            if (sysUserDao.updateUser(dto) > 0) {
                val authDto = Tblmi_usr_authDto().apply {
                    usr_id = dto.usr_id
                    role_cd = dto.role_cd
                    upd_id = userInfo.usr_id
                }
                sysUserDao.deleteUserAuth(authDto)
                val authUpdated = sysUserDao.insertUserAuth(authDto)

                map["check"] = authUpdated > 0
                map["message"] = if (authUpdated > 0) "사용자 정보가 수정되었습니다." else "권한 수정에 실패하였습니다."
            } else {
                map["check"] = false
                map["message"] = "저장에 실패하였습니다. 관리자에게 문의해주세요."
            }
        }
        return map
    }

    override fun getAllUserList(uDto : Tblmi_usrDto): MutableMap<String, Any>{
        val dto = uDto as Usr_searchDto
        dto.firstIndex = null
        val map : MutableMap<String, Any> = HashMap()
        map["list"] = sysUserDao.getUserList(dto)
        return map
    }

    override fun updateUsrSt(uDto : Tblmi_usrDto): MutableMap<String, Any>{
        val dto = uDto as Usr_searchDto
        val userInfo = UsefulUtils.sessionUser()
        dto.upd_id = userInfo.usr_id
        val map : MutableMap<String, Any> = HashMap()
        if(sysUserDao.updateUser(dto) > 0){
            map["check"] = true
        }else{
            map["check"] = false
            map["message"] = "저장에 실패하였습니다. 관리자에게 문의해주세요."
        }
        return map
    }

    override fun getUserLog(uDto: Tblmi_usr_log_hstDto):MutableMap<String, Any>{
        val dto = uDto as Usr_log_searchDto
        val map : MutableMap<String, Any> = HashMap()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(pageNo,10,10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysUserDao.getUserLogCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysUserDao.getUserLog(dto);
        return map;
    }

}
