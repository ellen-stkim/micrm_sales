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
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<!-- section 영역 시작 -->
<div class="table_tit">
    <span>개인로그</span>
</div>
<c:choose>
    <c:when test="${not empty list}">
        <table class="table">
            <colgroup>
                <col width="30%"/>
                <col width="30%"/>
                <col width="40%"/>
            </colgroup>
            <thead>
            <tr>
                <th>시간</th>
                <th class="en_font">IP</th>
                <th>로그</th>
            </tr>
            </thead>
            <tbody id="userLogTbody">
            <input type="hidden" id="sizeList" value="${fn:length(list)}"/>
            <c:forEach var="n" items="${list}" varStatus="status">
                 <tr>
                     <td>
                         <fmt:parseDate var="regDate" value="${n.reg_dt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                         <jsp:useBean id="nowTime" class="java.util.Date" />
                         <fmt:parseNumber value="${regDate.time / 1000 }" var="regDateSe" />
                         <fmt:parseNumber value="${nowTime.time / 1000 }" var="nowTimeSe" />
                         <fmt:parseNumber value="${nowTimeSe - regDateSe }" integerOnly="true" var="secondsTime"/>
                         <c:choose>
                             <c:when test="${secondsTime < 60 }">${secondsTime }초 전 </c:when>
                             <c:when test="${secondsTime < 3600 }">
                                 <fmt:formatNumber value="${secondsTime / 60 }" pattern="#,##0"></fmt:formatNumber> 분 전
                             </c:when>
                             <c:when test="${secondsTime / 60 / 60 < 24 }">
                                 <fmt:formatNumber value="${secondsTime / 60 / 60 }" pattern="#,##0"></fmt:formatNumber> 시간 전
                             </c:when>
                             <c:when test="${secondsTime / 60 / 60 < 48 }">어제</c:when>
                             <c:when test="${secondsTime / 60 / 60 / 24 < 365 }">
                                 <fmt:formatNumber value="${secondsTime / 60 / 60 / 24}" pattern="#,##0"></fmt:formatNumber> 일 전
                             </c:when>
                             <c:otherwise>작년</c:otherwise>
                         </c:choose>
                     </td>
                     <td class="en_font">${n.usr_ip}</td>
                     <td>${n.work_detail}</td>
                 </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="btn_row">
            <ul class="pager">
                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getUserLog"/>
            </ul>
        </div>
    </c:when>
    <c:otherwise>
        <table class="table">
            <colgroup>
                <col width="30%"/>
                <col width="30%"/>
                <col width="40%"/>
            </colgroup>
            <thead>
            <tr>
                <th>시간</th>
                <th class="en_font">IP</th>
                <th>로그</th>
            </tr>
            </thead>
            <tbody>
            <tr class="no_data">
                <td colspan="3">개인로그 기록이 없습니다.</td>
            </tr>
            </tbody>
        </table>
        <div class="btn_row">
            <ul class="pager">
            </ul>
        </div>
    </c:otherwise>
</c:choose>