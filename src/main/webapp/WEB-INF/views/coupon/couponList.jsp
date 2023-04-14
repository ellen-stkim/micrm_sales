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
<script type="text/javascript" charset="utf-8" src="/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/mcdonalds_coupon.js"></script>
<div class="wrap mcdonald">
    <h3 class="page_title">COUPON</h3>
    <form:form id="searchCouponListForm" name="searchCouponListForm" onsubmit="return false">
        <article class="area option bdr_bottom">
            <section class="breadcrumb">
                <ul>
                    <li><span>홈</span></li>
                    <li><span>쿠폰 리스트</span></li>
                </ul>
            </section>
            <section class="select-box">
                <select name="category_seq" id="category_seq">
                    <option value="">카테고리 전체</option>
                    <c:forEach var="category" items="${categoryList}">
                        <option value="${category.seq}">${category.nm}</option>
                    </c:forEach>
                </select>
            </section>
            <section class="period">
                <input type="text" name="expire_dt" placeholder="유효 기간" class="datepicker" />
                <button type="button" class="btn calendar"></button>
            </section>
            <section class="srh-box">
                <input type="text" name="nm" placeholder="쿠폰명 입력" onkeyup="if (window.event.keyCode == 13) { getCouponList('1'); } return false;" />
                <button type="button" class="btn srh" onclick="getCouponList('1');"></button>
            </section>
        </article>
        <article class="area option bdr_bottom">
            <button type="button" class="btn del" onclick="deleteCoupon()">
                <span class="ico"></span>
                <span class="text">삭제</span>
            </button>
            <a href="${baseURL}/coupon/couponRegister.mi" class="link create">
                <span class="ico coupon"></span>
                <span class="text">신규 쿠폰 등록</span>
            </a>
        </article>
    </form:form>
    <article class="tbl_wrap list"  id="couponListTable">

    </article>
    <footer class="footer">
        <p class="copyright">ⓒ Milvus Corp.</p>
    </footer>
</div>
<script src="/js/jquery-ui-timepicker.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/mcdonalds_coupon.js"></script>
<script>
    $(document).ready(function() {
        getCouponList('1');
    });

    function getCouponList(pageNo) {

        var data = $('#searchCouponListForm').serializeArray();
        data.push({name: "pageNo", value: pageNo});
        const res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('#couponListTable').html($("#body", $doc).html());
        }

        com_ajax.ajax('post', '${baseURL}/coupon/getCouponList.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function deleteCoupon() {

        var checkArr = [];
        $('input[name="deleteChk"]:checked').each(function () {
            checkArr.push(this.value)
        });

        // 아무것도 선택 안함 체크
        if (checkArr.length === 0) {
            popup.popAlert('삭제할 쿠폰을 선택해주세요.');
            return;
        }

        var data = {
            "deleteCouponSeq" : checkArr
        };
        const res = function (response) {
            popup.popAlertCallback(response["message"], "location.href = '/coupon/couponList.mi';");
        };

        com_ajax.ajax('post', '${baseURL}/coupon/deleteCoupon.service', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }


    function clickDeleteChk() {
        let deleteAllChk = $('input[id="deleteAllChk"]');
        deleteAllChk.checked = deleteAllChk.is(':checked');
        $('input[name="deleteChk"]').each(function () {
            this.checked = deleteAllChk.is(':checked');
        });
    }
</script>
