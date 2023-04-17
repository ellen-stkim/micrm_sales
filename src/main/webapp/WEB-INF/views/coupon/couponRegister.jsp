<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
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
                        <span>쿠폰 등록</span>
                    </li>
                </ul>
            </section>
        </article>
        <form:form id="registerCouponForm" name="registerCouponForm" onsubmit="return false">
        <article class="area option bdr_bottom regist">
            <section class="input_field">
                <h6 class="title">쿠폰명</h6>
                <input type="text" name="nm" placeholder="쿠폰명을 입력해주세요." />
            </section>
            <section class="select-box">
                <select name="category_seq" id="category_seq">
                    <option value="">카테고리 선택</option>
                    <c:forEach var="category" items="${categoryList}">
                        <option value="${category.seq}">${category.nm}</option>
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
                                <input type="file" name="imgFile" id="imgFile" accept="image/*" onchange="loadImage(this)" />
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
                            <textarea name="title" id="title" cols="30" rows="10" placeholder="Title을 입력해주세요." maxlength="200"></textarea>
                            <section class="text_cnt"><span class="current" id="titleCount">0</span>&#47;200<i>자</i></section>
                        </article>
                    </li>
                    <li>
                        <h6 class="label_name">Description</h6>
                        <article class="components">
                            <textarea name="descr" id="descr" cols="30" rows="10" placeholder="Description을 입력해주세요." maxlength="500"></textarea>
                            <section class="text_cnt"><span class="current" id="descrCount">0</span>&#47;500<i>자</i></section>
                        </article>
                    </li>
                    <li>
                        <h6 class="label_name">Temps & Condition</h6>
                        <article class="components">
                            <textarea name="notice" id="notice" cols="30" rows="10" placeholder="Temps & Condition을 입력해주세요." maxlength="4000"></textarea>
                            <section class="text_cnt"><span class="current" id="noticeCount">0</span>&#47;4,000<i>자</i></section>
                        </article>
                    </li>
                </ul>
                <ul class="input_field period">
                    <li>
                        <article class="part">
                            <h6 class="label_name">Expiry Date</h6>
                            <section class="components">
                                <input type="text" name="expire_date" class="datepicker" id="expireDateInput" placeholder="0000-00-00" value="" onkeyup="formatDate(this);" maxlength="10"/>
                                <button type="button" class="btn calendar"></button>
                            </section>
                        </article>
                        <article class="part">
                            <h6 class="label_name">Expiry Time</h6>
                            <section class="components">
                                <input type="text" name="expire_time" class="timepicker" placeholder="00:00" value="" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeyup="formatTime(this);" maxlength="5" autocomplete="off" />
                                <button type="button" class="btn time"></button>
                            </section>
                        </article>
                    </li>
                    <li>
                        <article class="part">
                            <h6 class="label_name">Daily Start Time</h6>
                            <section class="components">
                                <input type="text" name="daily_start_time" class="timepicker" placeholder="00:00" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeyup="formatTime(this);" maxlength="5" autocomplete="off"  />
                                <button type="button" class="btn time"></button>
                            </section>
                        </article>
                        <article class="part">
                            <h6 class="label_name">Daily End Time</h6>
                            <section class="components">
                                <input type="text" name="daily_end_time" class="timepicker" placeholder="00:00" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeyup="formatTime(this);" maxlength="5" autocomplete="off"  />
                                <button type="button" class="btn time"></button>
                            </section>
                        </article>
                    </li>
                    <li>
                        <article class="part">
                            <h6 class="label_name">Available Day</h6>
                            <section class="components">
                                <label><input type="checkbox" value="1" name="available_day">월</label>
                                <label><input type="checkbox" value="2" name="available_day">화</label>
                                <label><input type="checkbox" value="3" name="available_day">수</label>
                                <label><input type="checkbox" value="4" name="available_day">목</label>
                                <label><input type="checkbox" value="5" name="available_day">금</label>
                                <label><input type="checkbox" value="6" name="available_day">토</label>
                                <label><input type="checkbox" value="0" name="available_day">일</label>
                            </section>
                        </article>
                    </li>
                </ul>
            </section>
            <section class="right">
                <article class="preview">
                    <section class="image">
                        <img alt="이미지 없음" class="noimage" />
                    </section>
                    <section class="contents">
                        <textarea name="content" id="content" cols="30" rows="10" placeholder="문자 메시지 내용과 쿠폰 링크를 삽입해주세요."></textarea>
                    </section>
                </article>
            </section>
        </article>
        <article class="area button">
            <input type="button" class="btn regist" value="쿠폰 등록" onclick="registerCoupon();">
        </article>
        </form:form>
    <footer class="footer">
        <p class="copyright">ⓒ Milvus Corp.</p>
    </footer>
</div>
<script type="text/javascript">

    $(document).ready(function() {

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

    });

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

    function registerCoupon() {

        var data = new FormData();
        var insertForm = $('#registerCouponForm').serializeArray();
        for (var i = 0; i < insertForm.length; i++ ) {
            data.append(insertForm[i].name, insertForm[i].value);
        }
        let img = $('#imgFile')[0].files[0];
        if (img != undefined) {
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
        com_ajax.ajax_file('${baseURL}/coupon/registerCoupon.service', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function formatDate(date) {
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