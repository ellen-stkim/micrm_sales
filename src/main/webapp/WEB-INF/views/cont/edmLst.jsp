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
    <form:form id="edmListform" name="edmListform" method="post" onsubmit="return false">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>메세지</li>
                    <li>이메일</li>
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
            <div class="right">
                <!-- select 영역 시작 -->
                <div class="select style1 left-border" id="searchOption">
                    <!-- selected value -->
                    <div class="value searchSelect" id="searchSelect" data="">기준선택</div>
                    <!-- option -->
                    <ul class="option">
                        <li data="cont_nm">템플릿명</li>
                        <li data="cont_sub">제목</li>
                        <li data="use_yn">사용여부</li>
                    </ul>
                </div>
                <span id="target_area" class="left"></span>
                <input type="hidden" name="use_yn" id="use_yn" value=""/>
                <!-- select 영역 끝 -->
                <input type="hidden" name="searchType" id="searchType"/>
                <input type="text" class="searchInp left-border" id="searchValue" name="searchValue"  placeholder="검색어입력" onkeyup="enterSubmit();"/>
                <button type="button" class="searchBtn" onclick="return getEdmSearch();" >검색</button>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border cf">
            <div class="left">
                <a href="/cont/edmCreate.mi" class="btn_basic emailCreate left right-border">이메일 컨텐츠 생성</a>
                <input type="button" class="btn_basic delete left right-border"
                       onclick="deleteEdmList();" value="삭제"/>
            </div>
        </div>
    </form:form>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
    <form:form id="detailListform" name="detailListform" method="post">
        <c:choose>
            <c:when test="${not empty list}">
            <div class="section">
                <!-- list_container 영역 시작 -->
                <div class="list_container cf">
                    <div class="row_grid">
                        <!-- column 1단위 영역 시작 -->
                        <c:forEach var="item" items="${list}" varStatus="status">
                            <!-- column 1단위 영역 시작 -->
                            <div class="column <c:if test="${item.use_yn eq 'N'}">off</c:if>">
                                <!-- 비활성화 cover -->
                                <div class="hidden_cover"></div>
                                <div class="row_head cf">
                                    <!-- 체크박스 -->
                                    <label class="custom_check1"><input type="checkbox" value="${item.seq}" name="list"/><span></span></label>
                                    <!-- 템플릿명 -->
                                    <h3>${item.cont_nm}</h3>
                                    <div class="remove_info">
                                        <input type="button" value="${item.use_yn}" class="en_font useState"  onclick="useState('${item.seq}', this);"/>
                                        <a href="#" onclick="detailEdm('${item.seq}');">수정</a>
                                    </div>
                                </div>
                                <div class="row_top cf">
                                    <!-- 컨텐츠 type -->
                                    <div class="contents_type">
                                        <c:if test="${item.send_tp eq 'SENDTP01'}">광고</c:if>
                                        <c:if test="${item.send_tp eq 'SENDTP02'}">안내</c:if>
                                    </div>
                                    <!-- 제목 -->
                                    <h4>${item.cont_sub}</h4>
                                </div>
                                <div class="row_body">
                                    <!-- edm 이미지 영역 -->
                                    <div class="edm">
                                             <img src='${filePath}${item.thm_url}' alt=""  onerror="this.src = '/image/bg_none_wide.png'">
                                    </div>
                                </div>
                                <div class="row_footer">
                                    <!-- 수정일 -->
                                    <div class="date">수정일&nbsp;&nbsp;
                                        <span>
                                            <c:choose>
                                                <c:when test="${cutil:isEmptyObject(item.upd_dt)}"> ${cutil:stringDateParse(item.reg_dt)}</c:when>
                                                <c:otherwise>${cutil:stringDateParse(item.upd_dt)}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <!-- 등록일 -->
                                    <div class="date">등록일
                                        <span>
                                             ${cutil:stringDateParse(item.reg_dt)}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        </div>
                            <!-- list_container 영역 끝 -->
                            <span id="pageBtn">
                                 <c:if test="${nextCk eq true}">
                                     <div class="btn_more" onclick="getEdmList('${pageNo}');"><img src="/image/bullet_arrw1.png" alt=""/>더보기</div>
                                 </c:if>
                            </span>
                    </div>
                <!-- section 영역 끝 -->
            </div>
            </c:when>
            <c:otherwise>
                <%--없을경우--%>
                <div class="none list_ht bottom-border">
                    조회된 결과가 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
        <input type="hidden" name="seq" id="seq"/>
    </form:form>
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

    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            getEdmSearch();
        }
        return false;
    }

    function getEdmList(page) {
        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').append($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };
        var param = $("#edmListform").serializeArray();
        param.push({name : 'pageNo', value : parseInt(page) +1});
        com_ajax.ajax('post', '${baseURL}/cont/getEdmList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function getEdmSearch() {
        let standard = $('#searchSelect').attr('data');
        let searchValue = $('#searchValue').val().trim();

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            getEdbListNew('1');
        }
    }
    function getEdbListNew(pageNo) {
        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').html($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };
        $("#use_yn").val($('#useYnVal').attr('data'));
        var param = $("#edmListform").serializeArray();
        param.push({name : 'pageNo', value : pageNo});
        com_ajax.ajax('post', '${baseURL}/cont/getEdmList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    //이메일 컨텐츠 삭제
    function deleteEdmList(){
        let checkbox = document.getElementsByName("list");
        let checkboxLength = checkbox.length;
        let count = 0;
        for(let a=0; a < checkboxLength; a++){
            if(checkbox[a].checked){
                count++;
            }
        }
        if(count == 0){
            popup.deleteAlert('false', "삭제할 컨텐츠를 선택해주세요.");

        }else {
            deleteEdmCheck('true', count + "개의 컨텐츠를 삭제하시겠습니까?");
        }

    }

    function deleteEdmCheck(promptState, deleteTxt) {
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
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteEdm();" value="확인" />' +
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
    function deleteEdm() {
        var nowPage;
        var res = function (response) {
            if (response.message >0) {
                popup.popAlert("삭제되었습니다.");
                popupClose($('.btn_size2'));
            } else {
                popup.popAlert("삭제도중 오류가 발생하였습니다. 관리자에게 문의해주세요.");
            }
            getEdbListNew(nowPage);
        };
        nowPage = ${pageNo};
        var checkList = [];
        var checkLength = $('.custom_check1 input[name=list]:checked').length;
        for(var i=0; i<checkLength; i++){
            checkList.push($('.custom_check1 input[name=list]:checked').eq(i).val());
        }
        var param = {checkList: checkList};
        com_ajax.ajax('post', '${baseURL}/cont/deleteEdmList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    function useState(seq, thisVal){
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
                $(thisVal).val(response.list.use_yn);
                if (response.list.use_yn == 'Y') {
                    $(thisVal).parents('.column').removeClass('off');
                }else{
                    $(thisVal).parents('.column').addClass('off');
                }
            }
        };
        var param = {seq : seq, use_yn : useValue};
        com_ajax.ajax('post', '${baseURL}/cont/updateEdmYn.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
    //상세페이지
    function detailEdm(seqNo) {
        $('#seq').val(seqNo);
        $('#detailListform').attr('action','${baseURL}/cont/edmDetail.mi');
        $('#detailListform').submit();
    }

    $("#searchOption ul li").on('click',function(){
        let thisData = $(this).attr('data');
        console.log(thisData);
        if(thisData === "use_yn"){
            $('#searchValue').hide();
            $('#searchValue').val("");
            $('#target_area').html(
                '<div class="select style1 left-border right-border" id="useOption">' +
                '<div class="value searchSelect searchTarget" id="useYnVal" data="Y">Y</div>' +
                '<ul class="option">' +
                '<li data="Y">Y</li>' +
                '<li data="N">N</li>' +
                '</ul>' +
                '</div>'
            );

        }else{
            $('#searchValue').show();
            $('#target_area').find('#useOption').remove();
            $('#usr_yn').val("");
        }
    });

</script>
