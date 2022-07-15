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

<!-- table 영역 시작 -->
<c:choose>
    <c:when test="${not empty list}">
        <div class="scroll_tbl">
            <table class="table tbl_width2">
                <thead>
                <tr>
                    <th>회원번호</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>모바일</th>
                    <th>사용여부</th>
                    <th>ETC1</th>
                    <th>ETC2</th>
                    <th>ETC3</th>
                    <th>ETC4</th>
                    <th>ETC5</th>
                    <th>수정/삭제</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="n" items="${list}" varStatus="status">
                    <tr>
                        <td class="en_font">${n.usr_id}</td>
                        <td>${n.usr_nm}</td>
                        <td class="en_font">${n.usr_edm}</td>
                        <td class="en_font">${cutil:numberToPhone(n.usr_mob)}</td>
                        <td>
                            <c:if test = "${fn:trim(n.use_yn) != ''}">
                                <input type ="button" class="use_state en_font btn_state" value = "${n.use_yn}"
                                       onclick="updateTestTargetYn('${n.seq}' , '${n.use_yn}')"/>
                            </c:if>
                        </td>
                        <td>${n.usr_etc1}</td>
                        <td>${n.usr_etc2}</td>
                        <td>${n.usr_etc3}</td>
                        <td>${n.usr_etc4}</td>
                        <td>${n.usr_etc5}</td>
                        <td>
                            <input type="button" class="btn_sm_line btn_inline size" value="수정" onclick="testMemberRePopup(this,'${n.seq}');" />
                            <input type="button" class="btn_sm_line btn_inline size" value="삭제" onclick="deleteAlert(this,'${n.seq}');" />
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="btn_row bottom-border">
            <ul class="pager">
                <ui:pagination paginationInfo="${page}" type="image" jsFunction="selectTargetLst"/>
            </ul>
        </div>
        <input type="hidden" id="nowPageNo" value="${pageNo}"/>
        <input type ="hidden" id="targetGrpCnt" value ="${grpCnt}"/>
        <input type ="hidden" id="targetMobCnt" value ="${mobCnt}"/>
        <input type ="hidden" id="targetEdmCnt" value ="${edmCnt}"/>
    </c:when>
    <c:otherwise>
        <div class="scroll_tbl">
            <table class="table tbl_width2">
                <thead>
                <tr>
                    <th>회원번호</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>모바일</th>
                    <th>사용여부</th>
                    <th>ETC1</th>
                    <th>ETC2</th>
                    <th>ETC3</th>
                    <th>ETC4</th>
                    <th>ETC5</th>
                    <th>수정/삭제</th>
                </tr>
                </thead>
                <tbody>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <tr class="no_data">
                    <td colspan="11">조회된 결과가 없습니다.</td>
                </tr>
                </tbody>
            </table>
        </div>
        <input type="hidden" id="nowPageNo" value="${pageNo}"/>
        <input type ="hidden" id="targetGrpCnt" value ="${grpCnt}"/>
        <input type ="hidden" id="targetMobCnt" value ="${mobCnt}"/>
        <input type ="hidden" id="targetEdmCnt" value ="${edmCnt}"/>
    </c:otherwise>
</c:choose>
<!-- section 영역 끝 -->