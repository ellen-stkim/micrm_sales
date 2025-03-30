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
                        <li>알림톡 템플릿</li>
                    </ul>
                </div>
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border" id="searchItems">
                        <!-- selected value -->
                        <div class="value searchSelect" data="" >기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="tmpl_nm">템플릿명</li>
                            <%--<li data="chan_id">채널명</li>--%>
                            <li data="kep_status">검수상태</li>
                            <li data="use_yn">휴면상태</li>
                            <li data="tmpl_status">템플릿상태</li>
                        </ul>
                    </div>
                    <div class="left" id="typeArea"></div>
                    <input type="hidden" name="searchType" id="searchType"/>
                    <!-- select 영역 끝 -->
                    <input type="text" class="searchInp left-border" name="searchValue" id="searchValue" placeholder="검색어입력"/>
                    <%-- 검수 상태--%>
                    <span id="kep_st_area" class="left" name="subOption" hidden>
                        <div class="select style1 left-border right-border">
                            <div class="value searchSelect searchTarget">${kepSt[0].cd_desc}</div>
                            <ul class="option">
                                <c:forEach var="kep_st" items="${kepSt}">
                                    <li data="${kep_st.cd_val}">${kep_st.cd_desc}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </span>
                    <%--  휴면상태  --%>
                    <span id="use_yn_area" class="left" name="subOption" hidden>
                        <div class="select style1 left-border right-border">
                            <div class="value searchSelect searchTarget">휴면해제</div>
                            <ul class="option">
                                <li data="N">휴면해제</li>
                                <li data="Y">휴면</li>
                            </ul>
                        </div>
                    </span>
                    <%--  템플릿상태  --%>
                    <span id="tmpl_st_area" class="left" name="subOption" hidden>
                        <div class="select style1 left-border right-border">
                            <div class="value searchSelect searchTarget">${tmplSt[0].cd_desc}</div>
                            <ul class="option">
                                 <c:forEach var="tmpl_st" items="${tmplSt}">
                                     <li data="${tmpl_st.cd_val}">${tmpl_st.cd_desc}</li>
                                 </c:forEach>
                            </ul>
                        </div>
                    </span>

                    <input type="submit" class="searchBtn" value="검색" onclick="return searchMobileList();"/>
                </div>
            </form:form>
        </div>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border cf">
            <div class="left">
                <form:form action="./kko/tmplCreate.mi" method="post" style="float: left;">
                    <input type="submit" class="btn_basic smsCreate left right-border" value="알림톡 템플릿 생성"/>
                </form:form>
                <input type="button" class="btn_basic delete left right-border" onclick="deleteMobileList('campaign','');" value="삭제">
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
                <c:if test="${nextCk eq true}">
                    <div class="btn_more" onclick="getMobileListAdd();">
                        <img src="/image/bullet_arrw1.png" alt="" />더보기
                    </div>
                </c:if>
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

<form:form id="extentionForm" method="post" target="_blank">
    <input type="hidden" id="extId" name="extId" value="" />
</form:form>

