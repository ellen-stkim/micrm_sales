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
    <div class="count border-bottom cf">
        <div class="total left">공지사항 리스트</div>
        <div class="gray_color left">※ 공지사항은 최대 2건까지 오픈 가능합니다.</div>
        <input type="button" class="btn_add" value="추가" onclick="noticeCrtPopup();"/>
    </div>
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <table class="table">
                <colgroup>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="*"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                </colgroup>
                <thead>
                <tr>
                    <th class="en_font">ON/OFF</th>
                    <th>등록일</th>
                    <th>시작일</th>
                    <th>종료일</th>
                    <th>제목</th>
                    <th>등록자</th>
                    <th>수정/삭제</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="n" items="${list}" varStatus="status">
                    <tr>
                        <td><input type="button"
                                   class='en_font btn_toggle
                                   <c:choose>
                                   <c:when test="${n.noti_popyn eq 'Y'}">on</c:when>
                                   <c:otherwise>off</c:otherwise>
                                    </c:choose>'
                                   name="noti_popyn"
                                   value='<c:if test="${n.noti_popyn eq 'Y'}">ON</c:if>
                                   <c:if test="${n.noti_popyn eq 'N'}">OFF</c:if>'
                                   onclick="popynChange(this,'${n.seq}','${pageNo}');"
                            />
                        </td>
                        <td class="en_font">
                                ${cutil:stringDateParse(n.reg_dt)}
                        </td>
                        <td class="en_font">
                                ${cutil:stringDateParse(n.noti_bgn_dttm)}
                        </td>
                        <td class="en_font">
                                ${cutil:stringDateParse(n.noti_end_dttm)}
                        </td>
                        <td><span class="ellipsis">${n.noti_sub}</span></td>
                        <td class="en_font">${n.reg_id}</td>
                        <td>
                            <input type="button" class="btn_sm_line btn_inline size" value="수정"
                                   onclick="noticeRePopup('${n.seq}','${pageNo}');"/>
                            <input type="button" class="btn_sm_line btn_inline size" value="삭제"
                                   onclick="deleteAlert('${n.seq}','${n.noti_popyn}','${pageNo}');"/>
                        </td>
                    </tr>
                </c:forEach>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <!-- <tr class="no_data">
                        <td colspan="8">조회된 결과가 없습니다.</td>
                     </tr> -->
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class ="pager">
                    <ui:pagination paginationInfo = "${page}" type="image" jsFunction="getNoticeList"/>
                </ul>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <colgroup>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                    <col width="*"/>
                    <col width="12.5%"/>
                    <col width="12.5%"/>
                </colgroup>
                <thead>
                <tr>
                    <th class="en_font">ON/OFF</th>
                    <th>등록일</th>
                    <th>시작일</th>
                    <th>종료일</th>
                    <th>제목</th>
                    <th>등록자</th>
                    <th>수정/삭제</th>
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
    <!-- table 영역 끝 -->
</div>

<!-- section 영역 끝 -->
