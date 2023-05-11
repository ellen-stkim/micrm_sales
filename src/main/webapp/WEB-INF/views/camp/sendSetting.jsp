<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="http://egovframework.gov/ctl/ui" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<!-- container 영역 시작 -->
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
                    <li>캠페인 발송</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
<%--                <div class="tooltip_icon">--%>
<%--                    <img src="../../image/ico_tooltip.png" alt="Tooltip" />--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                    스타일론 직장인이 26.69억(29.1%), <br />--%>
<%--                    스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
<%--                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border min-width cf">
            <div class="left">
                <a href="#" class="btn_basic ico_save left right-border" onclick="temporarySave();">임시저장</a>
                <!-- <input type="button" class="btn_basic ico_simulaiton left right-border" value="시뮬레이션"/> -->
                <input type="button" class="btn_basic ico_test left right-border" value="테스트" onclick="testGroupPopup();"/>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="send bottom-border cf">
                <form:form id="form" name="form" method="post" action="/camp/sendCreate.service">
                <input type="hidden" id="pro_id" name="pro_id" value="">
                <div class="left_column">
                    <div class="row flex bottom-border cf">
                        <!-- 캠페인 명 영역 시작 -->
                        <div class="th right-border">캠페인 명</div>
                        <div class="td right-border">
                            <input type="text" class="width1" id="pro_nm" name="pro_nm" placeholder="캠페인 명 입력"/>
                        </div>
                        <!-- 캠페인 명 영역 끝 -->
                        <!-- 캠페인 타겟 영역 시작 -->
                        <div class="th right-border">캠페인 타겟</div>
                        <div class="td right-border grow">
                            <input type="text" class="width2 left" id="campaignTgNm" placeholder="타겟 선택" readonly/>
                            <input type="hidden" id="campaignTgTp" name="pro_tg_tp"/>
                            <input type="hidden" id="campaignTgId" name="pro_tg_id"/>
                            <span class="btn_sm_line right" onclick="targetCheckPopup();">선택</span>
                        </div>
                        <!-- 캠페인 타겟 영역 끝 -->
                        <!-- 캠페인 컨트롤 그룹 영역 시작 -->
                        <div class="th right-border">컨트롤 그룹</div>
                        <div class="td">
                            <input type="text" class="width3 en_font" placeholder="00" name="grp_cnt" oninput="numberReplace(this);" onkeyup="handleInput(this);"/>
                            <span class="en_font">%</span>
                        </div>
                        <!-- 캠페인 컨트롤 그룹 영역 끝 -->
                    </div>

                    <article class="setting_area">
                        <div id="sendTargetLst" style="display: none">
                            <div class="title">캠페인 발송 셋팅</div>
                            <input type="hidden" id="camp_id" name="camp_id" value="" />
                            <div class="set_area">
                                <!-- 타겟 리스트 1단위 영역 시작 -->
                                <div class="target_area cf">
                                    <div class="row bottom-border cf">
                                        <div class="number en_font">1</div>
                                        <div class="setting_name">
                                            <!-- 타겟명 -->
                                            <h3 id="setting_tg_nm"></h3>
                                            <!-- 타겟 수 -->
                                            <span>(<span class="en_font" id="setting_tg_cnt"></span> 명)</span>
                                        </div>
                                        <!-- 타겟 추출 날짜 -->
                                        <div class="date right" id="setting_tg_dt"></div>
                                    </div>
                                    <!-- 발송 유형 영역 시작 -->
                                    <div class="step right-border">
                                        <div class="row bottom-border">
                                            <div class="th">발송 유형</div>
                                            <div class="td">
                                                <div class="toggle right">단일 발송</div>
                                            </div>
                                        </div>
                                        <div class="low_area"></div>
                                    </div>
                                    <!-- 발송 유형 영역 끝 -->
                                    <!-- 컨텐츠 선택 영역 시작 -->
                                    <div class="step right-border">
                                        <div class="row bottom-border">
                                            <div class="th">컨텐츠</div>
                                            <div class="td"></div>
                                        </div>
                                        <div class="low_area">
                                            <div class="conts_area">
                                                <input type="text" class="input" placeholder="컨텐츠를 선택해주세요." id="cont_sel_nm" readonly/>
                                                <input type="hidden" class="input" id="cont_id" name="cont_id" />
                                                <!-- 컨텐츠 선택 버튼 -->
                                                <input type="button" class="btn_sm_line" value="선택" onclick="contentsSettingPopup();"/>
                                                <!-- 컨텐츠 미리보기 버튼 -->
                                                <div class="btn_sm_line view" id="preview_btn">미리보기</div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 컨텐츠 선택 영역 끝 -->
                                    <!-- 발송 일정 선택 영역 시작 -->
                                    <div class="step">
                                        <div class="row bottom-border">
                                            <div class="th">발송일정</div>
                                            <div class="td"></div>
                                        </div>
                                        <div class="low_area">
                                            <div class="schedule_area">
                                                <div class="bottom-border cf">
                                                    <!-- select 영역 시작 -->
                                                    <div class="select">
                                                        <input type="hidden" name="sto" value="01">
                                                        <div class="value searchSelect" style="color: rgb(34, 34, 34);" data="01" >일괄발송</div>
                                                        <ul class="option" name="sto_ul">
                                                            <li data="01">일괄발송</li>
                                                            <%--
                                                            <li data="02">시간 최적화</li>
                                                            <li data="03">요일 최적화</li>
                                                            --%>
                                                        </ul>
                                                    </div>
                                                    <!-- select 영역 끝 -->
                                                </div>
                                                <div class="bottom-border cf">
                                                    <!-- select 영역 시작 -->
                                                    <div class="select">
                                                        <input type="hidden" name="send_tp" value="0">
                                                        <div class="value searchSelect" style="color: rgb(34, 34, 34);"  data="0" >예약발송</div>
                                                        <ul class="option" name="send_tp_ul">
                                                            <li data="0">예약발송</li>
                                                            <li data="1">즉시발송</li>
                                                        </ul>
                                                    </div>
                                                    <!-- select 영역 끝 -->
                                                </div>
                                                <div class="re_option active bottom-border cf">
                                                    <!-- 날짜 선택 영역 -->
                                                    <input type="text" class="input_style en_font calendar" placeholder="YYYY.MM.DD" id="dataCalendar" name="send_dt" value="" readonly />
                                                </div>
                                                <div  class="re_option active bottom-border reservation cf">
                                                    <!-- 시간 입력 영역 -->
                                                    <input type="text" id='timepicker' class="input_style en_font" placeholder="00 : 00" name="send_time" value=""  readonly />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 발송 일정 선택 영역 끝 -->
                                </div>
                            </div>
                        </div>
                        <div class="none" id="sendTargeEmpty">
                            타겟을 선택해 주세요.
                        </div>
                    </article>
                </div>
                </form:form>
                <div class="right_column">
                    <div class="row">
                        <div class="th"><div class="ellipsis"></div>미리보기</div>
                    </div>
                    <div class="inner" id="preview_1"></div>
                    <!-- 승인요청 버튼 -->
                    <div class="btn_bg" onclick="requestPopup();">승인요청</div>
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

