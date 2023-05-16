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
                    <li>홈</li>
                    <li>시스템관리</li>
                    <li>환경</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
                <div class="tooltip_icon">
                    <img src="../../image/ico_tooltip.png" alt="Tooltip" />
                </div>
                <!-- tooltip box 영역 시작 -->
                <%--<div class="tooltip_box">
                    <!-- tooltip bullet 영역 -->
                    <div class="bullet"></div>
                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />
                                나오론이 52.4억(57.2%)으로 가장 많은 비중을
                                차지합니다.</span>
                    스타일론 직장인이 26.69억(29.1%), <br />
                    스타일론 자영업자가 4.1억(4.47%)입니다.<br />
                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
            <div class="right">
                <!-- select 영역 시작 -->
                <div class="select style1 left-border" id="searchItems">
                    <!-- selected value -->
                    <div class="value searchSelect" data="">기준선택</div>
                    <!-- option -->
                    <ul class="option">
                        <li data="list_nm">Type</li>
                        <li data="list_val">Key</li>
                        <li data="def_yn">기본설정여부</li>
                    </ul>
                </div>
                <div class="left" id="typeArea"></div>
                <!-- select 영역 끝 -->
                <input type="hidden" name="searchType" id="searchType"/>
                <input type="text" class="searchInp left-border searchWord" placeholder="검색어입력"
                       id="searchValue" onkeyup="enterSearch();" />
                <input type="submit" class="searchBtn" value="검색" onclick="return searchMappingSetting();" />
            </div>
        </div>
        <!-- row 영역 끝 -->
        <ul class="tab_row">
            <!-- Tab menu -->
            <li<c:if test = "${urlPath eq '/sys/setting/teamSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/teamSetting.mi">팀 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/mappingSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/mappingSetting.mi">매핑 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/smsSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/smsSetting.mi">문자 정보 설정</a></li>
            <%--<li><a href="approval.html">승인 절차 설정</a></li>--%>
            <li<c:if test = "${urlPath eq '/sys/setting/kkoSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/kkoSetting.mi">카카오 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/rejectSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/rejectSetting.mi">수신거부 문구 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/naverAppSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/naverAppSetting.mi">네이버 Short URL 설정</a></li>
        </ul>
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">매핑정보 리스트</div>
                <div class="btn_col right">
                    <input type="button" value="추가" class="btn_sm_line" onclick="mappingAddPopup();" />
                </div>
            </div>
            <span id ="mappingSettingList"></span>
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

<!-- 매핑정보 추가 팝업 영역 시작 -->
<div class="layer_pop mappingAddPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">매핑정보 추가</div>
        <div class="pop_inner">
            <form action="" id="postForm1">
                <table class="pop_table_type1" summary="매핑정보 추가">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>Type</th>
                        <td>
                            <div class="select" id="list_nm">
                                <!-- selected value -->
                                <div class="value searchSelect" data="" style="line-height: 24px;">기준선택</div>
                                <!-- option -->
                                <ul class="option" style="top: 31px;">
                                    <li data="USR_KEY">회원정보</li>
                                    <li data="FROM_TO">수신번호</li>
                                </ul>
                            </div>
<%--                            <input type="text" name="list_nm" id="list_nm" placeholder="Key를 입력해주세요." class="input_type1" />--%>
                        </td>
                    </tr>
                    <tr>
                        <th>Key</th>
                        <td><input type="text" name="list_val" id="list_val" placeholder="Value를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkMappingAddress();" value="저장" />
            </div>
        </div>
    </div>
</div>
<!-- 매핑정보 추가 팝업 영역 끝 -->

<!-- 매핑정보 수정 팝업 영역 수정 -->
<div class="layer_pop mappingRePopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="modifyPopupClose(this);" />
        <div class="pop_title">매핑정보 수정</div>
        <div class="pop_inner">
            <form action="" id="postForm2">
                <table class="pop_table_type1" summary="매핑정보 수정">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <input type ="hidden" name="seq_mod" id="seq_mod"/>
                    <tr>
                        <th>Type</th>
                        <td>
                            <div class="select" id="list_nm_mod">
                                <!-- selected value -->
                                <div class="value searchSelect" data="" style="line-height: 24px;">기준선택</div>
                                <!-- option -->
                                <ul class="option" style="top: 31px;">
                                    <li data="USR_KEY">회원정보</li>
                                    <li data="FROM_TO">수신번호</li>
                                </ul>
                            </div>
<%--                            <input type="text" name="list_nm_mod" id="list_nm_mod" placeholder="Key를 입력해주세요." class="input_type1" />--%>
                        </td>
                    </tr>
                    <tr>
                        <th>Key</th>
                        <td><input type="text" name="list_val_mod" id ="list_val_mod" placeholder="Value를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea2"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkMappingAddressModify($('#seq_mod').val());" value="저장" />
            </div>
        </div>
    </div>
