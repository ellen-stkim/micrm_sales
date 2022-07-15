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
<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>HOME</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
<%--                <div class="tooltip_icon">--%>
<%--                    <img src="/image/ico_tooltip.png" alt="Tooltip"/>--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br/>--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                    스타일론 직장인이 26.69억(29.1%), <br/>--%>
<%--                    스타일론 자영업자가 4.1억(4.47%)입니다.<br/>--%>
<%--                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="main_calendar">
                <h2>발송 캘린더</h2>
                <!-- 월별 이동 달력 영역 시작 -->
                <div class="month_pop">
                    <table class="month_tbl">
                        <colgroup>
                            <col width="35"/>
                            <col width="35"/>
                            <col width="35"/>
                            <col width="35"/>
                        </colgroup>
                        <thead>
                        <tr>
                            <th>
                                <div class="prev" onclick="prevYear();"></div>
                            </th>
                            <th class="year" colspan="2"></th>
                            <th>
                                <div class="next" onclick="nextYear();"></div>
                            </th>
                        </tr>
                        </thead>
                        <tbody class="month_body"></tbody>
                    </table>
                </div>
                <!-- 월별 이동 달력 영역 끝 -->
                <!-- [Fullcalendar.js] 영역 -->
                <div id="calendar"></div>
                <!-- 달력 범례 영역 시작 -->
                <div class="calendar_legend bottom-border">
                    <div class="state4">승인대기</div>
                    <div class="state2">발송대기</div>
                    <div class="state5">타겟추출중</div>
                    <div class="state6">발송중</div>
                    <div class="state3">발송완료</div>
                    <div class="state1">발송실패</div>
                </div>
                <!-- 달력 범례 영역 끝 -->
            </div><!-- 'main_calendar' end -->

            <!-- 발송 요약 영역 시작 -->
            <div class="state_viewer right">
                <!-- basic start -->
                <div class="basic">
                    <h3>발송 가능 회원 비중</h3>
                    <!-- pregress 영역 시작 -->
                    <div class="member_progress">
                        <div class="top">
                            전체
                            <span>
                                <c:choose>
                                    <c:when test="${tblSumCk ne false}">
                                     <c:choose>
                                         <c:when test="${!cutil:isEmptyObject(tblSum.total_cnt)}">
                                             <span><fmt:formatNumber value="${tblSum.total_cnt}" pattern="#,###" /></span>
                                         </c:when>
                                         <c:otherwise><span>0</span></c:otherwise>
                                     </c:choose>
                                    </c:when>
                                    <c:otherwise><span>0</span></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="bottom cf">
                            <!-- [edm progress.js] -->
                            <div class="edm">
                                <p>
                                <c:choose>
                                    <c:when  test="${tblSumCk ne false}">
                                    <c:choose>
                                        <c:when test="${!cutil:isEmptyObject(tblSum.edm_agree_cnt)}">
                                            <span class="en_font"><fmt:formatNumber value="${tblSum.edm_agree_cnt}" pattern="#,###" /></span>
                                        </c:when>
                                        <c:otherwise><span class="en_font">0</span></c:otherwise>
                                    </c:choose>
                                    </c:when>
                                    <c:otherwise><span class="en_font">0</span></c:otherwise>
                                </c:choose>
                                    &nbsp;<span>
                                    (
                                        <c:choose>
                                            <c:when  test="${tblSumCk ne false}"><fmt:formatNumber type="percent" pattern="0.00%" value="${tblSum.edm_agree_cnt/tblSum.total_cnt}" />
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    )
                                </span>
                                </p>
                                <div id="edmProgress" data="<c:if test='${tblSumCk ne false}'>${tblSum.edm_agree_cnt/tblSum.total_cnt}</c:if>"></div>
                            </div>
                            <!-- [mms progress.js] -->
                            <div class="mms">
                                <p>
                                    <c:choose>
                                        <c:when  test="${tblSumCk ne false}">
                                            <c:choose>
                                                <c:when test="${!cutil:isEmptyObject(tblSum.mdm_agree_cnt)}">
                                                    <span class="en_font"><fmt:formatNumber value="${tblSum.mdm_agree_cnt}" pattern="#,###" /></span>
                                                </c:when>
                                                <c:otherwise><span class="en_font">0</span></c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise><span class="en_font">0</span></c:otherwise>
                                    </c:choose>
                                    &nbsp;<span>
                                    (
                                        <c:choose>
                                            <c:when test="${tblSumCk ne false}"><fmt:formatNumber type="percent" pattern="0.00%" value="${tblSum.mdm_agree_cnt/tblSum.total_cnt}" /></c:when>
                                             <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    )
                                    </span></p>
                                <div class="" id="mmsProgress" data="<c:if test='${tblSumCk ne false}'>${tblSum.mdm_agree_cnt/tblSum.total_cnt}</c:if>"></div>
                            </div>
                        </div>
                    </div>
                    <!-- pregress 영역 끝 -->
                    <h3>발송 현황</h3>
                    <div class="status_graph">
                        <!-- edm/mms 채널 선택 영역 시작 -->
                        <div class="graph_btn cf">
                            <label class="edm on"><input type="checkbox" checked/>
                                <img src="/image/ico_edm.png" alt="이메일"/></label>
                            <label class="mms on"><input type="checkbox" checked/><img
                                    src="/image/ico_mobile.png" alt="문자"/></label>
                        </div>
                        <!-- edm/mms 채널 선택 영역 끝 -->
                        <!-- [Chart.js] 영역 -->
                        <div class="chart_box">
                            <canvas id="myChart" width="277"></canvas>
                        </div>
                        <div class="data cf">
                            <div>평균 발송 횟수<span class="blue_point_color">0</span></div>
                            <div>최대 발송 횟수<span class="blue_point_color">0</span></div>
                        </div>
                    </div>
                </div>
                <!-- basic end -->
            </div><!-- 'state_viewer' end -->
        </div>
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