<!-- 타겟 선택 팝업 영역 시작 -->
<div class="layer_pop" id="targetCheckPopup">
    <div class="pop_container popup_size4">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">타겟 선택</div>
        <div class="pop_inner">
            <div class="radio_type">
                <label class="block_radio">
                    <input type="radio" name="Tgtp" value="TG02" checked/>
                    <span>업로드 그룹</span>
                </label>
            </div>
            <form:form id="send_tg_form" onsubmit="return false;">
            <div class="form_search">
                <!-- 검색 영역 시작 -->
                <input type="text" class="calendar" id="tg_from" name="reg_dt" placeholder="생성일 선택" />
                <span class="hyphen"></span>
                <input type="text" class="calendar" id="tg_to" name="reg_dt_range" placeholder="생성일 선택" />
                <div class="input_txt left-border-none">
                    <input type="text" name="grp_nm" placeholder="타겟 명 검색" />
                    <input type="button" class="btn_search" id="tg_search_btn" value="검색" />
                </div>
                <!-- 검색 영역 끝 -->
            </div>
            </form:form>
            <table class="pop_table table_fixed" id="send_tg_lst" summary="list">
                <colgroup>
                    <col width="35"/>
                    <col width="302"/>
                    <col width="130"/>
                    <col width="*"/>
                </colgroup>
                <thead>
                <tr>
                    <th></th>
                    <th>타겟 명</th>
                    <th>타겟 수</th>
                    <th>생성일</th>
                </tr>
                </thead>
                <tbody id="send_tg_tbody"></tbody>
            </table>
            <div class="btn_row bottom-border">
                <ul class="pager" id="send_tg_pager"></ul>
            </div>
            <!-- 오류 메시지 영역 -->
            <div class="pop_error_txt blue_point_color" id="targetError"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" onclick="targetCheck();" value="확인" />
            </div>
        </div>
    </div>
</div>
<!-- 타겟 선택 팝업 영역 끝 -->

<!-- 컨텐츠 선택 팝업 영역 시작 -->
<div class="layer_pop contentsSetting" id="settingPopup">
    <div class="pop_container popup_size8">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">컨텐츠 선택</div>
        <div class="pop_inner">
            <form:form id="send_ct_form" onsubmit="return false;">
            <div class="form_search">
                <!-- 이메일/모바일 선택 -->
                <div id="contents_tab">
                <%--<c:forEach var="g" items="${CtCd}" varStatus="st">
                    <label class="block_radio">
                        <input type="radio" name="ch_tp" value="${g.cd_id}" <c:if test="${st.first}">checked</c:if>/>
                        <span>${g.cd_nm}</span>
                    </label>
                </c:forEach>--%>
                    <c:set var ="contTitleLst" value="${CtCd}"/>
                    <label class="block_radio">
                        <input type="radio" name="ch_tp" value="${contTitleLst[1].cd_id}" checked/>
                        <span>${contTitleLst[1].cd_nm}</span>
                    </label>
                    <label class="block_radio">
                        <input type="radio" name="ch_tp" value="${contTitleLst[0].cd_id}"/>
                        <span>${contTitleLst[0].cd_nm}</span>
                    </label>
                </div>
                <!-- 검색 영역 시작 -->
                <input type="text" class="calendar" id="ct_from" name="reg_dt" placeholder="등록일 선택" />
                <span class="hyphen"></span>
                <input type="text" class="calendar" id="ct_to" name="reg_dt_range" placeholder="등록일 선택" />
                <div class="input_txt left-border-none">
                    <input type="text" placeholder="컨텐츠 명 검색" id="contentsName" name="cont_nm" />
                    <input type="button" class="btn_search" value="검색" id="ct_search_btn" />
                </div>
                <!-- 검색 영역 끝 -->
                <!-- 오류 메시지 영역 -->
                <div class="blue_point_color" id="erre_area1"></div>
            </div>
            </form:form>
            <div class="option_div">
                <div class="image_container" id="send_ct_tbody"></div>
                <div class="btn_row bottom-border left-border right-border">
                    <ul class="pager" id="send_ct_pager"></ul>
                </div>
            </div>
            <!-- 오류 메시지 영역 -->
            <div class="pop_error_txt blue_point_color" id="erre_area2"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center"  onclick="contentsSave();" value="저장" />
            </div>
        </div>
    </div>
</div>
<!-- 컨텐츠 선택 팝업 영역 끝 -->

