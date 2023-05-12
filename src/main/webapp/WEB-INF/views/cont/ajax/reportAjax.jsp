<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<!-- container 영역 시작 -->
<div  id="list_table_box">
    <table class="pop_table table_fixed" id="" style="width: 588px; height:210px;" summary="table">
        <colgroup>
            <col width="30"/>
            <col width="180"/>
            <col width="30"/>
            <col width="100"/>
            <col width="100"/>
            <col width="100"/>
        </colgroup>
        <thead>
            <tr>
                <th><input type="checkbox" name="pro_nm_allcheck" onclick="allCheckBtn(this); checkEvent(this);"></th>
                <th><span>캠페인명</span></th>
                <th><input type="checkbox" name="target_allcheck" onclick="allCheckBtn(this); checkEvent(this);"></th>
                <th><span>캠페인 타겟</span></th>
                <th><span>타겟수</span></th>
                <th><span>캠페인 채널</span></th>
            </tr>
        </thead>
        <tbody id="report_tbody">
        <c:choose>
            <c:when test="${fn:length(programLst) == 0 }">
                <tr></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${programLst}">
                    <tr>
                        <td rowspan="${item.camp_cnt}">
                            <input type="checkbox" name="pro_nm_check"  value="${item.pro_id}" onclick="addSelectList(this)">
                        </td>
                        <td rowspan="${item.camp_cnt}">
                            <span class="ellipsis" name="pro_nm">${item.pro_nm}</span>
                        </td>
                        <td>
                            <input type="checkbox" class="target_check" name="cont_seq" value="${item.seq}" onclick="addSelectList(this);">
                        </td>
                        <td>
                            <span name="target_nm">${item.target_nm}</span>
                        </td>
                        <td>
                            <span class="sendStatus"><fmt:formatNumber value="${item.total_cnt}" pattern="#,##0"/></span>
                        </td>
                        <td>
                            <span>
                                <c:if test="${item.camp_ch eq 'CH01'}">이메일</c:if>
                                <c:if test="${item.camp_ch eq 'CH02'}">문자</c:if>
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
    <div class="btn_row bottom-border">
        <ul class="pager" id="report_pager">
            <ui:pagination paginationInfo="${page}" type="image" jsFunction="reportList"/>
        </ul>
    </div>
</div>
