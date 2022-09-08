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
<div class="section">
<div class="status_area cf">
    <ol class="left cf" id="olDom">
        <li class="step_box">
            <div class="top">
                <span class="status_mark"></span>임시저장
            </div>
            <div class="en_font number">${tempSave}</div>
        </li>
        <li class="step_box">
            <div class="top">
                <span class="status_mark orange"></span>승인대기
            </div>
            <div class="en_font number">${waitAppo}</div>
        </li>
        <li class="step_box">
            <div class="top">
                <span class="status_mark blue"></span>발송대기
            </div>
            <div class="en_font number">${waitSend}</div>
        </li>
        <li class="step_box">
            <div class="top">
                <span class="status_mark green"></span>타겟추출
            </div>
            <div class="en_font number">${targeting}</div>
        </li>
        <li class="step_box">
            <div class="top">
                <span class="status_mark purple"></span>발송중
            </div>
            <div class="en_font number">${sending}</div>
        </li>
        <li class="step_box">
            <div class="top">
                <span class="status_mark indigo"></span>발송완료
            </div>
            <div class="en_font number">${success}</div>
        </li>
    </ol>
    <div class="fail step_box right">
        <div class="top">
            <span class="status_mark red"></span>발송실패
        </div>
        <div class="en_font number">${error}</div>
    </div>
</div>


<c:choose>
    <c:when test="${!cutil:isEmptyObject(list)}">
        <div class="scroll_tbl" id="bodyDom">
            <!-- table 영역 시작 -->
            <table class="table target_tbl dynamic_tbl list" id="sendTable">
                <thead>
                <tr>
                    <th>상태</th>
                    <th>구분</th>
                    <th>캠페인 명</th>
                    <th>발송일시</th>
                    <th>발송 타겟</th>
                    <th>타겟 수</th>
                    <th>발송 담당자</th>
                    <th>보기</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${list}" varStatus="status">
                    <tr>
                        <td><span class="status_mark
                            <c:choose>
                                <c:when test="${item.pro_st eq '00'}">orange</c:when>
                                <c:when test="${item.pro_st eq '01'}">blue</c:when>
                                <c:when test="${item.pro_st eq '02'}">green</c:when>
                                <c:when test="${item.pro_st eq '03'}">purple</c:when>
                                <c:when test="${item.pro_st eq '04'}">indigo</c:when>
                                <c:when test="${item.pro_st eq '99'}">red</c:when>
                            </c:choose>
                        "></span>${item.pro_st_nm}</td>
                        <td>${item.pro_tg_tp_nm}</td>
                        <td><span class="ellipsis">${item.pro_nm}</span></td>
                        <td class="en_font">${item.start_dt}</td>
                        <td>${item.target_nm}</td>
                        <td><span class="en_font"><fmt:formatNumber value="${item.tar_cnt}" pattern="#,###" /></span>명</td>
                        <td><span class="en_font">${item.usr_nm} (${item.usr_email})</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${item.pro_tg_tp eq 'TEST'}">
                                    <div onclick="testDetailPopup(this);" class="btn_sm_line btn_inline size">상세</div>
                                </c:when>
                                <c:otherwise>
                                    <a href="/camp/st/sendDetail.mi?pid=${item.pro_id}" class="btn_sm_line btn_inline size">상세</a>
                                </c:otherwise>
                            </c:choose>
                            <!-- 플로우 페이지 이동 -->
                            <!-- <a href="#" class="btn_sm_line btn_inline size btn_flow"><img src="../../image/ico_btn19.png" alt=""/></a> -->
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="btn_row bottom-border">
            <ul class="pager" id="pagingDom">
                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getSearchSendStatus"/>
            </ul>
        </div>
        <!-- table 영역 끝 -->
    </c:when>
    <c:otherwise>
        <div class="scroll_tbl" id="bodyDom">
            <!-- table 영역 시작 -->
            <table class="table target_tbl dynamic_tbl list" id="sendTable">
                <thead>
                <tr>
                    <th>상태</th>
                    <th>캠페인 명</th>
                    <th>발송일시</th>
                    <th>발송 타겟</th>
                    <th>타겟 수</th>
                    <th>발송 담당자</th>
                    <th>보기</th>
                </tr>
                </thead>
                <tbody>
                <tr class="no_data">
                    <td colspan="100%">조회된 결과가 없습니다.</td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="btn_row bottom-border">
            <ul class="pager" id="pagingDom"></ul>
        </div>
        <!-- table 영역 끝 -->
    </c:otherwise>
</c:choose>