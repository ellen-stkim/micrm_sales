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
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>

<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <form:form id="searchForm" name="searchForm" action="${baseURL}/camp/st/sendStatus.mi" method="get">
            <!-- row 영역 시작 -->
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>캠페인</li>
                        <li>발송 현황</li>
                    </ul>
                    <!-- tooltip 버튼 영역  -->
<%--                    <div class="tooltip_icon">--%>
<%--                        <img src="../../image/ico_tooltip.png" alt="Tooltip" />--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 시작 -->
<%--                    <div class="tooltip_box">--%>
<%--                        <!-- tooltip bullet 영역 -->--%>
<%--                        <div class="bullet"></div>--%>
<%--                        <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />--%>
<%--                                    나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                    차지합니다.</span>--%>
<%--                        스타일론 직장인이 26.69억(29.1%), <br />--%>
<%--                        스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 끝 -->
                </div>
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border" id="searchOption">
                        <!-- selected value -->
                        <div class="value searchSelect" id="searchStandard" data="${searchType}">
                            <c:choose>
                                <c:when test="${searchType == 'pro_nm'}">캠페인명</c:when>
                                <c:when test="${searchType == 'usr_nm'}">발송담당자</c:when>
                                <c:when test="${searchType == 'cd_nm'}">진행상태</c:when>
                                <c:otherwise>기준선택</c:otherwise>
                            </c:choose>
                        </div>
                        <!-- option -->
                        <ul class="option">
                            <li data="">기준선택</li>
                            <li data="pro_nm">캠페인명</li>
                            <li data="usr_nm">발송담당자</li>
                            <li data="cd_nm">진행상태</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <span id="cd_area" class="left">
                    </span>
                    <input type="text" class="searchInp left-border" id="searchValue" name="searchValue" placeholder="검색어입력" onkeyup="enterSubmit();" value="${searchValue}"/>
                    <input type="hidden" name="searchType" id="searchType" value="${searchType}"/>
                    <input type="hidden" id="page_num" name="pageNo" value="${pageNo}"/>
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchSendStatus();" />
                </div>
            </div>

            <!-- row 영역 끝 -->
            <!-- row 영역 시작 -->
            <div class="row bottom-border cf">
                <!-- 검색 기간 영역 시작 -->
                <div class="range_calendar right">
                    <input type="text" class="date" id="from" name="st_dt" placeholder="시작날짜" autocomplete="off" value="${stdt}" />
                    <input type="text" class="date" id="to" name="end_dt" placeholder="종료날짜" autocomplete="off" value="${enddt}"/>
                    <ul class="option_month cf">
                        <li type="button" class="en_font" value="1" onclick="quickDate(this.value, 'st_dt', 'end_dt')">1</li>
                        <li type="button" class="en_font" value="2" onclick="quickDate(this.value, 'st_dt', 'end_dt')">2</li>
                        <li type="button" class="en_font" value="3" onclick="quickDate(this.value, 'st_dt', 'end_dt')">3</li>
                        <li type="button" class="en_font" value="6" onclick="quickDate(this.value, 'st_dt', 'end_dt')">6</li>
                    </ul>
                </div>
                <!-- 검색 기간 영역 끝 -->
            </div>
        </form:form>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="status_area cf">
            </div>
                <c:choose>
                    <c:when test="${!cutil:isEmptyObject(list)}">
                        <div class="scroll_tbl" id="bodyDom">
                            <!-- table 영역 시작 -->
                            <table class="table target_tbl dynamic_tbl list" id="sendTable">
                                <thead>
                                <tr>
                                    <th>상태</th>
                                    <th>구분</th>
                                    <th>캠페인 명</th>
                                    <th>발송일시</th>
                                    <th>타겟 수</th>
                                    <th>보기</th>
                                </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${list}" varStatus="status">
                                        <tr>
                                            <td><span class="status_mark
                                            <c:choose>
                                                <c:when test="${item.pro_st eq '00'}">orange</c:when>
                                                <c:when test="${item.pro_st eq '01'}">blue</c:when>
                                                <c:when test="${item.pro_st eq '02'}">green</c:when>
                                                <c:when test="${item.pro_st eq '03'}">purple</c:when>
                                                <c:when test="${item.pro_st eq '04'}">indigo</c:when>
                                                <c:when test="${item.pro_st eq '99'}">red</c:when>
                                            </c:choose>
                                            "></span>${item.pro_st_nm}</td>
                                            <td>${item.pro_tg_tp_nm}</td>
                                            <td><span class="ellipsis">${item.pro_nm}</span></td>
                                            <td class="en_font">${item.start_dt}</td>
                                            <td><span class="en_font"><fmt:formatNumber value="${item.send_cnt}" pattern="#,###" /></span>명</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.pro_tg_tp eq 'TEST'}">
                                                        <div onclick="testDetailPopup('${item.pro_id}');" class="btn_sm_line btn_inline size">상세</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="/camp/st/sendDetail.mi?pid=${item.pro_id}" class="btn_sm_line btn_inline size">상세</a>
                                                    </c:otherwise>
                                                </c:choose>
                                                <!-- 플로우 페이지 이동 -->
                                                <!-- <a href="#" class="btn_sm_line btn_inline size btn_flow"><img src="../../image/ico_btn19.png" alt=""/></a> -->
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_row bottom-border">
                            <ul class="pager" id="pagingDom">
                                <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
                            </ul>
                        </div>
                    <!-- table 영역 끝 -->
                </c:when>
                <c:otherwise>
                    <div class="scroll_tbl">
                        <!-- table 영역 시작 -->
                        <table class="table target_tbl dynamic_tbl list" id="sendTable">
                            <thead>
                            <tr>
                                <th>상태</th>
                                <th>캠페인 명</th>
                                <th>발송일시</th>
                                <th>발송 타겟</th>
                                <th>타겟 수</th>
                                <th>보기</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr class="no_data">
                                <td colspan="100%">조회된 결과가 없습니다.</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btn_row bottom-border">
                    </div>
                    <!-- table 영역 끝 -->
                </c:otherwise>
            </c:choose>

        <!-- section 영역 끝 -->
    </div>
    <!-- 컨텐츠 영역 끝 -->
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>
<!-- wrap end -->

