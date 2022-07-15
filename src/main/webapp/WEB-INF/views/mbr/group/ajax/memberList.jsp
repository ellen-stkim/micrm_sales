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
<!-- 검색 결과 영역 시작 -->
<div class="count border-bottom cf" id="memberMstAppend">
    <div class="total left">전체 DB회원<span><fmt:formatNumber value="${cnt}" pattern="#,###" /></span></div>
    <ol class="cf left">
        <li>이메일&nbsp;<span class="en_font"><fmt:formatNumber value="${edm_agree_cnt}" pattern="#,###" /></span></li>
        <li>문자&nbsp;<span class="en_font"><fmt:formatNumber value="${mdm_agree_cnt}" pattern="#,###" /></span></li>
    </ol>
</div>
<!-- 검색 결과 영역 끝 -->
<div class="scroll_tbl">
    <!-- table 영역 시작 -->
    <table class="table member dynamic_tbl list">
        <thead></thead>
        <!-- section 영역 시작 -->
        <tbody id="body">
        <c:choose>
            <c:when test="${not empty list}">
                <c:forEach var="item" items="${list}">
                    <tr>
                        <td class="en_font">${item.usr_id}</td>
                        <td>${item.usr_nm}</td>
                        <td class="en_font">${item.usr_mob}</td>
                        <td class="en_font">${item.usr_myn}</td>
                        <td class="en_font">${item.usr_edm}</td>
                        <td class="en_font">${item.usr_eyn}</td>
                        <td>${item.usr_gdr}</td>
                        <td>${item.usr_addr}</td>
                        <td>${item.usr_etc1}</td>
                        <td>${item.usr_etc2}</td>
                        <td>${item.usr_etc3}</td>
                        <td>${item.usr_etc4}</td>
                        <td>${item.usr_etc5}</td>
                        <td>${item.usr_etc6}</td>
                        <td>${item.usr_etc7}</td>
                        <td>${item.usr_etc8}</td>
                        <td>${item.usr_etc9}</td>
                        <td>${item.usr_etc10}</td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <tr class="no_data">
                    <td colspan="100%">조회된 결과가 없습니다.</td>
                </tr>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
<div class="btn_row bottom-border" id="pagingBody">
    <ul class="pager">
        <ui:pagination paginationInfo="${page}" type="image" jsFunction="getTblmiList"/>
    </ul>
    <form:form id="downloadForm" name="downloadForm" action="/mbr/downloadTblmiList.mi" method="post">
        <input type="hidden" id="resultSearchType" name="searchType" value="${searchType}"/>
        <input type="hidden" id="resultSearchValue" name="searchValue" value="${searchValue}"/>
        <input type="hidden" name="columnNm"/>
        <input type="hidden" name="tbl_id"/>
    </form:form>
</div>


