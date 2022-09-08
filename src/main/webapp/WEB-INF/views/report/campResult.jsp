<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<!-- container 영역 시작 -->
<section class="container camp_report" style="height: 100%">
    <div class="contents">
        <form:form id="searchForm" name="searchForm" action="" method="get">
            <!-- row 영역 시작 -->
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>리포트</li>
                        <li>캠페인 통합</li>
                        <li>캠페인 리스트</li>
                    </ul>
                </div>
                <div class="right">
                    <!-- select 영역 끝 -->
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border" id="searchOption">
                        <!-- selected value -->
                        <div class="value searchSelect" id="searchStandard" data="${searchType}">
                            <c:choose>
                                <c:when test="${searchType == 'pro_nm'}">캠페인명</c:when>
                                <c:when test="${searchType == 'target_nm'}">캠페인타겟</c:when>
                                <c:when test="${searchType == 'camp_ch'}">캠페인채널</c:when>
                                <c:when test="${searchType == 'camp_dt'}">캠페인기간</c:when>
                                <c:otherwise>기준선택</c:otherwise>
                            </c:choose>
                        </div>
                        <!-- option -->
                        <ul class="option">
                            <li data="">기준선택</li>
                            <li data="pro_nm">캠페인명</li>
                            <li data="target_nm">캠페인타겟</li>
                            <li data="camp_ch">캠페인채널</li>
                            <li data="camp_dt">캠페인기간</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <span id="target_area" class="left">
                        <c:if test="${searchType == 'target_nm'}">
                        <div class="select style1 left-border right-border" id="memberOption"
                             style="${param.pro_tg_tp == 'TG01' ? 'width: 326px;':  'width: 101px;'} ">
                            <div class="value searchSelect searchTarget" data="${param.pro_tg_tp}">
                                <c:choose>
                                    <c:when test="${param.pro_tg_tp == 'TG02'}">업로드 회원</c:when>
                                    <c:when test="${param.pro_tg_tp == 'TG99'}">테스트 그룹</c:when>
                                    <c:otherwise>DB 회원</c:otherwise>
                                </c:choose></div>
                            <ul class="option">
                                <li data="TG01">DB 회원</li>
                                <li data="TG02">업로드 회원</li>
                                <li data="TG99">테스트 그룹</li>
                                <input type="hidden" name="pro_tg_tp" value="">
                            </ul>
                        </div>
                        </c:if>
                    </span>
                    <span id="ch_area" class="left">
                        <c:if test="${searchType == 'camp_ch'}">
                            <div class="select style1 left-border right-border" id="chOption" style="width: 326px;"><div
                                    class="value searchSelect searchTarget" data="${param.pro_tg_tp}">이메일</div>
                                <ul class="option">
                                    <li data="CH01">이메일</li>
                                    <li data="CH02">문자</li>
                                </ul>
                            </div>
                        </c:if>
                    </span>
                    <input type="text" class="searchInp left-border " id="searchValue" name="searchValue"
                           style="${searchType != 'camp_ch' && param.pro_tg_tp != 'TG01' ? '' :'display:none'}"
                           placeholder="검색어입력" value="${searchValue}" onkeypress="if(event.keyCode==13) {searchCampList(); return false; }" />
                    <input type="hidden" name="searchType" id="searchType" value="${searchType}"/>
                    <input type="hidden" name="pageNo" value="${pageNo}"/>
                    <input type="text" class="searchBtn" value="검색" onclick="searchCampList();"/>
                </div>
            </div>

            <!-- row 영역 끝 -->
            <!-- row 영역 시작 -->
            <div class="row bottom-border cf">
                <!-- 검색 기간 영역 시작 -->

                <div class="range_calendar right">
                    <!-- select 영역 시작 -->
                    <div class="info_txt left left-border" id="">검색기간
                    </div>
                    <input type="text" class="date" id="from" name="st_dt" placeholder="시작날짜" autocomplete="off"
                           value="${stdt}"/>
                    <input type="text" class="date" id="to" name="end_dt" placeholder="종료날짜" autocomplete="off"
                           value="${enddt}"/>
                    <ul class="option_month cf">
                        <li type="button" class="en_font" value="1" onclick="quickDate(this.value, 'st_dt', 'end_dt')">
                            1
                        </li>
                        <li type="button" class="en_font" value="2" onclick="quickDate(this.value, 'st_dt', 'end_dt')">
                            2
                        </li>
                        <li type="button" class="en_font" value="3" onclick="quickDate(this.value, 'st_dt', 'end_dt')">
                            3
                        </li>
                        <li type="button" class="en_font" value="6" onclick="quickDate(this.value, 'st_dt', 'end_dt')">
                            6
                        </li>
                    </ul>
                </div>
                <!-- 검색 기간 영역 끝 -->
            </div>
        </form:form>
        <form:form id="current-form" class="disnone" action="" method="get">
            <input type="text" name="pro_tg_tp" value="${pro_tg_tp}"/>
            <input type="text" class="searchInp left-border " id="searchValue" name="searchValue"
                   style="${searchType != 'camp_ch' && param.pro_tg_tp != 'TG01' ? '' :'display:none'}"
                   placeholder="검색어입력" value="${searchValue}"/>
            <input type="hidden" name="searchType" value="${searchType}"/>
            <input type="hidden" name="pageNo" value="${pageNo}"/>
            <input type="text" class="date"name="st_dt" placeholder="시작날짜" autocomplete="off"
                   value="${stdt}"/>
            <input type="text" class="date" name="end_dt" placeholder="종료날짜" autocomplete="off"
                   value="${enddt}"/>
            <input type="hidden" id="page_num" name="pageNo" value="${pageNo}"/>
        </form:form>
        <div class="camp-container">
            <div class="right">
                <input type="button" value="캠페인 상세 분석" class="btn_sm_line" onclick="ReportPopup();"/></div>
            <div class="scroll_tbl">
                <table class="table target_tbl">
                    <colgroup>
                        <col width="60"/>
                        <col width="100"/>
                        <col width="100"/>
                        <col width="80"/>
                        <col width="80"/>
                        <col width="80"/>
                        <col width="80"/>
                        <col width="80"/>
                        <col width="80"/>
                    </colgroup>
                    <thead>
                    <tr>
                        <th><span>상태</span></th>
                        <th><span>캠페인명</span></th>
                        <th><span>캠페인 타겟</span></th>
                        <th><span>캠페인 채널</span></th>
                        <th><span>발송 타겟수</span></th>
                        <th><span>성공</span></th>
                        <th><span>오픈</span></th>
                        <th><span>클릭</span></th>
                        <th><span>리포트</span></th>
                    </tr>
                    </thead>
                    <tbody id="body">
                    <c:choose>
                        <c:when test="${fn:length(programLst) == 0 }">
                            <tr>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="programMap" items="${programLst}">
                                <tr>
                                    <c:set var="total" value="${programMap.total}"/>
                                    <td rowspan="${total.rowCnt}">
                                        <span>${total.pro_st_nm}</span><br><span>(${fn:split(total.start_dt,' ')[0]})</span>
                                    </td>
                                    <td rowspan="${total.rowCnt}"><span class="ellipsis">${total.pro_nm}</span></td>
                                    <td class="total"><span>total</span></td>
                                    <td class="total">
                                        <c:if test="${total.ch_total eq 'CH00'}">이메일 / 문자</c:if>
                                        <c:if test="${total.ch_total eq 'CH01'}">이메일</c:if>
                                        <c:if test="${total.ch_total eq 'CH02'}">문자</c:if>
                                    </td>
                                    <td class="total"><span>${total.t_cnt}</span></td>
                                    <td class="total"><span>${total.s_cnt}</span></td>
                                    <td class="total"><span>${total.o_cnt}</span></td>
                                    <td class="total"><span>${total.c_cnt}</span></td>
                                    <td class="total"><a href="./proDt.mi?pro_id=${total.pro_id}"
                                                         class="btn_sm_line size">
                                        <spna>상세</spna>
                                    </a></td>
                                </tr>
                                <c:forEach var="cont" items="${programMap.program}">
                                    <tr>
                                        <td><span class="ellipsis">${cont.target_nm}</span></td>
                                        <td>
                                        <span>
                                            <c:if test="${cont.camp_ch eq 'CH01'}">이메일</c:if>
                                            <c:if test="${cont.camp_ch eq 'CH02'}">문자</c:if>
                                        </span>
                                        </td>
                                        <td><span class="sendStatus"><fmt:formatNumber value="${cont.total_cnt}"
                                                                                       pattern="#,##0"/></span>
                                        </td>
                                        <td><span class="sendStatus"><fmt:formatNumber value="${cont.suc_cnt}"
                                                                                       pattern="#,##0"/></span><br>
                                            <fmt:formatNumber value="${cont.suc_cnt / cont.total_cnt}"
                                                              pattern="(###%)"/>
                                        </td>
                                        <td> <span><fmt:formatNumber value="${cont.open_cnt}"
                                                                     pattern="#,##0"></fmt:formatNumber></span><br>
                                            <fmt:formatNumber value="${cont.open_cnt / cont.total_cnt}"
                                                              pattern="(###%)"/>
                                        </td>
                                        <td>
                                            <span><fmt:formatNumber value="${cont.click_cnt}"
                                                                    pattern="#,##0"></fmt:formatNumber></span><br>
                                            <fmt:formatNumber value="${cont.click_cnt / cont.total_cnt}"
                                                              pattern="(###%)"/>
                                        </td>
                                        <td><a class="btn_sm_line size" href="./singleDt.mi?cont_seq=${cont.seq}">
                                            <spna>상세</spna>
                                        </a></td>
                                    </tr>
                                </c:forEach>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
                </ul>
            </div>
        </div>
    </div>
