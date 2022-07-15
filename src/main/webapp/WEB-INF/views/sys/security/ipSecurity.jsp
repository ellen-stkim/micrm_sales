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
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
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
                    <li>보안</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
                <div class="tooltip_icon">
                    <img src="../../image/ico_tooltip.png" alt="Tooltip"/>
                </div>
                <!-- tooltip box 영역 시작 -->
                <div class="tooltip_box">
                    <!-- tooltip bullet 영역 -->
                    <div class="bullet"></div>
                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br/>
                                나오론이 52.4억(57.2%)으로 가장 많은 비중을
                                차지합니다.</span>
                    스타일론 직장인이 26.69억(29.1%), <br/>
                    스타일론 자영업자가 4.1억(4.47%)입니다.<br/>
                </div>
                <!-- tooltip box 영역 끝 -->
            </div>
            <form:form id="searchBlockList" method="post" onsubmit="return false">
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border">
                        <!-- selected value -->
                        <div class="value searchSelect" data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="block_target">IP</li>
                            <li data="block_type">차단 주체</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <input type="text" class="searchInp left-border searchWord" id="searchWord" placeholder="검색어입력"
                           onkeyup="enterSubmit();"/>
                    <input type="button" class="searchBtn" value="검색" onclick="return searchBlockList();"/>
                    <input type="hidden" id="searchType" value=""/>
                    <input type="hidden" id="searchValue" value=""/>
                </div>
            </form:form>
        </div>
        <!-- row 영역 끝 -->
        <div class="tab_row">
            <!-- Tab menu -->
            <div class="on"><a href="/sys/security/ipSecurity.mi">IP 차단</a></div>
            <div><a href="/sys/security/userLog.mi">사용자 로그</a></div>
            <!-- 차단 IP 입력 -->
            <div class="ip_box">
                <input type="text" placeholder="차단 IP 입력" id="ipValue"/>
                <input type="button" value="추가" class="btn_ip"/>
            </div>
        </div>
        <!-- section 영역 시작 -->
        <span id="listHtml">
            <div class="section">
                <!-- 검색 결과 영역 시작 -->
                <div class="count border-bottom cf">
                    <div class="total left">차단 리스트</div>
                </div>
                <!-- 검색 결과 영역 끝 -->
                <!-- table 영역 시작 -->
                <c:choose>
                    <c:when test="${not empty list}">
                        <table class="table">
                            <colgroup>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>IP</th>
                                <th>등록자</th>
                                <th>차단 로그</th>
                                <th>차단 주제</th>
                                <th>등록일</th>
                                <th>해제</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="n" items="${list}" varStatus="status">
                                <tr>
                                   <td class="en_font">${n.block_target}</td>
                                    <td class="en_font">${n.block_reg_id}</td>
                                    <td></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${n.block_type eq '1'}">시스템차단</c:when>
                                            <c:when test="${n.block_type eq '2'}">사용자 등록</c:when>
                                        </c:choose>
                                    </td>
                                    <td class="en_font">
                                        <c:if test="${!cutil:isEmptyObject(n.reg_dt)}"> ${cutil:stringDateParse(n.reg_dt)}</c:if>
                                    </td>
                                    <td>
                                        <sec:authentication property="name" var="usrId"/>
                                        <c:choose>
                                            <c:when test="${n.block_status eq '0'}">
                                                <c:if test="${usrId eq n.block_reg_id}">
                                                    <input type="button" class="btn_sm_line btn_inline size" value="해제 요청" onclick="blockPopup('${n.block_target}', '${n.seq}');"/>
                                                </c:if>
                                            </c:when>
                                            <c:when test="${n.block_status eq '1'}">
                                                <c:if test="${usrId eq n.block_reg_id}">
                                                <input type="button" class="btn_sm_line btn_inline size" value="취소" onclick="updateBlock('${n.block_target}', '${n.seq}', '0');"/>
                                                </c:if>
                                                <span class="req_status">요청 진행 중</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <!-- 검색 결과가 없는 경우 영역 시작 -->
                            <!-- <tr class="no_data">
                                    <td colspan="6">조회된 결과가 없습니다.</td>
                                 </tr> -->
                            <!-- 검색 결과가 없는 경우 영역 시작 -->
                            </tbody>
                        </table>
                        <div class="btn_row bottom-border">
                            <ul class="pager">
                                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getBlockList"/>
                            </ul>
                        </div>
                        <!-- table 영역 끝 -->
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <colgroup>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                                <col width="16.6%"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>IP</th>
                                <th>등록자</th>
                                <th>차단 로그</th>
                                <th>차단 주제</th>
                                <th>등록일</th>
                                <th>해제</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr class="no_data">
                                <td colspan="6">조회된 결과가 없습니다.</td>
                            </tr>
                            </tbody>
                        </table>
                        <div class="btn_row bottom-border">
                            <ul class="pager">
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
                <!-- table 영역 끝 -->
            </div>
        <!-- section 영역 끝 -->
        </span>
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