<!-- 테스트 발송 팝업 영역 시작 -->
<div class="layer_pop" id="testGroupPopup">
    <div class="pop_container popup_size2">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">테스트 발송</div>
        <form:form id="test_send_form" onsubmit="return false">
        <input type="hidden" name="pro_tp" value="TEST">
        <div class="pop_inner">
            <div class="sendArea cf">
                <div class="left">
                    <div class="top">
                        <h3>컨텐츠</h3>
                        <!-- Tab Nav 영역 -->
                        <ul class="tab_nav cf">
                            <li class="on">1</li>
                        </ul>
                    </div>
                    <div class="info">
                        <table class="info_table" summary="table">
                            <colgroup>
                                <col width="105">
                                <col width="220">
                                <col width="105">
                                <col width="110">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">캠페인 명</th>
                                    <td colspan="3">
                                        <input type="text" class="" id="test_pro_nm" name="pro_nm" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">타겟</th>
                                    <td class="ellipsis" id="test_target_nm"></td>
                                    <th scope="col">총 명수</th>
                                    <td class="ellipsis en_font" id="test_target_cnt"></td>
                                </tr>
                                <tr>
                                    <th scope="row">발송 일시</th>
                                    <td colspan="3" class="en_font" id="test_send_dt"></td>
                                </tr>
                                <tr>
                                    <th scope="row">컨텐츠 명</th>
                                    <td colspan="3" class="ellipsis" id="test_cont_nm"></td>
                                </tr>
                                <tr>
                                    <th scope="row">발송 주소</th>
                                    <td colspan="3" class="ellipsis" id="test_from"></td>
                                </tr>
                                <tr>
                                    <th scope="row">제목</th>
                                    <td colspan="2" class="ellipsis title" >
                                        <input type="hidden" class="title" id="test_cont_id" name="cont_id" value="">
                                        <input type="text" class="title" id="test_cont_sub" name="cont_sub" value="" onkeyup="common.calculate(this.value, 'test_cont_sub_byte');">
                                    </td>
                                    <td><span class="title_byte en_font" id="test_cont_sub_byte">0byte</span></td>
                                </tr>
                                <tr>
                                    <td colspan="100%" class="padding_none">
                                        <div class="view" id="preview_2"></div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="right testgroup">
                    <div class="inner">
                        <!-- 테스트 그룹 선택 select 영역 시작 -->
                        <div class="select">
                            <div class="value" data="" id="testGroupVal">테스트 그룹 선택</div>
                            <ul class="option"></ul>
                        </div>
                        <!-- 테스트 그룹 선택 select 영역 끝 -->
                        <div class="group_area">
                            <h3>개별 추가</h3>
                            <!-- 개별 추가 table 영역 시작 -->
                            <table class="pop_table_type3 align">
                                <thead>
                                    <tr>
                                        <th>이름</th>
                                        <th>이메일</th>
                                        <th>모바일</th>
                                    </tr>
                                </thead>
                                <tbody id="test_target_add">
                                    <tr>
                                        <td><input type="text" class="input" id="usr_nm" /></td>
                                        <td><input type="text" class="input" id="usr_edm" /></td>
                                        <td><input type="text" class="input" id="usr_mob" /></td>
                                    </tr>
                                </tbody>
                            </table>
                            <!-- 개별 추가 table 영역 끝 -->
                            <!-- 개별 추가 버튼 영역 -->
                            <div class="cf">
                                <div class="btn_sm_line size" id="test_target_add_btn">개별 추가</div>
                                <p class="sub_txt">
                                    ※ 테스트 시, 테스트 표시 문구로 인해 <span class="en_font">byte</span>수가 증가하여<br/>
                                    <span class="en_font">SMS -> LMS</span>로 변환될 수 있습니다.
                                </p>
                            </div>
                            <div class="row_text">
                                <img src="/image/ico_arrow1.png" alt=""/>&nbsp;&nbsp;기존 테스트 멤버를 유지하고 추가됩니다.
                            </div>
                            <h3>테스트 발송 리스트</h3>
                            <div class="vertical_scroll">
                                <!-- 테스트 발송 리스트 영역 시작 -->
                                <table class="pop_table_type3 table_fixed">
                                    <colgroup>
                                        <col width="130"/>
                                        <col width="130"/>
                                        <col width="130"/>
                                        <col width="30"/>
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>이름</th>
                                            <th>이메일</th>
                                            <th>모바일</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody id="test_target_lst"></tbody>
                                </table>
                                <!-- 테스트 발송 리스트 영역 끝 -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 오류 메시지 영역 -->
            <div class="pop_error_txt blue_point_color" id="error_area3"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" value="발송" onclick="testSendSave();"/>
            </div>
        </div>
        </form:form>
    </div>
</div>
<!-- 테스트 발송 팝업 영역 끝 -->

