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
<div class="section">
    <!-- 검색 결과 영역 시작 -->
    <div class="count border-bottom cf">
        <div class="total left">차단 리스트</div>
    </div>
    <!-- 검색 결과 영역 끝 -->
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <table class="table" summary="table">
                <colgroup>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                </colgroup>
                <thead>
                <tr>
                    <th>IP</th>
                    <th>등록자</th>
                    <th>차단 로그</th>
                    <th>차단 주제</th>
                    <th>등록일</th>
                    <th>해제</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="n" items="${list}" varStatus="status">
                    <tr>
                       <td class="en_font">${n.block_target}</td>
                        <td class="en_font">${n.block_reg_id}</td>
                        <td></td>
                        <td>
                            <c:choose>
                                <c:when test="${n.block_type eq '1'}">시스템차단</c:when>
                                <c:when test="${n.block_type eq '2'}">사용자 등록</c:when>
                            </c:choose>
                        </td>
                        <td class="en_font">
                            <c:if test="${!cutil:isEmptyObject(n.reg_dt)}"> ${cutil:stringDateParse(n.reg_dt)}</c:if>
                        </td>
                        <td>
                            <sec:authentication property="name" var="usrId"/>
                            <c:choose>
                                <c:when test="${n.block_status eq '0'}">
                                    <c:if test="${usrId eq n.block_reg_id}">
                                        <input type="button" class="btn_sm_line btn_inline size" value="해제 요청" onclick="blockPopup('${n.block_target}', '${n.seq}');"/>
                                    </c:if>
                                </c:when>
                                <c:when test="${n.block_status eq '1'}">
                                    <c:if test="${usrId eq n.block_reg_id}">
                                        <input type="button" class="btn_sm_line btn_inline size" value="취소" onclick="updateBlock('${n.block_target}', '${n.seq}', '0');"/>
                                    </c:if>
                                    <span class="req_status">요청 진행 중</span>
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <!-- <tr class="no_data">
                        <td colspan="6">조회된 결과가 없습니다.</td>
                     </tr> -->
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="getBlockList"/>
                </ul>
            </div>
            <!-- table 영역 끝 -->
        </c:when>
        <c:otherwise>
            <table class="table" summary="table">
                <colgroup>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                    <col width="16.6%"/>
                </colgroup>
                <thead>
                <tr>
                    <th>IP</th>
                    <th>등록자</th>
                    <th>차단 로그</th>
                    <th>차단 주제</th>
                    <th>등록일</th>
                    <th>해제</th>
                </tr>
                </thead>
                <tbody>
                <tr class="no_data">
                    <td colspan="6">조회된 결과가 없습니다.</td>
                </tr>
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                </ul>
            </div>
        </c:otherwise>
    </c:choose>
    <!-- table 영역 끝 -->
</div>
<!-- section 영역 끝 -->