</div>
<script>

    $(document).ready(function () {

        $('#searchItems ul li').on('click',function(){
            let searchItem = $(this).attr('data');

            if(searchItem == "list_nm" || searchItem == "list_val"){
                $("#searchValue").val('');
                $('#searchValue').show();
                $('#typeArea').children().remove();
            } else if(searchItem == "def_yn"){
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
            }
        });
    });

    getMappingSettingList('1');

    // 매핑정보 저장 팝업 띄우기
    function mappingAddPopup() {
        $('.mappingAddPopup').addClass('active');
    }

    // 매핑정보 수정 팝업 띄우기
    function mappingRePopup(seq) {
        const res = function(response){
            let type = response.data.list_nm == "USR_KEY" ? '회원번호' : '수신번호'
            $("#list_nm_mod .value").html(type).attr("data",response.data.list_nm);
            $("#list_etc_mod").val(response.data.list_etc);
            $("#list_val_mod").val(response.data.list_val);
            $("#seq_mod").val(response.data.seq);
            $('.mappingRePopup').addClass('active');
        }
        let data = []
        data.push({name: 'seq', value: seq });
        com_ajax.ajax('post', '${baseURL}/sys/setting/detailLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 매핑정보 저장하기
    function saveMapping() {

        const res = function(response){
            let nowPageNo = $("#nowPageNo").val();
            $("#list_nm").val('');
            $("#list_val").val('');
            $("#errorArea1").html('');
            $('.mappingAddPopup').removeClass('active')
            getMappingSettingList(nowPageNo);
        }

        let data = []
        data.push({name : "list_nm" , value : $("#list_nm .value").attr("data").trim()})
        data.push({name : "list_val" , value : $("#list_val").val().trim()})

        com_ajax.ajax('post', '${baseURL}/sys/setting/insertMapping.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 중복 매핑정보 체크하기
    function checkMappingAddress() {

        let senderName = $("#list_nm .value").attr("data").trim();
        let senderNumber = $("#list_val").val().trim();

        if(senderName == '') {
            $("#errorArea1").html("Key를 입력해 주세요.")
            return false;
        }
        if(senderNumber == '') {
            $("#errorArea1").html('Value를 입력해 주세요.')
            return false;
        }

        const res = function(response) {
            if(response.status == true){
                saveMapping();
            }  else {
                $("#errorArea1").html('중복된 매핑정보 입니다.')
                return false;
            }
        }

        let data = {list_nm : senderName , list_val : senderNumber}
        console.log(data)
        com_ajax.ajax('post', '${baseURL}/sys/setting/isExistMapping.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 중복 매핑정보 수정 체크하기
    function checkMappingAddressModify(seq) {

        let senderName = $("#list_nm_mod .value").attr("data").trim();
        let senderNumber = $("#list_val_mod").val().trim();

        if(senderName == '') {
            $("#errorArea2").html("Type을 선택해 주세요.")
            return false;
        }
        if(senderNumber == '') {
            $("#errorArea2").html('Key를 입력해 주세요.')
            return false;
        }

        const res = function(response) {
            if(response.status == true){
                modifyMapping(seq);
            }  else {
                $("#errorArea2").html('중복된 매핑정보 입니다.')
                return false;
            }
        }

        let data = []
        data.push({name : "list_nm" , value : senderName} )
        data.push({name : "list_val" , value : senderNumber} )
        data.push({name : "seq" , value : seq} )
        com_ajax.ajax('post', '${baseURL}/sys/setting/isExistMappingModify.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 삭제 팝업
    let deleteEl, formatNum;
    function deleteAlert(el,seq) {
        deleteEl = el;
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">매핑정보 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">선택된 매핑정보를 삭제하시겠습니까?</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteMappingAddress('+ seq +');"  value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }

    // 매핑정보 리스트 가져오기
    function getMappingSettingList(page) {
        const res = function (response) {
            $("#mappingSettingList").html(response);
        };
        let data = [];
        data.push({name: 'pageNo', value: page});
        data.push({name: 'searchType', value: $("#searchType").val()});
        data.push({name: 'searchValue', value: $("#searchValue").val()});
        com_ajax.ajax('post', '${baseURL}/sys/setting/getMappingSettingList.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function enterSearch() {
        if(window.event.keyCode == 13){
            searchMappingSetting()
        }
    }

    // 매핑정보 리스트 검색하기
    function searchMappingSetting() {

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if(standard == 'def_yn') {
            let yn_data = $("#yn_select").attr('data');
            $("#searchValue").val(yn_data)
        }

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            if (standard == 'noti.NOTI_POPYN') {
                var selectData = document.querySelector('#selectData').getAttribute("data");
                $('#searchValue').val(selectData);
            }
            getMappingSettingList('1');
        }
    }

    // 문자 리스트 Y,N 값 변경하기
    function updateYnCheck(seq,list_nm,def_yn){
        const res = function(response){
            let pageNo = $("#nowPageNo").val();
            getMappingSettingList(pageNo)
            popup.searchAlert("변경되었습니다.");
        }

        let data = []
        data.push({name : "seq" , value : seq })
        data.push({name : "list_nm" , value : list_nm })
        data.push({name : "def_yn" , value : def_yn} )

        com_ajax.ajax('post', '${baseURL}/sys/setting/changeTypeDefYn.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');

    }


    // 삭제 처리
    function deleteMappingAddress(seq){
        let nowPage = $("#nowPageNo").val();

        const res = function(response) {
            $('.alert').removeClass('active');
            if(response.status == true){
                popup.popAlert("삭제 완료 되었습니다");
                getMappingSettingList(nowPage);
            }
        }
        let param = {seq : seq}
        com_ajax.ajax('post', '${baseURL}/sys/setting/deleteMapping.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        return false;
    }

    function modifyPopupClose() {
        $("#errorArea2").html('')
        $('.mappingRePopup').removeClass('active');
    }

    function modifyMapping(seq){

        let senderNm = $("#list_nm_mod .value").attr("data").trim();
        let senderNumber = $("#list_val_mod").val().trim();
        const pageNo = $("#nowPageNo").val();

        const res = function(response) {
            if(response.status == true) {
                popup.popAlert("수정이 완료 되었습니다.")
                $('#errorArea2').html('');
                $('.mappingRePopup').removeClass('active');
                getMappingSettingList(pageNo)
            }
        }

        let data = [];
        data.push({name: 'seq', value: seq});
        data.push({name: 'list_nm', value: senderNm});
        data.push({name: 'list_val', value: senderNumber});

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');

    }

</script>