<!-- 승인요청 팝업 영역 시작 -->
<div class="layer_pop" id="requestPopup">
    <div class="pop_container popup_size2">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">승인요청</div>
        <div class="pop_inner">
            <div class="sendArea cf">
                <div class="left cf">
                    <div class="top">
                        <h3>컨텐츠</h3>
                        <!-- Tab Nav 영역 -->
                        <ul class="tab_nav cf">
                            <li class="on">1</li>
                        </ul>
                    </div>
                    <div class="info">
                        <table class="info_table" summary="table">
                            <colgroup>
                                <col width="105"/>
                                <col width="220"/>
                                <col width="105"/>
                                <col width="110"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">캠페인 명</th>
                                    <td colspan="3" class="ellipsis" id="confirm_pro_nm"></td>
                                </tr>
                                <tr>
                                    <th scope="row">타겟</th>
                                    <td class="ellipsis" id="confirm_target_nm"></td>
                                    <th scope="row">총 명수</th>
                                    <td class="ellipsis en_font" id="confirm_target_cnt"></td>
                                </tr>
                                <tr>
                                    <th scope="row">발송 일시</th>
                                    <td colspan="3" class="en_font" id="confirm_send_dt"></td>
                                </tr>
                                <tr>
                                    <th scope="row">컨텐츠 명</th>
                                    <td colspan="3" class="ellipsis" id="confirm_cont_nm"></td>
                                </tr>
                                <tr>
                                    <th scope="row">발송 주소</th>
                                    <td colspan="3" class="ellipsis" id="confirm_from"></td>
                                </tr>
                                <tr>
                                    <th scope="row">제목</th>
                                    <input type="hidden" class="title" id="confirm_cont_id" name="cont_id" value="">
                                    <td colspan="3" class="ellipsis title" id="confirm_cont_sub"></td>
                                </tr>
                                <tr>
                                    <td colspan="100%" class="padding_none">
                                        <div class="view" id="preview_3"></div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="right confirm">
                    <!-- 캠페인 Type Tab Nav -->
                    <div class="option_area" id="type_tab">
                        <div>이메일</div>
                        <div>모바일</div>
                    </div>
                    <div class="inner bottom-border cf">
                        <div class="top"><h3>캠페인 확인사항</h3></div>
                        <!-- [이메일] 확인사항 리스트 영역 시작 -->
                        <div class="tab_contents" id="emdCheckLst">
                            <!-- 진행도 영역 시작 -->
                            <div class="row_progress">
                                <span class="tit">진행도</span>
                                <div class="middle">
                                    <div class="progress_wrap"><div class="bar_inner" id="mailBar"></div></div>
                                    <div class="percents en_font"><span id="mailCount">0</span>%</div>
                                </div>
                                <div class="btn">
                                    <div class="btn_sm_line size" onclick="allCheck('mail');">모두 확인</div>
                                </div>
                            </div>
                            <!-- 진행도 영역 끝 -->
                            <div class="vertical_scroll">
                                <dl class="confirm_list" id="mailCheck">
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>광고 메시지의 경우 제목에 (광고) 문구를 기입하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>광고성 메일 표기 의무 사항</span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>발송 타겟 및 타겟 모수를 확인하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                타겟 조건 및 모수 확인
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>발송 주소를 확인하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                예) milvus: milvus@milvus.co.kr
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>컨텐츠 오탈자 및 디자인을 확인하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                1) 이메일 제목 내 앞뒤 빈칸<br/>
                                                2) 디자인 깨짐 현상
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>컨텐츠에 날짜가 있다면 요청 날짜(이벤트 날짜)와 일치합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                컨텐츠 내 이벤트의 날짜 & 실제 이벤트 날짜 동일 여부
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>기입된 날짜와 요일이 모두 일치합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                예 : 2020년 9월 2일 (금) -> (수)
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>컨텐츠에 금액이 표시된 경우, 요청 금액과 일치합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                제품 가격 & 요청 금액 일치 확인
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>수신동의일자를 확인하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                타겟 데이터 업데이트 일자 기준
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>URL이 정상적으로 접속됩니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                URL 접속 정상 여부<br/>
                                                GA UTM 코드 정상 노출 여부 및 UTM 코드로 인한 링크 오픈 오류 확인
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>발송 일시가 요청 일시와 일치합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                트래킹 코드 작성 여부 및 정상 트래킹 여부 확인
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>포털 별 정상 수신 여부를 확인하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                Google / Naver / Daum 등 정상 수신 여부 확인
                                            </span>
                                        </div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                        <!-- [이메일] 확인사항 리스트 영역 끝 -->
                        <!-- [모바일] 확인사항 리스트 영역 시작 -->
                        <div class="tab_contents" id="mdmCheckLst">
                            <!-- 진행도 영역 시작-->
                            <div class="row_progress">
                                <span class="tit">진행도</span>
                                <div class="middle">
                                    <div class="progress_wrap"><div class="bar_inner" id="mobileBar"></div></div>
                                    <div class="percents en_font"><span id="mobileCount">0</span>%</div>
                                </div>
                                <div class="btn">
                                    <div class="btn_sm_line size" onclick="allCheck('mobile');">모두 확인</div>
                                </div>
                            </div>
                            <!-- 진행도 영역 끝 -->
                            <div class="vertical_scroll">
                                <dl class="confirm_list" id="mobileCheck">
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>광고 메시지의 경우 제목에 (광고) 문구를 기입하였습니까?(안내 메시지인 경우 (안내) 문구 기입)</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                광고성 문자 표기 의무 사항<br/>
                                                카카오톡 : (광고) 문구 자동 기입, 별도 추가 불필요<br/>
                                                LMS : (광고)필수
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>제목에 전송자의 명칭 및 연락처를 기입하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                광고성 문자 표기 의무 사항<br/>
                                                전송자 명칭(문자 맨 앞 작성 필요)<br/>
                                                예. [밀버스]<br/>
                                                연락처<br/>
                                                예. 고객센터: 1588-1234
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>광고 발송 건의 경우 하단 무료수신거부번호 내용을 기입하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                광고성 문자 표기 의무 사항<br/>
                                                예 : 무료수신거부 : 080-000-0000
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>컨텐츠 오탈자를 확인하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                1) 띄어쓰기<br/>
                                                2) 맞춤법<br/>
                                                3) 동일한 표현 한/영 통일<br/>
                                                4) 제목 내에 T / TEST 여부
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>컨텐츠에 날짜가 있다면 요청 날짜(이벤트 날짜)와 일치합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                컨텐츠 내 이벤트의 날짜 & 실제 이벤트 날짜 동일 여부
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>기입된 날짜와 요일이 모두 일치합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                예 : 2020년 9월 2일 (금) -> (수)
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>컨텐츠에 금액이 표시된 경우, 요청 금액과 일치합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                제품 가격 & 요청 금액 일치 확인
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>개인화 매칭이 모두 정상적으로 작동합니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                개인화 코드 정상 매칭 여부 확인<br/>
                                                예) ‘이름 개인화’ 님 ->  밀버스 님
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>URL이 정상적으로 접속됩니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                URL 접속 정상 여부<br/>
                                                GA UTM 코드 정상 노출 여부 및 UTM 코드로 인한 링크 오픈 오류 확인
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>트래킹 링크가 정상적으로 작동합니까?(정상 접속 여부, 트래킹 작동 여부 등)</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                트래킹 코드 작성 여부 및 정상 트래킹 여부 확인
                                            </span>
                                        </div>
                                    </dd>
                                    <dd class="cf">
                                        <div class="col">
                                            <label class="custom_check1"><input type="checkbox"/><span></span></label>
                                        </div>
                                        <div class="col">
                                            <p>통신3사 정상 수신 여부를 확인하였습니까?</p>
                                        </div>
                                        <div class="col ico_tooltip">
                                            <img src="/image/ico_tooltip2.png" alt=""/>
                                        </div>
                                        <div class="toolip_text">
                                            <span>
                                                SKT / KT / LG U+<br/>
                                                (U+ 스팸 발생이 잦아 유의 필요)
                                            </span>
                                        </div>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                        <!-- [모바일] 확인사항 리스트 영역 끝 -->
                        <!-- 승인 담당자 선택 영역 -->
                        <div class="row border">
                            <div class="th right-border">승인 담당자 선택</div>
                            <div class="td width1">
                                <div class="select">
                                    <c:choose>
                                        <c:when test="${empty apprInfo}">
                                            <div class="value" data="" id="appr_id">- <span class="en_font"></span></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="value" data="${apprInfo.usr_id}" id="appr_id" style="color: rgb(34, 34, 34);">${apprInfo.usr_nm}(${apprInfo.usr_email} / ${apprInfo.usr_mob})</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <ul class="option">
                                        <c:forEach var="g" items="${authLst}">
                                            <li data="${g.usr_id}">${g.usr_nm} <span class="en_font">(${g.usr_email} / ${g.usr_mob})</span></li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- 캠페인 비용 입력 영역 -->
                        <table class="pop_table_type2">
                            <colgroup>
                                <col width="104"/>
                                <col width="*"/>
                                <col width="104"/>
                                <col width="*"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>기획비</th>
                                <td><input type="text" id="plan_cost" placeholder="0" class="en_font" /><span>원</span></td>
                                <th>오퍼비</th>
                                <td><input type="text" id="off_cost" placeholder="0" class="en_font" /><span>원</span></td>
                            </tr>
                            <tr>
                                <th>개발비</th>
                                <td><input type="text" id="dev_cost" placeholder="0" class="en_font" /><span>원</span></td>
                                <th>디자인비</th>
                                <td><input type="text" id="des_cost" placeholder="0" class="en_font" /><span>원</span></td>
                            </tr>
                            </tbody>
                        </table>
                        <!-- 발송 예상 비용 & 상세비용 확인 영역 -->
                        <div class="bottom">
                            <div class="left">
                                <span class="th">발송 예상 비용(원)</span>
                                <span class="td en_font" id="total_cost">0</span>
                            </div>
                            <div class="right">
                                <p>※ 실제 비용과 다를 수 있습니다.</p>
                                <div class="btn_sm_line size" onclick="detailPrice();">상세비용 확인하기</div>
                            </div>
                        </div>
                    </div>
                    <div class="pop_error_txt blue_point_color" id="erre_area4">캠페인 확인사항을 검토해 주세요.</div>
                    <div class="btn_row">
                        <input type="button" class="btn_bg btn_size2 btn_center" value="승인요청" onclick="requestConfirm();"/>
                    </div>
                </div>
            </div>
        </div>
        <!-- 타겟 별 상세 비용 팝업 시작 -->
        <div class="pop_container" id="detailPrice">
            <input type="button" value="닫기" class="btn_pop_close" onclick="detailPriceClose();"/>
            <div class="pop_title">타겟 별 상세 비용</div>
            <div class="pop_inner">
                <!-- 타겟 리스트 1단위 영역 시작 -->
                <dl class="price_box">
                    <dt>
                        <h3 class="name ellipsis">TARGET A</h3>
                        <span class="num en_font" id="price_target_cnt"></span>
                    </dt>
                    <dd class="cf">
                        <div class="top">
                            <div class="inline en_font">
                                <!-- 발송 컨텐츠 타입 -->
                                <span class="name ellipsis">Email</span>
                                <!-- 금액 -->
                                <span class="price">${apiPrice["email"]}원</span>
                            </div>
                        </div>
                        <div class="total">
                            <!-- 총 금액 -->
                            <span class="en_font blue_point_color">0</span><span>원</span>
                        </div>
                    </dd>
                </dl>
                <!-- 타겟 리스트 1단위 영역 끝 -->
                <table class="pop_table_type2 unit">
                    <thead>
                        <tr>
                            <th class="en_font">SMS/RCS<br/>SMS</th>
                            <th class="en_font">LMS/RCS<br/>LMS</th>
                            <th class="en_font">MMS/RCS<br/>MMS</th>
                            <th><span class="en_font">RCS</span><br/>템플릿</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="en_font">${apiPrice["sms"]}/${apiPrice["rcs_sms"]}</span>원</td>
                            <td><span class="en_font">${apiPrice["lms"]}/${apiPrice["rcs_lms"]}</span>원</td>
                            <td><span class="en_font">${apiPrice["mms"]}/${apiPrice["rcs_mms"]}</span>원</td>
                            <td><span class="en_font">${apiPrice["rcs_teplate"]}</span>원</td>
                        </tr>
                    </tbody>
                </table>
                <p class="sub_txt">* RCS/카카오/문자 비용은 타겟 수의 1:3:6 비율로 측정됩니다.</p>
            </div>
        </div> <!-- 타겟 별 상세 비용 팝업 끝 -->
    </div>