</section>
<!-- container 영역 끝 -->
</div>

<!-- 타겟 선택 팝업 영역 시작 -->
<div class="layer_pop" id="campReportPopup">
    <div class="pop_container popup_size2 active">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">캠페인 통합 분석</div>
        <div class="dis_flex">
            <div class="pop_inner">
                <form:form id="camp-report-form" class="camp-report dis_flex" name="searchForm"
                           onsubmit="return false;">
                    <div class="form_search">
                        <div class="dis_flex">
                            <!-- selected value -->
                            <div class="select style2 left-border " id="popUp-search">
                                <div class="value searchSelect" id="popUp-searchStandard">기준선택</div>
                                <!-- option -->
                                <ul class="option">
                                    <li data="">기준선택</li>
                                    <li data="pro_nm">캠페인명</li>
                                    <li data="target_nm">캠페인타겟</li>
                                    <li data="camp_ch">캠페인채널</li>
                                    <li data="camp_dt">캠페인기간</li>
                                </ul>
                            </div>
                            <div class="input_txt left-border-none" style="width: 325px;">
                                <span id="target_area" class="left"></span>
                                <span id="ch_area" class="left"></span>
                                <input type="text" class="full" id="searchValue" name="searchValue"
                                       placeholder="검색어 입력" onkeypress="if(event.keyCode==13) {popupSearch(); return false; }"/>
                            </div>
                        </div>
                        <!-- 검색 영역 시작 -->
                        <div>
                            <div class="option_month2">
                                <input type="button" class="btn_basic3 left border" value="Monthly"
                                       onclick="quickDate(1, 'tg_from', 'tg_to')"/>
                                <input type="button" class="btn_basic3 left border" value="Quaterly"
                                       onclick="quickDate(6, 'tg_from', 'tg_to')"/>
                                <input type="button" class="btn_basic3 left border" value="Yearly"
                                       onclick="quickDate(12, 'tg_from', 'tg_to')"/>
                            </div>
                            <input type="text" class="calendar" id="tg_from" name="tg_from" placeholder="생성일 선택"/>
                            <span class="hyphen"></span>
                            <input type="text" class="calendar" id="tg_to" name="tg_to" placeholder="생성일 선택"/>
                        </div>
                        <!-- 검색 영역 끝 -->
                        <div><input type="hidden" name="searchType" id="popup-searchType"/>
                            <input type="hidden" name="st_dt" id="popup-st-dt"/>
                            <input type="hidden" name="end_dt" id="popup-end-dt"/>
                            <input type="hidden" name="pageNo" id="popup-pageNo" value="1"/></div>
                    </div>
                    <div class="btn_size3 btn_bg3" onclick="popupSearch()"><span>검색</span></div>

                </form:form>
                <div id="list_table_box" style="width: 588px; height:210px;">
                    <table class="pop_table table_fixed" id="pop_list_table">
                        <colgroup>
                            <col width="30"/>
                            <col width="180"/>
                            <col width="30"/>
                            <col width="150"/>
                            <col width="90"/>
                            <col width="100"/>
                        </colgroup>
                        <thead>
                        <tr>
                            <th><input type="checkbox" name="pro_nm_allcheck"
                                       onclick="allCheckBtn(this); checkEvent(this);"></th>
                            <th><span>캠페인명</span></th>
                            <th><input type="checkbox" name="target_allcheck"
                                       onclick="allCheckBtn(this); checkEvent(this);"></th>
                            <th><span>캠페인 타겟</span></th>
                            <th><span>타겟수</span></th>
                            <th><span>캠페인 채널</span></th>
                        </tr>
                        </thead>
                        <tbody id="report_tbody">

                        </tbody>
                    </table>
                </div>
                <div class="btn_row bottom-border">
                    <ul class="pager" id="report_pager">
                    </ul>
                </div>

            </div>
            <div class="pop_inner">
                <div class="select_lst_box">
                    <div><h1 class="info">선택된 캠페인 리스트 ( 캠페인 <span id="info_camp">0</span>건 | 타겟 <span
                            id="info_target">0</span>건 )</h1></div>
                    <form:form id="select_form" action="./dt.mi">
                        <table class="pop_table table_fixed" id="select_lst">
                            <colgroup>
                                <col width="20"/>
                                <col width="100"/>
                                <col width="20"/>
                                <col width="100"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <th><input type="checkbox" name="pro_nm_allcheck"
                                           onclick="allCheckBtn(this); checkEvent(this);"></th>
                                <th><span>캠페인명</span></th>
                                <th><input type="checkbox" name="target_allcheck"
                                           onclick="allCheckBtn(this); checkEvent(this);"></th>
                                <th><span>캠페인 타겟</span></th>
                            </tr>
                            </thead>
                            <tbody id="select_lst_tbody">
                            </tbody>
                        </table>
                    </form:form>
                </div>
                <!-- 오류 메시지 영역 -->
                <div class="pop_error_txt blue_point_color"></div>
                <div class="right">
                    <input type="button" class="btn_bg3 btn_size2 btn_inline" onclick="delList();" value="삭제"/>
                    <input type="button" class="btn_bg3 btn_size2 btn_inline" onclick="delAllList();" value="초기화"/>
                </div>
            </div>
        </div>
        <!-- 오류 메시지 영역 -->
        <div class="pop_error_txt blue_point_color" id="targetError"></div>
        <div class="dis_flex">
            <input type="button" class="btn_bg btn_size2 btn_row" id="ok_btn" value="확인"/>
            <input type="button" class="btn_bg4 btn_size2 btn_row" onclick="popupClose(this);" value="취소"/>
        </div>
    </div>
