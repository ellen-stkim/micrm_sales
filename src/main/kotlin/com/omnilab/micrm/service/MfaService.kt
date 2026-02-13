package com.omnilab.micrm.service


interface MfaService {
    fun sendVerificationCode(usrId: String, phone: String, usrGprCd:String): MutableMap<String, Any>
    fun codeCheck(usrId: String, phone: String, code:String): Boolean

}