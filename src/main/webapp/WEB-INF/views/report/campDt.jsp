<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="http://egovframework.gov/ctl/ui" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>

<!-- common js -->
<script src="/js/jquery-3.3.1.min.js"></script>
<script src="/js/jquery-ui.min.js"></script>
<!-- progressbar.js -->
<script src="/js/progressbar.min.js"></script>
<!-- char.js -->
<script src="/js/Chart.min.js"></script>
<!-- fontawesome icon -->
<link href="https://use.fontawesome.com/releases/v5.0.6/css/all.css" rel="stylesheet">


<script src="/js/edmCreate.js"></script>

<!-- container 영역 시작 -->
<section class="container" id="campDt">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border min-width cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>리포트</li>
                    <li>캠페인 통합</li>
                    <li>캠페인 상세</li>
                </ul>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->

        <!-- section 영역 끝 -->


        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">캠페인 상세 요약</div>
                <div class="btn_col right">
                    <input type="button" value="캠페인 리스트 수정" class="btn_sm_line" onclick="addressAddPopup();">
                </div>
            </div>
            <c:set var="total" value="${totalResult}"/>
            <div class=" border-bottom cf">
                <div class="contentBox camp_summa">
                    <ol class="left cf row border perp">
                        <li class="th right-border"><span>캠페인 수집기간</span>
                        </li>
                        <li class="td right-border">
                            <span>( ${fn:split(total.start_dt,' ')[0]} ~ ${fn:split(total.end_dt,' ')[0]} )</span>
                        </li>
                        <li class="th right-border">
                            <span>캠페인 수</span>
                        </li>
                        <li class="td right-border">
                            <span>${total.seq}</span>
                        </li>
                        <li class="th right-border">
                            <span>발송채널</span>
                        </li>
                        <li class="td">
                            <span>${fn:replace(total.camp_ch,',','/')}</span>
                        </li>
                    </ol>
                </div>
            </div>


            <div class="count border-bottom cf">
                <div class="total left">캠페인 전환별 결과</div>
            </div>

            <!-- 캠페인 리포트 캠페인 전체 성과 요약 테이블 -->
            <div class="border-bottom cf contentBox">
                <div class="status_area cf">
                    <ol class="left cf" id="olDom">
                        <li class="step_box">
                            <div class="top">
                                <span class="status_mark"></span>발송
                            </div>
                            <div class="en_font number">${total.total_cnt}</div>
                        </li>
                        <li class="step_box" onclick="reportTabControl(this,'sucTab')">
                            <div class="top">
                                <span class="status_mark orange"></span>도달
                            </div>
                            <div class="tab-body">
                                <div class="en_font number"><fmt:formatNumber value="${total.suc_cnt / total.total_cnt}"
                                                                              pattern="###.##%"/></div>
                                <span><fmt:formatNumber value="${total.suc_cnt}"
                                                        pattern="#,##0"/></span>
                            </div>
                        </li>
                        <li class="step_box" onclick="reportTabControl(this,'openTab')">
                            <div class="top">
                                <span class="status_mark blue"></span>오픈
                            </div>
                            <div class="tab-body">
                                <div class="en_font number"><fmt:formatNumber
                                        value="${total.open_cnt / total.total_cnt}"
                                        pattern="###.##%"/></div>
                                <span><fmt:formatNumber value="${total.open_cnt}"
                                                        pattern="#,##0"/></span>
                            </div>
                        </li>
                        <li class="step_box" onclick="reportTabControl(this,'clickTab')">
                            <div class="top">
                                <span class="status_mark green"></span>클릭
                            </div>
                            <div class="tab-body">
                                <div class="en_font number"><fmt:formatNumber
                                        value="${total.click_cnt / total.total_cnt}"
                                        pattern="###.##%"/></div>
                                <span><fmt:formatNumber value="${total.click_cnt}"
                                                        pattern="#,##0"/></span>
                            </div>
                        </li>
                       <%-- <li class="step_box" onclick="reportTabControl(this,'saleTab')">
                            <div class="top">
                                <span class="status_mark purple"></span>구매
                            </div>
                            <div class="tab-body">
                                <div class="en_font number"><fmt:formatNumber
                                        value="${total.sale_cnt / total.total_cnt}"
                                        pattern="###.##%"/></div>
                                <span><fmt:formatNumber value="${total.sale_cnt}"
                                                        pattern="#,##0"/></span>
                            </div>
                        </li>
                        <li class="step_box" onclick="reportTabControl(this,'roiTab')">
                            <div class="top">
                                <span class="status_mark indigo"></span>ROI%
                            </div>
                            <div class="en_font number">${total.roi}%</div>
                        </li>--%>
                    </ol>
                </div>
            </div>
            <div class="border-bottom cf ">
                <div class="contentBox">

                    <div class="row border list_open_btn perp" id="openLstTap">
                        <span>캠페인 리스트</span>
                        <span class="right" id="openLst">리스트 닫기
                    <span>▲</span></span>
                    </div>

                </div>
            </div>
            <div class="border-bottom cf" id="campLstBox">
                <div class="border-bottom cf contentBox">
                    <table class="table target_tbl border">
                        <colgroup>
                            <col width="200"/>
                            <col width="220"/>
                            <col width="220"/>
                            <col width="220"/>
                            <col width="120"/>
                            <col width="120"/>
                            <col width="120"/>
                            <col width="120"/>
                        </colgroup>
                        <thead>
                        <tr>
                            <th><span>상태</span></th>
                            <th><span>프로그램명</span></th>
                            <th><span>캠페인명</span></th>
                            <th><span>캠페인 채널</span></th>
                            <th><span>발송 타겟수</span></th>
                            <th><span>성공</span></th>
                            <th name="open"><span>오픈</span></th>
                            <th name="click"><span>클릭</span></th>
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
                                                ${total.ch_total}
                                        </td>
                                        <td class="total"><span>${total.t_cnt}</span></td>
                                        <td class="total"><span>${total.s_cnt}</span></td>
                                        <td class="total" name="open"><span>${total.o_cnt}</span></td>
                                        <td class="total" name="click"><span>${total.c_cnt}</span></td>
                                    </tr>
                                    <c:forEach var="cont" items="${programMap.program}">
                                        <tr class="cus_pointer" name="list_tr" onclick="showContDet(this , ${cont.cont_id})">
                                            <td><span class="ellipsis" name="camp_nm">${cont.camp_nm}</span></td>
                                            <td>
                                        <span>
                                            <c:if test="${cont.camp_ch eq 'CH01'}">이메일</c:if>
                                            <c:if test="${cont.camp_ch eq 'CH02'}">문자</c:if>
                                            <c:if test="${cont.camp_ch eq 'CH03'}">세일즈포스</c:if>
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
                                            <td name="open"> <span><fmt:formatNumber value="${cont.open_cnt}"
                                                                         pattern="#,##0"></fmt:formatNumber></span><br>
                                                <fmt:formatNumber value="${cont.open_cnt / cont.total_cnt}"
                                                                  pattern="(###%)"/>
                                            </td>
                                            <td name="click">
                                            <span><fmt:formatNumber value="${cont.click_cnt}"
                                                                    pattern="#,##0"></fmt:formatNumber></span><br>
                                                <fmt:formatNumber value="${cont.click_cnt / cont.total_cnt}"
                                                                  pattern="(###%)"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>

                </div>

            </div>
            <%--            <div class="count border-bottom cf disnone" id="resultBox">--%>

            <div class="border-bottom cf " id="resultBox">
                <div class="report-contents-list-cover contentBox">
                    <!-- 도달 리포트 ------------------------------------------------------------------------- ajax -->
                    <div id="sucTab" class="report-tab-contents disnone">
                        <c:set var="total" value="${totalResult}"/>
                        <div class="half-grid">
                            <table class="report-tab-table blue" style="display: inline-block">
                                <tr>
                                    <th>발송성공</th>
                                    <td>
											<span class="pointMid">
												<c:choose>
                                                    <c:when test="${total.total_cnt eq '' }">0%</c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber
                                                                value="${total.suc_cnt / total.total_cnt}"
                                                                pattern="###.##%"></fmt:formatNumber>
                                                    </c:otherwise>
                                                </c:choose>
											</span>
                                        <span class="text">(<fmt:formatNumber value="${total.suc_cnt }"
                                                                              pattern="#,##0"></fmt:formatNumber>)</span>
                                    </td>
                                </tr>
                            </table>
                            <div class="wait_txt"><span>발송 대기 : </span><span id="wait_cnt">0</span>명</div>
                            <div class="grid-space"></div>
                            <table class="report-tab-table max yellow">
                                <tr>
                                    <th class="wid-40-p">사용자 계정문제</th>
                                    <td>
                                        <span id="softTotalPortion" class="pointMid yellow"></span>
                                        <span id="softTotalSpan" class="text"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="ll" class="no-padding" colspan="2">
                                        <div class="chart-cover">
                                            <canvas id="usrErrGraph"></canvas>
                                        </div>
                                        <div class="legend-cover">
                                            <ul id="softList" class="legend-list"></ul>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="half-grid">
                            <table class="report-tab-table yellow">
                                <tr>
                                    <th>발송실패</th>
                                    <td>
											<span class="pointMid yellow" id="totalFailPct">
											</span>
                                        (<span class="text" id="totalFailCnt"></span>)
                                    </td>
                                </tr>
                            </table>
                            <div class="grid-space">
                                <div class="grid-line a"></div>
                                <div class="grid-line b"></div>
                                <div class="grid-line c"></div>
                            </div>
                            <table class="report-tab-table wid-100-p yellow">
                                <tr>
                                    <th class="wid-40-p">시스템 문제</th>
                                    <td>
                                        <span id="hardTotalPortion" class="pointMid yellow"></span>
                                        <span id="hardTotalSpan" class="text"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="rr" class="no-padding" colspan="2">
                                        <div class="chart-cover">
                                            <canvas id="sysErrGraph"></canvas>
                                        </div>
                                        <div class="legend-cover">
                                            <ul id="hardList" class="legend-list"></ul>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!-- 오픈 리포트 --------------->
                    <div id="openTab" class="report-tab-contents disnone">
                        <div>
                            <h3 class="title">오픈 시점 분석</h3>
                            <div id="openTimeResult" class="open-time-anal-cover"></div>
                        </div>
                    </div>

                    <!-- 클릭 리포트  -->
                    <div id="clickTab" class="report-tab-contents disnone">
                        <div>
                            <h3 class="title">컨텐츠 분석</h3>
                            <div class="click-chart-cover row-flex" id="content-analysis"></div>
                        </div>
                    </div>
                    <!-- 구매 리포트  -->
                    <div id="saleTab" class="report-tab-contents disnone">
                    </div>
                    <!-- ROI 리포트  -->
                    <div id="roiTab" class="report-tab-contents disnone">
                    </div>
                </div>
            </div>
        </div>
        <!-- footer 영역 시작 -->
        <footer class="footer">
            &copy; Milvus Corp.
        </footer>
        <!-- footer 영역 끝 -->
    </div>
    <!-- 컨텐츠 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>
