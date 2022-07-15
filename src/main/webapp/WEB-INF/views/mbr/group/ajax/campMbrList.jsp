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
        <div class="total left">그룹 리스트</div>
    </div>
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <table class="table rejection_tbl">
                <colgroup>
                    <col width="36"/>
                    <col width="*"/>
                    <col width="12%"/>
                    <col width="16%"/>
                    <col width="16%"/>
                    <col width="12%"/>
                    <col width="12%"/>
                </colgroup>
                <thead>
                <tr>
                    <th><label class="custom_check1 all"><input type="checkbox" name="checkAll"
                                                                id="checkAll"/><span></span></label>
                    </th>
                    <th>그룹명</th>
                    <th>타겟 수</th>
                    <th>생성일</th>
                    <th>수정일</th>
                    <th>사용여부</th>
                    <th>관리</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="group" items="${list}">
                    <tr>
                        <td><label class="custom_check1"><input type="checkbox" name="noArr" id="noArr"
                                                                value="${group.seq}"/><span></span></label></td>
                        <td>${group.grp_nm}</td>
                        <td class="en_font"><fmt:formatNumber value="${group.grp_cnt}" pattern="#,###" /></td>
                        <td class="en_font">
                            <c:if test="${!cutil:isEmptyObject(group.reg_dt)}">
                                ${cutil:stringDateHourParse(group.reg_dt)}
                            </c:if>
                        </td>
                        <td class="en_font">
                                <c:if test="${!cutil:isEmptyObject(group.upd_dt)}">
                                    ${cutil:stringDateHourParse(group.upd_dt)}
                                </c:if>
                        </td>
                        <td><input type="button" class="use_state en_font btn_state"
                                <c:if test="${group.use_yn eq 'Y'}"> value='Y'</c:if>
                                <c:if test="${group.use_yn eq 'N'}"> value='N'</c:if>
                                   onclick="updateGrpYorN('${group.seq}','${group.use_yn}','${group.grp_nm}')"
                        />
                        </td>
                        <td><a href="/mbr/campmbrDetail/${group.seq}.mi" class="btn_sm_line">수정</a></td>
                            <%--<td><a href="/mbr/campmbrDetail/${group.seq}.mi" class="btn_sm_line">수정</a></td>--%>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <%--<ui:pagination paginationInfo="${page}" type="image" jsFunction="fn_page"/>--%>
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
                </ul>
            </div>
            <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
            <input type ="hidden" id="totCnt" name ="totCnt" value ="${listCnt}"/>
        </c:when>
        <c:otherwise>
            <table class="table rejection_tbl">
                <colgroup>
                    <col width="36"/>
                    <col width="*"/>
                    <col width="12%"/>
                    <col width="16%"/>
                    <col width="16%"/>
                    <col width="12%"/>
                    <col width="12%"/>
                </colgroup>
                <thead>
                <tr>
                    <th><label class="custom_check1 all"><input type="checkbox"/><span></span></label></th>
                    <th>그룹명</th>
                    <th>타겟 수</th>
                    <th>생성일</th>
                    <th>수정일</th>
                    <th>사용여부</th>
                    <th>관리</th>
                </tr>
                </thead>
                <tbody>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <tr class="no_data">
                    <td colspan="7">입력된 정보가 없습니다.</td>
                </tr>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                </tbody>
            </table>
            <input type="hidden" id ="nowPageNo" value="${pageNo}"/>
        </c:otherwise>
    </c:choose>
</div>
