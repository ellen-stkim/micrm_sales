package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.service.MemberService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import kotlin.collections.HashMap

@Service("MemberServiceImpl")
class MemberServiceImpl : MemberService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("MemberDaoImpl")
    private lateinit var memberDao: MemberDao

    override fun getTblTblSum() : Map<String, Any>{
        val map: MutableMap<String, Any> = HashMap()
        val tblmstDto = Tblmi_tbl_mstDto()
        tblmstDto.tbl_grp = UsefulUtils.sessionUser().usr_grp_cd
        val resultTblmst = memberDao.getTblmimst(tblmstDto)
        if(resultTblmst != null){
            //member table 정보(total cnt, send cnt 정보등 가져오기) (tblmi_tbl_sum)
            val tblSumDto = Tblmi_tbl_sumDto()
            tblSumDto.tbl_id = resultTblmst.tbl_id
            val sumCheck = memberDao.getTblTblSum(tblSumDto)
            if(sumCheck != null){
                map["tblSum"] = sumCheck
                map["tblSumCk"] = true
            }else{
                map["tblSumCk"] = false
            }
        }else{
            map["tblSumCk"] = false
        }
        return map
    }

}