<!-- 타겟 선택 팝업 영역 시작 -->
<div class="layer_pop" id="campReportPopup">
    <div class="pop_container popup_size6 active">
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
                                    <li data="pro_st">상태</li>
                                    <li data="pro_nm">프로그램명</li>
                                    <li data="camp_nm">캠페인명</li>
                                    <li data="camp_ch">캠페인채널</li>
                                    <li data="camp_dt">캠페인기간</li>
                                </ul>
                            </div>
                            <div class="input_txt left-border-none" style="width: 325px;">
                                <span id="target_area" class="left"></span>
                                <span id="ch_area" class="left"></span>
                                <span name="st_area" class="left"></span>
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
                <div id="list_table_box" style="width: 588px; min-height:210px;">
                    <table class="pop_table table_fixed" id="pop_list_table">
                        <colgroup>
                            <col width="40"/>
                            <col width="130"/>
                            <col width="40"/>
                            <col width="130"/>
                            <col width="100"/>
                            <col width="130"/>
                        </colgroup>
                        <thead>
                        <tr>
                            <th><input type="checkbox" name="pro_nm_allcheck"
                                       onclick="allCheckBtn(this); checkEvent(this);"></th>
                            <th><span>프로그램명</span></th>
                            <th><input type="checkbox" name="pro_nm_allcheck"
                                       onclick="allCheckBtn(this); checkEvent(this);"></th>
                            <th><span>캠페인명</span></th>
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
                    <div><h1 class="info">선택된 캠페인 리스트 ( 프로그램 <span id="info_prg">0</span>건 | 캠페인 <span
                            id="info_camp">0</span>건 )</h1></div>
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
                                <th><span>프로그램명</span></th>
                                <th><input type="checkbox" name="camp_nm_allcheck"
                                           onclick="allCheckBtn(this); checkEvent(this);"></th>
                                <th><span>캠페인명</span></th>
                            </tr>
                            </thead>
                            <tbody id="select_lst_tbody"></tbody>

                        </table>
                    </form:form>
                    <table class="disnone">
                        <tbody id="curent_tbody">
                        <c:choose>
                            <c:when test="${fn:length(programLst) == 0 }">
                                <tr>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="programMap" items="${programLst}">
                                    <c:set var="total" value="${programMap.total}"/>
                                    <tr>
                                    <td rowspan="${total.rowCnt}">
                                        <input type="checkbox" name="pro_nm_check" value="${total.pro_id}" data="${total.pro_id}"
                                               onclick="checkEvent(this)">
                                    </td>
                                    <td rowspan="${total.rowCnt}"><span class="ellipsis" name="pro_nm">${total.pro_nm}</span></td>
                                    <c:forEach var="cont" items="${programMap.program}">
                                        <tr>
                                            <td><input type="checkbox" class="camp_nm_check" name="cont_seq" data_pro_id="${cont.pro_id}"
                                                       value="${cont.seq}" onclick="checkEvent(this);"></td>
                                            <td><span class="ellipsis" >${cont.camp_nm}</span></td>
                                        </tr>
                                    </c:forEach>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
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

