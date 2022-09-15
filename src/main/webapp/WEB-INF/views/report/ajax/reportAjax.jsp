<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<!-- container 영역 시작 -->
<div id="list_table_box">
    <table class="pop_table table_fixed" id="" style="width: 588px; height:210px;">
        <colgroup>
            <col width="40"/>
            <col width="130"/>
            <col width="40"/>
            <col width="130"/>
            <col width="100"/>
            <col width="130"/>
        </colgroup>
        <thead>
        <tr>
            <th><input type="checkbox" name="pro_nm_allcheck"
                       onclick="allCheckBtn(this); checkEvent(this);"></th>
            <th><span>프로그램명</span></th>
            <th><input type="checkbox" name="camp_nm_allcheck"
                       onclick="allCheckBtn(this); checkEvent(this);"></th>
            <th><span>캠페인명</span></th>
            <th><span>타겟수</span></th>
            <th><span>캠페인 채널</span></th>
        </tr>
        </thead>
        <tbody id="report_tbody">
        <c:choose>
            <c:when test="${fn:length(programLst) == 0 }">
                <tr>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="programMap" items="${programLst}">
                    <tr>
                        <c:set var="total" value="${programMap.total}"/>
                        <td rowspan="${total.rowCnt-1}">
                            <input type="checkbox" name="pro_nm_check" value="${total.pro_id}"
                                   onclick="addSelectList(this)">
                        </td>
                        <td rowspan="${total.rowCnt-1}"><span class="ellipsis" name="pro_nm">${total.pro_nm}</span></td>
                        <c:forEach var="cont" items="${programMap.program}" begin="">
                            <td>
                                <input type="checkbox" class="camp_nm_check" value="${cont.seq}"
                                       onclick="addSelectList(this)">
                            </td>

                            <td rowspan="${item.camp_cnt}"><span class="ellipsis" name="camp_nm">${cont.camp_nm}</span></td>

                            <td><span class="sendStatus"><fmt:formatNumber value="${cont.total_cnt}"
                                                                           pattern="#,##0"/></span>
                            </td>
                            <td>
                                            <span>
                                                <c:if test="${cont.camp_ch eq 'CH01'}">이메일</c:if>
                                                <c:if test="${cont.camp_ch eq 'CH02'}">문자</c:if>
                                                 <c:if test="${cont.camp_ch eq 'CH03'}">세일즈포스</c:if>
                                            </span>
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
    <div class="btn_row bottom-border">
        <ul class="pager" id="report_pager">
            <ui:pagination paginationInfo="${page}" type="image" jsFunction="popPage"/>
            <form:form class="disnone" id="current-form">
                <input type="text" name="pro_tg_tp" value="${pro_tg_tp}"/>
                <input type="text" class="searchInp left-border " name="searchValue" value="${searchValue}"/>
                <input type="text" name="searchType" value="${searchType}"/>
                <input type="text" class="date" name="st_dt" placeholder="시작날짜" autocomplete="off"
                       value="${stdt}"/>
                <input type="text" class="date" name="end_dt" placeholder="종료날짜" autocomplete="off"
                       value="${enddt}"/>
            </form:form>
        </ul>
    </div>
</div>
