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
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border min-width cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>캠페인</li>
                    <li>타겟팅</li>
                    <li>타겟팅 생성</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
                <%--<div class="tooltip_icon">
                    <img src="/image/ico_tooltip.png" alt="Tooltip" />
                </div>
                <!-- tooltip box 영역 시작 -->
                <div class="tooltip_box">
                    <!-- tooltip bullet 영역 -->
                    <div class="bullet"></div>
                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="target_layout bottom-border cf">
                <div class="extraction">
                    <div>
                        <h4>
                            타겟 추출이 진행되고 있습니다.<br/>
                            타겟 추출 완료 후 조건 수정 및 우선순위를 선정할 수 있습니다.
                        </h4>
                        <p>시작시간 : 2021.02.17 17:23 ~</p>
                        <a href="#" class="btn_bg btn_size1">타겟팅 리스트 돌아가기</a>
                    </div>
                </div>
                <!-- Left -->
                <div class="left_column">
                    <!-- 타겟팅 명 입력 영역 -->
                    <div class="row bottom-border cf">
                        <div class="th left right-border">타겟팅 명</div>
                        <div class="td left"><input type="text" class="width1" placeholder="타겟팅 명 입력"/></div>
                    </div>
                    <!-- 타겟팅 메모 입력 영역 -->
                    <div class="row_text bottom-border">
                        <textarea cols="30" rows="10" placeholder="타겟팅 메모 입력 영역 입니다."></textarea>
                    </div>
                    <div class="row bottom-border row_tit">타겟팅 상세</div>
                    <div>
                        <!-- 탭 영역 시작 -->
                        <div class="sheet_tab bottom-border cf">
                            <span class="left cf">
                                <div class="tab left on">
                                    <input type="text" placeholder="시트명을 입력해 주세요."/>
                                    <div class="right">
                                        <button><img src="/image/ico_btn28.png" alt="복사"/></button>
                                        <button><img src="/image/btn_close3.png" alt="삭제"/></button>
                                    </div>
                                </div>
                                <%--
                                <div class="tab left">
                                    <input type="text" placeholder="시트명을 입력해 주세요."/>
                                    <div class="right">
                                        <button><img src="/image/ico_btn28.png" alt="복사"/></button>
                                        <button><img src="/image/btn_close3.png" alt="삭제"/></button>
                                    </div>
                                </div>
                                <div class="tab left">
                                    <input type="text" placeholder="시트명을 입력해 주세요."/>
                                    <div class="right">
                                        <button><img src="/image/ico_btn28.png" alt="복사"/></button>
                                        <button><img src="/image/btn_close3.png" alt="삭제"/></button>
                                    </div>
                                </div>
                                --%>
                            </span>
                            <div class="tab_add right left-border"><img src="/image/ico_add.png" alt="생성"/></div>
                        </div>
                        <!-- 탭 영역 끝 -->
                        <div class="sheet_area" id="sheet_area">
                            <%--
                            <div class="sheet active">
                                <!-- 추출조건 -->
                                <div class="left">
                                    <h3>+ 추출 조건</h3>
                                    <div class="dropzone">
                                        <!-- segment가 null인 경우 -->
                                        <div class="btn_base" id="addSeg">
                                            <span lang="en">Segment</span> 추가하기</div>
                                        <div class="grid">
                                            <div class="object"><input type="text"/></div>
                                        </div>
                                        <div class="grid">
                                            <div class="object"><input type="text"/></div>
                                        </div>
                                        <div class="grid">
                                            <div class="object"><input type="text"/></div>
                                        </div>
                                    </div>
                                    <input type="button" class="btn_segment top-border left-border" style="cursor: pointer" onclick="addSeg(0)" value="추가"/>
                                </div>
                                <!-- 제외 조건 -->
                                <div class="right">
                                    <h3>- 제외 조건</h3>
                                    <div class="dropzone">
                                        <!-- segment가 null인 경우 -->
                                        <div class="btn_base" onclick="addSeg();"><span lang="en">Segment</span> 추가하기</div>
                                    </div>
                                    <input type="button"  class="btn_segment top-border left-border" style="cursor: pointer" onclick="removeSeg(0)" value="추가"/>
                                </div>
                            </div>
                            <div class="sheet">
                                <!-- 추출조건 -->
                                <div class="left">
                                    <h3>+ 추출 조건</h3>
                                    <div class="dropzone">
                                        <!-- segment가 null인 경우 -->
                                        <!-- <div class="btn_base"><span lang="en">Segment</span> 추가하기</div> -->
                                        <div class="grid">
                                            <div class="object"><input type="text"/></div>
                                            <div class="object"><input type="text"/></div>
                                        </div>
                                        <div class="object"><input type="text"/></div>
                                    </div>
                                    <input type="button"  class="btn_segment top-border left-border" value="추가" onclick="segmentFilterPopup();"/>
                                </div>
                                <!-- 제외 조건 -->
                                <div class="right">
                                    <h3>- 제외 조건</h3>
                                    <div class="dropzone">
                                        <!-- segment가 null인 경우 -->
                                        <!-- <div class="btn_base"><span lang="en">Segment</span> 추가하기</div> -->
                                        <div class="object"><input type="text"/></div>
                                        <div class="object"><input type="text"/></div>
                                        <div class="object"><input type="text"/></div>
                                    </div>
                                    <input type="button"  class="btn_segment top-border left-border" value="추가"/>
                                </div>
                            </div>
                            <div class="sheet">
                                <!-- 추출조건 -->
                                <div class="left">
                                    <h3>+ 추출 조건</h3>
                                    <div class="dropzone">
                                        <!-- segment가 null인 경우 -->
                                        <!-- <div class="btn_base"><span lang="en">Segment</span> 추가하기</div> -->
                                        <div class="grid">
                                            <div class="object"><input type="text"/></div>
                                            <div class="object"><input type="text"/></div>
                                        </div>
                                        <div class="object"><input type="text"/></div>
                                    </div>
                                    <input type="button"  class="btn_segment top-border left-border" value="추가" onclick="segmentFilterPopup();"/>
                                </div>
                                <!-- 제외 조건 -->
                                <div class="right">
                                    <h3>- 제외 조건</h3>
                                    <div class="dropzone">
                                        <!-- segment가 null인 경우 -->
                                        <!-- <div class="btn_base"><span lang="en">Segment</span> 추가하기</div> -->
                                        <div class="object"><input type="text"/></div>
                                        <div class="object"><input type="text"/></div>
                                        <div class="object"><input type="text"/></div>
                                    </div>
                                    <input type="button"  class="btn_segment top-border left-border" value="추가"/>
                                </div>
                            </div>
                            --%>
                        </div>
                    </div>
                </div><!-- Left end -->
                <!-- Right -->
                <div class="right_column">
                    <div class="row row_tit">예상 타겟 수</div>
                    <!-- 예상 타겟 수 -->
                    <div class="row_chart bottom-border cf">
                        <div class="chart_cover">
                            타겟 조건이 변경되었습니다.<br/>
                            타겟을 다시 추출해주세요.
                        </div>
                        <div class="left">
                            <h4>ABC_Comm_Open</h4>
                            <div class="total_num en_font"><span class="blue_point_color">1,523,894</span><span class="gray_color">(12%)</span></div>
                            <div id="pregress1"></div>
                            <p>
                                최종 타겟 추출<br/>
                                2021년 1월 22일 오후 3시 25분 기준
                            </p>
                        </div>
                        <div class="right cf">
                            <div>
                                <h4 class="ico_email">이메일</h4>
                                <canvas id="pieChart1" class="pie_align" width="40" height="40"></canvas>
                                <div class="en_font total_num">25,263 <span class="gray_color">(46%)</span></div>
                            </div>
                            <div>
                                <h4 class="ico_mobile">문자</h4>
                                <canvas id="pieChart2" class="pie_align" width="40" height="40"></canvas>
                                <div class="en_font total_num">25,263 <span class="gray_color">(46%)</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="row row_tit"><span lang="en">Segment</span> 상세</div>
                    <div class="segment_area">
                        <table summary="table">
                            <tbody>
                                <tr>
                                    <th>Test1</th>
                                    <td>Test12</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div><!-- Right end -->
                <div class="sheet_btn_row top-border">
                    <button class="btn_size1 btn_bg btn_inline" disabled>임시 저장하기</button>
                    <button class="btn_size1 btn_bg btn_inline">타겟 추출</button>
                    <button class="btn_size1 btn_bg btn_inline prev">우선순위 선정하기</button>
                </div>
            </div>

        </div>
        <!-- section 영역 끝 -->
        <!-- footer 영역 시작 -->
        <footer class="footer">
            &copy; Milvus Corp.
        </footer>
        <!-- footer 영역 끝 -->
    </div>
    <!-- 컨텐츠 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>