<script src="/js/Chart.min.js"></script>
<script src="/js/drawChart.js"></script>
<script>
    let currentCampSet = new Set();
    let selectedCampSet = new Set();
    let cont_seq = [];
    <c:forEach items="${cont_seq}" var="item">
    cont_seq.push(${item});
    selectedCampSet.add('${item}')
    currentCampSet.add('${item}')
    </c:forEach>

    $("#openLstTap").click(function () {
        if ($('#campLstBox').hasClass("disnone")) {
            $('#openLst').html(`리스트 닫기<span>▼</span>`);
            $("#campLstBox").removeClass("disnone");
            return;
        }
        $("#campLstBox").addClass("disnone");
        $('#openLst').html(`리스트 열기<span>▲</span>`);
    })

    function reportTabControl(me, id) {

        switch (id) {
            case 'sendTab':
                break;
            case 'sucTab':
                var rep = function (response) {
                    drawGraph(response);
                }
                var param = {
                    cont_seq: cont_seq
                }
                com_ajax.ajax('post', 'getSucTabAjax.ajax', param, rep);
                $(".orange_bg").removeClass("orange_bg");
                $(".blue_bg").removeClass("blue_bg");
                break;
            case 'openTab':
                var rep = function (response) {
                    if (response.length == 3) {
                        if (response[1].length != 0) {
                            let graphData = response[0];
                            let timingData = response[1];
                            let campNmData = response[2];
                            let tot = 0;
                            if (graphData.length > 0) {
                                tot = graphData[0].total;
                            }
                            // drawOpenGraph(graphData);
                            if (Object.keys(timingData).length <= 0) {
                                $('#openTimeResult').html('<span> 오픈 데이터 없음</span>');
                                return;
                            }

                            getOpenTimeResult(timingData, tot, campNmData);
                        }
                    } else {
                        //customDialog.alert('에러가 발생 하였습니다.<br/>통신 상태를 확인후 잠시후 다시 시도해주세요.');
                    }
                }
                var param = {
                    cont_seq: cont_seq
                }
                com_ajax.ajax('post', 'getOpenTabAjax.ajax', param, rep);
                $(".orange_bg").removeClass("orange_bg");
                $(".blue_bg").removeClass("blue_bg");
                $("[name=open]").addClass("orange_bg");
                $(".open-time-box").removeClass("disnone");
                $("#tooltip-click").addClass("disnone");
                break;
            case 'clickTab':
                $(".orange_bg").removeClass("orange_bg");
                $("[name=click]").addClass("orange_bg");
                $("tbody [name='click']")[1].click();
                $('.open-time-box').addClass("disnone");
                break;
        }
        $(me).siblings().removeClass('active');
        $(me).addClass('active');
        $('.report-tab-contents').addClass('disnone');
        $('#' + id).removeClass('disnone');
    }


    // 오픈 타임 시점 그려주기
    function getOpenTimeResult(data, total, campNmData) {

        let target = $('#openTimeResult'); // 전체 프로젝트 총 발송 대상자 수
        let tooltip = $('#tooltip-open-time');
        let integ = [];
        let inner = {};

        // data  값 꺼내오기
        let prev
        let i = 0;
        for (k in data) {
            if (i == 0 || data[k].WEEK_DAY != prev.WEEK_DAY) {
                if (i > 0) {
                    integ.push(inner);
                }
                inner = {};
                let key = data[k].WEEK_DAY;
                switch (key) {
                    case '0':
                        inner.WEEK_DAY = '월';
                        break;
                    case '1':
                        inner.WEEK_DAY = '화';
                        break;
                    case '2':
                        inner.WEEK_DAY = '수';
                        break;
                    case '3':
                        inner.WEEK_DAY = '목';
                        break;
                    case '4':
                        inner.WEEK_DAY = '금';
                        break;
                    case '5':
                        inner.WEEK_DAY = '토';
                        break;
                    case '6':
                        inner.WEEK_DAY = '일';
                        break;
                }
                let num = data[k].OPEN_CNT / total;
                num = num > 1 ? 1 : num;
                num = num.toFixed(4);
                inner[data[k].TIME_BAND] = num;

            } else if (i == data.length - 1) {
                let num = data[k].OPEN_CNT / total;
                num = num > 1 ? 1 : num;
                num = num.toFixed(4);
                inner[data[k].TIME_BAND] = num;
                integ.push(inner);
            } else {
                let num = data[k].OPEN_CNT / total;
                num = num > 1 ? 1 : num;
                num = num.toFixed(4);
                inner[data[k].TIME_BAND] = num;
            }
            prev = data[k];
            i++;
        }
        let html = '<ul class="row">'
            + '<li class="th"></li>'
            + '<li class="th">0</li>'
            + '<li class="th">1</li>'
            + '<li class="th">2</li>'
            + '<li class="th">3</li>'
            + '<li class="th">4</li>'
            + '<li class="th">5</li>'
            + '<li class="th">6</li>'
            + '<li class="th">7</li>'
            + '<li class="th">8</li>'
            + '<li class="th">9</li>'
            + '<li class="th">10</li>'
            + '<li class="th">11</li>'
            + '<li class="th">12</li>'
            + '<li class="th">13</li>'
            + '<li class="th">14</li>'
            + '<li class="th">15</li>'
            + '<li class="th">16</li>'
            + '<li class="th">17</li>'
            + '<li class="th">18</li>'
            + '<li class="th">19</li>'
            + '<li class="th">20</li>'
            + '<li class="th">21</li>'
            + '<li class="th">22</li>'
            + '<li class="th">23</li>'
            + '</ul>';
        let ulZindex = integ.length;
        for (let i = 0; i < integ.length; i++) {
            ulZindex = ulZindex - 1;
            html += '<ul class="row Nanum" ><li class="th">' + integ[i].WEEK_DAY + '</li>';
            let z = 23;
            for (let j = 0; j <= 23; j++) {
                let code = j < 10 ? '0' + j : j;

                for (key in integ[i]) {

                    if (key != 'WEEK_DAY' && key == code) {
                        let num = integ[i][key] * 100;
                        num = num.toFixed(2);
                        num = num + '%';
                        let op = parseFloat(integ[i][key]) + 0.1 > 1 ? 1 : parseFloat(integ[i][key]) * 8 + 0.1;
                        op = op.toFixed(2);
                        html += `<li class="td" id="` + key + `" style="z-index: ` + z + `;background-color: rgba(100, 117, 222, ` + op + `);"></li>`
                        z = z - 1;
                    }
                }
            }
            html += '</ul>';
        }
        target.html(html);
        tooltip.html(html);

        // 오픈 캠페인명 / 오픈횟수
        for (key in campNmData) {
            let nmLst = campNmData[key];
            let day = key.substr(0, 1).charCodeAt(0) - 65;
            let html = `<div class="open-title" name="open-title" style="position: absolute">`
            nmLst.forEach(item =>
                html = html + `<span> - ` + item.camp_nm + ` ( ` + item.open_cnt + `회 )</span><br/>`
            );
            html += `</div>`;

            let ul = $(".Nanum")[day];
            $(ul).find(`#` + key.substr(1, 2)).html(html);
        }
    }

    // 오픈 타임 캠페인명
    $(document).on("mouseenter", "#openTimeResult .Nanum .td", (e) => {
        $(e.target).css("z-index", "999");
        $(e.target).find("div[name=open-title]").show();
    })
    $(document).on("mouseleave", "#openTimeResult .Nanum .td", (e) => {
        $(e.target).css("z-index", "1");
        $(e.target).find("div[name=open-title]").hide();
    })


    // 오픈 캠페인 제목
    $(document).on("mouseover", "tr[name='list_tr']", (e) => {
        if (!$("td[name='open']").hasClass("orange_bg"))
            return;
        let tr = $(e.target).parents("tr[name='list_tr']");
        $(tr).find("td:first .cont_title_box").removeClass('disnone');
    })
    $(document).on("mouseleave", "tr[name='list_tr']", (e) => {
        if (!$("td[name='open']").hasClass("orange_bg"))
            return;
        let tr = $(e.target).parents("tr[name='list_tr']");
        $(tr).find("td:first .cont_title_box").addClass('disnone');
    })


    //클릭 탭  컨텐츠 분석 가져오기
    function showContDet(e, cont_id) {
        if (!$(e).find('[name=click]').hasClass("orange_bg")) {
            return;
        }
        $(".blue_bg").removeClass("blue_bg");
        $(e).addClass("blue_bg");

        var rep = function (response) {
            const $doc = new DOMParser().parseFromString(response, "text/html");
            $("#content-analysis").html($("#content-analysis", $doc).html());

            // help btn
            $("#tooltip-click").html($("#click-data-table", $doc).html());
            $("#tooltip-click").removeClass("disnone");

            if ($('#smsTab').hasClass("disnone")) {
                preview();
                return;
            }
            checkSmsTap();

            // RCS일 경우 제목 넣어주기
            if($('#rcs_prev').length >0){
                let title =$('#titleArea0').html();
                $('#tab-title').html(title)
            }

            var mySwiper = new Swiper('.slideSwiper', {
                direction: 'horizontal',
                pagination: {
                    el: '.rcs_paging',
                    type: 'fraction',
                },
                // Navigation arrows
                navigation: {
                    nextEl: '.rcs_next',
                    prevEl: '.rcs_prev',
                },
            });
        }
        var param = {
            cont_id: cont_id
            , camp_nm: $(e).find("span[name='camp_nm']").html()
        };
        com_ajax.ajax('post', 'getClickTabAjax.ajax', param, rep);

    }


    function changeTitle() {
        let title =$('.swiper-slide-active h3[name="titleArea"]').html();
        $('#tab-title').html(title)
    }
    $(document).on("click", "#rcs_prev", changeTitle)
    $(document).on("click", "#rcs_next", changeTitle)