<script>

    $(function () {
        getCookie();
        $('.month_body').html(month);
        // [Fullcalendar.js] option
        // state 적용 class
        // [state1 : eDM 발송취소],[state2 : eDM 발송대기],[state3 : eDM 발송완료],[state4 : eDM 승인대기]
        // [state5 : mms 발송취소],[state6 : mms 발송대기],[state7 : mms 발송대기],[state8 : mms 승인대기]
        $('#calendar').fullCalendar({
            contentHeight: 593,
            header: {
                left: 'prev, title, next',
                center: '',
                right: ''
            },
            navLinks: false,
            editable: false,
            dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
            views: {
                month: {
                    titleFormat: 'YYYY.MM',
                    columnFormat: 'ddd'
                }
            },
            eventLimit: true,
            events: function (start, end, timezone, callback) {
                var cDate = $('#calendar').fullCalendar('getDate');
                var res = function (response) {
                    var events = [];
                    for(var i=0; i<response.length; i++){
                        events.push({
                            id : response[i]["camp_ch"],
                            no : response[i]["seq"],
                            cont_id : response[i]["cont_id"],
                            className: 'state'+response[i]["camp_st"]+response[i]["camp_ch"],
                            title: response[i]["camp_nm"],
                            start: moment(response[i]["start_dt"]).format('YYYY-MM-DD'),
                            startDt:response[i]["start_dt"],
                            proId: response[i]["pro_id"],
                            campSt: response[i]["camp_st"],
                            tarCnt: response[i]["tar_cnt"]

                        });
                    }
                    callback(events);
                };
                var param = {startDate : moment(cDate).format('YYYY-MM-01'),
                    endDate   : moment(cDate).format('YYYY-MM-01')};
                com_ajax.ajax('post', '${baseURL}/getCampInfo.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
            },
             viewRender: function (view, element) {
                let moment = $('#calendar').fullCalendar('getDate');
                let mmYear = Number(moment.format('YYYY'));
                let mmMonth = Number(moment.format('MM'));
                $('.year').html(mmYear);
                $('.year').attr('value', mmYear);
                for (i = 0; i <= 11; i++) {
                    if ($('.month').eq(i).data('month') == mmMonth) {
                        $('.month').parent().siblings().removeClass('on');
                        $('.month').eq(i).parent().addClass('on');
                    }
                }
            },
            eventClick: function (info) {
                //캠페인 요약 open event
                $('.summary_modal').remove();
                /*if(info.no == null || info.no ==""){
                    return false;
                }*/
                getPopCamp(info.no, info.id, info.title, info.cont_id, info.proId, info.tarCnt, info.startDt, info.campSt);
            }
        });
        // 월별 달력 click event
        $('.month').on('click', function () {
            let dataMonth = $(this).attr('data-month');
            let year = $(this).parents('.month_tbl').find('.year').attr('value');
            let month = dataMonth.length == 1 ? "0" + dataMonth : dataMonth;
            let fullDate = year + '-' + month;
            let full = new Date(fullDate);
            $("#calendar").fullCalendar("gotoDate", full);
            $('.month_pop').hide();
        });
        // 월별 달력 open event
        $('.btn_month').on('click', function () {
            $('.month_pop').show();
        });
        // 월별 달력 close event
        $('body, html').on('click', function (e) {
            // select close
            if (!$(e.target).hasClass('btn_month') && !$(e.target).hasClass('month_pop') && !$(e.target).hasClass('prev') && !$(e.target).hasClass('next')) {
                $('.month_pop').hide();
            }
        });
        // 발송 채널 click event
        $('.graph_btn label input').on('click', function () {
            $(this).parent('label').toggleClass('on');
        });
        // 캠페인 요약 close event
        $(document).on('click','.btn_hide', function () {
            $('.summary_modal').remove();
        });
    });

    // 월별 달력 Prev
    function prevYear() {
        let todayYear = Number($('.year').attr('value'));
        let year = todayYear - 1;
        $('.year').attr('value', year);
        $('.year').html(year);
    }

    // 월별 달력 Next
    function nextYear() {
        let todayYear = Number($('.year').attr('value'));
        let year = todayYear + 1;
        $('.year').attr('value', year);
        $('.year').html(year);
    }

    // 월별 달력 layout 생성
    function month() {
        month_html = "";
        month_html += "<table class='month_tbl'><tr>"
        for (i = 1; i <= 12; i++) {
            month_html += "<td><div class='month' data-month='" + i + "'>" + i + "</div></td>";
            if (i % 4 == "0") {
                month_html += "</tr>";
            }
        }
        month_html += "</tr></table>";
        return month_html;
    };
    // eDM progress.js
    var bar1 = new ProgressBar.Line(edmProgress, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#618cd3',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: {width: '100%', height: '7px'}
    });
    bar1.animate(Number($("#edmProgress").attr('data')));
    // MMS progress.js
    var bar2 = new ProgressBar.Line(mmsProgress, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#618cd3',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: {width: '100%', height: '7px'}
    });
    bar2.animate(Number($("#mmsProgress").attr('data')));
    // Chart.js  발송 현황
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['1회', '2회', '3회', '4회', '5회 이상'],
            datasets: [{
                barPercentage: 0.3,
                data: [0, 0, 0, 0, 0],
                backgroundColor: [
                    '#efefef',
                    '#efefef',
                    '#efefef',
                    '#efefef',
                    '#efefef'
                ],
                hoverBackgroundColor: [
                    '#efefef',
                    '#efefef',
                    '#efefef',
                    '#efefef',
                    '#efefef'
                ],
                borderWidth: 0
            }]
        },
        options: {
            tooltips: false,
            layout: {
                padding: {
                    top: 20,
                    left: 0,
                    right: 0
                }
            },
            scales: {
                yAxes: [{
                    ticks: {
                        min: 0,
                        display: false
                    },
                    gridLines: {
                        display: false
                    }
                }],
                xAxes: [{
                    gridLines: {
                        display: false
                    },
                    ticks: {
                        fontFamily: "NotoSansCJKkr",
                        fontSize: 12
                    }
                }],
            },
            legend: {
                display: false
            },
            hover: {
                animationDuration: 0
            },
            animation: {
                duration: 1100,
                easing: 'easeInOutQuart',
                onComplete: function () {
                    var chartInstance = this.chart,
                        ctx = chartInstance.ctx;
                    ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, Chart.defaults.global.defaultFontStyle, Chart.defaults.global.defaultFontFamily);
                    ctx.fillStyle = '#999999';
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'bottom';
                    this.data.datasets.forEach(function (dataset, i) {
                        var meta = chartInstance.controller.getDatasetMeta(i);
                        meta.data.forEach(function (bar, index) {
                            var data = dataset.data[index];
                            var addUnit = data + "%";
                            ctx.fillText(addUnit, bar._model.x, bar._model.y - 5);
                        });
                    });
                }
            }
        }
    });
    var notInPop = [];

    function getNoticePop(notInPop) {
        var res = function (response) {
            $("#noticePopAppend").html(response);
        };
        var now = new Date();
        var year = now.getFullYear();
        var month = (1 + now.getMonth());
        month = month >= 10 ? month : '0' + month;
        var day = now.getDate();
        day = day >= 10 ? day : '0' + day;
        var todayDate = year + '-' + month + '-' + day;
        var param = {noti_popyn: 'Y', noti_bgn_dttm: todayDate, notInPop: notInPop};
        com_ajax.ajax('post', '${baseURL}/sys/setting/getNoticePop.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    function thispopupClose(close) {
        $(close).parents('.layer_pop').css('display', 'none');
    }

    //setCookie
    function setCookie(name, expiredays, close) {
        let todayDate = new Date();
        todayDate.setDate(todayDate.getDate() + expiredays);
        document.cookie = name + "=" + escape("done") + "; path=/; expires=" + todayDate.toGMTString() + ";";
        $(close).parents('.layer_pop').css('display', 'none');
    }

    //getCookie
    function getCookie() {
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            notInPop.push($.trim(ca[i].split('=')[0]));
        }
        getNoticePop(notInPop);
    }


    function getPopCamp(contSeq, campCh, campTitle, contId, proId, tarCnt, startDt, campSt) {
            var res = function (response) {
                var $doc = new DOMParser().parseFromString(response, "text/html");
                $(".state_viewer").append($("#appendHtml", $doc).html());
            };
            var param = {seq : contSeq, cont_id: contId, camp_nm : campTitle, ch_tp:campCh, pro_id :proId, tar_cnt:tarCnt, start_dt : startDt, camp_st : campSt};
            com_ajax.ajax('post', '${baseURL}/getMainCampView.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

</script>
