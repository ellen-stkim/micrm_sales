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
        <div class="total left">전체 사용자 관리</div>
        <input type="button" class="btn_add right" value="추가" onclick="accountPopup();"/>
    </div>
    <!-- 검색 결과 영역 끝 -->
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <table class="table management" summary="table">
                <colgroup>
                    <col width="5%"/>
                    <col width="7%"/>
                    <col width="14.5%"/>
                    <col width="14.5%"/>
                    <col width="12.5%"/>
                    <col width="7%"/>
                    <col width="14.5%"/>
                    <col width="10.15%"/>
                    <col width="10.15%"/>
                    <col width="11%"/>
                </colgroup>
                <thead>
                <tr>
                    <th>상태</th>
                    <th>이름</th>
                    <th>로그인이메일</th>
                    <th>이메일</th>
                    <th>휴대폰번호</th>
                    <th>권한</th>
                    <th>담당 승인자</th>
                    <th>마지막 로그인</th>
                    <th>마지막 비밀번호 변경</th>
                    <th>수정/상태 변경</th>
                </tr>
                </thead>
                <tbody>
                <!-- 정상 -->
                <c:forEach var="n" items="${list}" varStatus="status">
                <tr>
                    <td class="userStatus">
                        <c:if test="${n.usr_st eq '1'}">정상</c:if>
                        <c:if test="${n.usr_st eq '2'}">미사용</c:if>
                        <c:if test="${n.usr_st eq '3'}">차단</c:if>
                    </td>
                    <td>${n.usr_nm}</td>
                    <td class="en_font">${n.usr_log_id}</td>
                    <td class="en_font">${n.usr_email}</td>
                    <td class="en_font">
                        <c:if test="${!cutil:isEmptyObject(n.usr_mob)}">
                            ${cutil:numberToPhone(n.usr_mob)}
                        </c:if>
                    </td>
                    <td class="en_font">${n.cd_nm}</td>
                    <td class="en_font">${n.appr_email}</td>
                    <td class="en_font">
                        <c:if test="${!cutil:isEmptyObject(n.last_log_in_dt)}">
                            ${cutil:stringDateHourParse(n.last_log_in_dt)}
                        </c:if>
                    </td>
                    <td class="en_font">
                        <c:if test="${!cutil:isEmptyObject(n.last_pw_upd_dt)}">
                            ${cutil:stringDateHourParse(n.last_pw_upd_dt)}
                        </c:if>
                    </td>
                    <td>
                        <div class="btn_sm_line" onclick="userDetail('${n.seq}');">수정</div>
                        <c:choose>
                            <c:when test="${n.usr_st eq '1'}">
                                <div class="btn_sm_line" onclick="userStatus(this, '${n.seq}');" data="1">미사용</div>
                            </c:when>
                            <c:when test="${n.usr_st eq '2'}">
                                <div class="btn_sm_line" onclick="userStatus(this, '${n.seq}');" data="2">복구</div>
                            </c:when>
                            <c:when test="${n.usr_st eq '3'}">
                                <div class="btn_sm_line" onclick="userStatus(this, '${n.seq}');" data="1">차단해제</div>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="getUserList"/>
                </ul>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table management" summary="table">
                <colgroup>
                    <col width="7%"/>
                    <col width="7%"/>
                    <col width="15.4%"/>
                    <col width="12.4%"/>
                    <col width="7%"/>
                    <col width="15.4%"/>
                    <col width="12.4%"/>
                    <col width="12.4%"/>
                    <col width="11%"/>
                </colgroup>
                <thead>
                <tr>
                    <th>상태</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>휴대폰번호</th>
                    <th>권한</th>
                    <th>담당 승인자</th>
                    <th>마지막 로그인</th>
                    <th>마지막 비밀번호 변경</th>
                    <th>수정/상태 변경</th>
                </tr>
                </thead>
                <tbody>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <tr class="no_data">
                    <td colspan="9">조회된 결과가 없습니다.</td>
                </tr>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <!-- table 영역 끝 -->
</div>
<!-- section 영역 끝 -->