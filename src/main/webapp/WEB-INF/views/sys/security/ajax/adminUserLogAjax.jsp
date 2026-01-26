<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<div class="section">
    <!-- 검색 결과 영역 시작 -->
    <div class="count border-bottom cf">
        <span class="switch_label">일반 로그</span>
        <label class="btn_switch">
            <input type="checkbox" name="" onchange="" />
            <span></span>
        </label>
        <span class="switch_label">개인정보 로그</span>
    </div>
    <!-- 검색 결과 영역 끝 -->
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <table class="table" summary="table">
                <colgroup>
                    <col width="20%" />
                    <col width="20%" />
                    <col width="20%" />
                    <col width="40%" />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">시간</th>
                        <th scope="col">IP</th>
                        <th scope="col">사용자</th>
                        <th scope="col">로그</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="n" items="${list}" varStatus="status">
                        <tr>
                            <td class="en_font"><c:if test="${!cutil:isEmptyObject(n.reg_dt)}"> ${cutil:stringDateParse(n.reg_dt)}</c:if></td>
                            <td class="en_font">${n.usr_ip}</td>
                            <td class="en_font">${n.usr_nm}</td>
                            <td>${n.work_url} : ${n.work_detail}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="getAdminUserLog"/>
                </ul>
            </div>
        <!-- table 영역 끝 -->
        </c:when>
        <c:otherwise>
            <table class="table" summary="table">
                <colgroup>
                    <col width="20%" />
                    <col width="20%" />
                    <col width="20%" />
                    <col width="40%" />
                </colgroup>
                <thead>
                <tr>
                    <th>시간</th>
                    <th>IP</th>
                    <th>사용자</th>
                    <th>로그</th>
                </tr>
                </thead>
                <tbody>
                    <tr class="no_data">
                        <td colspan="4">조회된 결과가 없습니다.</td>
                    </tr>
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                </ul>
            </div>
        </c:otherwise>
    </c:choose>
    </div>
<!-- section 영역 끝 -->