package com.omnilab.micrm.config.handler

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.table.Tblmi_usr_hstDto
import com.omnilab.micrm.repository.CommonDao
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier

import org.springframework.web.servlet.HandlerInterceptor
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class InterceptorHandler : HandlerInterceptor {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("CommonDaoImpl")
    private lateinit var commonDao: CommonDao

    override fun preHandle(req: HttpServletRequest, rep: HttpServletResponse, handler: Any): Boolean {
        req.characterEncoding = "UTF-8"
        rep.contentType = "text/html; charset=UTF-8"
        return super.preHandle(req, rep, handler)
    }

    override fun postHandle(req: HttpServletRequest, rep: HttpServletResponse, handler: Any, modelAndView: ModelAndView?) {
        rep.setHeader("Set-Cookie", "JSESSIONID=" + req.requestedSessionId + "; HttpOnly; path=/; Secure; SameSite=None;")
        super.postHandle(req, rep, handler, modelAndView)
    }

    override fun afterCompletion(req: HttpServletRequest, rep: HttpServletResponse, handler: Any, ex: Exception?) {
        try {
            super.afterCompletion(req, rep, handler, ex)
            var checkIn: Boolean = true
            val url = req.requestURI
            var detail = "hello, detail"
            when (url) {
                "/home.mi" -> detail = "공통 기능 : 메인 대시보드 조회";
//                "/mbr/member.mi" -> detail = "회원관리 : DB 회원 조회";
                "/mbr/downloadTblmiList.mi" -> detail = "회원관리 : DB 회원 내려받기";
//                "/mbr/reject.mi" -> detail = "회원관리 : 수신거부 회원 조회";
                "/mbr/saveTblmiSupForm.ajax" -> detail = "회원관리 : 수신거부 파일 업로드";
                "/mbr/saveTblmiSupList.ajax" -> detail = "회원관리 : 수신거부 개별 추가";
                "/mbr/deleteAllTblmiSupList.ajax" -> detail = "회원관리 : 수신거부 회원 전체 삭제";
                "/mbr/deleteTblmiSupList.ajax" -> detail = "회원관리 : 수신거부 회원 개별 삭제";
                "/mbr/downloadTblmiSup.mi" -> detail = "회원관리 : 수신거부 회원 내려받기";
                "/cont/edmLst.mi" -> detail = "메시지 : 이메일 컨텐츠 조회";
                "/cont/edmDetail.mi" -> detail = "메시지 : 이메일 컨텐츠 상세 조회";
                "/cont/updateEdmYn.ajax" -> detail = "메시지 : 이메일 컨텐츠 사용/비사용 상태 수정";
                "/cont/deleteEdmList.ajax" -> detail = "메시지 : 이메일 컨텐츠 삭제";
                "/cont/edmCreate.mi" -> detail = "메시지 : 이메일 컨텐츠 생성 페이지 접속";
                "/cont/saveContForm.mi" -> detail = "메시지 : 이메일 컨텐츠 생성";
                "/cont/updateEmailContForm.mi" -> detail = "메시지 : 이메일 컨텐츠 수정";
                "/cont/imgLst.mi" -> detail = "메시지 : 이미지 파일 조회";
                "/cont/contentUpload.ajax" -> detail = "메시지 : 이미지 파일 업로드";
                "/cont/deleteImgList.ajax" -> detail = "메시지 : 이미지 파일 삭제";
                "/cont/updateImgYn.ajax" -> detail = "메시지 : 이미지 파일 사용/비사용 상태 수정";
                "/camp/sendSetting.mi" -> detail = "캠페인 : 캠페인 발송(캠페인 생성) 페이지 접속";
                "/camp/sendTempCreate.ajax" -> detail = "캠페인 : 캠페인 임시저장";
                "/camp/sendTest.ajax" -> detail = "캠페인 : 캠페인 테스트 발송";
                "/camp/sendCreate.service" -> detail = "캠페인 : 캠페인 작성, 승인 요청";
                "/camp/st/sendStatus.mi" -> detail = "캠페인 : 캠페인 발송현황 조회";
                "/camp/st/sendDetail.mi" -> detail = "캠페인 : 캠페인 상세보기";
                "/sys/work/workList.mi" -> detail = "시스템관리 : 작업 리스트 조회";
                "/coupon/couponList.mi" -> detail = "쿠폰 : 쿠폰 리스트 페이지 조회";
                "/coupon/couponRegister.mi" -> detail = "쿠폰 : 쿠폰 등록 페이지 접속";
                "/coupon/couponUpdate.mi" -> detail = "쿠폰 : 쿠폰 수정 페이지 접속";
                "/coupon/couponIssue.mi" -> detail = "쿠폰 : 쿠폰 발급 페이지 접속";
                "/coupon/couponIssuedLog.mi" -> detail = "쿠폰 : 쿠폰 발급 내역 페이지 접속";
                "/coupon/registerCoupon.service" -> detail = "쿠폰 : 쿠폰 등록";
                "/coupon/updateCoupon.service" -> detail = "쿠폰 : 쿠폰 수정";
                "/coupon/deleteCoupon.service" -> detail = "쿠폰 : 쿠폰 삭제";
                "/coupon/issueCoupon.service" -> detail = "쿠폰 : 쿠폰 발급";
                "/coupon/deleteCouponIssuedLog.service" -> detail = "쿠폰 : 쿠폰 발급 내역 삭제";
                "/coupon/getCouponList.ajax" -> detail = "쿠폰 : 쿠폰 리스트 조회";
                "/coupon/getCouponIssuedLogList.ajax" -> detail = "쿠폰 : 쿠폰 발급 내역 조회";
                "/coupon/extractExcel.ajax" -> detail = "쿠폰 : 쿠폰 발급 대상자 엑셀 추출";

                else -> checkIn = false
            }
            if (checkIn) {
                val userInfo = UsefulUtils.sessionUser()
                val dto = Tblmi_usr_hstDto()
                dto.usr_grp_cd = userInfo.usr_grp_cd
                dto.usr_seq = userInfo.seq
                dto.usr_id = userInfo.usr_id
                var usrIp: String = CommonUtils.clientip(req)
                if (usrIp == "0:0:0:0:0:0:0:1")
                    usrIp = "127.0.0.1"
                dto.usr_ip = usrIp
                dto.work_url = url
                dto.work_detail = detail
                dto.reg_id = userInfo.usr_id
                var returnCheck = commonDao.insertUserHistoryLog(dto)
            }
        }catch (ex2 : Throwable){

        }
    }

}