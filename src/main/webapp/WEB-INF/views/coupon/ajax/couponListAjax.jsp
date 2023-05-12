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
<h5 class="title">쿠폰 리스트</h5>
<table class="tbl" summary="table">
    <colgroup>
        <col width="36" />
        <col width="206" />
        <col width="*" />
        <col width="208" />
<%--        <col width="224" />--%>
        <col width="243" />
    </colgroup>
    <thead>
    <tr>
        <th>
            <label class="chk label">
                <input type="checkbox" name="deleteAllChk" id="deleteAllChk"  onclick="clickDeleteChk();"/>
                <span class="chk-box"></span>
            </label>
        </th>
        <th>카테고리</th>
        <th>쿠폰명</th>
        <th>유효 기간</th>
<%--        <th>쿠폰 발급</th>--%>
        <th>쿠폰 수정</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="coupon" items="${couponList}">
        <tr>
            <td>
                <label class="chk label">
                    <input type="checkbox" name="deleteChk" value="${coupon.encodedSeq}"/>
                    <span class="chk-box"></span>
                </label>
            </td>
            <td>${coupon.category_nm}</td>
            <td>
                ${coupon.nm}
                <article class="coupon_detail">
                    <button type="button" class="btn detail" onclick="viewCoupon(this)"></button>
                    <section class="modal coupon">
                        <div class="coupon_image">
                            <img src="${couponImageDomain}${coupon.img_url}" alt="쿠폰"/>
                        </div>
                    </section>
                </article>
            </td>
            <td>${coupon.expire_dt}</td>
<%--            <td>--%>
<%--                <a href="${baseUrl}/coupon/couponIssue.mi?seq=${coupon.encodedSeq}" class="btn coupon">쿠폰 발급</a>--%>
<%--            </td>--%>
            <td>
                <a href="${baseURL}/coupon/couponUpdate.mi?seq=${coupon.encodedSeq}" class="btn coupon" >쿠폰 수정</a>
            </td>
        </tr>
    </c:forEach>
    <div class="none list_ht bottom-border">
        조회된 결과가 없습니다.
    </div>
    </tbody>
</table>
<section class="paging_wrap">
    <div class="btn_row bottom-border">
        <ul class="pager">
            <ui:pagination paginationInfo="${page}" type="image" jsFunction="getCouponList"/>
        </ul>
    </div>
</section>
</span>

