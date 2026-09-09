<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>

<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <form:form id="searchForm" name="searchForm" action="${baseURL}/report/banWordHst.mi" method="get">
            <!-- row 영역 시작 -->
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>리포트</li>
                        <li>차단 이력</li>
                    </ul>
                </div>
                <div class="right">
                    <!-- 차단 시점 -->
                    <div class="select style1 left-border" id="blkTpOption">
                        <div class="value searchSelect" id="blkTpValue" data="${blkTp}">
                            <c:choose>
                                <c:when test="${blkTp == 'SAVE'}">콘텐츠 저장</c:when>
                                <c:when test="${blkTp == 'SEND'}">발송</c:when>
                                <c:otherwise>차단 시점</c:otherwise>
                            </c:choose>
                        </div>
                        <ul class="option">
                            <li data="">전체</li>
                            <li data="SAVE">콘텐츠 저장</li>
                            <li data="SEND">발송</li>
                        </ul>
                    </div>
                    <!-- 금칙어 종류 -->
                    <div class="select style1 left-border" id="banTpOption">
                        <div class="value searchSelect" id="banTpValue" data="${banTp}">
                            <c:choose>
                                <c:when test="${banTp == 'KEYWORD'}">키워드</c:when>
                                <c:when test="${banTp == 'URL'}">URL</c:when>
                                <c:when test="${banTp == 'TEL'}">전화번호</c:when>
                                <c:otherwise>금칙어 종류</c:otherwise>
                            </c:choose>
                        </div>
                        <ul class="option">
                            <li data="">전체</li>
                            <li data="KEYWORD">키워드</li>
                            <li data="URL">URL</li>
                            <li data="TEL">전화번호</li>
                        </ul>
                    </div>
                    <!-- 검색 기준 -->
                    <div class="select style1 left-border" id="searchOption">
                        <div class="value searchSelect" id="searchStandard" data="${searchType}">
                            <c:choose>
                                <c:when test="${searchType == 'ban_word'}">금칙어</c:when>
                                <c:when test="${searchType == 'send_to'}">수신번호</c:when>
                                <c:otherwise>기준선택</c:otherwise>
                            </c:choose>
                        </div>
                        <ul class="option">
                            <li data="">기준선택</li>
                            <li data="ban_word">금칙어</li>
                            <li data="send_to">수신번호</li>
                        </ul>
                    </div>
                    <input type="text" class="searchInp left-border" id="searchValue" name="searchValue" placeholder="검색어입력" onkeyup="enterSubmit();" value="${searchValue}"/>
                    <input type="hidden" name="blk_tp" id="blk_tp" value="${blkTp}"/>
                    <input type="hidden" name="ban_tp" id="ban_tp" value="${banTp}"/>
                    <input type="hidden" name="searchType" id="searchType" value="${searchType}"/>
                    <input type="hidden" name="pageNo" id="page_num" value="${pageNo}"/>
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchBanWordHst();" />
                </div>
            </div>
            <!-- row 영역 끝 -->
            <!-- row 영역 시작 -->
            <div class="row bottom-border cf">
                <!-- 검색 기간 영역 시작 -->
                <div class="range_calendar right">
                    <input type="text" class="date" id="from" name="st_dt" placeholder="시작날짜" autocomplete="off" value="${stdt}" />
                    <input type="text" class="date" id="to" name="end_dt" placeholder="종료날짜" autocomplete="off" value="${enddt}"/>
                    <ul class="option_month cf">
                        <li type="button" class="en_font" value="1" onclick="quickDate(this.value, 'st_dt', 'end_dt')">1</li>
                        <li type="button" class="en_font" value="2" onclick="quickDate(this.value, 'st_dt', 'end_dt')">2</li>
                        <li type="button" class="en_font" value="3" onclick="quickDate(this.value, 'st_dt', 'end_dt')">3</li>
                        <li type="button" class="en_font" value="6" onclick="quickDate(this.value, 'st_dt', 'end_dt')">6</li>
                    </ul>
                </div>
                <!-- 검색 기간 영역 끝 -->
            </div>
        </form:form>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">차단 이력 <span class="en_font">${cnt}</span>건</div>
            </div>
            <div class="scroll_tbl" id="bodyDom">
                <!-- table 영역 시작 -->
                <table class="table dynamic_tbl list" summary="banWordHst">
                    <thead>
                    <tr>
                        <th scope="col">차단 일시</th>
                        <th scope="col">차단 시점</th>
                        <th scope="col">금칙어 종류</th>
                        <th scope="col">금칙어</th>
                        <th scope="col">차단 규칙</th>
                        <th scope="col">수신번호</th>
                        <th scope="col">문자 제목</th>
                        <th scope="col">문자 내용</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${!cutil:isEmptyObject(list)}">
                            <c:forEach var="item" items="${list}">
                                <tr>
                                    <td class="en_font">${item.reg_dt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.blk_tp == 'SAVE'}">콘텐츠 저장</c:when>
                                            <c:when test="${item.blk_tp == 'SEND'}">발송</c:when>
                                            <c:otherwise>${item.blk_tp}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.ban_tp == 'KEYWORD'}">키워드</c:when>
                                            <c:when test="${item.ban_tp == 'URL'}">URL</c:when>
                                            <c:when test="${item.ban_tp == 'TEL'}">전화번호</c:when>
                                            <c:otherwise>${item.ban_tp}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${item.ban_word}</td>
                                    <td>${item.ban_rule}</td>
                                    <td class="en_font">${item.send_to}</td>
                                    <td>${item.cont_sub}</td>
                                    <td>${item.cont_body}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr class="no_data">
                                <td colspan="100%">조회된 결과가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
            <div class="btn_row bottom-border">
                <ul class="pager" id="pagingDom">
                    <c:if test="${!cutil:isEmptyObject(list)}">
                        <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
                    </c:if>
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

<script>

    $(document).ready(function() {
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
        });

        //기간 검색 시작일
        $('#from').datepicker({
            onSelect: function (selected) {
                $('#to').datepicker("option", "minDate", selected);
            }
        });
        //기간 검색 종료일
        $('#to').datepicker({
            onSelect: function (selected) {
                $('#from').datepicker("option", "maxDate", selected);
            }
        });

        // 선택된 검색 조건은 글자색을 진하게 표시한다
        let searchBox = $('.searchSelect');
        for(let i = 0; i < searchBox.length; i++){
            if(searchBox.eq(i).attr('data') != null && searchBox.eq(i).attr('data') != ""){
                searchBox.eq(i).css('color', '#222222');
            }
        }
    });

    function searchBanWordHst(){
        let standard = $('#searchStandard').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if((standard == null || standard == "") && searchValue != ''){
            popup.popAlert("기준을 선택해주세요.");
            return false;
        }

        $('#blk_tp').val($('#blkTpValue').attr('data'));
        $('#ban_tp').val($('#banTpValue').attr('data'));
        $('#searchType').val(standard);
        $('#page_num').val('1');

        return true;
    }

    function enterSubmit(){
        if(window.event.keyCode == 13){
            if(searchBanWordHst()){
                $("#searchForm").submit();
            }
        }
    }

    function linkPage(s){
        $("#page_num").val(s);
        $("#searchForm").submit();
    }

</script>
