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
<c:choose>
    <c:when test="${not empty list}">
        <table class="table">
            <colgroup>
                <col width="30%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
            </colgroup>
            <thead>
            <tr>
                <th>그룹명</th>
                <th>타겟 수</th>
                <th>이메일</th>
                <th>모바일</th>
                <th>사용여부</th>
                <th>생성일</th>
                <th>수정일</th>
                <th>보기/삭제</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="n" items="${list}" varStatus="status">
                <tr>
                    <td>${n.grp_nm}</td>
                    <td class="en_font">${n.grp_cnt}</td>
                    <td class="en_font">${n.edm_cnt}</td>
                    <td class="en_font">${n.mob_cnt}</td>
                    <td class="en_font">
                        <c:if test="${n.use_yn == 'Y'}">
                            <input type="button" class="use_state en_font btn_state"
                                   onclick="updateTestGrpYn('${n.seq}','${n.use_yn}')" value="Y" />
                        </c:if>
                        <c:if test="${n.use_yn == 'N'}">
                            <input type="button" class="use_state en_font btn_state"
                                   onclick="updateTestGrpYn('${n.seq}','${n.use_yn}')" value="N" />
                        </c:if>
                    </td>
                    <td class="en_font">
                        <c:if test="${!cutil:isEmptyObject(n.reg_dt)}">
                            ${cutil:stringDateHourParse(n.reg_dt)}
                        </c:if>
                    </td>
                    <td class="en_font">
                        <c:if test="${!cutil:isEmptyObject(n.upd_dt)}">
                            ${cutil:stringDateHourParse(n.upd_dt)}
                        </c:if>
                    </td>
                    <td>
                        <a href="/sys/setting/detailTestGrp/${n.seq}.mi" class="btn_sm_line btn_inline size">보기</a>
                        <input type="button" class="btn_sm_line btn_inline size" value="삭제" onclick="deleteAlert(this ,'${n.seq}');"/>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="btn_row bottom-border">
            <ul class="pager">
                <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
            </ul>
        </div>
        <input type ="hidden" id ="nowPageNo" value ="${pageNo}"/>
    </c:when>
    <c:otherwise>
        <table class="table">
            <colgroup>
                <col width="30%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
            </colgroup>
            <thead>
            <tr>
                <th>그룹명</th>
                <th>타겟 수</th>
                <th>이메일</th>
                <th>모바일</th>
                <th>사용여부</th>
                <th>생성일</th>
                <th>수정일</th>
                <th>보기/삭제</th>
            </tr>
            </thead>
            <tbody>
            <!-- 검색 결과가 없는 경우 영역 시작 -->
            <tr class="no_data">
                <td colspan="11">조회된 결과가 없습니다.</td>
            </tr>
            </tbody>
        </table>
        <input type ="hidden" id ="nowPageNo" value ="${pageNo}"/>
    </c:otherwise>
</c:choose>
<!-- section 영역 끝 -->