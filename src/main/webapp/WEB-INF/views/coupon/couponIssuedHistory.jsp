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
<script src="/js/jquery-ui-timepicker.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/mcdonalds_coupon.js"></script>
<div class="wrap mcdonald">
    <h3 class="page_title">COUPON</h3>
    <form:form id="searchCouponIssuedLogForm" name="searchCouponIssuedLogForm" onsubmit="return false" >
        <article class="area option bdr_bottom">
            <section class="breadcrumb">
                <ul>
                    <li>
                        <a href="javascript:void(0)">홈</a>
                    </li>
                    <li>
                        <span>쿠폰 발급내역</span>
                    </li>
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
            <div class="period_wrap">
                <section class="period">
                    <input type="text" name="send_start_dt" placeholder="발송 일자" class="datepicker" />
                    <button type="button" class="btn calendar"></button>
                </section>
                <span>-</span>
                <section class="period">
                    <input type="text" name="send_end_dt" placeholder="발송 일자" class="datepicker" />
                    <button type="button" class="btn calendar"></button>
                </section>
            </div>
            <section class="select-box">
                <select name="send_status" id="">
                    <option value="">발송상태</option>
                    <option value="">전체</option>
                    <option value="0">발송대기</option>
                    <option value="1">결과수신대기</option>
                    <option value="2">성공</option>
                    <option value="3">실패</option>
                </select>
            </section>
            <section class="select-box">
                <select name="use_yn" id="">
                    <option value="">사용 여부</option>
                    <option value="">전체</option>
                    <option value="Y">사용</option>
                    <option value="N">미사용</option>
                </select>
            </section>
            <section class="srh-box">
                <input type="text" name="coupon_nm" placeholder="쿠폰명 입력" onkeyup="if (window.event.keyCode == 13) { getCouponIssuedLogList('1'); } return false;"  />
                <button type="button" class="btn srh" onclick="getCouponIssuedLogList('1')"></button>
            </section>
        </article>
        <article class="area option bdr_bottom bdr_right">
            <button type="button" class="btn del" onclick="deleteCoupon()">
                <span class="ico"></span>
                <span class="text">삭제</span>
            </button>
        </article>
    </form:form>
    <article class="tbl_wrap list history" id="couponIssuedLogListTable">

    </article>
    <footer class="footer">
        <p class="copyright">ⓒ Milvus Corp.</p>
    </footer>
</div>
<script>
    $(document).ready(function() {
        getCouponIssuedLogList('1');
    });

    function getCouponIssuedLogList(pageNo) {

        var data = $('#searchCouponIssuedLogForm').serializeArray();
        data.push({name: "pageNo", value: pageNo});
        const res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('#couponIssuedLogListTable').html($("#body", $doc).html());
        }

        com_ajax.ajax('post', '${baseURL}/coupon/getCouponIssuedLogList.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function deleteCoupon() {

        var checkArr = [];
        $('input[name="deleteChk"]:checked').each(function () {
            checkArr.push(this.value)
        });

        // 아무것도 선택 안함 체크
        if (checkArr.length === 0) {
            popup.popAlert('삭제할 쿠폰 발급 내역을 선택해주세요.');
            return;
        }

        var data = {
            "deleteCouponIssuedLogSeq" : checkArr
        };
        const res = function (response) {
            popup.popAlertCallback(response["message"], "location.href = '/coupon/couponIssuedHistory.mi';");
        };

        com_ajax.ajax('post', '${baseURL}/coupon/deleteCouponIssuedLog.service', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function clickDeleteChk() {
        let deleteAllChk = $('input[id="deleteAllChk"]');
        deleteAllChk.checked = deleteAllChk.is(':checked');
        $('input[name="deleteChk"]').each(function () {
            this.checked = deleteAllChk.is(':checked');
        });
    }
</script>
