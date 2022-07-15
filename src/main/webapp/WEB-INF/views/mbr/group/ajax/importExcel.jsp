<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<!-- section 영역 시작 -->
<div class="section">
    <!-- 검색 결과 영역 시작 -->
    <div class="count border-bottom cf">
        <div class="total left">그룹 리스트</div>
    </div>
    <!-- table 영역 시작 -->
    <c:choose>
        <c:when test="${not empty list}">
            <table class="table rejection_tbl">
                <colgroup>
                    <col width="36"/>
                    <col width="*"/>
                    <col width="12%"/>
                    <col width="16%"/>
                    <col width="16%"/>
                    <col width="12%"/>
                    <col width="12%"/>
                </colgroup>
                <thead>
                <tr>
                    <th><label class="custom_check1 all"><input type="checkbox" name="checkAll"
                                                                id="checkAll"/><span></span></label>
                    </th>
                    <th>그룹명</th>
                    <th>타겟 수</th>
                    <th>생성일</th>
                    <th>수정일</th>
                    <th>사용여부</th>
                    <th>관리</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="group" items="${list}">
                    <tr>
                        <td><label class="custom_check1"><input type="checkbox" name="noArr" id="noArr"
                                                                value="${group.seq}"/><span></span></label></td>
                        <td class="en_font">${group.grp_nm}</td>
                        <td class="en_font">${group.grp_cnt}</td>
                        <td class="en_font">${group.reg_dt}</td>
                        <td class="en_font">${group.upd_dt}</td>
                        <td><input type="button" class="use_state en_font btn_state"
                                <c:if test="${group.use_yn eq 'Y'}"> value='Y'</c:if>
                                <c:if test="${group.use_yn eq 'N'}"> value='N'</c:if>
                                   onclick="updateGrpYorN('${group.seq}','${group.use_yn}')"
                        />
                        </td>
                        <td><a href="group.html" class="btn_sm_line">수정</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="fn_page"/>
                </ul>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table rejection_tbl">
                <colgroup>
                    <col width="36"/>
                    <col width="*"/>
                    <col width="12%"/>
                    <col width="16%"/>
                    <col width="16%"/>
                    <col width="12%"/>
                    <col width="12%"/>
                </colgroup>
                <thead>
                <tr>
                    <th><label class="custom_check1 all"><input type="checkbox"/><span></span></label></th>
                    <th>그룹명</th>
                    <th>타겟 수</th>
                    <th>생성일</th>
                    <th>수정일</th>
                    <th>사용여부</th>
                    <th>관리</th>
                </tr>
                </thead>
                <tbody>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <tr class="no_data">
                    <td colspan="7">입력된 정보가 없습니다.</td>
                </tr>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<!-- 삭제안내 팝업 영역 시작 -->
<div class="layer_pop deletePopup">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">삭제안내</div>
        <div class="pop_inner">
            <div class="alert_txt">
                <span id ="title"></span>
                그룹 리스트 <span class="length"></span>
                개의 그룹을 삭제하시겠습니까?<br/>
                복원이 불가합니다.
            </div>
            <input type="password" placeholder="비밀번호입력" name="password" class="password_input border"
                   id="deletePassword"/>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" id="deleteSave"
                       onclick="passwordReturn(document.getElementById('deletePassword').value);" value="확인">
                <input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소">
            </div>
        </div>
    </div>
</div>

<script>

    // 그룹 추가 유효성 검사
    function groupSave() {
        if ($('#groupName').val() == '') {
            $('#error').html('그룹명을 입력해주세요.');
            return false;
        }
        /*if ($('.file').val() == '') {
            $('#error').html('타겟 파일을 선택해주세요.');
            return false;
        }*/

        var res = function (response) {
            if (response.status === "success") {
                $('.groupPopup').removeClass('active');
                popup.popAlert("저장이 완료 되었습니다");

                getCampMbrList(${pageNo});
            } else {
                popup.popAlert("에러가 발생했습니다. 데이터를 확인해 주세요")
            }
            $("#groupName").val('');
            $("#targetFile").val('');
        }

        // grp_nm 값과 fileData 값을 같이 넘겨주기 위해 formData 사용
        var formData = new FormData();
        formData.append("grp_nm", $("#groupName").val());
        if($("#excelFileData")[0].files[0] != null){    // 임시 파일 넘기기용
            formData.append("excelFileData", $("#excelFileData")[0].files[0]);
        }
        com_ajax.ajax_file('${baseURL}/mbr/grpInsert.ajax', formData , res,'${_csrf.headerName}', '${_csrf.token}');
    }

    // 그룹 리스트 사용여부 변경
    function updateGrpYorN(seq, use_yn) {

        var res = function (response) {
            if (response.status === "success") {
                popup.popAlert(seq + "번의 사용여부가 변경되었습니다");
                getCampMbrList(${pageNo});
            }
        }
        var param = {seq: seq, use_yn: use_yn}
        com_ajax.ajax('post', '${baseURL}/mbr/updGrpState.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function deleteCheck() {

        var checkNoList = [];

        $("input[name='noArr']:checked").each(function () {
            checkNoList.push($(this).val());
        })

        var res = function (response) {
              getCampMbrList(${pageNo});
        }

        var param = {checkNoList: checkNoList}
        com_ajax.ajax('post', '${baseURL}/mbr/delGrpList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    function deleteAllGrp(){

        var res = function (response) {
            if (response.status === "success") {
                popup.popAlert("그룹 리스트가 전부 삭제되었습니다.");
                getCampMbrList(1);
            }
        }

        var param = $("#searchForm").serializeArray();

        com_ajax.ajax('post', '${baseURL}/mbr/delGrpListAll.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    //삭제 팝업
    function deletePopup() {

        let checkLength = $('.rejection_tbl .custom_check1').not('.all').find('input:checked').length;

        $('#title').text("선택된");
        $('.length').text(checkLength); // 체크된 게시글 카운트 구하기

        if(checkLength === 0){
            popup.popAlert('삭제할 회원을 선택해주세요.');
            return false;
        }

        $('.deletePopup').addClass('active');
        $('#deleteSave').attr('data', 'checkDel');
    }

    //전체 삭제 팝업
    function allDeletePopup() {

        var grpListCnt = ${listCnt}

        $('#title').text("전체");
        $('.length').text(grpListCnt); // 체크된 게시글 카운트 구하기

        $('.deletePopup').addClass('active');
        $('#deleteSaveAll').attr('data', 'all');
    }

</script>