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
import org.springframework.web.servlet.resource.ResourceHttpRequestHandler
import java.lang.Boolean.TRUE
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class InterceptorHandler : HandlerInterceptor {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("CommonDaoImpl")
    private lateinit var commonDao: CommonDao

    override fun preHandle(req: HttpServletRequest, rep: HttpServletResponse, handler: Any): Boolean {
        req.characterEncoding = "UTF-8"
        //rep.contentType = "text/html; charset=UTF-8"

        if (handler is ResourceHttpRequestHandler) {
            return true
        }

        val isPending = req.session.getAttribute("MFA_PENDING") as Boolean?
        // 2차 인증이 필요한 상태인데, 현재 페이지가 인증번호 입력 페이지나 API가 아니라면
        if (TRUE == isPending) {
            val uri: String = req.requestURI
            if (!uri.startsWith("/login/mfa.mi")
                && !uri.startsWith("/api/sms/verify.service")
                && !uri.startsWith("/api/sms/resend.service")
                && !uri.startsWith("/error/error.mi")
                ) {
                rep.sendRedirect("/login/mfa.mi")
                return false
            }
        }
        return super.preHandle(req, rep, handler)
    }

    override fun postHandle(req: HttpServletRequest, rep: HttpServletResponse, handler: Any, modelAndView: ModelAndView?) {
        //rep.setHeader("Set-Cookie", "JSESSIONID=" + req.requestedSessionId + "; HttpOnly; path=/; Secure; SameSite=None;")
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
                "/mbr/downloadTblmiList.mi" -> detail = "회원관리 : DB 회원 내려받기";
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
                "/cont/updateImg.ajax" -> detail = "메시지 : 이미지 파일 수정";
                "/cont/mdmLst.mi" -> detail = "메시지 : 문자 컨텐츠 조회";
                "/cont/mdmCreate.mi" -> detail = "메시지 : 문자 컨텐츠 생성 페이지 접속";
                "/cont/mobileInsert.service" -> detail = "메시지 : 문자 컨텐츠 생성";
                "/cont/mobileUpdate.service" -> detail = "메시지 : 문자 컨텐츠 수정";
                "/cont/updateMobileUseYn.ajax" -> detail = "메시지 : 문자 컨텐츠 사용/비사용 상태 수정";
                "/cont/deleteMobileContent.ajax" -> detail = "메시지 : 문자 컨텐츠 삭제";
                "/cont/atTemplate.mi" -> detail = "메시지 : 알림톡 템플릿 조회";
                "/cont/kko/tmplCreate.mi" -> detail = "메시지 : 알림톡 템플릿 생성 페이지 접속";
                "/cont/kko/tmplCreate.service" -> detail = "메시지 : 알림톡 템플릿 생성";
                "/cont/kko/tmplDetail.mi" -> detail = "메시지 : 알림톡 템플릿 상세 조회";
                "/cont/kko/tmplUpate.service" -> detail = "메시지 : 알림톡 템플릿 수정";
                "/cont/kko/updateUseYn.ajax" -> detail = "메시지 : 알림톡 템플릿 사용/비사용 상태 수정";
                "/cont/kko/updateDelYn.ajax" -> detail = "메시지 : 알림톡 템플릿 삭제";
                "/cont/kko/updReqTmplSt.service" -> detail = "메시지 : 알림톡 템플릿 검수요청";
                "/cont/kko/cancleTmplReq.service" -> detail = "메시지 : 알림톡 템플릿 검수요청 취소";
                "/cont/kko/updTmplSt.service" -> detail = "메시지 : 알림톡 템플릿 상태 수정";
                "/cont/kko/cancleTmplApp.service" -> detail = "메시지 : 알림톡 템플릿 승인 취소";
                "/camp/sendSetting.mi" -> detail = "캠페인 : 캠페인 발송(캠페인 생성) 페이지 접속";
                "/camp/sendTempCreate.ajax" -> detail = "캠페인 : 캠페인 임시저장";
                "/camp/sendTest.ajax" -> detail = "캠페인 : 캠페인 테스트 발송";
                "/camp/sendCreate.service" -> detail = "캠페인 : 캠페인 작성, 승인 요청";
                "/camp/st/sendStatus.mi" -> detail = "캠페인 : 캠페인 발송현황 조회";
                "/camp/st/sendDetail.mi" -> detail = "캠페인 : 캠페인 상세보기";
                "/camp/getSendHstDown.service" -> detail = "캠페인 : 캠페인 발송 이력 내려받기";
                "/report/main.mi" -> detail = "리포트 : 리포트 대시보드 조회";
                "/report/all.mi" -> detail = "리포트 : 캠페인 통합 리포트 조회";
                "/report/dt.mi" -> detail = "리포트 : 캠페인 통합 리포트 상세 조회";
                "/report/proDt.mi" -> detail = "리포트 : 캠페인 프로그램별 리포트 조회";
                "/report/singleDt.mi" -> detail = "리포트 : 캠페인 단건 리포트 조회";
                "/report/banWordHst.mi" -> detail = "리포트 : 금칙어 차단 이력 조회";
                "/cost/costDetail.mi" -> detail = "리포트 : 발송 비용 조회";
                "/cost/costReportDown.service" -> detail = "리포트 : 발송 비용 리포트 내려받기";
                "/cost/costReportLstDown.service" -> detail = "리포트 : 발송 비용 상세 내려받기";
                "/sys/work/workList.mi" -> detail = "시스템관리 : 작업 리스트 조회";
                "/sys/user/userManagement.mi" -> detail = "시스템관리 : 사용자 조회";
                "/sys/user/userDetail.mi" -> detail = "시스템관리 : 사용자 상세 조회";
                "/sys/user/saveUser.ajax" -> detail = "시스템관리 : 사용자 등록/수정";
                "/sys/user/updateUsrSt.ajax" -> detail = "시스템관리 : 사용자 상태 수정";
                "/sys/user/getUserLog.ajax" -> detail = "시스템관리 : 사용자 접속 이력 조회";
                "/sys/user/myInfo.mi" -> detail = "시스템관리 : 내 정보 조회";
                "/sys/info/main.mi" -> detail = "시스템관리 : 시스템 정보 조회";
                "/sys/info/save.service" -> detail = "시스템관리 : 시스템 정보 수정";
                "/sys/setting/teamSetting.mi" -> detail = "시스템관리 : 팀 정보 설정 조회";
                "/sys/setting/insertTeam.ajax" -> detail = "시스템관리 : 팀 정보 등록/수정";
                "/sys/setting/updateSortLst.ajax" -> detail = "시스템관리 : 팀 정보 순서 수정";
                "/sys/setting/mappingSetting.mi" -> detail = "시스템관리 : 매핑 정보 설정 조회";
                "/sys/setting/insertMapping.ajax" -> detail = "시스템관리 : 매핑 정보 등록/수정";
                "/sys/setting/deleteMapping.ajax" -> detail = "시스템관리 : 매핑 정보 삭제";
                "/sys/setting/smsSetting.mi" -> detail = "시스템관리 : 문자 정보 설정 조회";
                "/sys/setting/insertSms.ajax" -> detail = "시스템관리 : 문자 발신번호 등록";
                "/sys/setting/updateLst.ajax" -> detail = "시스템관리 : 발신자 정보 수정";
                "/sys/setting/changeDefaultLst.ajax" -> detail = "시스템관리 : 기본 연락처 변경";
                "/sys/setting/kkoSetting.mi" -> detail = "시스템관리 : 카카오 정보 설정 조회";
                "/sys/setting/insertKkoSenderKey.ajax" -> detail = "시스템관리 : 카카오 발신프로필 등록";
                "/sys/setting/rejectSetting.mi" -> detail = "시스템관리 : 수신거부 문구 설정 조회";
                "/sys/setting/insertRejectText.ajax" -> detail = "시스템관리 : 수신거부 문구 등록";
                "/sys/setting/naverAppSetting.mi" -> detail = "시스템관리 : 네이버 Short URL 설정 조회";
                "/sys/setting/insertNaverApp.ajax" -> detail = "시스템관리 : 네이버 Short URL 설정 등록";
                "/sys/setting/updateNaverApp.ajax" -> detail = "시스템관리 : 네이버 Short URL 설정 수정";
                "/sys/setting/deleteNaverApp.ajax" -> detail = "시스템관리 : 네이버 Short URL 설정 삭제";
                "/sys/setting/mcSetting.mi" -> detail = "시스템관리 : Marketing Cloud 설정 조회";
                "/sys/setting/updateMcSetting.ajax" -> detail = "시스템관리 : Marketing Cloud 설정 수정";
                "/sys/setting/deleteAddress.ajax" -> detail = "시스템관리 : 발신 정보 삭제";
                "/sys/setting/updateSetLstYn.ajax" -> detail = "시스템관리 : 설정 항목 사용/비사용 상태 수정";
                "/sys/setting/changeTypeDefYn.ajax" -> detail = "시스템관리 : 설정 항목 기본값 수정";
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

                // URL 에 변수가 포함되어 정확히 일치하지 않는 경우
                else -> {
                    if (url.startsWith("/cont/mdmDetail/")) {
                        detail = "메시지 : 문자 컨텐츠 상세 조회"
                    } else {
                        checkIn = false
                    }
                }
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