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
<script src="/js/jquery-ui-timepicker.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/mcdonalds_coupon.js?v=0.12"></script>
<div class="wrap mcdonald">
    <h3 class="page_title">COUPON</h3>
        <article class="area option bdr_bottom">
            <section class="breadcrumb">
                <ul>
                    <li>
                        <a href="javascript:void(0)">홈</a>
                    </li>
                    <li>
                        <span>쿠폰 수정</span>
                    </li>
                </ul>
            </section>
        </article>
        <form:form id="updateCouponForm" name="updateCouponForm" onsubmit="return false">
        <input type="hidden" name="encodedSeq" value="${coupon.encodedSeq}" />
        <input type="hidden" name="img_file_seq" value="${coupon.img_file_seq}" />
        <article class="area option bdr_bottom regist">
            <section class="input_field">
                <h6 class="title">쿠폰명</h6>
                <input type="text" name="nm" placeholder="쿠폰명을 입력해주세요." value="${coupon.nm}" />
            </section>
            <section class="select-box">
                <select name="category_seq" id="category_seq">
                    <option value="">카테고리 선택</option>
                    <c:forEach var="category" items="${categoryList}">
                    <option value="${category.seq}" <c:if test="${category.seq eq coupon.category_seq}">selected='selected'</c:if>>${category.nm}</option>
                    </c:forEach>
                </select>
            </section>
        </article>
        <article class="area form_field">
            <section class="left">
                <ul class="input_field">
                    <li>
                        <h6 class="label_name">이미지 등록</h6>
                        <article class="components file">
                            <section class="value">
                                <span>이미지를 등록해주세요.</span>
                                <button type="button" class="btn del" onclick="delImage(this)"></button>
                            </section>
                            <label class="file label">
                                <input type="file" name="imgFile" id="imgFile" accept="image/*" src="${baseURL}${coupon.img_url}" onchange="loadImage(this)" />
                                <span class="btn file">선택</span>
                            </label>
                        </article>
                    </li>
                    <li>
                        <h6 class="label_name">쿠폰 링크</h6>
                        <article class="components al_center">
                            <input type="text" name="" id="" placeholder="URL" value="{쿠폰링크}" readonly/>
                            <button type="button" class="btn insert" onclick="insertCouponLinkText()">삽입</button>
                        </article>
                    </li>
                </ul>
                <ul class="input_field text">
                    <li>
                        <h6 class="label_name">Title</h6>
                        <article class="components">
                            <textarea name="title" id="title" cols="30" rows="10" placeholder="Title을 입력해주세요.">${coupon.title}</textarea>
                            <section class="text_cnt"><span class="current" id="titleCount">0</span>&#47;200<i>자</i></section>
                        </article>
                    </li>
                    <li>
                        <h6 class="label_name">Description</h6>
                        <article class="components">
                            <textarea name="descr" id="descr" cols="30" rows="10" placeholder="Description을 입력해주세요.">${coupon.descr}</textarea>
                            <section class="text_cnt"><span class="current" id="descrCount">0</span>&#47;500<i>자</i></section>
                        </article>
                    </li>
                    <li>
                        <h6 class="label_name">Temps & Condition</h6>
                        <article class="components">
                            <textarea name="notice" id="notice" cols="30" rows="10" placeholder="Temps & Condition을 입력해주세요.">${coupon.notice}</textarea>
                            <section class="text_cnt"><span class="current" id="noticeCount">0</span>&#47;4,000<i>자</i></section>
                        </article>
                    </li>
                </ul>
                <ul class="input_field period">
                    <li>
                        <article class="part">
                            <h6 class="label_name">Expiry Date</h6>
                            <section class="components">
                                <input type="text" name="expire_date" class="datepicker" placeholder="0000-00-00" value="${fn:split(coupon.expire_dt, ' ')[0]}" autocomplete="off" />
                                <button type="button" class="btn calendar"></button>
                            </section>
                        </article>
                        <article class="part">
                            <h6 class="label_name">Expiry Time</h6>
                            <section class="components">
                                <input type="text" name="expire_time" class="timepicker" placeholder="00:00" value="${fn:split((fn:split(coupon.expire_dt, ' ')[1]), ':')[0]}:${fn:split((fn:split(coupon.expire_dt, ' ')[1]), ':')[1]}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeyup="formatTime(this);" maxlength="5" autocomplete="off" />
                                <button type="button" class="btn time"></button>
                            </section>
                        </article>
                    </li>
                    <li>
                        <article class="part">
                            <h6 class="label_name">Daily Start Time</h6>
                            <section class="components">
                                <input type="text" name="daily_start_time" id="daily_start_time" class="timepicker" placeholder="00:00" value="${fn:split(coupon.daily_start_time, ':')[0]}:${fn:split(coupon.daily_start_time, ':')[1]}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeyup="formatTime(this);" onchange="dailyStartEndTimePopup()" maxlength="5" autocomplete="off" />
                                <button type="button" class="btn time"></button>
                            </section>
                        </article>
                        <article class="part">
                            <h6 class="label_name">Daily End Time</h6>
                            <section class="components">
                                <input type="text" name="daily_end_time" id="daily_end_time" class="timepicker" placeholder="00:00" value="${fn:split(coupon.daily_end_time, ':')[0]}:${fn:split(coupon.daily_end_time, ':')[1]}"  oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeyup="formatTime(this);" onchange="dailyStartEndTimePopup()" maxlength="5" autocomplete="off" />
                                <button type="button" class="btn time"></button>
                            </section>
                        </article>
                    </li>
                    <li>
                        <article class="part full">
                            <h6 class="label_name">Date</h6>
                            <section class="components">
                                <ul class="days">
                                    <label for="chk-mon"><li <c:if test="${fn:contains(coupon.available_day, 1)}">class="active"</c:if>>MON</li></label>
                                    <input type="checkbox" id="chk-mon" value="1" name="available_day" style="display:none" <c:if test="${fn:contains(coupon.available_day, 1)}">checked</c:if>>
                                    <label for="chk-tue"><li <c:if test="${fn:contains(coupon.available_day, 2)}">class="active"</c:if>>TUE</li></label>
                                    <input type="checkbox" id="chk-tue" value="2" name="available_day" style="display:none" <c:if test="${fn:contains(coupon.available_day, 2)}">checked</c:if> >
                                    <label for="chk-wed"><li <c:if test="${fn:contains(coupon.available_day, 3)}">class="active"</c:if>>WED</li></label>
                                    <input type="checkbox" id="chk-wed" value="3" name="available_day" style="display:none" <c:if test="${fn:contains(coupon.available_day, 3)}">checked</c:if>>
                                    <label for="chk-thu"><li <c:if test="${fn:contains(coupon.available_day, 4)}">class="active"</c:if>>THU</li></label>
                                    <input type="checkbox" id="chk-thu" value="4" name="available_day" style="display:none" <c:if test="${fn:contains(coupon.available_day, 4)}">checked</c:if>>
                                    <label for="chk-fri"><li <c:if test="${fn:contains(coupon.available_day, 5)}">class="active"</c:if>>FRI</li></label>
                                    <input type="checkbox" id="chk-fri" value="5" name="available_day" style="display:none" <c:if test="${fn:contains(coupon.available_day, 5)}">checked</c:if>>
                                    <label for="chk-sat"><li <c:if test="${fn:contains(coupon.available_day, 6)}">class="active"</c:if>>SAT</li></label>
                                    <input type="checkbox" id="chk-sat" value="6" name="available_day" style="display:none" <c:if test="${fn:contains(coupon.available_day, 6)}">checked</c:if>>
                                    <label for="chk-sun"><li <c:if test="${fn:contains(coupon.available_day, 0)}">class="active"</c:if>>SUN</li></label>
                                    <input type="checkbox" id="chk-sun" value="0" name="available_day" style="display:none" <c:if test="${fn:contains(coupon.available_day, 0)}">checked</c:if>>
                                </ul>
                            </section>
                        </article>
                    </li>
                </ul>
            </section>
            <section class="right">
                <article class="preview">
                    <section class="image">
                        <img alt="이미지 없음" src="${baseURL}${coupon.img_url}" class="noimage modifyImg" />
                    </section>
                    <section class="contents">
                        <textarea name="content" id="content" cols="30" rows="10" placeholder="문자 메시지 내용과 쿠폰 링크를 삽입해주세요.">${coupon.content}</textarea>
                    </section>
                </article>
            </section>
        </article>
        <article class="area button">
            <input type="button" class="btn regist" value="쿠폰 수정" onclick="updateCoupon();">
        </article>
        </form:form>
    <footer class="footer">
        <p class="copyright">ⓒ Milvus Corp.</p>
    </footer>