<!-- IP 차단 해제 요청 팝업 영역 시작 -->

<!-- IP 차단 해제 요청 팝업 영역 끝 -->

<script>
    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchBlockList();
        }
        return false;
    }

    // IP 유효성 체크
    function ipCheck() {
        let ip = document.getElementById('ipValue').value;
        let ipReg = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
        let html = '';

        if (ip == '' || ip == undefined) {
            popup.popAlert('IP를 입력해주세요.');
        } else {
            if (!ipReg.test(ip)) {
                popup.popAlert('IP가 IPv4 규칙에 어긋납니다.<br/>IP를 확인해주세요.');
            } else {
                // IP등록
            }
        }
    }

    // 해제 사유 Byte
    function byteCount(text) {
        let textarea = text.value;
        let newText = new String(textarea);
        let textLength = newText.length;
        let strignAt;
        let count = 0;
        let code = event.keyCode;

        for (let a = 0; a < textLength; a++) {
            strignAt = newText.charAt(a);
            if (escape(strignAt) == '%0D') {
            } else if (escape(strignAt).length > 4) {
                count += 2;
            } else {
                count++;
            }
        }
        if (code != 8 && count > 100) {
            document.getElementById('errorArea').innerHTML = '해제 사유를 100byte 이하로 입력해주세요.';
        } else {
            document.getElementById('errorArea').innerHTML = '';
        }
        document.getElementById('byte').innerHTML = count;
    }

    // IP 차단 해제 요청 팝업 확인 버튼 click event
    function reasonValidation(button) {
        let reason = document.getElementById('reason').value;
        if (reason == '') {
            document.getElementById('errorArea').innerHTML = '사유를 입력하세요.';
        } else {
            popupClose(button);
            return true;
        }
    }

    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchBlockList();
        }
        return false;
    }

    function blockPopup(ip, blockNo) {
        $('.layer_pop.blockPopup').remove();
        let html = '';
            html += '<div class="layer_pop blockPopup active">'
                +'<div class="pop_container popup_size1">'
                +'<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>'
                +'<div class="pop_title">IP 차단 해제 요청</div>'
                +'<div class="pop_inner">'
                +'<div class="phrases">'
                +'시스템에 의해 자동으로 차단된 IP와 타 사용자가 요청해서 차단된 IP의 차단은 차단 신청 및<br/>'
                +'사유 검토 후 차단 해제 처리를 진행하고 있습니다.<br/><br/>'
                +'특히, 차단이 해제되어도 동일한 이유로 다시 해당 IP가 차단될 수도 있습니다.<br/>'
                +'또한 차단 IP를 통해 불법 및 해킹 시도가 발생할 경우 해제를 신청한 그룹의 계정에<br/>'
                +'불이익이 발생할 수 있습니다.<br/><br/>'
                +'차단 해제 사유를 입력 후 전송 버튼을 클릭하면 위 사항에 동의한 것으로 간주합니다.'
                +'</div>'
                +'<table class="tableType1">'
                +'<colgroup>'
                +'<col width="103"/>'
                +'<col width="*"/>'
                +'</colgroup>'
                +'<tbody>'
                +'<tr>'
                +'<th>해제 IP</th>'
                +'<td><span id="block_ip">'+ip+'</span></td>'
                +'</tr>'
                +'<tr>'
                +'<th>해제 사유</th>'
                +'<td>'
                +'<textarea name="block_memo" id="reason" cols="30" rows="10" placeholder="IP 차단 해제 사유를 입력하세요." oninput="byteCount(this);"></textarea>'
                +'<div class="byte">(<span id="byte">0</span>/100 byte)</div>'
                +'</td>'
                +'</tr>'
                +'</tbody>'
                +'</table>'
                +'<div class="pop_error_txt blue_point_color" id="errorArea"></div>'
                +'<div class="btn_row">'
                +'<input type="button" class="btn_bg btn_size2 btn_inline" onclick="updateBlockLst(\''+ip+'\',\''+blockNo+'\', this);" value="확인"/>'
                +'<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소"/>'
                +'</div>'
                +'</div>'
                +'</div>'
                +'</div>';

        $('body').append(html);
    }

    let ipButton = document.querySelector('.btn_ip');

    ipButton.addEventListener('click', function () {
        ipCheck();
    });

    // IP 유효성 체크
    function ipCheck() {
        let ip = document.getElementById('ipValue').value;
        let ipReg = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
        let html = '';

        if (ip == '' || ip == undefined) {
            popup.popAlert('IP를 입력해주세요.');
        } else {
            if (!ipReg.test(ip)) {
                popup.popAlert('IP가 IPv4 규칙에 어긋납니다.<br/>IP를 확인해주세요.');
            } else {
                // IP등록
                var res = function (response) {
                    if (response.status) {
                        getBlockList('1');
                        $("#ipValue").val();

                    }
                    popup.popAlert(response.message);
                };
                var param = {block_target: ip, block_type: 2, block_status: "0"};
                com_ajax.ajax('post', '${baseURL}/sys/security/saveBlockList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
            }
        }
    }

    function updateBlockLst(ip, blockNo, button) {
        let reason = document.getElementById('reason').value;
        if (reason == '') {
            document.getElementById('errorArea').innerHTML = '사유를 입력하세요.';
        } else {
            popupClose(button);
            $('.layer_pop').removeClass('active');
            updateBlock(ip,blockNo,'1')
        }
    }
    function updateBlock(ip, blockNo, stNo) {
        var res = function (response) {
            var msg ;
            if (response.status) {
                if (stNo === '1'){
                    msg = ip +' 차단 해제 요청하였습니다.';
                }else{
                    msg = ip +' 차단 해제 요청을 취소하였습니다.';
                }
                getBlockList('1');
            } else {
                msg = "오류가 발생하였습니다. 관리자에 문의해주세요.";
            }
            popup.popAlert(msg);
        };
        var param = {seq: blockNo, ip: ip, block_status: stNo};
        com_ajax.ajax('post', '${baseURL}/sys/security/updateBlockLst.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
    function searchBlockList() {
        let standard = $('.searchSelect').attr('data');
        var searchWord = $('#searchWord').val();
        var param = $("#searchBlockList").serializeArray();
        param.push({name: standard, value: searchWord});
        if (standard == '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $('#searchType').val(standard);
        $('#searchValue').val(searchWord);
        getBlockList('1');
    }

    function getBlockList(page) {
        var searchType = $('#searchType').val();
        var searchValue = $('#searchValue').val();
        var param = $("#searchBlockList").serializeArray();
        param.push({name: searchType, value: searchValue});
        param.push({name: 'pageNo', value: page});
        var res = function (response) {
            $('#listHtml').html(response);
        };
        com_ajax.ajax('post', '${baseURL}/sys/security/getUserIpSecurity.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
</script>
