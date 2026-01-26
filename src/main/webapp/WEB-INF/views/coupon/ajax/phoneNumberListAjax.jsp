<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>

<span id="body">
<c:forEach var="phoneNumber" items="${phoneNumberList}">
    <li id="${phoneNumber}">
        <p>${cutil:numberToPhone(phoneNumber)}</p>
        <button type="button" onclick="deleteReceivePhoneNumber(this,'${cutil:numberToPhone(phoneNumber)}')" class="btn del"></button>
    </li>
</c:forEach>
<script>

    var phoneList = [];
    <c:forEach var="num" items="${phoneNumberList}">
        phoneList.push("${num}");
    </c:forEach>
    var collectCnt = ${collectCnt};
    var duplicateCnt = ${duplicateCnt};
    var errorCnt = ${errorCnt};
</script>
</span>
