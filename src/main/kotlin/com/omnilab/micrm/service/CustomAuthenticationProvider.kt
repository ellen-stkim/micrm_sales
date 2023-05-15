package com.omnilab.micrm.service

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.model.table.*
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.authentication.AuthenticationProvider
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.AuthenticationException
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.stereotype.Component
import java.util.*
import javax.servlet.http.HttpServletRequest
import kotlin.jvm.Throws


@Component("customAuthenticationProvider")
class CustomAuthenticationProvider : AuthenticationProvider {

    private val log = LoggerFactory.getLogger(CustomAuthenticationProvider::class.java)

    @Autowired(required = true)
    private lateinit var request: HttpServletRequest

    @Autowired
    private lateinit var sqlSession: SqlSession

    @Throws(AuthenticationException::class)
    override fun authenticate(auth: Authentication): Authentication {
        val usrEmail = auth.principal.toString()
        val usrPw = auth.credentials.toString()


        if(usrEmail.trim().isEmpty() || usrPw.trim().isEmpty()){
            throw BadCredentialsException("BAD")
        }
        var ip = CommonUtils.clientip(request)
        if (ip == "0:0:0:0:0:0:0:1")
            ip = "127.0.0.1"

        val loginDto = Tblmi_usrDto(usrEmail, CommonUtils.sha512(usrPw))
        val userInfo: Tblmi_usrDto? = sqlSession.selectOne("sel_login", loginDto)

        if(userInfo == null){
            val commDto = Tblmi_comm_cdDto()
            commDto.par_id = "SALESFORCE"
            commDto.grp_id = "SALES_MID"
            commDto.cd_id = usrEmail
            val usrGrpCd = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", commDto)

            if(usrGrpCd == null){
                val info: Tblmi_usrDto? = sqlSession.selectOne("sel_tblmi_usr", loginDto)
                if(info != null){
                    sqlSession.insert("ins_tblmi_usr_log_hst", Tblmi_usr_log_hstDto(info.usr_grp_cd!!, info.usr_id!!, info.usr_email!!, ip, "1"))
                }else{
                    sqlSession.insert("ins_tblmi_usr_log_hst", Tblmi_usr_log_hstDto(usrEmail, ip, "1"))
                }
                throw BadCredentialsException("BAD")
            }else{
                val roles = ArrayList<GrantedAuthority>()
                roles.add(SimpleGrantedAuthority("ROLE_SALES"))
                //세일즈 포스 접속
                val result = UsernamePasswordAuthenticationToken(usrEmail, "", roles)
                val uInfo = Tblmi_usrDto()
                uInfo.usr_id = usrPw
                uInfo.usr_sales_id = usrPw
                uInfo.usr_sales_org_id = usrEmail
                uInfo.usr_grp_cd = usrGrpCd.cd_val
                result.details = uInfo
                return result
            }
        }else{
            val usrSt = userInfo.usr_st
            if(usrSt.equals("2")){
                sqlSession.insert("ins_tblmi_usr_log_hst", Tblmi_usr_log_hstDto(userInfo.usr_grp_cd!!, userInfo.usr_id!!, userInfo.usr_email!!, ip, "1"))
                throw BadCredentialsException("미사용 계정입니다. 관리자에 문의해 주세요.")
            }else if(usrSt.equals("3")){
                sqlSession.insert("ins_tblmi_usr_log_hst", Tblmi_usr_log_hstDto(userInfo.usr_grp_cd!!, userInfo.usr_id!!, userInfo.usr_email!!, ip, "1"))
                throw BadCredentialsException("차단 계정입니다. 관리자에 문의해 주세요.")
            }
            /*IP 차단 확인*/
            val blockDto = Tblmi_block_lstDto()
            blockDto.block_target = ip
            blockDto.block_grp_cd = userInfo.usr_grp_cd
            val ipBlockDto : List<Tblmi_block_lstDto> = sqlSession.selectList("getBlockBlockDto", blockDto)
            if(!ipBlockDto.isNullOrEmpty()){
                sqlSession.insert("ins_tblmi_usr_log_hst", Tblmi_usr_log_hstDto(userInfo.usr_grp_cd!!, userInfo.usr_id!!, userInfo.usr_email!!, ip, "1"))
                throw BadCredentialsException("현재 접속하신 IP[$ip]는 현재 차단된 상태입니다. 소속 그룹 관리자 또는 Milvus로 문의해 주세요.")
            }
            sqlSession.insert("ins_tblmi_usr_log_hst", Tblmi_usr_log_hstDto(userInfo.usr_grp_cd!!, userInfo.usr_id!!, userInfo.usr_email!!, ip, "0"))
            sqlSession.update("upd_tblmi_usr_log_in_dt", userInfo)
            val roleList: List<Tblmi_usr_authDto> = sqlSession.selectList("sel_tblmi_usr_auth", Tblmi_usr_authDto(userInfo.usr_id!!))
            val roles = ArrayList<GrantedAuthority>()
            roles.add(SimpleGrantedAuthority("ROLE_SALES"))
            roles.add(SimpleGrantedAuthority("ROLE_WEB"))
            for(role in roleList){
                roles.add(SimpleGrantedAuthority("ROLE_${role.role_cd}"))
            }
            val result = UsernamePasswordAuthenticationToken(usrEmail, "", roles)
            userInfo.usr_pw = null
            result.details = userInfo
            return result
        }
    }

    override fun supports(auth: Class<*>): Boolean {
        return auth == UsernamePasswordAuthenticationToken::class.java
    }

}