</div>
<!-- 타겟 선택 팝업 영역 끝 -->
<script>

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

    $(".btn_basic3").on('click', function () {
        $(".btn_basic3").removeClass("clickBtn");
        $(this).addClass("clickBtn");
    })

    //검색 조건 변경
    $("#searchOption ul li").on('click', searchTarget);
    $("#popUp-search ul li").on('click', searchTarget);

    function searchTarget() {

        let thisData = $(this).attr('data');
        let div = $(this).parents('form[name="searchForm"]');
        $(div).find('#searchValue').val("")
        if (thisData === "target_nm") {
            $(div).find('#searchValue').hide();
            $(div).find('#ch_area').empty();
            $(div).find('#target_area').html(
                '<div class="select style1 left-border right-border" id="memberOption" style="width: 326px;">' +
                '<div class="value searchSelect searchTarget" data="TG01">DB 회원</div>' +
                '<ul class="option">' +
                '<li data="TG01">DB 회원</li>' +
                '<li data="TG02">업로드 회원</li>' +
                '<li data="TG99">테스트 그룹</li>' +
                '<input type="hidden" name="pro_tg_tp" value=""/>' +
                '</ul>' +
                '</div>'
            );
        } else if (thisData === "camp_ch") {
            $(div).find('#searchValue').hide();
            $(div).find('#target_area').empty();
            $(div).find('.target_select').removeClass("target_select")
            $(div).find('#ch_area').html(
                '<div class="select style1 left-border right-border" id="chOption" style="width: 326px;">' +
                '<div class="value searchSelect searchTarget" data="CH01">이메일</div>' +
                '<ul class="option">' +
                '<li data="CH01">이메일</li>' +
                '<li data="CH02">문자</li>' +
                '</ul>' +
                '</div>'
            );
        } else {
            $(div).find('#searchValue').show();
            $(div).find('#target_area').find('#memberOption').remove();
            $(div).find('#chOption').remove();
            $(div).find('.target_select').removeClass("target_select")
        }
    }

    //발송타겟 검색 상세 옵션 select 체크 값 구분
    $(document).on('click', '#memberOption ul li', function () {
        let div = $(this).parents('form[name="searchForm"]');
        let memData = $(this).attr('data');
        if (memData === 'TG01') {
            $(div).find('#searchValue').val("");
            $(div).find('#searchValue').hide();
            $(div).find('#searchValue').removeClass('target_select');
            $(div).find("#memberOption").width('332px');
            return
        }
        $(div).find('#memberOption').removeClass('right-border');
        $(div).find('#searchValue').show();

        $(div).find("#memberOption").width('100px');
        $(div).find('#searchValue').addClass('target_select');

    });

    function popupClose(close) {
        $(close).parents('.layer_pop').css("display", "none");
    }

    //캠페인통합 기간 검색
    $('#tg_from').datepicker({
        onSelect: function (selected) {
            $('#tg_to').datepicker("option", "minDate", selected);
        }
    });
    $('#tg_to').datepicker({
        onSelect: function (selected) {
            $('#tg_from').datepicker("option", "maxDate", selected);
        }
    });

    function searchCampList() {

        let searchProSt = $('#searchProSt').attr('data');
        $('#pro_tp').val(searchProSt);
        let standard = $('#searchStandard').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if (standard === "target_nm") {
            $('input[name="pro_tg_tp"]').val($('.searchTarget').attr('data'));
        }
        if (standard === "camp_ch") {
            $('#searchValue').val($('.searchTarget').attr('data'));
        }

        if ((standard == null || standard == "") && searchValue != '') {
            popup.popAlert("기준을 선택해주세요.");
            return false;
        }
        $('#searchType').val(standard);
        $('#searchForm input[name="pageNo"]').val(1);
        $('#searchForm').submit();
    }

    function linkPage(s) {
        $('#current-form input[name="pageNo"]').val(s);
        $("#current-form").submit();
    }

    function ReportPopup() {
        $('#report_tbody').empty();
        $('#report_pager').empty();
        $("#select_lst_tbody").empty();
        $('input[name="pro_nm_allcheck"]').prop('checked', false);
        $('input[name="target_allcheck"]').prop('checked', false);
        $(".btn_basic3").removeClass("clickBtn");
        $(".calendar").val("");
        $("#campReportPopup #searchValue").val("")

        changeTitle()

        $('#campReportPopup').css("display", "flex");
    }

    function popPage(pageNo) {
        let form = $('#report_pager #current-form')
        $('#camp-report-form #memberOption input[name="pro_tg_tp"]').val($(form).find('input[name="pro_tg_tp"]').val())
        $('#popup-searchType').val($(form).find('input[name="searchType"]').val())
        $('#campReportPopup input[name="searchValue"]').val($(form).find('input[name="searchValue"]').val())
        $('#popup-st-dt').val($(form).find('input[name="st_dt"]').val())
        $('#popup-end-dt').val($(form).find('input[name="end-dt"]').val())
        $('#popup-pageNo').val(pageNo)

        reportList(pageNo)
    }

    function reportList(pageNo) {

        $('#report_tbody').empty();
        $('#report_pager').empty();
        $('input[name="pro_nm_allcheck"]').prop('checked', false);
        $('input[name="target_allcheck"]').prop('checked', false);

        if (typeof pageNo == "undefined" || pageNo == "" || pageNo == null) {
            pageNo = 1;
        }
        $("#popup-pageNo").val(pageNo);

        let formData = $('#camp-report-form').serializeArray().map(function (x) {
            this[x.name] = x.value;
            return this;
        }.bind({}))[0];

        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('#report_tbody').append($("#report_tbody", $doc).html());
            $('#report_pager').append($("#report_pager", $doc).html());
            checkLst();
        };
        com_ajax.ajax('post', 'reportAjax.ajax', formData, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function popupSearch() {
        let searchType = $("#popUp-searchStandard").attr("data");
        let searchValue = $("#campReportPopup #searchValue").val().trim();

        if ((searchType == "" || typeof searchType == "undefined") && searchValue != '') {
            popup.popAlert("기준을 선택해주세요.");
            return;
        }
        let standard = $('#popUp-searchStandard').attr('data');

        if (standard === "target_nm") {
            $('#camp-report-form #memberOption input[name="pro_tg_tp"]').val($('#camp-report-form .searchTarget').attr('data'));
        } else if (standard === "camp_ch") {
            $('#camp-report-form #searchValue').val($('#camp-report-form .searchTarget').attr('data'));
        }

        let tg_from = $("#tg_from").val();
        let tg_to = $("#tg_to").val();
        $("#popup-searchType").val(searchType);
        $("#popup-st-dt").val(tg_from);
        $("#popup-end-dt").val(tg_to);
        $("#popup-pageNo").val("1");

        reportList();
    }


    function allCheckBtn(item) {
        let check = true;

        if (!$(item).is(':checked')) {
            check = false;
        }

        let name = $(item).attr("name");
        let target = name.indexOf("pro_nm") != -1 ? "pro_nm_check" : "cont_seq";
        let table = $(item).parents("table");
        let addlist = $(table).attr("id") == "pop_list_table" ? true : false;

        $(table).find(`input[name="` + target + `"]`).each(function (index, item) {
            $(item).prop('checked', check);
            if (addlist)
                addSelectList(item);
            else
                checkEvent(item);
        });
    }

    function addSelectList(item) {
        // 선택 리스트 추가
        let tr = $(item).parents("tr");
        let campSeq = $(tr).find(".target_check").val();
        duplDocument(campSeq).remove();
        if ($(item).is(':checked')) {
            addHtml(tr);
        }
        checkEvent(item);
    }

    function checkEvent(item) {

        let tr = $(item).parents("tr");
        let check = $(item).is(':checked');
        let type = $(item).attr("name");

        if (type.indexOf("pro_nm") != -1) {
            $(tr).find("input[type=checkbox]").prop('checked', check); // 캠페인타겟 전체 체크
            return;
        }

        // 캠페인명 체크
        let tbody = $(item).parents("tbody");
        let proId = $(item).parents("tr").find("input[name='pro_nm_check']").val();
        let proList = $(tbody).find(`input[value='` + proId + `']`);

        $.each(proList, function (index, pro) {
            let tr = $(pro).parents('tr');
            if (check != $(tr).find(".target_check").is(':checked')) {
                return;
            }
        })
        $(proList).prop('checked', check);
        changeTitle();
    }

    // tbody 체크박스 클릭 시 전체 선택 버튼 선택/해제
    $(document).on("click", ".layer_pop tbody input[type='checkbox']", listAll)

    function listAll(e) {
        let tbody = $(e.target).parents("tbody");
        let target = $(e.target).prop("name")
        let check = $(e.target).is(':checked');
        let list = $(tbody).find(`input[name="` + target + `"]:not(:checked)`);

        if ((list.length <= 0 && check) || (list.length > 0 && !check)) {
            let thead = $(tbody).siblings("thead");
            $(thead).find('input[type="checkbox"]').prop('checked', check);
        }
    }

    function addHtml(tr) {
        let proId = $(tr).find("input[name='pro_nm_check']").val();
        let proNm = $(tr).find("span[name='pro_nm']").html();
        let targetNm = $(tr).find("span[name='target_nm']").html();
        let campSeq = $(tr).find(".target_check").val();

        let newHtml = `<tr>
                                <td><input type="checkbox" name="pro_nm_check"  value="` + proId + `" onclick="checkEvent(this)"></td>
                                <td><span class="ellipsis">` + proNm + `</span></td>
                                <td><input type="checkbox" class="target_check" name="cont_seq" cont_id" value="` + campSeq + `" onclick="checkEvent(this);"></td>
                                <td><span class="ellipsis">` + targetNm + `</span></td>
                            </tr>`;
        $("#select_lst_tbody").append(newHtml);
    }

    function delList() {
        let ckList = $("#select_lst_tbody input[type='checkbox']:checked");
        for (let i = 0; i < ckList.length; i++) {
            $(ckList[i]).parents("tr").remove();
        }
        changeTitle();
    }

    function delAllList() {
        $("#select_lst_tbody").empty();
        $("input[type='checkbox']").prop("checked", false);
        changeTitle();
    }

    function checkLst() {
        $('#report_tbody input[name="cont_seq"]').each(function (idx, contSeq) {
            let seq = $(contSeq).val();
            if (duplDocument(seq).length > 0) {
                let checkBox = $("#report_tbody input[value=" + seq + "]");
                $(checkBox).prop("checked", true);
                addSelectList(checkBox);
            }
        })
    }

    function duplDocument(id) {
        return $("#select_lst_tbody input[value=" + id + "]").parents("tr");
    }

    function changeTitle() {
        let campCnt = $("#select_lst_tbody input[name='pro_nm_check']").length;
        $("#info_camp").html(campCnt);

        let targetCnt = $("#select_lst_tbody .target_check").length;
        $("#info_target").html(targetCnt);
    }

    $("#ok_btn").click(() => {

        if ($('#select_lst_tbody td').length == 0) {
            popup.popAlert("선택된 캠페인이 없습니다.");
            return;
        }

        let allCk = $("#select_form input[name='pro_nm_allcheck']");
        $(allCk).prop("checked", true);
        checkEvent($(allCk));
        allCheckBtn($(allCk));
        $("#select_form").submit();
    });

</script>

