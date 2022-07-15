<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<script src="/js/imageUpload.js"></script>
<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <form:form id="imgListform" name="imgListform" method="post" onsubmit="return false">
            <!-- row 영역 시작 -->
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>메세지</li>
                        <li>이미지 파일</li>
                    </ul>
                    <!-- tooltip 버튼 영역  -->
<%--                    <div class="tooltip_icon">--%>
<%--                        <img src="/image/ico_tooltip.png" alt="Tooltip" />--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 시작 -->
<%--                    <div class="tooltip_box">--%>
<%--                        <!-- tooltip bullet 영역 -->--%>
<%--                        <div class="bullet"></div>--%>
<%--                        <span class="bold">--%>
<%--                            2019년 12월 신규 취급액은 91.6억 중,<br />--%>
<%--                            나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                            차지합니다.</span>--%>
<%--                            스타일론 직장인이 26.69억(29.1%), <br />--%>
<%--                            스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 끝 -->
                </div>
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border">
                        <!-- selected value -->
                        <div class="value searchSelect" data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="img.IMG_NM">이미지명</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <input type="hidden" name="searchType" id="searchType"/>
                    <input type="text" class="searchInp left-border" id="searchValue" name="img_nm" placeholder="검색어입력" />
                    <input type="submit" class="searchBtn" value="검색" onclick="return getImgSearch();" />
                </div>
            </div>
            <!-- row 영역 끝 -->
            <!-- row 영역 시작 -->
            <div class="row bottom-border cf">
                <div class="left">
                    <a href="javascript:void(0);" class="btn_basic imageCreate left right-border"
                       onclick="imgUploadPop();">새 이미지 파일 업로드</a>
                    <input type="button" class="btn_basic delete left right-border"
                           onclick="deleteImgList();" value="삭제" />
                </div>
            </div>
            <!-- row 영역 끝 -->
            <!-- section 영역 시작 -->
            <c:choose>
                <c:when test="${not empty list}">
                <div class="section">
                    <!-- list_container 영역 시작 -->
                        <div class="list_container cf">
                            <div class="row_grid">
                                <!-- column 1단위 영역 시작 -->
                                <c:forEach var="item" items="${list}" varStatus="status">
                                <div class="column image_column <c:if test="${item.use_yn eq 'N'}">off</c:if>">
                                    <!-- 비활성화 cover -->
                                    <div class="hidden_cover"></div>
                                    <div class="img_head bg_color cf">
                                        <!-- 체크박스 -->
                                        <label class="custom_check1"><input type="checkbox" value="${item.seq}"
                                                                            name="list" /><span></span></label>
                                        <!-- 이미지 타입 -->
                                        <div class="image_type">${item.cd_nm}</div>
                                    </div>
                                    <div class="img_head cf">
                                        <!-- 이미지명 -->
                                        <h3>${item.img_nm}</h3>
                                        <div class="remove_info">
                                            <input type="button" value="${item.use_yn}" class="en_font useState right-border" name="use_yn" onclick="useState('${item.seq}', this);"/>
                                                <%-- <span  onclick="updateImg('${item.seq}')">수정</span>--%>
                                        </div>
                                    </div>
                                    <div class="row_body">
                                        <!-- 예시 이미지 영역 -->
                                        <div class="image_box">
                                            <img src="${filePath}${item.img_url}" alt="" onerror="this.src = '/image/bg_none.png'">
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
                        </div>
                        <!-- list_container 영역 끝 -->
                    <span id="pageBtn">
                        <c:if test="${nextCk eq true}">
                            <div class="btn_more" onclick="getImgList('${pageNo}');"><img src="/image/bullet_arrw1.png" alt="" />더보기</div>
                        </c:if>
                        <input type="hidden" name="nowPageNo" id="nowPageNo" value="${pageNo}"/>
                        <input type="hidden" name="nowPage" id="nowPage" value="${page}"/>
                    </span>
                </div>
                </c:when>
                <c:otherwise>
                    <div class="section">
                        <!-- list_container 영역 시작 -->
                        <div class="list_container cf">
                            <div class="row_grid">
                                <div class="none list_ht bottom-border">
                                    조회된 결과가 없습니다.
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        <!-- section 영역 끝 -->
         </div>
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

<!-- 새 이미지 파일 업로드 팝업 영역 시작 -->
<form:form id="form" name="form" method="post" onsubmit="return false" enctype="multipart/form-data">
    <span id="imgListHtml">
    </span>
</form:form>
<!-- 새 이미지 파일 업로드 팝업 영역 끝 -->
<!-- image upload js -->

