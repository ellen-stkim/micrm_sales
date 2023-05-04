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
<h5 class="title">쿠폰 발급내역</h5>
<c:if test="${fn:length(couponIssuedLogList) == 0}">
<div class="tbl_inner empty">
    <table class="tbl">
        <colgroup>
            <col width="36" />
            <col width="206" />
            <col width="*" />
            <col width="196" />
            <col width="194" />
            <col width="196" />
            <col width="242" />
        </colgroup>
            <thead>
                <tr>
                    <th>
                        <label class="chk label">
                        <input type="checkbox" name="" id="" />
                        <span class="chk-box"></span>
                        </label>
                    </th>
                    <th>수신자 번호</th>
                    <th>쿠폰명</th>
                    <th>발송 일자</th>
                    <th>발송 상태</th>
                    <th>사용 여부</th>
                    <th>비고</th>
                </tr>
            </thead>
        <tbody>
            <tr>
                <td colspan="7">조회된 결과가 없습니다.</td>
            </tr>
        </tbody>
    </table>
</div>
</c:if>
<c:if test="${fn:length(couponIssuedLogList) != 0}">
<div class="tbl_inner">
    <table class="tbl">
        <colgroup>
            <col width="36" />
            <col width="206" />
            <col width="*" />
            <col width="208" />
            <col width="224" />
            <col width="243" />
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
            <th>수신자 번호</th>
            <th>쿠폰명</th>
            <th>발송 일자</th>
            <th>발송 상태</th>
            <th>사용 여부</th>
            <th>비고</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="log" items="${couponIssuedLogList}">
            <tr>
                <td>
                    <label class="chk label">
                        <input type="checkbox" name="deleteChk" id="deleteChk" value="${log.encodedSeq}" />
                        <span class="chk-box"></span>
                    </label>
                </td>
                <td>${log.phone}</td>
                <td>
                    ${log.coupon_nm}
                    <article class="coupon_detail">
                        <button type="button" class="btn detail" onclick="viewCoupon(this)"></button>
                        <section class="modal coupon">
                            <div class="coupon_image">
                                <img src="${couponImageDomain}${log.img_url}" alt="쿠폰" />
                            </div>
                        </section>
                    </article>
                </td>
                <td>${log.send_dt}</td>
                <c:choose>
                    <c:when test="${log.send_status == 0}">
                        <td>발송대기</td>
                    </c:when>
                    <c:when test="${log.send_status == 1}">
                        <td>결과수신대기</td>
                    </c:when>
                    <c:when test="${log.send_status == 2}">
                        <td>성공</td>
                    </c:when>
                    <c:when test="${log.send_status == 3}">
                        <td>실패</td>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${log.use_yn == 'Y'}">
                        <td>사용</td>
                    </c:when>
                    <c:otherwise>
                        <td>미사용</td>
                    </c:otherwise>
                </c:choose>
                <td></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<section class="paging_wrap">
    <div class="btn_row bottom-border">
        <ul class="pager">
            <ui:pagination paginationInfo="${page}" type="image" jsFunction="getCouponIssuedLogList"/>
        </ul>
    </div>
</section>
</c:if>
</span>