</div>
<!-- 테스트 발송 팝업 영역 끝 -->

<script>
    let first_tg_check = true;
    let first_ct_check = true;
    let first_test_check = true;
    let testSend = true;
    let tg_form;
    let ct_form;
    let contLst = [];
    let sms_price = '${apiPrice["sms"]}';
    let rcs_sms_price = '${apiPrice["rcs_sms"]}';
    let lms_price = '${apiPrice["lms"]}';
    let rcs_lms_price = '${apiPrice["rcs_lms"]}';
    let mms_price = '${apiPrice["mms"]}';
    let rcs_mms_price = '${apiPrice["rcs_mms"]}';
    let rcs_teplate_price = '${apiPrice["rcs_teplate"]}';

    $(function(){
        //[타겟 선택 팝업] 검색 기간 달력
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
        });

        //[타겟 선택 팝업]시작일 달력
        $('#tg_from').datepicker({
            onSelect: function (selected) {
                $("#tg_to").datepicker("option", "minDate", selected)
            }
        });

        //[타겟 선택 팝업]종료일 달력
        $('#tg_to').datepicker({
            onSelect: function (selected) {
                $("#tg_from").datepicker("option", "maxDate", selected)
            }
        });

        $("#tg_search_btn").click(function(){
            const tg_from = $("#tg_from").val().trim();
            const tg_to = $("#tg_to").val().trim();

            if(tg_from === '' && tg_to !== ''){
                let date = $("#tg_to").datepicker('getDate');
                date.setDate(date.getDate() - 1);
                $("#tg_from").datepicker("setDate", date);
            }else if(tg_from !== '' && tg_to === ''){
                let date = $("#tg_from").datepicker('getDate');
                date.setDate(date.getDate() + 1);
                $("#tg_to").datepicker("setDate", date);
            }
            fn_page_tg(1, true);
        });

        //[타겟 선택 팝업] 업로드 / 타겟 DB 선택
        $('.option_area div').on('click',function(){
            $(this).addClass('on').siblings().removeClass('on');
        });

        //[컨텐츠 선택 팝업]시작일 달력
        $('#ct_from').datepicker({
            onSelect: function (selected) {
                $("#ct_to").datepicker("option", "minDate", selected);
            }
        });

        //[컨텐츠 선택 팝업]종료일 달력
        $('#ct_to').datepicker({
            onSelect: function (selected) {
                $("#ct_from").datepicker("option", "maxDate", selected);
            }
        });

        $("input[name='ch_tp']").click(function(){
            $("#ct_search_btn").click();
        });

        $("#ct_search_btn").click(function(){
            const ct_from = $("#ct_from").val().trim();
            const ct_to = $("#ct_to").val().trim();

            if(ct_from === '' && ct_to !== ''){
                let date = $("#ct_to").datepicker('getDate');
                date.setDate(date.getDate() - 1);
                $("#ct_from").datepicker("setDate", date);
            }else if(ct_from !== '' && ct_to === ''){
                let date = $("#ct_from").datepicker('getDate');
                date.setDate(date.getDate() + 1);
                $("#ct_to").datepicker("setDate", date);
            }
            fn_page_ct(1, true);
        });

        $("#preview_btn").click(function(){
            if(!$("#cont_id").val()){
                popup.popAlert("컨텐츠를 선택 해주세요.");
            }else{
                const res = function(response){
                    const $doc = new DOMParser().parseFromString(response, "text/html");
                    $("#preview_1").html($("#preview", $doc).html());
                    new Swiper("#preview_slideSwiper", {
                        direction: 'horizontal',
                        pagination: {
                            el: '#preview_rcs_paging',
                            type: 'fraction',
                        },
                        navigation: {
                            nextEl: '#preview_rcs_next',
                            prevEl: '#preview_rcs_prev',
                        },
                    });
                };
                let data = [];
                data.push({name : "cont_id" , value : $("#cont_id").val()});
                com_ajax.ajax('post', '/camp/sendContPreview.ajax', data, res);
            }
        });

        $("#pro_nm").blur(function(e){
            $("#test_pro_nm").val($(this).val());
            $("#confirm_pro_nm").html($(this).val());
        });

        //예약일 달력
        $('#dataCalendar').datepicker({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
            , minDate : 0
            , onSelect: function (selected) {
                $("#test_send_dt").html(selected + " " + $("#timepicker").val());
            }
        });

        $("#test_target_add_btn").click(function(){
            let usr_nm = $("#usr_nm").val();
            let usr_edm = $("#usr_edm").val();
            let usr_mob = $("#usr_mob").val();

            if(!usr_edm){
                popup.popAlert("이메일을 입력해주세요");
                return;
            }else if(!usr_mob){
                popup.popAlert("모바일 번호를 입력해주세요");
                return;
            }else{
                if(!common.emailcheck(usr_edm)){
                    popup.popAlert("이메일 형식이 올바르지 않습니다.");
                    return;
                }else if(!common.phonecheck(usr_mob)){
                    popup.popAlert("모바일 번호 형식이 올바르지 않습니다.");
                    return;
                }else{
                    let data = "<tr>"
                        + "<input type='hidden' name='usr_nm' value='"+ usr_nm +"'>"
                        + "<input type='hidden' name='usr_edm' value='"+ usr_edm +"'>"
                        + "<input type='hidden' name='usr_mob' value='"+ usr_mob +"'>"
                        + "<td>"+ usr_nm +"</td>"
                        + "<td>"+ usr_edm +"</td>"
                        + "<td>"+ usr_mob.replace("/-/g", "") +"</td>"
                        + "<td class='td'><span class=\"delete\">삭제</span></td>"
                        + "</tr>";
                    $("#test_target_lst").append(data);
                }
            }
        });

        //테스트 발송 리스트 삭제
        $(document).on('click','.delete',function(){
            $(this).parents('tr').remove();
        });

        $("#form").on('click', 'ul[name=sto_ul] > li', function(){
            let data = $(this).attr('data');
            $(this).parent().parent().children('input').val(data);
        });

        $("#form").on('click', 'ul[name=send_tp_ul]  > li', function(){
            let data = $(this).attr('data');
            $(this).parent().parent().children('input').val(data);
            if (data === '0') {
                $("#test_send_dt").html($("#dataCalendar").val() + " " + $("#timepicker").val());
                $('.re_option').addClass('active');
            } else {
                $("#test_send_dt").html("즉시발송");
                $('.re_option').removeClass('active');
            }
        });

        $("#plan_cost, #off_cost, #dev_cost, #des_cost").keypress(function(event){
        	if(event.which != 8 && isNaN(String.fromCharCode(event.which))){
        		event.preventDefault();
        	}
        });

        $("#plan_cost, #off_cost, #dev_cost, #des_cost").keyup(function(event){
            let data = common.removeComma($(this).val());
            $(this).val(common.comma(data));

            let cost = Number(common.removeComma($("#plan_cost").val()))
                + Number(common.removeComma($("#off_cost").val()))
                + Number(common.removeComma($("#dev_cost").val()))
                + Number(common.removeComma($("#des_cos").val()));
            $("#total_cost").html(common.comma(cost));
        });


        // 캠페인 확인사항 툴팁
        $('.ico_tooltip').mouseover(function(){
            let layerTop = $('#requestPopup .pop_container').offset().top;
            let tooltipTop = $(this).find('img').offset().top;
            let totalTop = tooltipTop - layerTop;
            let tooltipHt = $(this).next('.toolip_text').outerHeight();
            let tooltipMg = (tooltipHt / 2) - 8;
            $(this).next('.toolip_text').css({'top':totalTop,'marginTop':-tooltipMg});
            $(this).next('.toolip_text').addClass('on');
        });

        // 캠페인 확인사항 툴팁 mouseleave
        $('.ico_tooltip').mouseleave(function(){
            $(this).next('.toolip_text').removeClass('on');
        });

        //메일 캠페인 확인 사항 진행도 계산 동작
        $('#mailCheck input[type="checkbox"]').on('change',function(){
            let total = $('#mailCheck input[type="checkbox"]').length;
            let checkCount = $('#mailCheck input[type="checkbox"]').filter(':checked').length;
            let percents = Math.floor(checkCount / total * 100);
            $('#mailBar').css('width',percents + '%');
            $('#mailCount').html(percents);
        });

        //모바일 캠페인 확인 사항 진행도 계산 동작
        $('#mobileCheck input[type="checkbox"]').on('change',function(){
            let total = $('#mobileCheck input[type="checkbox"]').length;
            let checkCount = $('#mobileCheck input[type="checkbox"]').filter(':checked').length;
            let percents = Math.floor(checkCount / total * 100);
            $('#mobileBar').css('width',percents + '%');
            $('#mobileCount').html(percents);
        });
        /*
        $('#type_tab div').on('click',function(){
            let tabIndex = $('#type_tab div').index(this);
            $('.tab_contents').eq(tabIndex).addClass('active').siblings().removeClass('active');
        });
        */

        $('#timepicker').timepicki({
            show_meridian:false
            ,min_hour_value:0
            ,max_hour_value:23
            , on_change: function (e) {
                if(!$("#dataCalendar").val()){
                    $("#dataCalendar").val(common.today());
                    $("#test_send_dt").html($("#dataCalendar").val() + " " + $("#timepicker").val());
                }
                $("#test_send_dt").html($("#dataCalendar").val() + " " + $("#timepicker").val());
            }
        });
    });

    /* 컨트롤 그룹 (숫자만 입력가능 두자리까지만 허용) */
    function handleInput(number){
        let max = 2;
        number.value = number.value.substr(0,max);
    }

    function fn_page_tg(n, btn) {
        const res = function (response) {
            const $doc = new DOMParser().parseFromString(response, "text/html");
            $("#send_tg_tbody").html($("#send_tg_tbody", $doc).html());
            $("#send_tg_pager").html($("#send_tg_pager", $doc).html());
        };

        if (btn) {
            tg_form = $("#send_tg_form").serializeArray();
            tg_form.push({name: "pageNo", value: n});
            tg_form.push({name: "searchType", value: $("input[name='Tgtp']:checked").val()});
            com_ajax.ajax('post', '/camp/sendTragetList.ajax', tg_form, res);
        } else {
            tg_form.find(function(item) {
                return item.name === 'pageNo';
            }).value = n;
            com_ajax.ajax('post', '/camp/sendTragetList.ajax', tg_form, res);
        }
    }

    // 타겟 선택 팝업 open event
    function targetCheckPopup(){
        if(first_tg_check){
            first_tg_check = false;
            fn_page_tg(1, true);
        }
        $('#targetCheckPopup').addClass('active');
    }

    // [타겟 선택 팝업]
    function targetCheck(){
        if($("input[name='target_sel']:checked").length === 0){
            $('#targetError').html('타겟을 선택해주세요.');
        }else{
            let ele = $("input[name='target_sel']:checked");
            let text = ele.parent().parent().parent().children("td:nth-child(2)").children().html();
            let cnt = ele.parent().parent().parent().children("td:nth-child(3)").html();
            let dt = ele.parent().parent().parent().children("td:nth-child(4)").html().split(" ");

            $("#campaignTgNm").val(text);
            $("#setting_tg_nm").html(text);
            $("#setting_tg_cnt").html(cnt);

            $("#test_target_nm").html(text);
            $("#test_target_cnt").html(cnt);

            $("#confirm_target_nm").html(text);
            $("#confirm_target_cnt").html(cnt);
            $("#price_target_cnt").html("(" + cnt + "명)");

            let d_y = dt[0].split("-");
            let d_t = dt[1].split(":");
            let setting_dt_str = '<span class="en_font">'+ d_y[0] +'</span>년'
                            + '<span class="en_font">'+ d_y[1] +'</span>월'
                            + '<span class="en_font">'+ d_y[2] +'</span>일'
                            + '<span class="en_font">'+ d_t[0] +'</span>시'
                            + '<span class="en_font">'+ d_t[1] +'</span>분 기준';

            $("#setting_tg_dt").html(setting_dt_str);

            $("#campaignTgTp").val($("input[name='Tgtp']:checked").val());
            $("#campaignTgId").val($("input[name='target_sel']:checked").val());

            $("#sendTargetLst").show();
            $("#sendTargeEmpty").hide();
            $('#targetCheckPopup').removeClass('active');
        }
    }

    function fn_page_ct(n, btn){
        const res = function(response){
            const $doc = new DOMParser().parseFromString(response, "text/html");
            $("#send_ct_tbody").html($("#send_ct_tbody", $doc).html());
            $("#send_ct_pager").html($("#send_ct_pager", $doc).html());
        };
        if(btn){
            ct_form = $("#send_ct_form").serializeArray();
            ct_form.push({name : "pageNo" , value : n});
            com_ajax.ajax('post', '/camp/sendContList.ajax', ct_form, res);
        }else{
            ct_form.find(function(item) {
                return item.name === 'pageNo';
            }).value = n;
            com_ajax.ajax('post', '/camp/sendContList.ajax', ct_form, res);
        }
    }

    // 컨텐츠 선택 팝업 open event
    function contentsSettingPopup(){
        if(first_ct_check){
            first_ct_check = false;
            fn_page_ct(1, true);
        }
        $('#settingPopup').addClass('active');
    }

    //컨텐츠 선택 저장 버튼 click event
    function contentsSave() {
        if ($("input[name='cont_id']:checked").length === 0) {
            $('#erre_area2').html('컨텐츠를 선택해주세요.');
        } else {
            let ele = $("input[name='cont_id']:checked");
            let contTp = $("input[name='ch_tp']:checked").val();

            let text = "";
            if(contTp === "CH01"){
                text = ele.parent().parent().children("span").html();
            }else{
                text = ele.parent().parent().parent().children("div:eq(1)").children().html();
            }

            let cont_sub = $(ele).parent().parent().parent().children('input[name=cont_sub]').val();
            let send_to = $(ele).parent().parent().parent().children('input[name=send_to]').val();
            let send_nm = $(ele).parent().parent().parent().children('input[name=send_nm]').val();

            var parser = new DOMParser;
            var dom = parser.parseFromString('<!doctype html><body>' + text, 'text/html');
            var decodedString = dom.body.textContent;

            $("#cont_sel_nm").val(decodedString);
            $("#cont_id").val(ele.val());

            contLst = [];
            let obj  = {};
            obj.contId = ele.val();
            obj.contNm = text;
            obj.contSub = cont_sub;
            obj.sendFrom = send_to;
            obj.sendNm = send_nm;
            obj.contTp = contTp;
            contLst.push(obj);

            $('#erre_area2').html('');
            $('#settingPopup').removeClass('active');
        }
    }

    // 테스트 발송 팝업 open event
    function testGroupPopup(){
        if(first_test_check){
            if(!$("#pro_nm").val()){
                popup.popAlert("캠페인명을 입력해주세요.");
                return;
            } else if(!$("#campaignTgId").val()) {
                popup.popAlert("캠페인 타겟이 선택 되지않았습니다.");
                return;
            } else if(!$("#cont_id").val()){
                popup.popAlert("컨텐츠가 선택 되지않았습니다.");
                return;
            }else{
                let obj = contLst[0];
                $("#test_cont_nm").html(obj.contSub);
                $("#test_from").html(obj.sendNm + " ("+ obj.sendFrom +") ");
                $("#test_cont_sub").val(obj.contSub);
                common.calculate(obj.contSub, 'test_cont_sub_byte');
                $("#test_cont_id").val(obj.contId);

                const res = function(response){
                    const $doc = new DOMParser().parseFromString(response, "text/html");
                    $("#preview_slideSwiper", $doc).attr("id", "preview_slideSwiper2");
                    $("#preview_rcs_paging", $doc).attr("id", "preview_rcs_paging2");
                    $("#preview_rcs_next", $doc).attr("id", "preview_rcs_next2");
                    $("#preview_rcs_prev", $doc).attr("id", "preview_rcs_prev2");

                    $("#preview_2").html($("#preview", $doc).html());
                    new Swiper("#preview_slideSwiper2", {
                        direction: 'horizontal',
                        pagination: {
                            el: '#preview_rcs_paging2',
                            type: 'fraction',
                        },
                        navigation: {
                            nextEl: '#preview_rcs_next2',
                            prevEl: '#preview_rcs_prev2',
                        },
                    });
                };
                let data = [];
                data.push({name : "cont_id" , value : obj.contId });
                com_ajax.ajax('post', '/camp/sendContPreview.ajax', data, res);
            }
        }
        $('#testGroupPopup').addClass('active');
    }

    // 테스트 발송 팝업 발송 버튼 click event
    function testSendSave(){
        const cnt = $("#test_target_lst > tr").length;
        let error = $('#error_area3');
        let sub = $("#test_cont_sub").val();
        let contTp = contLst[0].contTp;

        if(cnt === 0) {
            $(error).html('테스트 타겟을 선택/입력 해주세요.');
            return false;
        } else if (contTp == 'CH02' && common.calByte(sub) > 40) {
            popup.popAlert("문자 제목은 40byte를 초과 할수 없습니다.");
            return false;
        } else {
            $(error).html('');
            $("#test_send_target_cnt").html(cnt);
            popup.confirmAlertCallback(cnt + "명에게 테스트 발송을 진행합니다.", "testSending(this)");
        }
    }

    function testSending(e){
        if(testSend){
            testSend = false;
            const res = function(response){
                popupClose(e);
                if(response.status){
                    popup.popAlert("테스트 발송이 시작되었습니다.");
                }else{
                    popup.popAlert(response.message);
                }
                testSend = true;
            };
            let data = $("#test_send_form").serializeArray();
            data.push({name : "pro_tg_id" , value : $("#testGroupVal").attr('data') });
            data.push({name : "cont_sub" , value : $("#test_cont_sub").val() });
            com_ajax.ajax('post', '/camp/sendTest.ajax', data, res);
        }
    }

    // 테스트 발송 안내 팝업 확인 버튼 event
    function testConfirm(){
        $('.layer_pop').removeClass('active');
    }

    //승인요청 팝업 open event
    function requestPopup(){
        if(!$("#pro_nm").val()) {
            popup.popAlert("캠페인명을 입력해주세요.");
            return;
        } else if(!$("#campaignTgId").val()) {
            popup.popAlert("캠페인 타겟이 선택 되지않았습니다.");
            return;
        } else if(!$("#cont_id").val()) {
            popup.popAlert("컨텐츠가 선택 되지않았습니다.");
            return;
        } else if($("input[name='send_tp']").val() === "0" &&  (!$("input[name='send_dt']").val() || !$("input[name='send_time']").val())) {
            popup.popAlert("발송 시간이 선택 되지않았습니다.");
            return;
        } else {
            let obj = contLst[0];
            $("#confirm_cont_nm").html(obj.contSub);
            $("#confirm_from").html(obj.sendNm + " (" + obj.sendFrom + ") ");
            $("#confirm_cont_sub").html(obj.contSub);
            $("#confirm_cont_id").html(obj.contId);
            if($("input[name='send_tp']").val() === "0"){
                $("#confirm_send_dt").html($("input[name='send_dt']").val() + " " + $("input[name='send_time']").val());
            }else{
                $("input[name='send_dt']").val(common.today());
                $("input[name='send_time']").val(common.todayTime());
                $("#confirm_send_dt").html($("input[name='send_dt']").val() + " " + $("input[name='send_time']").val());
            }
            $("#sendTarget").html();

            if(obj.contTp === "CH01"){
                $("#type_tab").children("div:eq(0)").addClass("on");
                $("#type_tab").children("div:eq(0)").show();
                $("#type_tab").children("div:eq(1)").removeClass("on");
                $("#type_tab").children("div:eq(1)").hide();
                $("#emdCheckLst").addClass("active");
                $("#mdmCheckLst").removeClass("active");
            }else{
                $("#type_tab").children("div:eq(1)").addClass("on");
                $("#type_tab").children("div:eq(1)").show();
                $("#type_tab").children("div:eq(0)").removeClass("on");
                $("#type_tab").children("div:eq(0)").hide();
                $("#emdCheckLst").removeClass("active");
                $("#mdmCheckLst").addClass("active");
            }

            const res = function (response) {
                const $doc = new DOMParser().parseFromString(response, "text/html");
                $("#preview_slideSwiper", $doc).attr("id", "preview_slideSwiper3");
                $("#preview_rcs_paging", $doc).attr("id", "preview_rcs_paging3");
                $("#preview_rcs_next", $doc).attr("id", "preview_rcs_next3");
                $("#preview_rcs_prev", $doc).attr("id", "preview_rcs_prev3");

                $("#preview_3").html($("#preview", $doc).html());
                new Swiper("#preview_slideSwiper3", {
                    direction: 'horizontal',
                    pagination: {
                        el: '#preview_rcs_paging3',
                        type: 'fraction',
                    },
                    navigation: {
                        nextEl: '#preview_rcs_next3',
                        prevEl: '#preview_rcs_prev3',
                    },
                });
            };
            let data = [];
            data.push({name: "cont_id", value: obj.contId});
            com_ajax.ajax('post', '/camp/sendContPreview.ajax', data, res);
        }
        $('#requestPopup').addClass('active');
    }

    //승인요청 팝업 버튼
    function requestConfirm(){
        let appr_id = ($("#appr_id").attr("data")).trim();
        let checkPer;
        let obj = contLst[0];
        if(obj.contTp === "CH01"){
            checkPer = $("#mailBar").width() / $('#mailBar').parent().width() * 100;
        }else {
            checkPer = $("#mobileBar").width() / $('#mobileBar').parent().width() * 100;
        }

        if(!appr_id){
            popup.popAlert("승인 담당자를 선택 해주세요.");
            return;
        }
        if(checkPer !== 100){
            popup.popAlert("캠페인 확인사항을 검토 해주세요.");
            return;
        }
        popup.confirmAlertCallback("승인요청 시, 승인 담당자에게<br/>승인요청 메일이 발송되며, 해당 발송 건은<br/> 승인 대기 상태로 변경됩니다. 요청하시겠습니까?", "sending(this)");
        $('#type1').addClass('active');
    }

    //모두 확인 체크 동작
    function allCheck(type){
        if(type == 'mail'){
            $('#mailCheck input[type="checkbox"]').prop('checked', true);
            $('#mailBar').css('width','100%');
            $('#mailCount').html('100');
        }
        if(type == 'mobile'){
            $('#mobileCheck input[type="checkbox"]').prop('checked', true);
            $('#mobileBar').css('width','100%');
            $('#mobileCount').html('100');
        }
        return false;
    }

    // 컨텐츠명 중복 검사후 이상 없으면 Sending 처리
    function sending(){
        let pro_nm = $("#pro_nm").val();

        const res = function(response) {
            if(response.status == false) {
                popup.popAlert(response.message);
            }else {
                let fm = $("#form");
                common.add_input(fm, "appr_id", $("#appr_id").attr('data'));
                common.add_input(fm, "plan_cost", common.removeComma($("#plan_cost").val()));
                common.add_input(fm, "off_cost", common.removeComma($("#off_cost").val()));
                common.add_input(fm, "dev_cost", common.removeComma($("#dev_cost").val()));
                common.add_input(fm, "des_cost", common.removeComma($("#des_cost").val()));
                fm.submit();
            }
        }

        let data = [];
        data.push({name: "pro_nm", value: pro_nm});
        com_ajax.ajax('post', '/camp/isCheckProNm.ajax', data, res);
    }

    // 임시 저장 시 유효성 체크
    function temporarySave(){
        let proNm = $('#pro_nm').val();
        if(proNm === ''){
            popup.popAlert('캠페인 명을 입력해 주세요.');
            return false;
        } else {
            const res = function(response){
                if(response.status){
                    popup.popAlert("임시저장 되었습니다.");
                    if(response.pro_id){
                        $("#pro_id").val(response.pro_id);
                    }
                    if(response.camp_id){
                        $("#camp_id").val(response.camp_id);
                    }
                }else{
                    popup.popAlert(response.message);
                }
            };

            let data = $("#form").serializeArray();
            data.push({name : "plan_cost" , value : common.removeComma($("#plan_cost").val()) });
            data.push({name : "off_cost" , value : common.removeComma($("#off_cost").val()) });
            data.push({name : "dev_cost" , value : common.removeComma($("#dev_cost").val()) });
            data.push({name : "des_cost" , value : common.removeComma($("#des_cost").val()) });
            com_ajax.ajax('post', '/camp/sendTempCreate.ajax', data, res);
            return true;
        }
    }

    // 타겟 별 상세 비용 팝업 open event
    function detailPrice(){
        $('#detailPrice').show();
    }

    // 타겟 별 상세 비용 팝업 close event
    function detailPriceClose(){
        $('#detailPrice').hide();
    }

</script>