</div>
<script type="text/javascript">

    $(document).ready(function() {
        // loadImage($("#imgFile"));

        $("#title").keyup(function(e) {
            var content = $(this).val();
            $("#titleCount").html(content.length);
        });

        $("#descr").keyup(function(e) {
            var content = $(this).val();
            $("#descrCount").html(content.length);
        });

        $("#notice").keyup(function(e) {
            var content = $(this).val();
            var count = content.length+"";
            if(content.length >= 1000) {
                count = count.substring(0, 1) + "," + count.substring(1, 4);
            }
            $("#noticeCount").html(count);
        });

        $('#updateCouponForm').validate({
            onfocusout: false
            , submitHandler: function () {
                return false;
            }
            , errorPlacement: $.noop
            , invalidHandler: function (form, validator) {
                let errors = validator.numberOfInvalids();
                if (errors) {
                    popup.popAlert(validator.errorList[0].message);
                }
            }
            , rules: {
                nm: {
                    required: true
                },
                category_seq:{
                    required: true
                },
                title: {
                    required: true
                },
                descr: {
                    required: true
                },
                notice: {
                    required: true
                },
                expire_date: {
                    required: true
                    ,vali_expire_date: true
                },
                expire_time: {
                    required: true
                    ,vali_expire_time: true
                },
                daily_start_time: {
                    required: true
                },
                daily_end_time: {
                    required: true
                }
            }
            , messages: {
                nm: {
                    required: "쿠폰명을 입력해주세요."
                },
                category_seq: {
                    required: "카테고리를 선택해주세요."
                },
                title: {
                    required: "Title을 입력해주세요."
                },
                descr: {
                    required: "Description을 입력해주세요."
                },
                notice: {
                    required: "Temps & Condition을 입력해주세요."
                },
                expire_date: {
                    required: "Expiry Date를 선택해주세요."
                    ,vali_expire_date: "Expiry Date 날짜 형식에 맞지 않습니다."
                },
                expire_time: {
                    required: "Expiry Time을 선택해주세요."
                    ,vali_expire_time: "Expiry Time 시간 형식에 맞지 않습니다."
                },
                daily_start_time: {
                    required: "Daily Start Time을 선택해주세요."
                    ,vali_expire_time: "Daily Start Time 시간 형식에 맞지 않습니다."
                },
                daily_end_time: {
                    required: "Daily End Time을 선택해주세요."
                    ,vali_expire_time: "Daily End Time 시간 형식에 맞지 않습니다."
                }
            }
        });

        $.validator.addMethod("vali_expire_date", function (value) {
            return /^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/.test(value) || value === "";
        });
        $.validator.addMethod("vali_expire_time", function (value) {
            return /^(0[0-9]|1[0-9]|2[0-3]):(0[0-9]|[1-5][0-9])$/.test(value) || value === "";
        });

    });

    function dailyStartEndTimePopup() {
        var dailyStartTime = $("#daily_start_time").val();
        var dailyEndTime = $("#daily_end_time").val();

        if (/^(0[0-9]|1[0-9]|2[0-3]):(0[0-9]|[1-5][0-9])$/.test(dailyStartTime) &&
            /^(0[0-9]|1[0-9]|2[0-3]):(0[0-9]|[1-5][0-9])$/.test(dailyEndTime)) {

            if (dailyStartTime > dailyEndTime) {
                let msg = '쿠폰 사용 시간은 당일 '+ dailyStartTime + '부터 다음 날 ' + dailyEndTime + '까지 입니다.';
                confirmAlertDailyTimeCheck(msg, "cancelDailyTime()");
            }
        }
    }

    function confirmAlertDailyTimeCheck(alertTxt, callback) {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="' + callback + '; popupClose(this);"/>' +
            '<div class="pop_title"></div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + alertTxt + '</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this);" value="적용" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="' + callback + '; popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
    }

    function cancelDailyTime() {
        $("#daily_end_time").val('');
    }

    function insertCouponLinkText(){
        var txtArea = document.getElementById('content');
        var txtValue = txtArea.value;
        var selectPos = txtArea.selectionStart; // 커서 위치 지정
        var beforeTxt = txtValue.substring(0, selectPos);  // 기존텍스트 ~ 커서시작점 까지의 문자
        var afterTxt = txtValue.substring(txtArea.selectionEnd, txtValue.length);   // 커서끝지점 ~ 기존텍스트 까지의 문자
        var addTxt = "{쿠폰링크}" // 추가 입력 할 텍스트

        txtArea.value = beforeTxt + addTxt + afterTxt;

        selectPos = selectPos + addTxt.length;
        txtArea.selectionStart = selectPos; // 커서 시작점을 추가 삽입된 텍스트 이후로 지정
        txtArea.selectionEnd = selectPos; // 커서 끝지점을 추가 삽입된 텍스트 이후로 지정
        $("#content").focus();
    }

    function updateCoupon() {
        if(!$('#updateCouponForm').valid()){
            return
        }

        var data = new FormData();
        var insertForm = $('#updateCouponForm').serializeArray();
        for (var i = 0; i < insertForm.length; i++ ) {
            data.append(insertForm[i].name, insertForm[i].value);
        }
        var img = $('#imgFile')[0].files[0];
        if (img != null) {
            data.append('imgFile', img);
        }

        const res = function (response) {
            if (response["status"] != null && response["status"] == "400") {
                popup.popAlert(response["message"]);
                return;
            }

            popup.popAlertCallback(response["message"], "location.href = '/coupon/couponList.mi';");
        };

        // ajax
        com_ajax.ajax_file('${baseURL}/coupon/updateCoupon.service', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function formatTime(time) {
        var replaceTime = time.value.replace(/\:/g, "");

        if (replaceTime.length >= 4 && replaceTime.length < 5) {

            var hours = replaceTime.substring(0, 2);
            var minute = replaceTime.substring(2, 4);

            if (isFinite(hours + minute) == false) {
                popup.popAlert("문자는 입력하실 수 없습니다.");
                time.value = "00:00";
                return false;
            }

            if (hours + minute > 2359) {
                popup.popAlert("시간은 24시를 넘길 수 없습니다.");
                time.value = "23:00";
                return false;
            }

            if (minute > 60) {
                popup.popAlert("분은 60분을 넘길 수 없습니다.");
                time.value = hours + ":00";
                return false;
            }
            time.value = hours + ":" + minute;
        }
    }
</script>