<script>
    $(function () {
        selectMobileList(1);
    });

    $(document).on('click', '.useState', function () {
        let state = $(this).val();
        if (state == 'Y') {
            $(this).val('N');
            $(this).parents('.column').addClass('off');
        } else {
            $(this).val('Y');
            $(this).parents('.column').removeClass('off');
        }
    });

    $(function () {
        // 검색 타입 별
        $('#searchItems ul li').on('click', function () {
            let searchItem = $(this).attr('data');
            if (searchItem == "tmpl_nm" || searchItem == "chan_id") {
                $("#searchValue").val('');

                $('#searchValue').show();

                $("#kep_st_area").hide();
                $("#use_yn_area").hide();
                $("#tmpl_st_area").hide();

            } else if (searchItem == "kep_status") {
                $('#kep_st_area').show();

                $("#searchValue").hide();
                $("#use_yn_area").hide();
                $("#tmpl_st_area").hide();
                $("#searchValue").val('${kepSt[0].cd_val}');
            } else if (searchItem == 'use_yn') {
                $('#use_yn_area').show();

                $("#searchValue").hide();
                $("#kep_st_area").hide();
                $("#tmpl_st_area").hide();
                $("#searchValue").val('Y');
            } else if (searchItem == "tmpl_status") {
                $('#tmpl_st_area').show();

                $("#searchValue").hide();
                $("#kep_st_area").hide();
                $("#use_yn_area").hide();

                $("#searchValue").val('${tmplSt[0].cd_val}');
            }
        });

        // 검수 | 휴면 | 탬플릿 상태 옵션 선택시 searchValue에 데이터 넣어주기
        $(document).on('click','[name="subOption"]  ul li',function(){
            let data = $(this).attr("data");
            $('#searchValue').val(data);
            console.log($('#searchValue').val());
        });
    })



    // 리스트 출력하기
    function selectMobileList(pageNo) {
        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();
        /*
        if (standard == 'use_yn') {
            let yn_data = $("#yn_select").attr('data');
            $("#searchValue").val(yn_data)
        }
        */
        let res = function (response) {
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').html($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };

        let param = $("#searchForm").serializeArray();
        param.push({name: 'pageNo', value: pageNo});
        com_ajax.ajax('post', '${baseURL}/cont/kko/atTmplLst.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 리스트 버튼으로 추가 가져오기
    function getMobileListAdd(pageNo) {
        let res = function (response) {
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').append($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };
        let param = $("#searchForm").serializeArray();
        param.push({name: 'pageNo', value: parseInt(pageNo) + 1});
        com_ajax.ajax('post', '${baseURL}/cont/kko/atTmplLst.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 모바일 리스트 삭제 처리
    function deleteMobileList() {
        let count = $('.custom_check1').not('.all').find('input:checked').length;
        if (count == 0) {
            deleteMobilePopUp('false', "삭제할 컨텐츠를 선택해주세요.");
        } else {
            deleteMobilePopUp('true', count + "개의 컨텐츠를 삭제하시겠습니까?");
        }
    }

    // 삭제 팝업 띄우기
    function deleteMobilePopUp(promptState, deleteTxt) {
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
    function deleteMobile() {
        let nowPage = $("#nowPageNo").val();
        let checkList = [];
        let checkLength = $('.custom_check1 input[name="tmpl_cd"]:checked').length;

        let res = function (response) {
            if (response.status == "true") {
                popup.popAlert("삭제 되었습니다");
            } else {
                popup.popAlert("삭제도중 오류가 발생하였습니다. 관리자에게 문의해주세요.");
            }
            $('#deleteAllPop').removeClass('active');
            selectMobileList(nowPage)
        }
        for (var i = 0; i < checkLength; i++) {
            checkList.push($('.custom_check1 input[name="tmpl_cd"]:checked').eq(i).val());
        }
        let param = {checkList: checkList};
        com_ajax.ajax('post', '${baseURL}/cont/kko/updateDelYn.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 모바일 리스트 가져오기
    function searchMobileList() {

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $('#searchType').val(standard);
        selectMobileList('1');
    }

    // 컨텐츠 사용여부 변경 event
    function updateUseState(seq, thisVal) {
        var state = $(thisVal).val();
        var useValue = "";
        if (state == "Y") {
            useValue = "N";
        } else {
            useValue = "Y";
        }
        var res = function (response) {
            if (response.message > 0) {
                //popup.popAlert("변경되었습니다.");
                $(thisVal).val(response.list[0].use_yn);
                if (response.list[0].use_yn == 'Y') {
                    $(thisVal).parents('.column').removeClass('off');
                } else {
                    $(thisVal).parents('.column').addClass('off');
                }
            }
        };
        var param = {seq: seq, use_yn: useValue};
        com_ajax.ajax('post', '${baseURL}/cont/kko/updateUseYn.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    let type = ['kakao', 'MMS', 'SMS', 'rcsText', 'rcsHorizontalLeft', 'rcsHorizontalRight', 'rcsVerticalTall', 'rcsVerticalMedium', 'rcsSlideSmall', 'rcsSlideMedium'];
    function updAtTmpl(seq){
        $("#extentionForm").attr("action", "/cont/kko/tmplDetail.mi?seq="+seq);
        $('#extentionForm').submit();
    }
</script>