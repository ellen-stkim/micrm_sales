<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>

<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <form:form id="workSearchForm" name="workSearchForm" method="post" onsubmit="return false">
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>시스템관리</li>
                        <li>작업</li>
                    </ul>
                    <!-- tooltip 버튼 영역  -->
<%--                    <div class="tooltip_icon">--%>
<%--                        <img src="/image/ico_tooltip.png" alt="Tooltip" />--%>
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
                    <div class="select style1 left-border"id="searchOption">
                        <!-- selected value -->
                        <div class="value searchSelect" data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <%--<li data="wrk.seq">작업번호</li>
                            <li data="wrk.work_msg">작업내용</li>
                            <li data="wrk.work_stat">작업상태</li>
                            <li data="usr.usr_email">작업 요청자</li>--%>
                            <sec:authorize access="hasAnyRole('R1','R2')">
                                <li data="seq">작업번호</li>
                                <li data="work_type">작업내용</li>
                                <li data="work_stat">작업상태</li>
                                <input type="hidden" name="work_usr_ip" value="${sessionScope.userId}">
                            </sec:authorize>
                            <sec:authorize access="hasRole('R10')">
                                <li data="seq">작업번호</li>
                                <li data="work_type">작업내용</li>
                                <li data="work_stat">작업상태</li>
                                <li data="usr_email">작업 요청자</li>
                            </sec:authorize>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <span class="input_append">
                    <input type="text" class="searchInp left-border searchWord" name="searchValue" id="searchValue" placeholder="검색어입력"
                           onkeyup="enterSubmit();"/>
                    </span>
                    <input type="hidden" id="searchType" name="searchType"/>
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchWork();"/>
                </div>
            </div>
            <!-- row 영역 끝 -->
            <!-- section 영역 시작 -->
            <div class="section">
                <!-- 검색 결과 영역 시작 -->
                <div class="count border-bottom cf">
                    <div class="total left">작업 리스트</div>
                </div>
                <!-- 검색 결과 영역 끝 -->
                <!-- table 영역 시작 -->
               <span id="workList"></span>
            </div>
        <!-- section 영역 끝 -->
        </form:form>
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
<!-- 작업 상세 팝업 영역 시작 -->
<span id="workPopHtml"></span>

<!-- 작업 상세 팝업 영역 끝 -->
<script>
    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchWork();
        }
        return false;
    }

    // 작업 상세 팝업 open event
    function workPopup(thisValue) {
        var td = $(thisValue).closest("tr").children();
        var stDate = new Date(td.eq(4).text());
        var endToSt = "";
        if(td.eq(5).text().trim() != null && td.eq(5).text().trim()!== ""){
            var endDate = new Date(td.eq(5).text());

            var difTime = endDate-stDate;
            var hours = Math.floor((difTime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            if(0 <= hours && hours < 10){
                hours = "0" + Math.floor(hours);
            } else if(hours < 0 || isNaN(hours)){
                hours = "00";
            }
            var minutes = Math.floor((difTime % (1000 * 60 * 60)) / (1000 * 60));
            if(0 <= minutes && minutes < 10){
                minutes = "0" + Math.floor(minutes);
            } else if(hours < 0 || isNaN(minutes)){
                minutes = "00";
            }
            var seconds = Math.floor((difTime % (1000 * 60)) / 1000);
            if(0 <= seconds && seconds < 10){
                seconds = "0" + Math.floor(seconds);
            } else if(hours < 0 || isNaN(seconds)){
                seconds = "00";
            }
            endToSt = hours +':'+ minutes+':'+ seconds;
        }
        var htmlWork = '<div class="layer_pop workPopup active">'+
                        '<div class="pop_container popup_size1">'+
                        '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />'+
                        '<div class="pop_title">작업 상세</div>'+
                        '<div class="pop_inner">'+
                        '<table class="pop_table_type1">'+
                        '<colgroup>'+
                        '<col width="103" />'+
                        '<col width="*" />'+
                        '</colgroup>'+
                        '<tbody>'+
                        '<tr>'+
                        '<th>작업 요청자</th>'+
                        '<td>'+
                        td.eq(3).text()+
                        '</td>'+
                        '</tr>'+
                        '<tr>'+
                        '<th>작업 상태</th>'+
                        '<td>'+td.eq(2).text()+
                        '</td>'+
                        '</tr>'+
                        '<tr>'+
                        '<th>작업 내용</th>'+
                        '<td>'+td.eq(1).text()+
                        '</td>'+
                        '</tr>'+
                        '<tr>'+
                        '<th>작업 시간</th>'+
                        '<td>'+
                        '작업 시작 : '+td.eq(4).text()+'<br />'+
                        '작업 종료 : '+td.eq(5).text()+'<br />'+
                        '소요 시간 : '+endToSt+/*td.eq(5).text()-td.eq(4).text()+*/
                        '</td>'+
                        '</tr>'+
                        '<tr>'+
                        '<th>상세 내역</th>'+
                        '<td>'+
                        $(thisValue).siblings($("input[name='work_msg']")).val()+
                        '</td>'+
                        '</tr>'+
                        '</tbody>'+
                        '</table>'+
                        '<div class="btn_row">'+
                        '<input type="button" class="btn_bg btn_size2 btn_center" value="확인" onclick="popupClose(this);" />'+
                        '</div>'+
                        '</div>'+
                        '</div>'+
                        '</div>';
        $("#workPopHtml").html(htmlWork);
    }

    $('.btn_more').on('click',function(){
        $('.table tbody').append(addList);
    });

    function addList(){
        let html ='';
        for(let i=0; i < 10; i++){
            html +=          '<tr>' +
                '<td class="en_font">WORk3720181022135846737</td>' +
                '<td>201006_NEW_TARGETING 발송</td>' +
                '<td>진행중</td>' +
                '<td class="en_font">Milvus2</td>' +
                '<td class="en_font">2020-10-05 16:14:00</td>' +
                '<td class="en_font">2020-10-05 16:14:00</td>' +
                '<td><span class="btn_sm_line" onclick="workPopup();">상세</span></td>' +
                '</tr>' ;
        }
        return html;
    }

    function searchWork() {
        let standard = $('.searchSelect').attr('data');
        let searchValue = $('#searchValue').val().trim();

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            if(standard=='work_stat'){
                var selectData = document.querySelector('#selectData').getAttribute("data");
                $('#searchValue').val(selectData);
            }
            $('#searchType').val(standard);
            getWorkList('1');
        }
    }

    //유저리스트
    function getWorkList(page) {
        var res = function (response) {
            $("#workList").html(response);
        };
        var param = $("#workSearchForm").serializeArray();
        param.push({name: 'pageNo', value: page});
        com_ajax.ajax('post', '${baseURL}/sys/work/getWorkList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
    $('#searchOption .option li').click(function(){
        let optionVal = $(this).attr('data');
        if(optionVal == 'work_stat'){
            $('.input_append').html(
                '<div class="select style1 left-border right-border" id="viewState">' +
                '<input type="hidden" name="searchValue" id="searchValue"/>' +
                '<div class="value searchSelect" id="selectData" data="">작업상태</div>' +
                '<ul class="option">' +
                '<li data="0">작업중</li>' +
                '<li data="1">완료</li>' +
                '<li data="2">오류</li>' +
                '<li data="3">삭제</li>' +
                '</ul>' +
                '</div>'
            );
        }else{
            $('.input_append').html(
                '<input type="text" class="searchInp left-border searchWord" name="searchValue" id="searchValue" placeholder="검색어입력" onkeyup="enterSubmit();"/>'
            );
        }
    });

    getWorkList('1');
</script>