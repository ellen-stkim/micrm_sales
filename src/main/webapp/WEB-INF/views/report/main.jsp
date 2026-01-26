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
<section class="container" style="height: 100%">
    <!-- row 영역 시작 -->
    <div class="row tooltip_area bottom-border cf">
        <div class="left">
            <!-- location 영역 -->
            <ul class="location">
                <li>홈</li>
                <li>리포트</li>
                <li>리포트</li>
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
    </div>
    <!-- row 영역 끝 -->
    <!-- row 영역 끝 -->
    <!-- section 영역 시작 -->
    <div class="section" style="height: 100%; margin-top: 30px;">
        <div id="tableauDiv" style="width: 100%; height: 100%;"></div>
    </div>
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>
<script type="text/javascript" src="/js/tableau.js?v=0.17"></script>
<script type="text/javascript" src="https://tableau-report.com/javascripts/api/tableau-2.min.js"></script>
<script>
    $(function(){
        let containerDiv = document.getElementById("tableauDiv")
            , url = '${tableauUrl}'
            , options = {
                hideTabs : true
                , hideToolbar : true
                , device : "desktop"
                , width : "100%"
                , height : "100%"
                , onFirstInteractive: function () {
                    $("#tableauDiv > iframe").css("overflow-y", "hidden");
                }
            };
        let viz = new tableau.Viz(containerDiv, url, options);
    });
</script>
