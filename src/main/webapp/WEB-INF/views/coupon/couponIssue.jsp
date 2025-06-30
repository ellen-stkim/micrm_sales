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
<script type="text/javascript" charset="utf-8" src="/js/mcdonalds_coupon.js?v=0.16"></script>
<div class="wrap mcdonald">
    <h3 class="page_title">COUPON</h3>
    <form:form id="couponIssueForm" name="couponIssueForm" onsubmit="return false">
    <input type="hidden" name="encodedCouponSeq" value="${coupon.encodedSeq}">
    <input type="hidden" name="msg_content" value="${coupon.content}">
    <article class="area option bdr_bottom">
        <section class="breadcrumb">
            <ul>
                <li>
                    <a href="javascript:void(0)">홈</a>
                </li>
                <li>
                    <span>쿠폰 발급</span>
                </li>
            </ul>
        </section>
    </article>
    <article class="area option bdr_bottom regist">
        <section class="input_field">
            <h6 class="title">메시지 제목</h6>
            <input type="text" name="msg_title" id="msgTitleInput" placeholder="메시지 제목을 입력해주세요."  autocomplete="off" />
        </section>
    </article>
    <article class="area form_field issue">
        <section class="left">
            <ul class="input_field info">
                <li>
                    <h6 class="label_name">쿠폰명</h6>
                    <article class="components al_center">
                        <section class="value">
                            ${coupon.nm}
                        </section>
                        <article class="coupon_detail">
                            <button type="button" class="btn detail" onclick="viewCoupon(this)"></button>
                            <section class="modal coupon" style="min-width: 300px; max-width: 500px;">
                                <div class="coupon_image" >
                                    <img src="${couponImageDomain}${coupon.img_url}" alt="쿠폰" style="max-width: 100%; max-height: 100%; object-fit: contain;" />
                                </div>
                            </section>
                        </article>
                    </article>
                </li>
                <li>
                    <h6 class="label_name">발신번호</h6>
                    <article class="components al_center" id="sendNumber"></article>
                </li>
            </ul>
            <ul class="input_field audience">
                <li>
                    <h6 class="label_name">발행 대상자</h6>
                    <article class="components">
                        <section class="part list">
                            <div class="inner">
                                <input type="text" id="phoneNumberInput" placeholder="직접 입력" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"  autocomplete="off" />
                                <div class="btn_field">
                                    <button type="button" class="btn add" id="addBtn" onclick="addReceivePhoneNumber()">
                                        <span class="line"></span>
                                        <span class="line"></span>
                                    </button>
                                    <button type="button" class="btn reset" onclick="resetPhoneNumber();"></button>
                                </div>
                            </div>
                            <div class="list_wrap">
                                <ul class="add_list" id="add_list"></ul>
                            </div>
                        </section>
                        <section class="part file">
                            <div class="inner">
                                <label class="file label">
                                    <input type="file" name="" id="fileInput" accept=".xls,.xlsx" onchange="addExcelPhoneNumber(this)" onclick="this.value=null;"/>
                                    <span class="btn file">파일등록</span>
                                </label>
                                <input type="text" name="" id="fileName" placeholder="선택된 파일 없음" readonly />
                            </div>
                            <section class="count">총 <span class="current" id="current_add_number">0</span>건</section>
                        </section>
                    </article>
                </li>
            </ul>
        </section>
        <section class="right">
            <article class="preview complete">
                <section class="contents">
                    <h6 id="msgTitle">메시지 제목</h6>
                    <p>
                        ${coupon.content}
                    </p>
                </section>
            </article>
        </section>
    </article>
    <article class="area button">
        <button type="button" class="btn regist" id="issueCouponBtn" onclick="issueCoupon()">쿠폰 발급</button>
    </article>
    </form:form>
    <footer class="footer">
        <p class="copyright">ⓒ Milvus Corp.</p>
    </footer>
