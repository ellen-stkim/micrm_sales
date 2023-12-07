package com.omnilab.micrm.service.impl

import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.SysInfoService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import java.text.SimpleDateFormat
import java.util.*

@Service("SysInfoServiceImpl")
class SysInfoServiceImpl : SysInfoService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("SysSettingDaoImpl")
    lateinit var sysSettingDao : SysSettingDao

    override fun setCode(lst: MutableList<Tblmi_comm_cdDto>): Boolean {
        try{
            val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            for(i in lst){
                i.use_yn = "Y"
                if(i.seq == null && !i.cd_val.isNullOrEmpty()){
                    sysSettingDao.ins_tblmi_comm_cd(i)
                    i.reg_dt = sdf.format(Date())
                }else{
                    sysSettingDao.upd_tblmi_comm_cd(i)
                    i.upd_dt = sdf.format(Date())
                }
            }
            return true
        }catch (e: Exception){
            logger.error("setcode", e)
            return false
        }
    }

}
