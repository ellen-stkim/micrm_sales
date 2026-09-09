<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
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
            </div>
        </div>
        <!-- row 영역 끝 -->
        <jsp:include page="settingTab.jsp" />
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">Marketing Cloud 설정</div>
                <div class="btn_col right">
                    <input type="button" value="수정" id="modifyBtn" class="btn_sm_line" onclick="mcModifyPopup();" />
                </div>
            </div>
            <!-- table 영역 시작 -->
            <table class="tableType2" summary="table">
                <colgroup>
                    <col width="240" />
                    <col width="*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">AUTH Base URI</th>
                    <td><span class="en_font">${cdMap['SALES_AUTH_URL']}</span></td>
                </tr>
                <tr>
                    <th scope="row">REST Base URI</th>
                    <td><span class="en_font">${cdMap['SALES_REST_URL']}</span></td>
                </tr>
                <tr>
                    <th scope="row">SOAP Base URI</th>
                    <td><span class="en_font">${cdMap['SALES_SOAP_URL']}</span></td>
                </tr>
                <tr>
                    <th scope="row">DE Row Count</th>
                    <td><span class="en_font">${cdMap['SALES_TOTAL']}</span></td>
                </tr>
                <tr>
                    <th scope="row">Client Id</th>
                    <td><span class="en_font">${cdMap['SALES_CID']}</span></td>
                </tr>
                <tr>
                    <th scope="row">Client Secret</th>
                    <td><span class="en_font">${cdMap['SALES_SEC']}</span></td>
                </tr>
                <tr>
                    <th scope="row">JWT</th>
                    <td><span class="en_font">${cdMap['SALES_JWT']}</span></td>
                </tr>
                </tbody>
            </table>
            <!-- table 영역 끝 -->
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

<div class="layer_pop mcModifyPopup">
    <div class="pop_container popup_size5">
        <input type="button" value="닫기" class="btn_pop_close" onclick="mcModifyPopupClose();" />
        <div class="pop_title">Marketing Cloud 설정 수정</div>
        <div class="pop_inner">
            <form action="" id="postForm1">
                <table class="pop_table_type1" summary="Marketing Cloud 설정 수정">
                    <colgroup>
                        <col width="180" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>AUTH Base URI</th>
                        <td><input type="text" id="SALES_AUTH_URL" value="${cdMap['SALES_AUTH_URL']}" placeholder="AUTH Base URI를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>REST Base URI</th>
                        <td><input type="text" id="SALES_REST_URL" value="${cdMap['SALES_REST_URL']}" placeholder="REST Base URI를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>SOAP Base URI</th>
                        <td><input type="text" id="SALES_SOAP_URL" value="${cdMap['SALES_SOAP_URL']}" placeholder="SOAP Base URI를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>DE Row Count</th>
                        <td><input type="text" id="SALES_TOTAL" value="${cdMap['SALES_TOTAL']}" placeholder="DE Count 조회 URL을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>Client Id</th>
                        <td><input type="text" id="SALES_CID" value="${cdMap['SALES_CID']}" placeholder="Client Id를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>Client Secret</th>
                        <td><input type="text" id="SALES_SEC" value="" placeholder="변경할 때만 입력해주세요. (미입력 시 기존 값 유지)" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>JWT</th>
                        <td><input type="text" id="SALES_JWT" value="" placeholder="변경할 때만 입력해주세요. (미입력 시 기존 값 유지)" class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="modifyMcSetting();" value="저장" />
            </div>
        </div>
    </div>
</div>
<script>

    // 인증 정보는 마스킹되어 있어 값을 채우지 않는다. 입력한 경우에만 변경된다.
    const MC_GRP_ID = ['SALES_AUTH_URL', 'SALES_REST_URL', 'SALES_SOAP_URL', 'SALES_TOTAL', 'SALES_CID', 'SALES_SEC', 'SALES_JWT'];

    function mcModifyPopup() {
        $('.mcModifyPopup').addClass('active');
    }

    function mcModifyPopupClose() {
        $('.mcModifyPopup').removeClass('active');
    }

    function modifyMcSetting() {
        const res = function(response) {
            popup.popAlertCallback("수정이 완료 되었습니다.", "window.location.reload();")
        }

        let data = [];
        MC_GRP_ID.forEach(function(grpId) {
            data.push({name : grpId, value : $("#" + grpId).val().trim()});
        });

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateMcSetting.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

</script>
