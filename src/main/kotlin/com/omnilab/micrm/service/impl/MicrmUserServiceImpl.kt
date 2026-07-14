package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.repository.MicrmUserDao
import com.omnilab.micrm.service.MicrmUserService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import java.security.SecureRandom
import java.util.*
import kotlin.collections.HashMap

@Service("MicrmUserServiceImpl")
class MicrmUserServiceImpl : MicrmUserService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("MicrmUserDaoImpl")
    private lateinit var micrmUserDao : MicrmUserDao

    @Autowired
    private lateinit var commonService: com.omnilab.micrm.service.CommonService

    override fun checkUserPassWord(password: String): Boolean {

        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()

        // 이메일 로 현재 유저 DB 정보 가져 오기
        val currentUser = Tblmi_usrDto()
        currentUser.usr_log_id = userInfo.usr_log_id
        val user = micrmUserDao.sel_tblmi_usr(currentUser)

        // 패스워드가 같을 경우 True , 아닐 경우 false
        return user.usr_pw.equals(CommonUtils.sha512(password))
    }

    override fun sel_check_id(usrDto: Tblmi_usrDto): HashMap<String, String> {
        return micrmUserDao.sel_check_id(usrDto)
    }

    override fun sendPassword(usrDto: Tblmi_usrDto): HashMap<String, String> {

        val userMap = HashMap<String,String>()
        val random = SecureRandom()
        val randomNumber = random.nextInt(79999) + 10000
        val tempPassword = "micrm$randomNumber"

        val sendTo = usrDto.usr_log_id
        val sendToNm = usrDto.usr_nm
        val sendFrom = UsefulUtils.adminEmail();
        val subject = "임시 비밀번호"
        val body = "임시 비밀번호를 발급합니다.<br> 임시 비밀번호는 " + tempPassword + "입니다"

        logger.error("tempPasword: $tempPassword");

        val userDto = Tblmi_usrDto()
        userDto.usr_log_id = usrDto.usr_log_id
        userDto.usr_pw = CommonUtils.sha512(tempPassword)

        micrmUserDao.updateUserPw(userDto)
        commonService.sendMail(sendTo!!, sendToNm!!, sendFrom, subject, body);


        return userMap
    }
}