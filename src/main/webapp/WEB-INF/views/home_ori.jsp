<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
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
<%--                    <img src="../image/ico_tooltip.png" alt="Tooltip" />--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                    스타일론 직장인이 26.69억(29.1%), <br />--%>
<%--                    스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
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
                            <col width="35" />
                            <col width="35" />
                            <col width="35" />
                            <col width="35" />
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
                    <div class="state1">발송취소</div>
                    <div class="state2">발송대기</div>
                    <div class="state3">발송완료</div>
                    <div class="state4">승인대기</div>
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
                            전체<span>1,523,894</span>
                        </div>
                        <div class="bottom cf">
                            <!-- [edm progress.js] -->
                            <div class="edm">
                                <p>1,277,975&nbsp;<span>(82%)</span></p>
                                <div id="edmProgress"></div>
                            </div>
                            <!-- [mms progress.js] -->
                            <div class="mms">
                                <p>886,154&nbsp;<span>(67%)</span></p>
                                <div class="" id="mmsProgress"></div>
                            </div>
                        </div>
                    </div>
                    <!-- pregress 영역 끝 -->
                    <h3>9월 발송 현황</h3>
                    <div class="status_graph">
                        <!-- edm/mms 채널 선택 영역 시작 -->
                        <div class="graph_btn cf">
                            <label class="edm on"><input type="checkbox" checked /><img
                                    src="../image/ico_edm.png" alt="이메일" /></label>
                            <label class="mms on"><input type="checkbox" checked /><img
                                    src="../image/ico_mobile.png" alt="문자" /></label>
                        </div>
                        <!-- edm/mms 채널 선택 영역 끝 -->
                        <!-- [Chart.js] 영역 -->
                        <div class="chart_box"><canvas id="myChart" width="277"></canvas></div>
                        <div class="data cf">
                            <div>평균 발송 횟수<span class="blue_point_color">3.6</span></div>
                            <div>최대 발송 횟수<span class="blue_point_color">9</span></div>
                        </div>
                    </div>
                </div>
                <!-- basic end -->

                <!-- 캠페인 요약 이메일 영역 시작 -->
                <div class="summary_modal edm_modal">
                    <div class="btn_hide">닫기</div>
                    <h3>캠페인 요약</h3>
                    <div class="padding_inner">
                        <!-- [state1 : eDM 발송취소],[state2 : eDM 발송대기],[state3 : eDM 발송완료],[state4 : eDM 승인대기]
          [state5 : mms 발송취소],[state6 : mms 발송대기],[state7 : mms 발송대기],[state8 : mms 승인대기]    -->
                        <div class="title ellipsis state3">Superstar reminder</div>
                        <div class="sum_info cf">
                            <!-- 발송 날짜 영역 -->
                            <div class="date">발송일정<span>2020년 9월 9일 오후 3시</span></div>
                            <!-- 발송 현황 영역 -->
                            <div class="state_txt">발송완료</div>
                        </div>
                        <!-- 이메일 viewer 영역 -->
                        <div class="view">
                            <div class="img edm"><img src="../image/test_img1.jpg" alt="" /></div>
                        </div>
                        <!-- Target 영역 -->
                        <div class="row_state arrow cf">
                            <div class="th">Target</div>
                            <div class="td">201,525</div>
                            <div class="td percents">-</div>
                        </div>
                        <!-- Success 영역 -->
                        <div class="row_state arrow cf">
                            <div class="th">Success</div>
                            <div class="td">200,005</div>
                            <div class="td percents">99.2%</div>
                        </div>
                        <!-- Open 영역 -->
                        <div class="row_state arrow cf">
                            <div class="th">Open</div>
                            <div class="td">82,533</div>
                            <div class="td percents">41.2%</div>
                        </div>
                        <!-- Click 영역 -->
                        <div class="row_state cf">
                            <div class="th">Click</div>
                            <div class="td">7,210</div>
                            <div class="td percents">3.6%</div>
                        </div>
                        <!-- 상세 보러가기 버튼 -->
                        <a href="#" class="btn_link">상세 보러가기</a>
                    </div>
                </div>
                <!-- 캠페인 요약 이메일 영역 끝 -->
                <!-- 캠페인 요약 문자 영역 시작 -->
                <div class="summary_modal mms_modal">
                    <div class="btn_hide">닫기</div>
                    <h3>캠페인 요약</h3>
                    <div class="padding_inner">
                        <div class="title ellipsis state6">SYS reminder</div>
                        <div class="sum_info cf">
                            <!-- 발송 날짜 영역 -->
                            <div class="date">발송일정<span>2020년 9월 9일 오후 3시</span></div>
                            <!-- 발송 현황 영역 -->
                            <div class="state_txt">발송대기</div>
                        </div>
                        <!-- 문자 viewer 영역 -->
                        <div class="view">
                            <div class="img mms"><img src="../image/test_img2.jpg" alt="" /></div>
                            <p class="mms">(광고)[adidas] 9월 아디클럽 회원 혜택 안내<br />
                                ♥9월 MEMBERS ONLY♥</p>
                        </div>
                        <!-- Target 영역 -->
                        <div class="row_state arrow cf">
                            <div class="th">Target</div>
                            <div class="td">98,562</div>
                            <div class="td percents">-</div>
                        </div>
                        <!-- Success 영역 -->
                        <div class="row_state arrow cf">
                            <div class="th">Success</div>
                            <div class="td">-</div>
                            <div class="td percents">-</div>
                        </div>
                        <!-- Open 영역 -->
                        <div class="row_state arrow cf">
                            <div class="th">Open</div>
                            <div class="td">-</div>
                            <div class="td percents">-</div>
                        </div>
                        <!-- Click 영역 -->
                        <div class="row_state cf">
                            <div class="th">Click</div>
                            <div class="td">-</div>
                            <div class="td percents">-</div>
                        </div>
                        <!-- 상세 보러가기 버튼 -->
                        <a href="#" class="btn_link">상세 보러가기</a>
                    </div>
                </div>
                <!-- 캠페인 요약 문자 영역 끝 -->
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
            defaultDate: '2020-10-13',
            navLinks: false,
            editable: false,
            dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
            views: {
                month: {
                    titleFormat: 'YYYY.MM',
                    columnFormat: 'ddd'
                },
            },
            eventLimit: true,
            events: [
                {
                    id: "event1",
                    className: "state1",
                    title: '"CLICK", Superstar launching',
                    start: '2020-10-09'
                },
                {
                    className: "state3",
                    title: 'Thanksgiving 1st',
                    start: '2020-10-09'
                },
                {
                    className: "state6",
                    title: 'SYS Reminder',
                    start: '2020-10-09'
                },
                {
                    className: "state6",
                    id: "event2",
                    title: '"CLICK", Bounce back info',
                    start: '2020-10-21'
                },
                {
                    className: "state8",
                    title: '★ 로그인만 해도 자동응모! 지금 바로 카카오페이 멤버십으로 로그인하기:',
                    start: '2020-10-30'
                },
                {
                    className: "state5",
                    title: 'Superstar launching',
                    start: '2020-10-10'
                },
                {
                    className: "state6",
                    title: 'Superstar launching',
                    start: '2020-10-10'
                },
                {
                    className: "state7",
                    title: '(광고)[Reebok] 봄맞이 럭키드로우 이벤트★',
                    start: '2020-10-10'
                },
                {
                    className: "state7",
                    title: '[Reebok] 라인프렌즈 사전예약 안내',
                    start: '2020-10-27'
                }
            ]
            , viewRender: function (view, element) {
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
                $('.summary_modal').removeClass('on');
                if (info.id == "event1") {
                    $('.edm_modal').addClass('on');
                } else if (info.id == "event2") {
                    $('.mms_modal').addClass('on');
                } else {
                    return false;
                }
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
        $('.btn_hide').on('click', function () {
            $(this).parent('.summary_modal').removeClass('on');
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
        month_html += "</tr></table>"
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
        svgStyle: { width: '100%', height: '7px' }
    });
    bar1.animate(0.82);
    // MMS progress.js
    var bar2 = new ProgressBar.Line(mmsProgress, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#618cd3',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: { width: '100%', height: '7px' }
    });
    bar2.animate(0.67);
    // Chart.js  발송 현황
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['1회', '2회', '3회', '4회', '5회 이상'],
            datasets: [{
                barPercentage: 0.3,
                data: [15, 20, 30, 25, 10],
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
    function getNoticePop(notInPop){
        var res = function (response) {
            $("#noticePopAppend").html(response);
        };
        var now = new Date();
        var year = now.getFullYear();
        var month = (1 + now.getMonth());
        month = month >= 10 ? month : '0' + month;
        var day = now.getDate();
        day = day >= 10 ? day : '0' + day;
        var todayDate= year + '-' + month + '-' + day;
        var param ={noti_popyn : 'Y', noti_bgn_dttm : todayDate, notInPop : notInPop};
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

</script>
