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
<!-- section 영역 시작 -->
<div class="section">
    <!-- 검색 결과 영역 시작 -->
    <div class="count border-bottom cf">
        <div class="total left">수신거부 회원<span id="totCnt">${cnt}</span></div>
    </div>
    <!-- 검색 결과 영역 끝 -->
    <!-- table 영역 시작 -->
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <table class="table rejection_tbl">
                <colgroup>
                    <col width="36"/>
                    <col width="12.28%"/>
                    <col width="12.28%"/>
                    <col width="12.28%"/>
                    <col width="*"/>
                    <col width="16.28%"/>
                    <col width="14.28%"/>
                </colgroup>
                <thead>
                <tr>
                    <th><label class="custom_check1 all"><input type="checkbox" name ="checkAll"/><span></span></label></th>
                    <th>유형</th>
                    <th>회원번호</th>
                    <th>채널</th>
                    <th>주소</th>
                    <th>캠페인</th>
                    <th>등록일</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="n" items="${list}">
                    <tr>
                        <td><label class="custom_check1"><input type="checkbox" name ="checkEach" value="${n.seq}" /><span></span></label></td>
                        <td class="en_font">${n.sup_type}</td>
                        <td class="en_font">${n.pro_id}</td>
                        <td>${n.ch_type}</td>
                        <td class="en_font">${n.send_to}</td>
                        <td class="en_font">${n.camp_nm}</td>
                        <td class="en_font">
                                ${cutil:stringDateParse(n.reg_dt)}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="getTblmiSupList"/>
                </ul>
            </div>
            <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
        </c:when>
        <c:otherwise>
            <table class="table rejection_tbl">
                <colgroup>
                    <col width="36"/>
                    <col width="12.28%"/>
                    <col width="12.28%"/>
                    <col width="12.28%"/>
                    <col width="*"/>
                    <col width="16.28%"/>
                    <col width="14.28%"/>
                </colgroup>
                <thead>
                <tr>
                    <th><label class="custom_check1 all"><input type="checkbox"/><span></span></label></th>
                    <th>유형</th>
                    <th>회원번호</th>
                    <th>채널</th>
                    <th>주소</th>
                    <th>캠페인</th>
                    <th>등록일</th>
                </tr>
                </thead>
                <tbody>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <tr class="no_data">
                    <td colspan="7">조회된 결과가 없습니다.</td>
                </tr>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <form:form id="downloadForm" name="downloadForm" action="/mbr/downloadTblmiSup.mi" method="post" >
        <input type="hidden" id="resultSearchType" name="searchType" value="${searchType}"/>
        <input type="hidden" id="resultSearchValue" name="searchValue" value="${searchValue}"/>
    </form:form>
</div>