</script>
<script>
    CKEDITOR.plugins.add('abbr', {
        icons: 'abbr',
        init: function (editor) {
            $Editor = editor
            lang = editor.lang.format
        }
    });
    CKEDITOR.plugins.add('abbr2', {
        icons: 'abbr2'
    });

    function preview() {
        //ckeditor option
        CKEDITOR.replace('cont_body', {
            language: 'ko',
            toolbar: [],
            format_tags: 'p;h1;h2;h3;pre',
            allowedContent: true,
            removePlugins: 'newpage, exportpdf, elementspath',
            docType: "<!DOCTYPE html>",
            autoParagraph: false,
            on: {
                instanceReady: function () {
                    let data = CKEDITOR.instances.cont_body.getData();
                    let viewer = $('#preview').contents().find('body');
                    data = scriptCheck(data);
                    viewer.html(edmCreate.baseLayout);
                    viewer.find('.edm_source').html(data);
                    viewer.find('.edm_layout').width($(viewer).find('table').prop('width'));
                    edmCreate.linkArea();
                    $('#preview').contents().find('.edm_link').show();
                }
            }
        });

    };
    let RegExClass = /(\s)(class)(\s)?=(\s)?(\"|\')[^<]+(\"|\')/gi;
    let RegExStyle = /<(style)([^<]+)(<\/style>|\s+\/>)/gi;
    let RegExScript = /<(script)([^<]+)(<\/script>|\s+\/>)/gi;
    let RegExOnAttr = /(\s)(on)[a-z]+(\s)?=(\s)?(\"|\')[^\/>]+(\"|\')/gi;

    function scriptCheck(str) {
        str = str.replace(RegExScript, '');
        str = str.replace(RegExOnAttr, '');
        str = str.replace(RegExStyle, '');
        str = str.replace(RegExClass, '');
        return str;
    }

    // 컨텐츠 분석 문자 tap
    function checkSmsTap() {
        let taps = $('#smsTab li');
        $(taps).each((idx, tap) => {
            let type = tap.id;
            if (!$('#prev_' + type).length) {
                $(tap).addClass("disnone");
                return;
            }
        })
    }

    $(document).on("click", "#smsTab li span", (e) => {
        let li = $(e.target).parents("li");
        let type = $(li).prop("id");
        if (!$('#prev_' + type).length) {
            return;
        }

        $(li).siblings().removeClass("on");
        $(li).addClass("on");

        //preview
        $('.prev_box').addClass("disnone");
        $('#prev_' + type).removeClass("disnone");

        //링크 테이블
        $('#click-data-table tbody').addClass("disnone");
        $('#click-data-table #tbody_' + type).removeClass("disnone");
    })
</script>
<script>
    /* 그래프 처리 모듬 ---------------------------------------------------------------- */
    function drawGraph(data) {// 도달 리포트 그래프
        let targetDiv1 = 'usrErrGraph';
        let targetDiv2 = 'sysErrGraph';
        let chartType = '02' // horizontalBarChart
        let inputData1 = [];
        let inputData2 = [];
        let dataSet1 = {};
        let dataSet2 = {};
        let column1 = [];
        let column2 = [];
        let data1 = [];
        let bgColor1 = [];
        let bgColor2 = [];
        let data2 = [];
        let html1 = '';
        let html2 = '';
        let softTotal = 0;
        let hardTotal = 0;
        let waitTotal = 0;
        for (let i = 0; i < data.length; i++) {
            let cd_val = data[i].cd_val === undefined || data[i].cd_val === ""|| data[i].cd_val === null  ? "알 수 없음" : data[i].cd_val;
            let cd_desc = data[i].cd_desc === undefined || data[i].cd_desc === "" || data[i].cd_desc === null ? "알 수 없음" : data[i].cd_desc;
            if (data[i].bounce_cate == 'U') {
                data1.push(data[i].send_cnt);
                softTotal += Number(data[i].send_cnt);
                let color = colorPicker(1, [70, 70, 90], 50, 150);

                bgColor1.push(color);
                column1.push(cd_val);
                html1 += '<li>'
                    + '<label class="icon"><div class="pointer" style="background-color: ' + color + ';"></div><div class="cd_val">' + cd_val + '</div></label>'
                    + '<div class="info">'
                    + '<span class="txt"  name="info-btn">?</span>'
                    + '<div class="info-box">'
                    + '<h6>' + cd_val + '</h6>'
                    + '<p>' + cd_desc + '</p>'
                    + '</div>'
                    + '</div>'
                    + '</li>';
            } else if (data[i].bounce_cate == 'S' || data[i].bounce_cate == null) {  //hard bounce  이거나 일치하는 코드값 없음
                data2.push(data[i].send_cnt);
                hardTotal += Number(data[i].send_cnt);
                let color = colorPicker(1, [70, 70, 90], 30, 150);
                bgColor2.push(color);
                column2.push(cd_val);
                html2 += '<li>'
                    + '<label class="icon"><div class="pointer" style="background-color: ' + color + ';"></div><div class="cd_val">' + cd_val + '</div></label>'
                    + '<div class="info">'
                    + '<span class="txt" name="info-btn">?</span>'
                    + '<div class="info-box">'
                    + '<h6>' + cd_val + '</h6>'
                    + '<p>' + cd_desc + '</p>'
                    + '</div>'
                    + '</div>'
                    + '</li>';
            }
        }
        dataSet1.data = data1;
        dataSet1.backgroundColor = bgColor1;
        dataSet1.label = "DataSet 1";
        inputData1.push(dataSet1);
        dataSet2.data = data2;
        dataSet2.backgroundColor = bgColor2;
        dataSet2.label = "DataSet 1";
        inputData2.push(dataSet2);
        let options = {
            legend: {display: false},
        }
        drawChart(targetDiv1, chartType, inputData1, column1, options);
        drawChart(targetDiv2, chartType, inputData2, column2, options);
        $('#softList').html(html1);
        $('#hardList').html(html2);
        let total = softTotal + hardTotal;
        let sfp = softTotal / total * 100;
        sfp = sfp.toFixed(1);
        let hfp = hardTotal / total * 100;
        hfp = hfp.toFixed(1);
        if (sfp != 'NaN') {
            $('#softTotalPortion').html(sfp + "%");
        } else {
            $('#softTotalPortion').html("0%");
        }
        if (hfp != 'NaN') {
            $('#hardTotalPortion').html(hfp + "%");
        } else {
            $('#hardTotalPortion').html("0%");
        }

        let totalCnt = ${empty totalResult.total_cnt ? 0 : totalResult.total_cnt};
        let sucCnt = ${empty totalResult.suc_cnt ? 0 : totalResult.suc_cnt};

        waitTotal = totalCnt - sucCnt - (softTotal + hardTotal);
        softTotal = "(" + common.comma(softTotal) + ")";
        $('#softTotalSpan').html(softTotal);
        hardTotal = "(" + common.comma(hardTotal) + ")";
        $('#hardTotalSpan').html(hardTotal);


        let totalFailPer = (1 - (sucCnt + waitTotal) / totalCnt) * 100;
        $('#totalFailPct').html(totalFailPer.toFixed(2)+'%');

        let totalFailCnt = common.comma(totalCnt - sucCnt - waitTotal);
        $('#totalFailCnt').html(totalFailCnt);

        $('#wait_cnt').html(common.comma(waitTotal));
    }

    $(document).on("mouseenter", "span[name='info-btn']", (e) => {
        $(e.target).siblings('.info-box').show();
    });

    $(document).on("mouseleave", "span[name='info-btn']", (e) => {
        $(e.target).siblings('.info-box').hide();
    });

    //click  컨텐츠 분석 테이블 도움말
    $(document).on("mouseenter", "span[name=click-help]", (e) => {
        $(e.target).siblings('label').removeClass("disnone");
    })
    $(document).on("mouseleave", "span[name=click-help]", (e) => {
        $(e.target).siblings('label').addClass("disnone");
    })

    function addressAddPopup() {
        // 기존 선택된 캠페인
        selectedCampSet.clear()
        for(let contSeq of currentCampSet){
            selectedCampSet.add(contSeq);
        }

        $('#popUp-searchStandard').html("기준선택");
        $('#popUp-searchStandard').prop("data", " ");
        $('#searchValue').val("");
        $('#report_tbody').empty();
        $('#report_pager').empty();
        $("#select_lst_tbody").html($('#curent_tbody').html());
        changeTitle();

        $('input[name="pro_nm_allcheck"]').prop('checked', false);
        $('input[name="target_allcheck"]').prop('checked', false);
        $(".btn_basic3").removeClass("clickBtn");
        $(".calendar").val("");
        $('#campReportPopup').css("display", "flex");
    }

    //-------------------------------------   campResult 페이지와 동일


    $(".btn_basic3").on('click', function () {
        $(".btn_basic3").removeClass("clickBtn");
        $(this).addClass("clickBtn");
    })

    $("#popUp-search ul li").on('click', searchTarget);

    function searchTarget() {

        let thisData = $(this).attr('data');
        let div = $(this).parents('form[name="searchForm"]');
        $(div).find('#searchValue').val("")
        if (thisData === "camp_ch") {
            $(div).find('#searchValue').hide();
            $(div).find('span[name="st_area"]').html('');
            $(div).find('#target_area').empty();
            $(div).find('.target_select').removeClass("target_select")
            $(div).find('#ch_area').html(
                '<div class="select style1 left-border right-border" id="chOption" style="width: 326px;">' +
                '<div class="value searchSelect searchTarget" data="CH01">이메일</div>' +
                '<ul class="option">' +
                '<li data="CH01">이메일</li>' +
                '<li data="CH02">문자</li>' +
                '<li data="CH03">세일즈포스</li>' +
                '</ul>' +
                '</div>'
            );
        } else if (thisData === "pro_st") {
            $(div).find('#searchValue').hide();
            $(div).find('.target_select').removeClass("target_select")
            $(div).find('#chOption').remove();
            $(div).find('span[name="st_area"]').html(
                '<div class="select style1 left-border right-border" id="stOption" style="width: 326px;">' +
                '<div class="value searchSelect searchTarget" data="03">발송중</div>' +
                '<ul class="option">' +
                '<li data="03">발송중</li>' +
                '<li data="04">완료</li>' +
                '</ul>' +
                '</div>'
            );
        }  else {
            $(div).find('#searchValue').show();
            $(div).find('#chOption').remove();
            $(div).find('.target_select').removeClass("target_select")
            $(div).find('span[name="st_area"]').html('');
        }
    }


    function popupClose(close) {
        $(close).parents('.layer_pop').css("display", "none");
    }

    function popPage(pageNo) {
        let form = $('#report_pager #current-form')
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
        }.bind({}))[0]

        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('#report_tbody').append($("#report_tbody", $doc).html());
            $('#report_pager').append($("#report_pager", $doc).html());
            checkLst();
            genRowspan();
        };
        com_ajax.ajax('post', 'reportAjax.ajax', formData, res, '${_csrf.headerName}', '${_csrf.token}');
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

    function popupSearch() {
        let searchType = $("#popUp-searchStandard").attr("data")
        let searchValue = $("#searchValue").val().trim();

        if ((searchType === "" || typeof searchType == "undefined") && searchValue != '') {
            popup.popAlert("기준을 선택해주세요.");
            return
        }
        let standard = $('#popUp-searchStandard').attr('data');
        if (standard === "camp_ch" || standard === "pro_st") {
            $('#camp-report-form #searchValue').val($('.searchTarget').attr('data'));
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

        let table = $(item).parents("table");
        let addlist = $(table).attr("id") == "pop_list_table" ? true : false;

        $(table).find(`tbody input[type="checkbox"]`).each(function (index, item) {
            $(item).prop('checked', check);
            if (addlist) {
                addSelectList(item);
            } else
                checkEvent(item);
        });
    }

    function addSelectList(item) {
        let tr = $(item).parents("tr");
        let campSeq = $(tr).find(".camp_nm_check").val();

        if ($(item).is(':checked')) {
            let tableId = $(item).parents("table").attr("id");
            if (!selectedCampSet.has(campSeq) && tableId != "#select_lst") {  //이미 등록된 캠페인은 등록하지 않음
                // 선택 리스트 추가
                selectedCampSet.add(campSeq);
                addHtml(tr);
            }
        }
        checkEvent(item);
    }

    function checkEvent(item) {

        let table = $(item).parents("table");
        let tr = $(item).parents("tr");
        let check = $(item).is(':checked');
        let type = $(item).attr("name");

        if (type =="pro_nm_allcheck"|| type =="camp_nm_allcheck") {
            $(tr).find("input[type=checkbox]").prop('checked', check); // 캠페인타겟 전체 체크
            return;
        }else if (type =='pro_nm_check') {   // 프로그램 선택
            let proId =  $(item).attr("data")
            $(table).find(`input[data_pro_id="`+proId+`"]`).prop('checked', check);
            return;
        }else{    // 캠페인명 체크
            let tbody = $(item).parents("tbody");
            let proId = $(item).attr("data_pro_id");
            let campList = $(tbody).find(`input[data_pro_id='` + proId + `']`);
            let isCampAllCk=true;

            $.each(campList, function (index, camp) {
                if (check != $(camp).is(':checked')) {
                    isCampAllCk =false;
                    return;
                }
            })
            if(isCampAllCk){
                $(tbody).find(`input[data='` + proId + `']`).prop('checked', check);
            }
            changeTitle();
        }
    }

    // tbody 체크박스 클릭 시 전체 선택 버튼 선택/해제
    $(document).on("click", ".layer_pop tbody input[type='checkbox']", listAll)

    function listAll(e) {
        let tbody = $(e.target).parents("tbody");
        let check = $(e.target).is(':checked');
        let list = $(tbody).find(`input[type="checkbox"]:not(:checked)`);

        if ((list.length <= 0 && check) || (list.length > 0 && !check)) {
            let thead = $(tbody).siblings("thead");
            $(thead).find('input[type="checkbox"]').prop('checked', check);
        }
    }

    function addHtml(tr) {
        let proId = $(tr).find(".camp_nm_check").attr("data_pro_id");
        let proNm = $(tr).find(".camp_nm_check").attr("data_pro_nm");
        let contSeq = $(tr).find(".camp_nm_check").val();
        let campNm = $(tr).find("span[name='camp_nm']").html();

        let newHtml = `<tr>
                                <td><input type="checkbox" name="pro_nm_check" data="`+proId+`" value="` + proId + `" onclick="checkEvent(this)"></td>
                                <td><span class="ellipsis">` + proNm + `</span></td>
                                <td><input type="checkbox" class="camp_nm_check" name="cont_seq" value="` + contSeq + `" data_pro_id ="`+proId+`" onclick="checkEvent(this)"></td>
                                <td><span class="ellipsis">` + campNm + `</span></td>
                            </tr>`;

        if($(`#select_lst_tbody input[data="`+proId+`"]`).length > 0){   // 기존에 선택된 프로그램이 있을 경우 바로 밑에 추가
            $(`#select_lst_tbody input[data="`+proId+`"]`).parents('tr').after(newHtml);
        }else {
            $("#select_lst_tbody").append(newHtml);
        }

        genRowspan(); // 중복 프로그램 합치기
    }

    function genRowspan() {
        $(`#select_lst_tbody input[name="pro_nm_check"]`).each(function () {
            var curr = $(this).attr("data");
            var rows = $(`#select_lst_tbody input[name="pro_nm_check"]`).filter(function () {
                return $(this).attr("data") == curr;
            });

            if (rows.length > 1) {

                let firstRowTdLst = $(rows).eq(0).parents("tr").find('td');
                firstRowTdLst.eq(0).attr("rowspan", rows.length);
                firstRowTdLst.eq(1).attr("rowspan", rows.length);

                let td = rows.not(":eq(0)").parents("tr").find('td');

                td.eq(0).remove();
                td.eq(1).remove();
            }
        });
    }

    function delList() {
        let ckList = $("#select_lst_tbody input[type='checkbox']:checked");
        for (let i = 0; i < ckList.length; i++) {
            let tr = $(ckList[i]).parents("tr");
            let seq = $(tr).find('.camp_nm_check').val();
            selectedCampSet.delete(seq);

            $(ckList[i]).parents("tr").remove();

        }
        changeTitle();
    }

    function delAllList() {
        $("#select_lst_tbody").empty();
        $("input[type='checkbox']").prop("checked", false);
        changeTitle();
        selectedCampSet.clear();
    }

    function checkLst() {
        $('#report_tbody .camp_nm_check').each(function (idx, contSeq) {
            let seq = $(contSeq).val();
            if(selectedCampSet.has(seq)){
                $(contSeq).trigger("click")
            }
        })
    }

    function duplDocument(id) {
        return $("#select_lst_tbody input[value=" + id + "]").parents("tr");
    }

    function changeTitle() {
        let prgCnt = $("#select_lst_tbody input[name='pro_nm_check']").length;
        $("#info_prg").html(prgCnt);

        let campCnt = $("#select_lst_tbody .camp_nm_check").length;
        $("#info_camp").html(campCnt);
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

