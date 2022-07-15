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
<div class="section">
    <!-- 검색 결과 영역 시작 -->
    <div class="count border-bottom cf">
        <div class="total left">회원 수 <span id ="totCnt">${listCnt}</span></div>
    </div>
    <!-- 검색 결과 영역 끝 -->
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <div class="scroll_tbl">
                <table class="table group_tbl dynamic_tbl">
                    <thead>
                        <tr>
                            <th><label class="custom_check1 all"><input type="checkbox" name ="checkAll" /><span></span></label>
                            </th>
                            <th>회원번호</th>
                            <th>이름</th>
                            <th>모바일</th>
                            <th>이메일</th>
                            <th>성별</th>
                            <th>주소</th>
                            <th>ETC1</th>
                            <th>ETC2</th>
                            <th>ETC3</th>
                            <th>ETC4</th>
                            <th>ETC5</th>
                            <th>ETC6</th>
                            <th>ETC7</th>
                            <th>ETC8</th>
                            <th>ETC9</th>
                            <th>ETC10</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="grpUser" items="${list}">
                            <tr>
                                <td><label class="custom_check1"><input type="checkbox" name="checkEach"
                                                                        value="${grpUser.seq}" /><span></span></label></td>
                                <td class="en_font">${grpUser.usr_id}</td>
                                <td>${grpUser.usr_nm}</td>
                                <td class="en_font">${cutil:numberToPhone(grpUser.usr_mob)}</td>
                                <td class="en_font">${grpUser.usr_edm}</td>
                                <td>${grpUser.usr_gdr}</td>
                                <td>${grpUser.usr_addr}</td>
                                <td>${grpUser.usr_etc1}</td>
                                <td>${grpUser.usr_etc2}</td>
                                <td>${grpUser.usr_etc3}</td>
                                <td>${grpUser.usr_etc4}</td>
                                <td>${grpUser.usr_etc5}</td>
                                <td>${grpUser.usr_etc6}</td>
                                <td>${grpUser.usr_etc7}</td>
                                <td>${grpUser.usr_etc8}</td>
                                <td>${grpUser.usr_etc9}</td>
                                <td>${grpUser.usr_etc10}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="btn_row bottom-border">
                <ul class ="pager">
                    <ui:pagination paginationInfo = "${page}" type="image" jsFunction="getCampMbrDetailList"/>
                </ul>
            </div>
            <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
        </c:when>
        <c:otherwise>
            <div class="scroll_tbl">
                <table class="table group_tbl dynamic_tbl">
                    <thead>
                        <tr>
                            <th><label class="custom_check1 all"><input type="checkbox" /><span></span></label>
                            </th>
                            <th>회원번호</th>
                            <th>이름</th>
                            <th>모바일</th>
                            <th>이메일</th>
                            <th>성별</th>
                            <th>주소</th>
                            <th>ETC1</th>
                            <th>ETC2</th>
                            <th>ETC3</th>
                            <th>ETC4</th>
                            <th>ETC5</th>
                            <th>ETC6</th>
                            <th>ETC7</th>
                            <th>ETC8</th>
                            <th>ETC9</th>
                            <th>ETC10</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="no_data">
                            <td colspan="100%">조회된 결과가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
        </c:otherwise>
    </c:choose>
    <input type="hidden" id="resultSearchType" name="resultSearchType" value="${searchType}"/>
    <input type="hidden" id="resultSearchValue" name="resultSearchValue" value="${searchValue}"/>
</div>