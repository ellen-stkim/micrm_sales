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
<sec:authentication var="user" property="details"/>
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>캠페인</li>
                    <li>발송 현황</li>
<%--                    <li>${dto.pro_nm}</li>--%>
                </ul>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!--
           발송 상태에 따라 현재 진행 중인 ('article'클래스) 영역에
          'active'클래스 적용
          -->
        <!-- section 영역 시작 -->
        <div class="contents">
            <div class="contentsDet">
                <div class="settingDet">
                    <div class="chart-cover">
                        <canvas id="chartCover" style="width:100%; height:100%;"></canvas>
                    </div>
                    <table class="single-table graph-table active" id="graph-table">
                        <colgroup>
                            <col style="width:10%;" span="2">
                        </colgroup>
                        <thead>
                        <tr>
                            <th colspan="2">기간</th>
                            <c:forEach var="index" begin="1" end="${fn:length(totalMap)}" >
                                <th>${index}</th>
                            </c:forEach>
                            <th>Total</th>
                        </tr>
                        </thead>
                        <tbody id="tbody">
                        <tr>
                            <td rowspan="11">발송<br>건수</td>
                            <td>알림톡</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>친구톡(txt)</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>친구톡(img)</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>친구톡(wid)</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>RCS SMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>RCS LMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>RCS MMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>RCS 템플릿</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>SMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>LMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>MMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <th colspan="2">Total</th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                        </tbody>
                        <tfoot id="tfoot">
                        <tr>
                            <td rowspan="8">발송<br>금액</td>
                            <td>알림톡</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>친구톡(txt)</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>친구톡(img)</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>친구톡(wid)</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>SMS/RCS<br>SMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>LMS/RCS<br>LMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>MMS/RCS<br>MMS</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>RCS 템플릿</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <th colspan="2">Total</th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                        </tfoot>
                    </table>
                    <div class="table-tab" id="table-tab">
                        <div class="open none">
                            <span>표 열기</span>
                            <img src="/image/ico_pager_next1.png" alt="">
                        </div>
                        <div class="close">
                            <span>표 닫기</span>
                            <img src="/image/ico_pager_next1.png" alt="">
                        </div>
                    </div>
                    <!-- SEARCH AREA START-->
                    <div class="simple-search-wrap">
                        <input type="text" class="date-pick-box" id="from" placeholder="시작날짜" autocomplete="off"/>
                        <span class="hyphen">-</span>
                        <input type="text" class="date-pick-box" id="to" placeholder="종료날짜" autocomplete="off"/>
                        <div class="select-wrap" id="customSelectWrap">
                            <div class="customSelect" id="customSelect">
                                <div class="value">기준선택</div>
                            </div>
                            <ul class="option">
                                <li data="data1">캠페인명</li>
                                <li data="data2">발송자</li>
                            </ul>
                        </div>
                        <input type="text" class="search-text-box" placeholder="검색어입력"/>
                        <button class="gray-search-btn"></button>
                    </div>
                    <!-- SEARCH AREA END-->
                    <div class="single-table-cover">
                        <table class="single-table">
                            <colgroup>
                                <col style="width:10%;" span="3">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>캠페인 명</th>
                                <th>발송일</th>
                                <th>발송자</th>
                                <th>발송건수</th>
                                <th>발송비용</th>
                            </tr>
                            </thead>
                            <tbody id="listBody">
                            <tr>
                                <td>프로그램명</td>
                                <td>2023-02-03</td>
                                <td>Lucas</td>
                                <td class="table-inner">
                                    <table class="table-inner-count">
                                        <colgroup>
                                            <col style="width:25%;" span="4">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>알림톡</th>
                                            <th>친구톡(txt)</th>
                                            <th>친구톡(img)</th>
                                            <th>친구톡(wid)</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <table class="table-inner-count">
                                        <colgroup>
                                            <col style="width:25%;" span="4">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>RCS SMS</th>
                                            <th>RCS LMS</th>
                                            <th>RCS MMS</th>
                                            <th>RCS 템플릿</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <table class="table-inner-count">
                                        <colgroup>
                                            <col style="width:33.3333%;" span="4">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>SMS</th>
                                            <th>LMS</th>
                                            <th>MMS</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <p class="sms-result total" >Total : 1110</p>
                                </td>
                                <td class="table-inner">
                                    <table class="table-inner-count">
                                        <colgroup>
                                            <col style="width:25%;" span="4">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>알림톡</th>
                                            <th>친구톡(txt)</th>
                                            <th>친구톡(img)</th>
                                            <th>친구톡(wid)</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <table class="table-inner-count">
                                        <colgroup>
                                            <col style="width:25%;" span="4">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>SMS/RCS<br>SMS</th>
                                            <th>LMS/RCS<br>LMS</th>
                                            <th>MMS/RCS<br>MMS</th>
                                            <th>RCS 템플릿</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                            <td>10</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <p class="sms-result total" >Total : 1110</p>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
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
<!-- wrap end -->
<content tag="script">
    <script src="/js/Chart.min.js"></script>
    <script src="/js/drawChart.js"></script>
    <script type="text/javascript">
        $(function(){
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

            // custom Select Box
            $("#customSelect").on('click', function(){
                $("#customSelectWrap ul").slideDown();
            });

            $("#customSelectWrap ul li").on('click',function(){
                let thisData = $(this).attr('data');
                let thisVal = $(this).text();
                $("#customSelect .value").text(thisVal);
                $("#customSelect .value").css("color", "#222");
                $("#customSelectWrap ul").slideUp();
            });

            // hide table
            let table = document.getElementById('graph-table');
            let tab = document.getElementById('table-tab').children;
            Array.from(tab).forEach((item, idx) => {
                item.addEventListener('click', () => {
                    for(let i = 0; i < tab.length; i++){
                        tab[i].classList.remove('none');
                    }
                    tab[idx].classList.add('none');

                    if(idx == 0){
                        table.classList.add('active');
                    } else if(idx == 1){
                        table.classList.remove('active');
                    }
                })
            })


            var chartArea = document.getElementById('chartCover').getContext('2d');
            var myChart = new Chart(chartArea, {
                type: 'bar',
                data: {
                    labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August'],
                    datasets: [
                        {
                            label: '알림톡',
                            data: [50, 60, 50, 40, 50, 70, 80, 60],
                            backgroundColor: 'rgba(62, 98, 156, 1)'
                        },
                        {
                            label: '친구톡(txt)',
                            data: [40, 60, 50, 30, 40, 50, 50, 40],
                            backgroundColor: 'rgba(97, 140, 211, 1)'
                        },
                        {
                            label: '친구톡(img)',
                            data: [10, 60, 30, 40, 50, 10, 20, 10],
                            backgroundColor: 'rgba(118, 174, 221, 1)'
                        },
                        {
                            label: '친구톡(wid)',
                            data: [10, 60, 30, 40, 50, 10, 20, 10],
                            backgroundColor: 'rgba(118, 204, 221, 1)'
                        },
                        {
                            label: 'SMS/RCS SMS',
                            data: [10, 60, 30, 40, 50, 10, 20, 10],
                            backgroundColor: 'rgba(75, 179, 198, 1)'
                        },
                        {
                            label: 'LMS/RCS LMS',
                            data: [10, 60, 30, 40, 50, 10, 20, 10],
                            backgroundColor: 'rgba(85, 218, 172, 1)'
                        },
                        {
                            label: 'MMS/RCS MMS',
                            data: [10, 60, 30, 40, 50, 10, 20, 10],
                            backgroundColor: 'rgba(243, 137, 66, 1)'
                        },
                        {
                            label: 'RCS 템플릿',
                            data: [20, 80, 60, 10, 20, 20, 30, 10],
                            backgroundColor: 'rgba(255, 164, 68, 1)'
                        },
                    ]
                },
                options: {
                    responsive: false,
                    scales: {
                        x: {
                            stacked: true,
                            grid: {
                                color: 'rgba(244, 244, 244, 1)'
                            }
                        },
                        y: {
                            stacked: true,
                            beginAtZero: true,
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        });

    </script>
</content>