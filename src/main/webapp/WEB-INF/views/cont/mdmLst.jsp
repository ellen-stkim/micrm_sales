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
        <div class="row tooltip_area bottom-border cf">
            <form:form id="searchForm" name="searchForm" onsubmit="return false">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>메세지</li>
                        <li>모바일</li>
                    </ul>
                    <!-- tooltip 버튼 영역  -->
<%--                    <div class="tooltip_icon">--%>
<%--                        <img src="/image/ico_tooltip.png" alt="Tooltip"/>--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 시작 -->
<%--                    <div class="tooltip_box">--%>
<%--                        <!-- tooltip bullet 영역 -->--%>
<%--                        <div class="bullet"></div>--%>
<%--                        <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br/>--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                        스타일론 직장인이 26.69억(29.1%), <br/>--%>
<%--                        스타일론 자영업자가 4.1억(4.47%)입니다.<br/>--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 끝 -->
                </div>
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border" id="searchItems">
                        <!-- selected value -->
                        <div class="value searchSelect" data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="cont_nm">템플릿명</li>
                            <li data="cont_sub">제목</li>
                            <li data="use_yn">사용 여부</li>
                        </ul>
                    </div>
                    <div class="left" id="typeArea"></div>
                    <input type="hidden" name="searchType" id="searchType"/>
                    <!-- select 영역 끝 -->
                    <input type="text" class="searchInp left-border" name="searchValue" id="searchValue"
                           placeholder="검색어입력"/>
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchMobileList();"/>
                </div>
            </form:form>
        </div>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border cf">
            <div class="left">
                <a href="/cont/mdmCreate.mi" class="btn_basic smsCreate left right-border">모바일 컨텐츠 생성</a>
                <%--<input type="button" class="btn_basic delete left right-border"
                       onclick="popup.deleteClick('campaign', '');" value="삭제"/>--%>
                <input type="button" class="btn_basic delete left right-border"
                       onclick="deleteMobileList('campaign','');" value="삭제"/>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <!-- list_container 영역 시작 -->
            <div class="list_container sms cf">
                <div class="row_grid">
                </div>
            </div>
            <input type="hidden" id="nowPageNoCur" name="nowPageNoCur" value="${pageNo}"/>

            <!-- list_container 영역 끝 -->
            <span id="pageBtn">
                <%--<c:if test="${nextCk eq true}">
                    <div class="btn_more" onclick="getMobileListAdd();"><img src="/image/bullet_arrw1.png" alt="" />더보기</div>
                </c:if>--%>
            </span>
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

    $(document).ready(function(){
        selectMobileList(1)
    })

    $(document).on('click','.useState',function(){
        let state = $(this).val();
        if(state == 'Y'){
            $(this).val('N');
            $(this).parents('.column').addClass('off');
        }else{
            $(this).val('Y');
            $(this).parents('.column').removeClass('off');
        }
    });

    $(function(){
        $('#searchItems ul li').on('click',function(){
            let searchItem = $(this).attr('data');
            console.log(searchItem);

            if(searchItem == "cont_nm" || searchItem == "cont_sub"){
                $("#searchValue").val('');
            }

            if(searchItem == "use_yn"){
                $('#searchValue').hide();
                $('#typeArea').html(
                    '<div class="select style1 right-border left-border">' +
                    '<div class="value searchSelect" id="yn_select" data="Y">Y</div>' +
                    '<ul class="option">' +
                    '<li data="Y">Y</li>' +
                    '<li data="N">N</li>' +
                    '</ul>' +
                    '</div> '
                );
            }if(searchItem != 'use_yn'){
                $('#searchValue').show();
                $('#typeArea').children().remove();
            }
        });
    })

    // 리스트 출력하기
    function selectMobileList(pageNo) {
        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if(standard =='use_yn') {
            let yn_data = $("#yn_select").attr('data');
            $("#searchValue").val(yn_data)
        }

        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').html($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };

        var param = $("#searchForm").serializeArray();
        param.push({name : 'pageNo', value : pageNo});
        com_ajax.ajax('post', '${baseURL}/cont/mobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 리스트 버튼으로 추가 가져오기
    function getMobileListAdd(pageNo){

        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').append($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };
        var param = $("#searchForm").serializeArray();
        param.push({name : 'pageNo', value : parseInt(pageNo) +1});
        com_ajax.ajax('post', '${baseURL}/cont/mobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 모바일 리스트 삭제 처리
    function deleteMobileList(type,state){
        let count = $('.custom_check1').not('.all').find('input:checked').length;
        if(type != '' && type != "undefined"){
            if(type == 'image'){
                listType = "이미지";
            }else{
                listType = "컨텐츠";
            }
        }
        if(count == 0){
            deleteMobilePopUp('false', "삭제할 " + listType + " 를 선택해주세요.");
        }else{
            deleteMobilePopUp('true', count + "개의 " + listType + " 를 삭제하시겠습니까?");
        }
    }

    // 삭제 팝업 띄우기
    function deleteMobilePopUp(promptState,deleteTxt){
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">삭제 안내</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + deleteTxt + '</div>';
        if (promptState == 'false') {
            html += '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_center" onclick="popupClose(this);" value="확인" />' +
                '</div>';
        } else {
            html += '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteMobile();" value="확인" />' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>';
        }
        html += '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }

    // 모바일 리스트 삭제하기
    function deleteMobile(){
        var nowPage = $("#nowPageNo").val();
        var checkList = [];
        var checkLength = $('.custom_check1 input[name=list]:checked').length;

        var res = function(response){
            if(response.status == "true"){
                popup.popAlert("삭제 되었습니다");
            }else{
                popup.popAlert("삭제도중 오류가 발생하였습니다. 관리자에게 문의해주세요.");
            }
            $('#deleteAllPop').removeClass('active');
            selectMobileList(nowPage)
        }
        for(var i=0; i<checkLength; i++){
            checkList.push($('.custom_check1 input[name=list]:checked').eq(i).val());
        }
        var param = {checkList: checkList};
        com_ajax.ajax('post', '${baseURL}/cont/deleteMobileContent.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    };

    // 모바일 리스트 가져오기
    function searchMobileList() {

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if (standard == '' && searchValue!='') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $('#searchType').val(standard);
        selectMobileList('1');
    }

    // 컨텐츠 사용여부 변경 event
    function updateUseState(seq, thisVal){
        var state = $(thisVal).val();
        var useValue = "";
        if(state == "Y"){
            useValue = "N";
        }else{
            useValue = "Y";
        }
        var res = function (response) {
            if(response.message > 0) {
                //popup.popAlert("변경되었습니다.");
                $(thisVal).val(response.list[0].use_yn);
                if (response.list[0].use_yn == 'Y') {
                    $(thisVal).parents('.column').removeClass('off');
                }else{
                    $(thisVal).parents('.column').addClass('off');
                }
            }
        };
        var param = {seq : seq, use_yn : useValue};
        com_ajax.ajax('post', '${baseURL}/cont/updateMobileUseYn.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }


   /* function deleteMdmList(){
        let checkbox = document.getElementsByName("list");
        let checkboxLength = checkbox.length;
        let count = 0;
        for(let a=0; a < checkboxLength; a++){
            if(checkbox[a].checked){
                count++;
            }
        }
        console.log("checkbox : " + checkbox);
        console.log("checkboxLength :" + checkboxLength);

        if(count == 0){
            popup.deleteAlert('false', "삭제할 컨텐츠를 선택해주세요.");

        }else {
            deleteEdmCheck('true', count + "개의 컨텐츠를 삭제하시겠습니까?");
        }
    }*/





    let type = ['kakao', 'MMS','SMS', 'rcsText', 'rcsHorizontalLeft', 'rcsHorizontalRight', 'rcsVerticalTall', 'rcsVerticalMedium', 'rcsSlideSmall', 'rcsSlideMedium'];
    // 더보기 버튼 클릭시 layout append function


</script>