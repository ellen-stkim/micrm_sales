package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Tblmi_mfa
import com.omnilab.micrm.model.table.Tblmi_workDto
import com.omnilab.micrm.model.table.mdm.LgSc_tranDto


interface MfaDao {
   fun selTblmiMfa(dto: Tblmi_mfa): Tblmi_mfa?
   fun insTblmiMfa(dto: Tblmi_mfa): Int
   fun updTblmiMfa(dto: Tblmi_mfa): Int

   fun insSmsLg(dto: LgSc_tranDto): Int

}