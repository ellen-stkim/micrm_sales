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
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<div id="testDetail">
    <h3 class="popup_title">${cnt["pro_nm"]}</h3>
    <table class="pop_table_type3 pop_margin_bttm" summary="detail">
        <colgroup>
            <col width="33.3%"/>
            <col width="33.3%"/>
            <col width="33.3%"/>
        </colgroup>
        <thead>
			<th>상태</th>
			<th>타겟 수</th>
			<th>보기</th>
        </thead>
        <tbody>
        <tr>
            <td>발송완료</td>
            <td class="en_font">${cnt['s_cnt'] + cnt['f_cnt']}</td>
            <td><input type="button" value="상세" class="btn_sm_line" onclick="testDetailPopup('${cnt["pro_id"]}')"/></td>
        </tr>
        <tr>
            <td>발송성공</td>
            <td class="en_font">${cnt['s_cnt']}</td>
            <td><input type="button" value="상세" class="btn_sm_line" onclick="testDetailPopup('${cnt["pro_id"]}', '0')"/></td>
        </tr>
        <tr>
            <td>발송실패</td>
            <td class="en_font">${cnt['f_cnt']}</td>
            <td><input type="button" value="상세" class="btn_sm_line" onclick="testDetailPopup('${cnt["pro_id"]}', '1')"/></td>
        </tr>
        </tbody>
    </table>
    <h3 class="popup_title">결과 상세 리스트</h3>
    <div class="vertical_wrap">
        <table class="pop_table_type3" summary="결과 상세 리스트">
            <colgroup>
                <col width="10%"/>
                <col width="30%"/>
                <col width="30%"/>
                <col width="30%"/>
            </colgroup>
            <thead>
				<th>NO</th>
				<th>발송상세</th>
				<th>이메일/모바일</th>
				<th>원인</th>
            </thead>
            <tbody>
                <c:if test="${empty list}">
                <tr>
                    <td colspan="4" style="text-align: center">-</td>
                </tr>
                </c:if>
				<c:forEach var="g" items="${list}" varStatus="st">
				<tr>
					<td class="en_font">${st.count}</td>
					<td>${g.send_rst}</td>
					<td class="en_font">${g.send_to}</td>
					<td>${g.cd_desc}</td>
				</tr>
				</c:forEach>
            </tbody>
        </table>
    </div>
    <div class="btn_sm_line size list_down right" onclick="testDetailDown()">내려받기</div>
    <div class="btn_row">
        <input type="button" class="btn_bg btn_size2 btn_center" onclick="popupClose(this);" value="확인"/>
    </div>
</div>
