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
                    <li>보안</li>
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
                <form:form id="searchBlockList" method="post"  onsubmit="return false">
                    <div class="select style1 left-border">
                        <!-- selected value -->
                        <div class="value searchSelect" data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="block_target">IP</li>
                            <li data="block_reg_usr">등록자</li>
                            <li data="block_type">차단 주체</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <input type="text" class="searchInp left-border searchWord" id="searchWord" placeholder="검색어입력" onkeyup="enterSubmit();" />
                    <input type="button" class="searchBtn" value="검색" onclick="return searchBlockList();" />
                    <input type="hidden" id="searchType" value=""/>
                    <input type="hidden" id="searchValue" value=""/>
                </form:form>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <div class="tab_row">
            <!-- Tab menu -->
            <div><a href="/sys/security/adminIpBlockSecurity.mi">IP 차단</a></div>
            <div class="on"><a href="/sys/security/adminIpSecurity.mi">IP 차단 해제 요청</a></div>
          <%--  <div><a href="/sys/security/adminPermitSecurity.mi">IP 허용</a></div>--%>
            <div><a href="/sys/security/adminUserLog.mi">사용자 로그</a></div>
            <!-- 차단 IP 입력 -->
        </div>
        <!-- section 영역 시작 -->
        <span id="listHtml">
        <div class="section">
            <!-- 검색 결과 영역 시작 -->
            <div class="count border-bottom cf">
                <div class="total left">IP 차단 해제 요청 리스트</div>
            </div>
            <!-- 검색 결과 영역 끝 -->
            <c:choose>
                <c:when test="${not empty list}">
            <!-- table 영역 시작 -->
            <table class="table" summary="table">
                <colgroup>
                    <col width="12.5%" />
                    <col width="12.5%" />
                    <col width="12.5%" />
                    <col width="12.5%" />
                    <col width="12.5%" />
                    <col width="12.5%" />
                    <col width="12.5%" />
                    <col width="12.5%" />
                </colgroup>
                <thead>
                <tr>
                    <th>IP</th>
                    <th>등록자</th>
                    <th>해제 요청자</th>
                    <th>차단 로그</th>
                    <th>차단 주제</th>
                    <th>등록일</th>
                    <th>해제 사유</th>
                    <th>해제/요청 거절</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="n" items="${list}" varStatus="status">
                    <tr>
                        <td class="en_font">${n.block_target}</td>
                        <td class="en_font">${n.block_reg_id}</td>
                        <td class="en_font">${n.block_upd_id}</td>
                        <td></td>
                        <td>
                             <c:choose>
                                 <c:when test="${n.block_type eq '1'}">시스템차단</c:when>
                                 <c:when test="${n.block_type eq '2'}">사용자 등록</c:when>
                             </c:choose>
                        </td>
                        <td class="en_font">${n.upd_dt}</td>
                        <td>${n.block_memo}</td>
                        <td>
                            <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('${n.block_target}', '${n.seq}','2');" />
                            <input type="button" class="btn_sm_line btn_inline size" value="거절" onclick="ipAlertPopup('${n.block_target}', '${n.seq}','0');"/>
                        </td>
                    </tr>
                </c:forEach>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <!-- <tr class="no_data">
                        <td colspan="8">조회된 결과가 없습니다.</td>
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
                    <table class="table" summary="table">
                        <colgroup>
                            <col width="12.5%" />
                            <col width="12.5%" />
                            <col width="12.5%" />
                            <col width="12.5%" />
                            <col width="12.5%" />
                            <col width="12.5%" />
                            <col width="12.5%" />
                            <col width="12.5%" />
                        </colgroup>
                    <thead>
                        <tr>
                            <th>IP</th>
                            <th>등록자</th>
                            <th>해제 요청자</th>
                            <th>차단 로그</th>
                            <th>차단 주제</th>
                            <th>등록일</th>
                            <th>해제 사유</th>
                            <th>해제/요청 거절</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="no_data">
                            <td colspan="8">조회된 결과가 없습니다.</td>
                        </tr>
                    </tbody>
                    </table>
                        <div class="btn_row bottom-border">
                            <ul class="pager">
                            </ul>
                        </div>
                </c:otherwise>
            </c:choose>
        </div>
        </span>
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
<script>
    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchBlockList();
        }
        return false;
    }

    function ipAlertPopup(ip, blockNo,blockStatus) {
        if(blockStatus =="2"){
            let html = '';
            html += '<div class="layer_pop alert active">' +
                '<div class="pop_container popup_size3">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title">IP 차단 해제</div>' +
                '<div class="pop_inner">' +
                '<div class="alert_txt">' + ip + '의 차단을 해제합니다.' + '</div>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="updateBlockLst(\''+ip+'\',\''+blockNo+'\',\''+blockStatus+'\');" value="확인" //>' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.alert').remove();
            $('body').append(html);
        }else{
            let html = '';
            html += '<div class="layer_pop alert active">' +
                '<div class="pop_container popup_size3">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title">IP 차단 해제</div>' +
                '<div class="pop_inner">' +
                '<div class="alert_txt">' + ip + '의 차단을 거절합니다.' + '</div>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="updateBlockLst(\''+ip+'\',\''+blockNo+'\',\''+blockStatus+'\');" value="확인" //>' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.alert').remove();
            $('body').append(html);
        }

        return false;
    }
    function updateBlockLst(ip, blockNo,blockStatus) {
        $('.layer_pop').removeClass('active');
        var res = function (response) {
            var msg = "";
            if(response.status){
                if(blockStatus == "2"){
                    msg= ip + " 차단이 해제되었습니다.";
                }else{
                    msg=ip + " 차단 해제가 거정되었습니다.";
                }
            }else{
                msg = "오류가 발생하였습니다. 관리자에게 문의해주세요.";
            }
            popup.popAlert(msg);
            getBlockList('1');
        };
        var param = {seq : blockNo, ip : ip, block_status : blockStatus};
        com_ajax.ajax('post', '${baseURL}/sys/security/updateBlockLst.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function searchBlockList() {
        let standard = $('.searchSelect').attr('data');
        var searchWord =  $('#searchWord').val();
        var param = $("#searchBlockList").serializeArray();
        param.push({name: standard, value: searchWord});
        param.push({name: 'block_status', value: '1'});
        if (standard == '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $('#searchType').val(standard);
        $('#searchValue').val(searchWord);
        getBlockList('1');
    }
    function getBlockList(page) {
        var searchType =  $('#searchType').val();
        var searchValue =  $('#searchValue').val();
        var param = $("#searchBlockList").serializeArray();
        param.push({name: searchType, value: searchValue});
        param.push({name: 'pageNo', value: page});
        param.push({name: 'block_status', value: '1'});

        var res = function (response) {
            $('#listHtml').html(response);
        };
        com_ajax.ajax('post', '${baseURL}/sys/security/getIpSecurity.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
</script>