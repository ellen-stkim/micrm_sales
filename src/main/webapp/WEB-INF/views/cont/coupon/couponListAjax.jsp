<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>

<span id="body">
    <h5 class="tbl_title">쿠폰리스트</h5>
    <table class="pop_table table_fixed" id="send_tg_lst">
        <colgroup>
            <col width="248" />
            <col width="183" />
            <col width="107" />
        </colgroup>
        <thead>
        <tr>
            <th>쿠폰명</th>
            <th>유효기간</th>
            <th>선택</th>
        </tr>
        </thead>
        <tbody id="send_tg_tbody">
        <c:forEach var="coupon" items="${couponList}">
            <tr>
                <td>
                    <div class="ellipsis">${coupon.nm}</div>
                </td>
                <td class="en_font">${coupon.expire_dt}</td>
                <td>
                    <button type="button" class="btn select" onclick="chkCoupon('${coupon.encodedSeq}')">선택</button>
                </td>
            </tr>
        </c:forEach>

        </tbody>
    </table>
    <section class="paging_wrap">
        <div class="btn_row bottom-border">
            <ul class="pager">
                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getCouponListAtSales"/>
            </ul>
        </div>
    </section>
</span>