</div>
<script>
    var phoneSet = new Set();
    var currentAddNumberCount = 0;

    $(document).ready(function() {

        $("#msgTitleInput").keyup(function(e) {
             $("#msgTitle").html($(this).val());

        });

        $("#phoneNumberInput").keyup(function (e) {
            if (e.keyCode == 13) {
                addReceivePhoneNumber();
            }
            $("#phoneNumberInput").val(formattingPhoneNumber($("#phoneNumberInput").val()));
        });

        showPhoneNumberFormatted();
    });

    function addReceivePhoneNumber() {
        // 핸드폰 형식 검사
        let regexPhoneNumber = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;
        let phoneNumberInput = $("#phoneNumberInput").val();

        if (!regexPhoneNumber.test(phoneNumberInput)) {
            popup.popAlert('핸드폰 형식에 맞게 입력해주세요.');
            return false;
        }

        // 중복 검사
        if(phoneSet.has(phoneNumberInput.replace(/-/gi, ""))) {

            popup.popAlert('중복된 번호입니다.');
            return false;
        }

        // 추가 및 입력 필드 초기화
        phoneSet.add(phoneNumberInput.replace(/-/gi, ""));
        addAudience(document.getElementById('addBtn'));

        $("#phoneNumberInput").val('');
        currentAddNumberCount ++;
        showNumberCountFormatted();

        popup.popAlert('추가되었습니다.');
    }

    function deleteReceivePhoneNumber(btn, phoneNumber) {

        phoneSet.delete(phoneNumber.replace(/-/gi, ""));

        currentAddNumberCount --;
        showNumberCountFormatted();
        delAudience(btn);
    }

    function showNumberCountFormatted() {
        $("#current_add_number").text(currentAddNumberCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));
    }

    function showPhoneNumberFormatted() {

        $('#sendNumber').html(phoneFormatter('${sendNumber}'));
    }

    function formattingPhoneNumber(phoneNumber) {
        var reg = /^((01[1|6|7|8|9])[0-9]+[0-9]{6,7})|(010[0-9][0-9]{7})$/;

        if(reg.test(phoneNumber.replace(/-/gi, ""))) {
            if (phoneNumber.length == 10) {
                //010 123 1234
                phoneNumber = phoneNumber.substr(0,3) + '-' + phoneNumber.substr(3,3) + '-' + phoneNumber.substr(6,4);
            } else if (phoneNumber.length == 11) {
                phoneNumber = phoneNumber.substr(0,3) + '-' + phoneNumber.substr(3,4) + '-' + phoneNumber.substr(7,4);
            }
        }

        return phoneNumber;
    }

    function phoneFormatter(num){

        var formatNum;

        if(num.length==11){
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        }else if(num.length==8){
            formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
        }else{
            if(num.indexOf('02')==0){
                formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
            }else{
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
            }
        }
        return formatNum;
    }



    function addExcelPhoneNumber(file) {

        var data = new FormData();
        data.append("file", $(file)[0].files[0]);
        const res = function (response) {
            if (response["status"] != null && response["status"] == "400") {
                popup.popAlert(response["message"]);
                return;
            }

            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('#add_list').append($("#body", $doc).html());
            $('#fileName').val($(file).val());
            fileUpload(document.getElementById('fileInput'));
            setPhoneNumberList(phoneList);

            currentAddNumberCount += Number(collectCnt);
            showNumberCountFormatted();

            popup.popAlert("등록되었습니다. 성공: "+collectCnt+", 중복: "+duplicateCnt+", 실패: "+errorCnt);
        }
        com_ajax.ajax_file('${baseURL}/coupon/extractExcel.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function setPhoneNumberList(phoneList) {
        for (var i = 0; i < phoneList.length; i++) {
            if (phoneSet.has(String(phoneList[i]))) {
                $('#'+String(phoneList[i])).remove();
                collectCnt --;
                duplicateCnt ++;
            } else {
                phoneSet.add(phoneList[i]);
            }
        }
    }

    function issueCoupon() {

        let phoneNumberArr = divisionArr(Array.from(phoneSet));
        if ($('#msgTitleInput').val() == '') {
            popup.popAlert('메시지 제목을 입력해주세요.');
            return;
        }
        if (phoneNumberArr.length == 0) {
            popup.popAlert('쿠폰 발행 대상을 입력해주세요.');
            return;
        }

        var data = $('#couponIssueForm').serializeArray();
        data.push({name: "phoneNumberList", value: phoneNumberArr});

        const res = function (response) {
            if (response["status"] != null && response["status"] == "400") {
                popup.popAlert(response["message"]);
                return;
            }

            popup.popAlertCallback(response["message"], "location.href = '/coupon/couponIssuedLog.mi';");
        };

        com_ajax.ajax('post', '${baseURL}/coupon/issueCoupon.service', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function divisionArr(phoneArr) {
        var arr = [];
        var size = 200;
        var str = '';
        for (let i = 0; i < phoneArr.length; i += size) {
            var slicedArr = phoneArr.slice(i, i + size);
            slicedArr.forEach(function (value) {
                str += (value + ',');
            })
            arr.push(str);
            str = '';
        }

        return arr
    }

    function resetPhoneNumber() {
        $("#fileInput").val("");
        $("#fileName").val("");
        phoneSet = new Set();
        currentAddNumberCount = 0;
        showNumberCountFormatted();
        $('#add_list').html('');
    }



</script>