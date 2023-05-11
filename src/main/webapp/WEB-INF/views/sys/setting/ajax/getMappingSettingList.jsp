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
        <table class="table mail_tbl" summary="table">
            <colgroup>
                <col width="3%" />
                <col width="15.8%" />
                <col width="25.8%" />
                <col width="15.8%" />
                <col width="10.8%" />
                <col width="15.8%" />
            </colgroup>
            <thead>
            <tr>
                <th></th>
                <th>Type</th>
                <th>Key</th>
                <th>생성일</th>
                <th>기본값 설정</th>
                <th>수정/삭제</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="n" items="${list}" varStatus="status">
                <tr>
                    <%--<td><label class="custom_radio"><input name="callingNumber" type="radio" value="${n.seq}"><span></span>
                        <input type="hidden" name="changeSendNumber" value="${n.list_val}"/>
                        <input type="hidden" name="changeSender" value="${n.list_nm}"/>
                        </label>
                    </td>--%>
                    <td>
                        <input type="hidden" name="changeSendNumber" value="${n.list_val}"/>
                        <input type="hidden" name="changeSender" value="${n.list_nm}"/>
                    </td>
                    <td class="en_font">${n.list_nm eq "USR_KEY" ? '회원번호' :'' }${n.list_nm eq "FROM_TO" ? '수신번호' :'' }</td>
                    <td class="en_font">${cutil:numberToPhone(n.list_val)}</td>
                    <td class="en_font">${n.reg_dt}</td>
                    <td class="en_font">
                        <c:if test = "${fn:trim(n.def_yn) == 'Y'}">
                            <input type="button" class="use_state en_font btn_state" value="Y"
                                   onclick="updateYnCheck('${n.seq}','${n.list_nm}','${n.def_yn}')"
                            />
                        </c:if>
                        <c:if test = "${fn:trim(n.def_yn) == 'N'}">
                            <input type="button" class="use_state en_font btn_state" value="N"
                                   onclick="updateYnCheck('${n.seq}','${n.list_nm}','${n.def_yn}')"
                            />
                        </c:if>
                    </td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="수정" onclick="mappingRePopup('${n.seq}');" />
                        <input type="button" class="btn_sm_line btn_inline size" value="삭제" onclick="deleteAlert(this ,'${n.seq}');" />
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="btn_row bottom-border">
            <ul class="pager">
                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getMappingSettingList"/>
            </ul>
        </div>
        <input type ="hidden" id ="nowPageNo" value ="${pageNo}"/>
    </c:when>
    <c:otherwise>
        <table class="table mail_tbl" summary="table">
            <colgroup>
                <col width="3%" />
                <col width="15.8%" />
                <col width="25.8%" />
                <col width="15.8%" />
                <col width="10.8%" />
                <col width="15.8%" />
            </colgroup>
            <thead>
            <tr>
                <th></th>
                <th>Type</th>
                <th>Key</th>
                <th>생성일</th>
                <th>기본값 설정</th>
                <th>수정/삭제</th>
            </tr>
            </thead>
            <tbody>
            <!-- 검색 결과가 없는 경우 영역 시작 -->
            <tr class="no_data">
                <td colspan="6">조회된 결과가 없습니다.</td>
            </tr>
            </tbody>
        </table>
        <input type ="hidden" id ="nowPageNo" value ="${pageNo}"/>
    </c:otherwise>
</c:choose>
<!-- section 영역 끝 -->