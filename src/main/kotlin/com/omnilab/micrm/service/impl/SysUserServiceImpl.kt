package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Usr_log_searchDto
import com.omnilab.micrm.model.Usr_searchDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmi_usr_authDto
import com.omnilab.micrm.model.table.Tblmi_usr_log_hstDto
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.repository.SysUserDao
import com.omnilab.micrm.service.SysUserService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.HashMap


@Service("SysUserServiceImpl")
class SysUserServiceImpl: SysUserService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var sysUserDao : SysUserDao;
    @Autowired
    lateinit var sysSettingDao : SysSettingDao;

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
        val map : MutableMap<String, Any> = HashMap()
        val userInfo = UsefulUtils.sessionUser()

        dto.usr_grp_cd = userInfo.usr_grp_cd
        dto.usr_tel = dto.usr_tel?.replace("-","")
        dto.usr_mob = dto.usr_mob?.replace("-","")

        if(dto.seq == null){
            //아이디 중복체크
            val duplCk = sysUserDao.duplicationCheckId(dto);
            if(duplCk > 0 ){
                map["check"] = false
                map["message"] = "중복된 로그인 아이디(이메일) 입니다."
                return map
            }
            dto.usr_pw = CommonUtils.sha512(dto.usr_pw)
            dto.reg_id = userInfo.usr_id
            dto.access_yn = "1"
            val tempDto : Tblmi_usrDto = Tblmi_usrDto()
            tempDto.usr_grp_cd = userInfo.usr_grp_cd
            val maxUserDto = sysUserDao.getMaxUser(tempDto);
            val newUsrId :String?
            if(maxUserDto == null){
                var commDto = Tblmi_comm_cdDto()
                commDto.grp_id = "USR_GRP_CD"
                commDto.cd_id = userInfo.usr_grp_cd
                commDto = sysSettingDao.getCommCD(commDto)!!
                val preId = commDto.cd_val
                dto.usr_id = preId + "0001"
                dto.appr_id = userInfo.usr_id
                newUsrId = dto.usr_id
            }else{
                val maxId = maxUserDto.usr_id!!
                val lengthId = maxId.length
                val preId = maxId.substring(0,lengthId-4)
                var surId = maxId.substring(lengthId-4)
                val parseId = (surId.toInt()+1).toString()
                surId = surId.substring(0,surId.length-parseId.length)
                dto.usr_id = preId + surId + parseId
                dto.appr_id = userInfo.usr_id
                newUsrId = dto.usr_id
            }

            if(sysUserDao.insertUser(dto) > 0){
                val authDto : Tblmi_usr_authDto = Tblmi_usr_authDto()
                authDto.usr_id = newUsrId
                authDto.role_cd = dto.role_cd
                authDto.reg_id = userInfo.usr_id
                if(sysUserDao.insertUserAuth(authDto) >0){
                    map["check"] = true
                    map["message"] = "사용자가 추가 되었습니다."
                }else{
                    map["check"] = false
                    map["message"] = "저장에 실패하였습니다. 관리자에게 문의해주세요."
                }
            }else{
                map["check"] = false
                map["message"] = "저장에 실패하였습니다. 관리자에게 문의해주세요."
            }
        }else{
            dto.upd_id = userInfo.usr_id
            if(!dto.usr_pw.isNullOrEmpty()){
                dto.last_pw_upd_dt = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(System.currentTimeMillis())
                dto.usr_pw = CommonUtils.sha512(dto.usr_pw)
            }
            if(sysUserDao.updateUser(dto) > 0){
                val authDto : Tblmi_usr_authDto = Tblmi_usr_authDto()
                authDto.usr_id = dto.usr_id
                authDto.role_cd = dto.role_cd
                authDto.upd_id = userInfo.usr_id
                if(sysUserDao.updateUserAuth(authDto) >0) {
                    map["check"] = true
                    map["message"] = "사용자 정보가 수정되었습니다."
                }
            }else{
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

    override fun getUserLog(udto: Tblmi_usr_log_hstDto):MutableMap<String, Any>{
        val dto = udto as Usr_log_searchDto
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