<!-- 테스트 발송 상세 팝업 영역 시작 -->
<div class="layer_pop" id="testDetailPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">테스트 발송 상세</div>
        <div class="pop_inner" id="testDetail"></div>
    </div>
</div>
<!-- 테스트 발송 상세 팝업 영역 끝 -->

<!-- alert 팝업 Type1 -->
<div class="layer_pop alert" id="type1">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title"></div>
        <div class="pop_inner">
            <div class="alert_txt">
                문구 영역
            </div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" onclick="popupClose(this);" value="확인" />
            </div>
        </div>
    </div>
</div>

<!-- alert 팝업 Type2 -->
<div class="layer_pop alert" id="type2">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title"></div>
        <div class="pop_inner">
            <div class="alert_txt">
                문구 영역
            </div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this);" value="확인" />
                <input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />
            </div>
        </div>
    </div>
</div>

<script>
    let testParam = [];

    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchSendStatus();
        }
        return false;
    }
    $(function () {
        // 전체 체크/해제 동작
        $('.all input').click(function () {
            if ($(this).is(':checked') == true) {
                $('.custom_check1 input').not('.all input').prop('checked', true);
            } else {
                $('.custom_check1 input').not('.all input').prop('checked', false);
            }
        });

        $('.table tbody .custom_check1 input').click(function () {
            let total = $('.custom_check1 input').not('.all input').length;
            let checkTotal = $('.custom_check1 input:checked').not('.all input').length;
            if (total == checkTotal) {
                $('.all input').prop('checked', true);
            } else {
                $('.all input').prop('checked', false);
            }
        });
        //end

        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
        });

        //기간 검색 시작일
        $('#from').datepicker({
            onSelect: function (selected) {
                $('#to').datepicker("option", "minDate", selected);
            }
        });
        //기간 검색 종료일
        $('#to').datepicker({
            onSelect: function (selected) {
                $('#from').datepicker("option", "maxDate", selected);
            }
        });

        // 검색 기준 선택 값이 발송타겟인 경우 상세 옵션 Select 영역 생성, 삭제 동작
        $("#searchOption ul li").on('click',function(){
            let thisData = $(this).attr('data');
           if(thisData === "cd_nm"){
               $('#searchValue').hide();
               $('#cd_area').html(
                  '<div class="select style1 left-border right-border" id="stOption">' +
                       '<div class="value searchSelect searchTarget">승인대기</div>' +
                        '<ul class="option">' +
                           '<li>승인대기</li>' +
                           '<li>발송대기</li>' +
                           '<li>타겟추출중</li>' +
                           '<li>발송중</li>' +
                           '<li>에러</li>' +
                           '<li>완료</li>' +
                           '<li>임시저장</li>' +
                       '</ul>' +
                   '</div>'
               );
           }else{
               $('#searchValue').val("");
               $('#searchValue').show();
               $('#cd_area').find('#stOption').remove();
               $('#cd_area').hide();
           }
        });
        
        //발송타겟 검색 상세 옵션 select 체크 값 구분
        $(document).on('click','#stOption ul li',function(){
            let data = $(this).html();
            console.log(data)
            $('#searchValue').val(data);
        });

        //발송 상태 Click
        $('.step_box').on('click',function(){
            if(!$(this).hasClass('block')){
                $(this).toggleClass('active').siblings().removeClass('active');
            }else{
                return false;
            }
        });

    });
    //테스트 발송 상세 팝업 open event
    function testDetailPopup(proId, type){
        const res = function (response) {
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $("#testDetail").html($("#testDetail", $doc).html());
            $('#testDetailPopup').addClass('active');
        };

        testParam = [];
        testParam.push({name: 'pid', value: proId});
        if(type){
            testParam.push({name: 'type', value: type});
        }
        com_ajax.ajax('post', '/camp/getSendHst.ajax', testParam, res);
    }
    
    function testDetailDown() {
        let frm = common.create_form('dummy', 'POST', '/camp/getSendHstDown.service', 'popup_down');
        for(const t in testParam){
            common.add_input(frm, testParam[t].name, testParam[t].value);
        }
        let message = '<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge"><title>miCRM</title></head><body><img src="/image/excelDown.jpg" alt="" style="width:100%;"></body></html>';
        common.popview('', 'popup_down', '661', '423', message);
        document.body.insertBefore(frm, null);
        frm.submit();
        frm.remove();
    }

    function searchSendStatus(){
        let searchProSt = $('#searchProSt').attr('data');
        $('#pro_tp').val(searchProSt);
        let standard = $('#searchStandard').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if((standard == null ||standard == "") && searchValue != ''){
            popup.popAlert("기준을 선택해주세요.");
            return false;
        }
        $('#searchType').val(standard);

        $('#page_num').val(1);
        $('#searchForm').submit();
    }
    
    function getSearchSendStatus(pageNo) {
        let res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $("#bodyDom").html($("#bodyDom", $doc).html());
            $("#pagingDom").html($("#pagingDom", $doc).html());
            $("#olDom").html($("#olDom", $doc).html());
            var typeCheck = $('#pro_tp').val();
            if(typeCheck == "TEST"){
                for(let i=0; i < 4; i ++){
                    $('#olDom').children('li').eq(i).addClass('block');
                }
            }else{
                for(let i=0; i < 4; i ++){
                    $('#olDom').children('li').eq(i).removeClass('block');
                }
            }
        };
        let param = $("#searchForm").serializeArray();
        param.push({name: 'pageNo', value: pageNo});

        com_ajax.ajax('post', '${baseURL}/camp/getSearchSendStatus.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function linkPage(s){
        $("#page_num").val(s);
        $("#searchForm").submit();
    }
    function init(){
        var searchType = '${searchType}';
        var searchValue = '${searchValue}';

        if(searchType === "cd_nm"){
            $('#searchValue').hide();
            $('#cd_area').html(
                '<div class="select style1 left-border right-border" id="stOption">' +
                '<div class="value searchSelect searchTarget">'+searchValue+'</div>' +
                '<ul class="option">' +
                '<li>승인대기</li>' +
                '<li>발송대기</li>' +
                '<li>타겟추출중</li>' +
                '<li>발송중</li>' +
                '<li>에러</li>' +
                '<li>완료</li>' +
                '<li>임시저장</li>' +
                '</ul>' +
                '</div>'
            );
        }
        var searchBox = $('.searchSelect');
        for(var i=0; i<searchBox.length; i++){
            if(searchBox.eq(i).attr('data') != null && searchBox.eq(i).attr('data') != ""){
                searchBox.eq(i).css('color','#222222');
            }
        }
    }

    init();
</script>