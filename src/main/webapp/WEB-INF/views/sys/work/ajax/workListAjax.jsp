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

<!-- table 영역 시작 -->
<div class="scroll_tbl">
    <c:choose>
        <c:when test="${not empty list}">
        <table class="table">
            <colgroup>
                <col width="18.3%" />
                <col width="18.3%" />
                <col width="12.3%" />
                <col width="12.3%" />
                <col width="14.3%" />
                <col width="14.3%" />
                <col width="10.3%" />
            </colgroup>
            <thead>
            <tr>
                <th>작업번호</th>
                <th>작업내용</th>
                <th>작업상태</th>
                <th>작업 요청자</th>
                <th>시작</th>
                <th>종료</th>
                <th>보기</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="n" items="${list}" varStatus="status">
            <tr>
                <td class="en_font">${n.seq}</td>
                <td>${n.work_type}</td>
                <td>
                    <c:choose>
                        <c:when test="${n.work_stat eq '0'}">작업중</c:when>
                        <c:when test="${n.work_stat eq '1'}">완료</c:when>
                        <c:when test="${n.work_stat eq '2'}">오류</c:when>
                        <c:otherwise>삭제</c:otherwise>
                    </c:choose>
                </td>
                <td class="en_font">${n.work_usr_id}</td>
                <td class="en_font">
                    ${cutil:stringDateHourParse(n.work_st_dt)}
                </td>
                <td class="en_font">
                    ${cutil:stringDateHourParse(n.work_end_dt)}
                </td>
                <td><span class="btn_sm_line" onclick="workPopup(this);">상세</span>
                    <input type="hidden" name="workDetail" value="${n.work_msg}"/>
                </td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="btn_row bottom-border">
            <ul class="pager">
                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getWorkList"/>
            </ul>
        </div>
        </c:when>
        <c:otherwise>
        <table class="table">
            <colgroup>
                <col width="18.3%" />
                <col width="18.3%" />
                <col width="12.3%" />
                <col width="12.3%" />
                <col width="14.3%" />
                <col width="14.3%" />
                <col width="10.3%" />
            </colgroup>
            <thead>
            <tr>
                <th>작업번호</th>
                <th>작업내용</th>
                <th>작업상태</th>
                <th>작업 요청자</th>
                <th>시작</th>
                <th>종료</th>
                <th>보기</th>
            </tr>
            </thead>
            <tbody>
            <!-- 검색 결과가 없는 경우 영역 시작 -->
            <tr class="no_data">
                <td colspan="7">조회된 결과가 없습니다.</td>
            </tr>
            </tbody>
        </table>
        </c:otherwise>
    </c:choose>
</div>
<!-- table 영역 끝 -->