<script>
    function imgUploadPop() {
        var html ='<div class="layer_pop uploadPopup active">'+
            '<div class="pop_container popup_size1">'+
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />'+
            '<div class="pop_title">새 이미지 파일 업로드</div>'+
            '<div class="pop_inner">'+
            '<table class="pop_table_type1">'+
            '<colgroup>'+
            '<col width="103" />'+
            '<col width="*" />'+
            '</colgroup>'+
            '<tbody>'+
            '<tr>'+
            '<th>채널</th>'+
            '<td>'+
            '<label class="custom_radio">모바일<input name="ch_tp" type="radio" value="IMGTP02" checked><span></span></label>'+
            '<label class="custom_radio">카카오<input name="ch_tp" type="radio" value="IMGTP03"><span></span></label>'+
            '<label class="custom_radio">이메일<input name="ch_tp" type="radio" value="IMGTP01"><span></span></label>'+
            '<label class="custom_radio">RCS<input name="ch_tp" type="radio" value="RCS"><span></span></label>'+
            '</td>'+
            '</tr>'+
            '<tr class="rcsImgForm rcs_option">'+
            '<th>양식</th>'+
            '<td>'+
            '<div class="select style1 rcs_select">'+
            '<div class="value" data="">RCS 양식 선택</div>'+
            '<ul class="option">'+
            '<li data="0">RCS 양식 선택</li>'+
            '<li data="IMGTP04">가로형</li>'+
            '<li data="IMGTP05">세로형 / Tall</li>'+
            '<li data="IMGTP06">세로형 / Medium</li>'+
            '<li data="IMGTP07">슬라이드형 / Small</li>'+
            '<li data="IMGTP08">슬라이드형 / Medium</li>'+
            '</ul>'+
            '</div>'+
            '</td>'+
            '</tr>'+
            '<tr>'+
            '<th>이미지 명</th>'+
            '<td>'+
            '<input type="text" placeholder="이미지 명을 입력해주세요." id="img_nmCk" name="img_nm" class="input_type1" />'+
            '</td>'+
            '</tr>'+
            '<tr>'+
            '<th>이미지 파일</th>'+
            '<td>'+
            '<input type="text" id="fileName" name="fileName" class="input_file" placeholder="이미지 파일을 선택해주세요." readonly />'+
            '<span class="btn_file">파일 선택<input type="file" class="file" id="file"/></span>'+
            '</td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'+
            '<ul class="guide_txt">'+
            '<li class="on">※ 가로형 : 1MB 이하</li>'+
            '<li>※ 세로형 : ① Tall : 568 X 528 (1MB 이하), ② Medium : 568 X 336 (1MB 이하)</li>'+
            '<li>※ 슬라이드형 : ① Small : 360 X 336, ② Medium : 696 X 504, 최대 사이즈 360 X 1569 , 1MB 이하</li>'+
            '</ul>'+
            '<div class="left pop_error_txt other_guide">※ 모바일 : Jpg, png(200KB 이하), 이메일 : jpg, png, gif</div>'+
            '<div class="right pop_error_txt blue_point_color"></div>'+
            '<div class="img_viewer noImg"></div>'+
            '<div class="btn_row">'+
            '<input type="button" class="btn_bg btn_size2 btn_center uploadSave" onclick="saveContentImg();" value="저장" />'+
            '</div>'+
            '</div>'+
            '</div>'+
            '</div>';
        $("#imgListHtml").html(html);
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
                $(thisVal).val(response.list[0].use_yn);
                if (response.list[0].use_yn == 'Y') {
                    $(thisVal).parents('.column').removeClass('off');
                }else{
                    $(thisVal).parents('.column').addClass('off');
                }
            }
        };
        var param = {seq : seq, use_yn : useValue};
        com_ajax.ajax('post', '${baseURL}/cont/updateImgYn.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function saveContentImg() {
        var imgNm = $("#img_nmCk").val();
        if(imgNm == "" || imgNm == null){
            popup.popAlert("이미지명을 입력해주세요.");
            return false;
        }
        if( $("#file").val() == "" ||  $("#file").val() == null){
            popup.popAlert("업로드된 파일이 없습니다.");
            return false;
        }

        var res = function(response){
            //TO-DO
            //리스트 새로 불러오기
            if(response.imgCheck == 0){
                popup.popAlert(response.imgCheckErr);
                return false;
            }
            popup.popAlert(response.message);
            $('.uploadPopup').removeClass('active');
            $("#form")[0].reset();
            $("#file").val();
            $(".img_viewer").children().remove();
            $(".img_view").addClass('noImg');
            getImgListNew('1');
        };

        var data = new FormData();
        data.append("file", $("#file")[0].files[0]);
        var ch_tp = $("input[name=ch_tp]:checked").val();
        if(ch_tp == 'RCS') {
            data.append("ch_tp", $('.rcs_select .value').attr('data'));
        }else{
            data.append("ch_tp", ch_tp);
        }
        data.append("img_nm", imgNm);

        com_ajax.ajax_file('${baseURL}/cont/contentUpload.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    //리스트 가져오기
    function getImgList(page) {
        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').append($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };
        var param = $("#imgListform").serializeArray();
        param.push({name : 'pageNo', value : parseInt(page) +1});
        com_ajax.ajax('post', '${baseURL}/cont/getImgList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function getImgSearch() {
        let standard = $('.searchSelect').attr('data');
        let searchValue = $('#searchValue').val().trim();

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            getImgListNew('1');
        }
    }

    function getImgListNew(pageNo) {
        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').html($("#body", $doc).html());
            $("#pageBtn").html($("#pageHtml", $doc).html());
        };
        var param = $("#imgListform").serializeArray();
        param.push({name : 'pageNo', value : pageNo});
        com_ajax.ajax('post', '${baseURL}/cont/getImgList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        return false;
    }

    function deleteImgList(){
        let checkbox = document.getElementsByName("list");
        let checkboxLength = checkbox.length;
        let count = 0;
        for(let a=0; a < checkboxLength; a++){
            if(checkbox[a].checked){
                count++;
            }
        }
        if(count == 0){
            popup.deleteAlert('false', "삭제할 이미지를 선택해주세요.");

        }else {
            deleteImgCheck('true', count + "개의 이미지를 삭제하시겠습니까?");
        }

    }

      function deleteImgCheck(promptState, deleteTxt) {
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
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteImg();" value="확인" />' +
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
    function deleteImg() {
       var nowPage;
       var res = function (response) {
           if (response.message >0) {
               popup.popAlert("삭제되었습니다.");
               popupClose($('.btn_size2'));
           } else {
               popup.popAlert("삭제도중 오류가 발생하였습니다. 관리자에게 문의해주세요.");
           }
           $('#deleteAllPop').removeClass('active');
           getImgListNew(nowPage);
       };
        nowPage = ${pageNo};
        var checkList = [];
        var checkLength = $('.custom_check1 input[name=list]:checked').length;
        for(var i=0; i<checkLength; i++){
            checkList.push($('.custom_check1 input[name=list]:checked').eq(i).val());
        }
        var param = {checkList: checkList};
        com_ajax.ajax('post', '${baseURL}/cont/deleteImgList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

    }
    //상세페이지
    function updateImg(seq) {
        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $("#imgListHtml").html($("#body", $doc).html());
            $('.uploadPopup').addClass('active');
        };
        var param = $("#form").serializeArray();
        param.push({name : 'seq', value : seq});
        com_ajax.ajax('post', '${baseURL}/cont/updateImg.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function updateContentImg() {
        var seqNo = $("input[name=seq]").val();
        var baseUrl = '${baseURL}';
        var res = function(response){
            if(response.uploaded>0){
                var regDt= moment(response.list[0].reg_dt).format('YYYY.MM.DD HH:mm');
                var updDt= moment(response.list[0].upd_dt).format('YYYY.MM.DD HH:mm');
                var html ='<div class="hidden_cover"></div>'+
                    '<div class="img_head bg_color cf">'+
                    '<label class="custom_check1"><input type="checkbox" value="'+response.list[0].seq+' name="list" /><span></span></label>'+
                    '<div class="image_type">'+response.list[0].cd_nm +'</div>'+
                    '</div>'+
                    '<div class="img_head cf">'+
                    '<h3>'+response.list[0].img_nm+'</h3>'+
                    '<div class="remove_info">'+
                    '<input type="button" value="'+response.list[0].use_yn+'" class="en_font useState" name="use_yn" onclick="useState(\''+response.list[0].seq+'\', this);"/>'+
                    '<span  onclick="updateImg(\''+response.list[0].seq+'\')">수정</span>'+
                    '</div>'+
                    '</div>'+
                    '<div class="row_body">'+
                    '<div class="image_box">'+
                    '<img src="'+baseUrl+'/'+response.list[0].img_url+'" alt="">'+
                    '</div>'+
                    '</div>'+
                    '<div class="row_footer">'+
                    '<div class="date">수정일&nbsp;&nbsp;<span>'+
                    updDt+
                    '</span>'+
                    '</div>'+
                    '<div class="date">등록일'+
                    regDt+
                    '<span>'+
                    '</span>'+
                    '</div>'+
                    '</div>';
                $("input:checkbox[name=list]:checkbox[value='"+seqNo+"']").parents('.column').html(html);
            }
            //TO-DO
            //리스트 새로 불러오기
            popup.popAlert(response.message);
            $('.uploadPopup').removeClass('active');
            $("#form")[0].reset();
            $("#file").val();
            $(".img_viewer").children().remove();
            $(".img_view").addClass('noImg');
            //getImgListNew('1');
        };
        var data = new FormData();
        data.append("file", $("#file")[0].files[0]);
        data.append("img_nm", $("input[name=img_nm]").val());
        data.append("seq", seqNo);
        com_ajax.ajax_file('${baseURL}/cont/updateContentImg.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }
</script>
