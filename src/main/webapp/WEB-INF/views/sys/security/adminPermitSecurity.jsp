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
                <div class="select style1 left-border">
                    <!-- selected value -->
                    <div class="value searchSelect" data="">기준선택</div>
                    <!-- option -->
                    <ul class="option">
                        <li data="IP">IP</li>
                        <li data="등록자">등록자</li>
                        <li data="차단 주체">차단 주체</li>
                    </ul>
                </div>
                <!-- select 영역 끝 -->
                <input type="text" class="searchInp left-border searchWord" placeholder="검색어입력" onkeyup="enterSubmit();" />
                <input type="button" class="searchBtn" value="검색" onclick="return searchCheck();" />
            </div>
        </div>
        <!-- row 영역 끝 -->
        <div class="tab_row">
            <!-- Tab menu -->
            <div><a href="/sys/security/adminIpBlockSecurity.mi">IP 차단</a></div>
            <div><a href="/sys/security/adminIpSecurity.mi">IP 차단 해제 요청</a></div>
           <%-- <div class="on"><a href="/sys/security/adminPermitSecurity.mi">IP 허용</a></div>--%>
            <div><a href="/sys/security/adminUserLog.mi">사용자 로그</a></div>
            <!-- 차단 IP 입력 -->
            <div class="ip_box">
                <input type="text" placeholder="허용 IP 입력" id="ipValue" />
                <input type="button" value="추가" class="btn_ip" />
            </div>
        </div>
        <!-- section 영역 시작 -->
        <div class="section">
            <!-- 검색 결과 영역 시작 -->
            <div class="count border-bottom cf">
                <div class="total left">IP 허용 리스트</div>
            </div>
            <!-- 검색 결과 영역 끝 -->
            <!-- table 영역 시작 -->
            <table class="table" summary="table">
                <colgroup>
                    <col width="16.6%" />
                    <col width="16.6%" />
                    <col width="16.6%" />
                    <col width="16.6%" />
                    <col width="16.6%" />
                </colgroup>
                <thead>
                <tr>
                    <th>IP</th>
                    <th>등록자</th>
                    <th>등록 메일</th>
                    <th>등록일</th>
                    <th>허용 해제</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <tr>
                    <td class="en_font">202.30.64.11</td>
                    <td class="en_font">MILVUS1</td>
                    <td>milvus1@milvus.co.kr</td>
                    <td class="en_font">20.10.30 17:22:40</td>
                    <td>
                        <input type="button" class="btn_sm_line btn_inline size" value="해제" onclick="ipAlertPopup('202.30.64.11');" />
                    </td>
                </tr>
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                <!-- <tr class="no_data">
                        <td colspan="5">조회된 결과가 없습니다.</td>
                     </tr> -->
                <!-- 검색 결과가 없는 경우 영역 시작 -->
                </tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager">
                    <!-- 페이지 이동 버튼이 활성화 상태일 경우 addClass'active' -->
                    <li class="first">First</li>
                    <li class="prev">Prev</li>
                    <!-- 페이지 번호가 활성화 상태일 경우 addClass'on' -->
                    <li class="page on">1</li>
                    <li class="page">2</li>
                    <li class="page">3</li>
                    <li class="page">4</li>
                    <li class="page">5</li>
                    <li class="page">6</li>
                    <li class="page">7</li>
                    <li class="page">8</li>
                    <li class="page">9</li>
                    <li class="page">10</li>
                    <li class="next active">Next</li>
                    <li class="last active">Last</li>
                </ul>
            </div>
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
<!-- container 영역 끝 -->
<script>
    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchCheck();
        }
        return false;
    }

    function ipAlertPopup(ip) {
        let html = '';
        html += '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">IP 허용 해제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + ip + '의 허용을 해제합니다.' + '</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this);" value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
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
            }
        }
    }

</script>