<%-- 타겟조건 팝업 영역 시작 --%>
<div class="layer_pop" id="segmentPopup">
    <div class="pop_container popup_size5">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title"><span class="en_font">TARGET Segment</span> 조건 생성 및 수정</div>
        <div class="filter_area" id="tableauDiv">
            <%--<iframe src="http://z.tableau-report.com:8081/html/test.html"></iframe>--%>
        </div>
        <div class="btn_row">
            <input type="button" class="btn_bg btn_size1 btn_center" id="btn_save" value="저장"/>
        </div>
    </div>
</div>
<%-- 타겟조건 팝업 영역 끝 --%>
<script type="text/javascript" src="/js/tableau.js?v=0.12"></script>
<script type="text/javascript" src="https://tableau-report.com/javascripts/api/tableau-2.min.js"></script>
<script>
    let tab = [];
    let tabIndex = 0;
    let myChart1, myChart2;

    window.addEventListener('message', function(e) {
        if(typeof e.data == "string"){
            if(e.data.includes("VizInteractiveEvent")){
                if(tab[tabIndex].onLoading){
                    tab[tabIndex].onLoading = false;
                    tab[tabIndex].SetValue();
                }
            }
        }
    });

    $(function () {
        if(tab.length === 0){
            tab[0] = tableauTab;
            tab[0].Init("TableauTab1", true);
        }

        $('.tab').on('click',function(){
            let now = $('.tab').index(this);
            $(this).addClass('on').siblings().removeClass('on');
            $('.sheet').eq(now).addClass('active').siblings('.sheet').removeClass('active');
        });

        $("#btn_save").click(function(){
            tab[tabIndex].Save();
        });

        // 예상 타겟 수
        let bar1 = new ProgressBar.Line(pregress1, {
            strokeWidth: 4,
            easing: 'easeInOut',
            duration: 1400,
            color: '#618cd3',
            trailColor: '#f4f4f4',
            trailWidth: 4,
            svgStyle: { width: '192px', height: '7px' }
        });
        bar1.animate(0.12);

        myChart = new Chart(document.getElementById("pieChart1").getContext('2d'), {
            type: 'pie',
            data: {
                datasets: [{
                    backgroundColor: [ "#94dad2","#f4f4f4" ],
                    borderWidth : 0,
                    data: [40, 60]
                }]
            }
            ,options : {
                animation : {
                    animateRotate : false
                }
            }
        });

        myChart2 = new Chart(document.getElementById("pieChart2").getContext('2d'), {
            type: 'pie',
            data: {
                datasets: [{
                    backgroundColor: [ "#f4cd90","#f4f4f4" ],
                    borderWidth : 0,
                    data: [40, 60]
                }]
            }
            ,options : {
                animation : {
                    animateRotate : false
                }
            }
        });
    });

    <%--
    function allValue(){
        let data ={};
        workbook.getParametersAsync().then(function(Parameter) {
            let objectParam = Parameter;
            let paramLength = objectParam.length;

            for(let p = 0; p < paramLength; p++){
                let paramName = objectParam[p].getName();
                let paramValue = objectParam[p].getCurrentValue().formattedValue;
                let paramArray = [];
                paramArray.push(paramValue);
                data[paramName] = paramArray;
            }
        }).always(function(){
            let sheet = workbook.getActiveSheet().getWorksheets();
            let sheetLen = sheet.length - 1;
            sheet.forEach(function (item, index, ele) {
                item.getFiltersAsync().then(function (filter) {
                    try {
                        let filterLength = filter.length;
                        for (let i = 0; i < filterLength; i++) {
                            let filterClass = filter[i];
                            let filterType = filterClass.getFilterType();
                            let filterName = filterClass.getFieldName();

                            if (filterType == tableau.FilterType.CATEGORICAL) {
                                let categoriValue = filterClass.getAppliedValues();
                                if (!filterClass.getIsAllSelected() && categoriValue) {
                                    let arrayValue = [];
                                    for (let a = 0; a < categoriValue.length; a++) {
                                        arrayValue.push(categoriValue[a].formattedValue);
                                    }
                                    data[filterName] = arrayValue;
                                }
                            } else if (filterType == tableau.FilterType.QUANTITATIVE) {
                                let rangeStart = filterClass.getMin();
                                let rangeEnd = filterClass.getMax();
                                data[filterName] = {rangeStart, rangeEnd};
                            } else if (filterType == tableau.FilterType.HIERARCHICAL) {
                                console.log(filterType);
                            } else if (filterType == tableau.FilterType.RELATIVE_DATE) {
                                console.log(filterType);
                            } else {
                                console.log(filterType);
                            }
                        }
                    } catch (e) {
                        console.log(e);
                    }
                }).always(function(){
                    if(sheetLen == index) {
                        console.log(data);
                        $('#commonLoading').removeClass('active');
                    }
                });
            });
        });
    }
    --%>
</script>