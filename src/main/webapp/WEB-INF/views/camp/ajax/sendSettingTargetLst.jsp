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
<table class="pop_table table_fixed" id="targetList">
    <colgroup>
        <col width="35"/>
        <col width="302"/>
        <col width="130"/>
        <col width="*"/>
    </colgroup>
    <thead>
    <tr>
        <th></th>
        <th>타겟 명</th>
        <th>타겟 수</th>
        <th>생성일</th>
    </tr>
    </thead>
    <tbody id="send_tg_tbody">
    <c:if test="${empty list}">
        <tr>
            <td colspan="4" style="text-align: center">-</td>
        </tr>
    </c:if>
    <c:forEach var="g" items="${list}">
        <tr>
            <td>
                <label class="custom_radio">
                    <input name="target_sel" type="radio" value="${g.seq}">
                    <span></span>
                </label>
            </td>
            <td>
                <div  class="ellipsis">${g.grp_nm}</div>
            </td>
            <td class="en_font"><fmt:formatNumber value="${g.grp_cnt}" pattern="#,###" /></td>
            <td class="en_font">${cutil:stringDatetimeParse(g.reg_dt)}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<div class="btn_row bottom-border">
    <ul class="pager" id="send_tg_pager">
        <ui:pagination paginationInfo="${page}" type="image" jsFunction="fn_page_tg"/>
    </ul>
</div>
