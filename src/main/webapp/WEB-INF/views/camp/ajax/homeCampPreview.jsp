<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<!-- 캠페인 요약 이메일 영역 시작 -->
<span id="appendHtml">

<c:choose>
    <c:when test="${camp.cont_tp eq 'DMTP01'}">
        <div class="summary_modal edm_modal on">
            <c:set var="camp_id">${campId}</c:set>
            <div class="btn_hide">닫기</div>
            <h3>캠페인 요약</h3>
            <div class="padding_inner">
                <!-- [state1 : eDM 발송취소],[state2 : eDM 발송대기],[state3 : eDM 발송완료],[state4 : eDM 승인대기]
        [state5 : mms 발송취소],[state6 : mms 발송대기],[state7 : mms 발송대기],[state8 : mms 승인대기]    -->
                <div class="title ellipsis state${campST}CH01">${cutil:escapeTextToHtml(campTitle)}</div>
                <div class="sum_info cf">
                    <!-- 발송 날짜 영역 -->
                    <div class="date">발송일정<span>${cutil:stringDateTimeKorParse(startDt)}</span></div>
                    <!-- 발송 현황 영역 -->
                    <div class="state_txt">
                        <c:choose>
                            <c:when test="${campST eq '00'}">승인대기</c:when>
                            <c:when test="${campST eq '01'}">발송대기</c:when>
                            <c:when test="${campST eq '02'}">타겟추출중</c:when>
                            <c:when test="${campST eq '03'}">발송중</c:when>
                            <c:when test="${campST eq '04'}">완료</c:when>
                            <c:when test="${campST eq '99'}">발송실패</c:when>
                        </c:choose>
                    </div>
                </div>
                <!-- 이메일 viewer 영역 -->
                <div class="view">
                    <div class="img edm"><img src="${filePath}${camp.thm_url}" alt=""  onerror="this.src = '/image/bg_none_wide.png'"/></div>
                </div>
                <!-- Target 영역 -->
                <div class="row_state arrow cf">
                    <div class="th">Target</div>
                    <div class="td"><fmt:formatNumber value="${tarCnt}" pattern="#,###" /></div>
                    <div class="td percents">-</div>
                </div>
                <!-- Success 영역 -->
                <div class="row_state arrow cf">
                    <div class="th">Success</div>
                    <div class="td">
                        <c:choose>
                            <c:when test="${empty sendCnt[camp_id]}">0</c:when>
                            <c:otherwise> <fmt:formatNumber value="${sendCnt[camp_id].s_cnt}" pattern="#,###" /></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="td percents">(<fmt:formatNumber type="percent" pattern="0.00%" value="${sendCnt[camp_id].s_cnt/tarCnt}" />)</div>
                </div>
                <!-- Open 영역 -->
                <div class="row_state arrow cf">
                    <div class="th">Open</div>
                    <div class="td">
                        <c:choose>
                            <c:when test="${empty openCnt[camp_id]}">0</c:when>
                            <c:otherwise><fmt:formatNumber value="${openCnt[camp_id].cnt}" pattern="#,###" /></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="td percents">(<fmt:formatNumber type="percent" pattern="0.00%" value="${openCnt[camp_id].cnt/tarCnt}" />)</div>
                </div>
                <!-- Click 영역 -->
                <div class="row_state cf">
                    <div class="th">Click</div>
                    <div class="td">
                        <c:choose>
                            <c:when test="${empty trackCnt[camp_id]}">0</c:when>
                            <c:otherwise><fmt:formatNumber value="${trackCnt[camp_id].cnt}" pattern="#,###" /></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="td percents">(<fmt:formatNumber type="percent" pattern="0.00%" value="${trackCnt[camp_id].cnt/tarCnt}" />)</div>
                </div>
                <!-- 상세 보러가기 버튼 -->
                <a href="/camp/st/sendDetail.mi?pid=${programId}" class="btn_link">상세</a>
            </div>
        </div>
        <!-- 캠페인 요약 이메일 영역 끝 -->
    </c:when>
    <c:otherwise>
        <!-- 캠페인 요약 문자 영역 시작 -->
        <div class="summary_modal mms_modal on">
            <c:set var="camp_id">${campId}</c:set>
            <div class="btn_hide">닫기</div>
            <h3>캠페인 요약</h3>
            <div class="padding_inner">
                <div class="title ellipsis state${campST}CH02">${cutil:escapeTextToHtml(campTitle)}</div>
                <div class="sum_info cf">
                   <!-- 발송 날짜 영역 -->
                    <div class="date">발송일정<span>${cutil:stringDateTimeKorParse(startDt)}</span></div>
                    <!-- 발송 현황 영역 -->
                    <div class="state_txt">
                        <c:choose>
                            <c:when test="${campST eq '00'}">승인대기</c:when>
                            <c:when test="${campST eq '01'}">발송대기</c:when>
                            <c:when test="${campST eq '02'}">타겟추출중</c:when>
                            <c:when test="${campST eq '03'}">발송중</c:when>
                            <c:when test="${campST eq '04'}">완료</c:when>
                            <c:when test="${campST eq '99'}">발송실패</c:when>
                        </c:choose>
                    </div>
                </div>
                <!-- 문자 viewer 영역 -->
                <div class="view">
                    <c:if test = "${!cutil:isEmptyObject(camp.img_lst)}">
                    <div class="img mms">
                        <c:choose>
                            <c:when test="${!cutil:isEmptyObject(camp.img_lst)}">
                                <c:set var="img_lst" value="${fn:split(camp.img_lst,',')}"/>
                                <img src="${filePath}${img_lst[0]}" alt=""  onerror="this.src = '/image/bg_none_wide.png'"/>
                            </c:when>
                            <c:when test="${!cutil:isEmptyObject(camp.kko_image_url)}">
                                <img src="${filePath}${camp.kko_image_url}" alt=""  onerror="this.src = '/image/bg_none_wide.png'"/>
                            </c:when>
                            <c:otherwise>
                                <img src="/image/bg_none_wide.png" alt=""/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    </c:if>
                    <p class="mms">
                        <c:choose>
                            <c:when test="${camp.cont_tp eq 'DMTP04'}">
                                    ${cutil:replaceBr(camp.cont_body_json[0]['description'])}
                            </c:when>
                            <c:otherwise>
                                ${cutil:replaceBr(camp.cont_body)}
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <!-- Target 영역 -->
                <div class="row_state arrow cf">
                    <div class="th">Target</div>
                    <div class="td"><fmt:formatNumber value="${tarCnt}" pattern="#,###" /></div>
                    <div class="td percents">-</div>
                </div>
                <!-- Success 영역 -->
                <div class="row_state arrow cf">
                    <div class="th">Success</div>
                    <div class="td">
                        <c:choose>
                            <c:when test="${empty sendCnt[camp_id]}">0</c:when>
                            <c:otherwise> <fmt:formatNumber value="${sendCnt[camp_id].s_cnt}" pattern="#,###" /></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="td percents">(<fmt:formatNumber type="percent" pattern="0.00%" value="${sendCnt[camp_id].s_cnt/tarCnt}" />)</div>
                </div>
                <!-- Open 영역 -->
                <div class="row_state arrow cf">
                    <div class="th">Open</div>
                    <div class="td">
                        <c:choose>
                            <c:when test="${empty openCnt[camp_id]}">0</c:when>
                            <c:otherwise><fmt:formatNumber value="${openCnt[camp_id].cnt}" pattern="#,###" /></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="td percents">(<fmt:formatNumber type="percent" pattern="0.00%" value="${openCnt[camp_id].cnt/tarCnt}" />)</div>
                </div>
                <!-- Click 영역 -->
                <div class="row_state cf">
                    <div class="th">Click</div>
                    <div class="td">
                        <c:choose>
                            <c:when test="${empty trackCnt[camp_id]}">0</c:when>
                            <c:otherwise><fmt:formatNumber value="${trackCnt[camp_id].cnt}" pattern="#,###" /></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="td percents">(<fmt:formatNumber type="percent" pattern="0.00%" value="${trackCnt[camp_id].cnt/tarCnt}" />)</div>
                </div>
                <!-- 상세 보러가기 버튼 -->
                <a href="/camp/st/sendDetail.mi?pid=${programId}" class="btn_link">상세</a>
            </div>
        </div>
        <!-- 캠페인 요약 문자 영역 끝 -->
    </c:otherwise>
</c:choose>

</span>


