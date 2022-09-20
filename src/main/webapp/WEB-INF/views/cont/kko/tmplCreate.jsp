<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>

<!-- smsCreste.js -->
<script src="/js/smsCreate.js"></script>
<!-- image upload js -->
<script src="/js/imageUpload.js"></script>
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
                    <li>메세지</li>
                    <li>알림톡</li>
                    <li>알림톡 템플릿 생성</li>
                </ul>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <form:form id="form" action="/cont/kko/tmplCreate.service" method="post">
                <div class="create_sms cf">
                    <div class="tab_contents active">
                        <div class="sms_form cover" id="kakao">
                            <h2>알림톡 템플릿</h2>
                            <div class="flex_box">
                                <div class="left_area">
                                    <div class="input_area left">
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">발신 프로필 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <input type="text" class="sms_number smsNumber" id="kko_send_to" style="width: 90%; height: 100%;"
                                                           placeholder="발신 프로필을 선택해주세요." readonly/>
                                                    <input type="hidden" name="send_key" id="send_key" value=""/>
                                                    <span class="btn_sm_line" onclick="mobileSenderPopup('1','sms')">변경</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">템플릿코드 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <input type="text" class="txt_input txt_input2" name="tmpl_cd" id="tmplCode"
                                                           placeholder=""/>
                                                    <span class="btn_sm_line btn_sm_line2 tmplCodeBtn">코드 자동 생성</span>
                                                    <input type="hidden" name="sms_trackinglink"/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block3">
                                            <div class="row">
                                                <div class="th th2">보안템플릿</div>
                                                <div class="td template_check_td">
                                                    <input type="checkbox" id="template_check">
                                                    <label for="template_check">보안 템플릿 설정 시, 메인 디바이스 모바일 외 모든 서브 디바이스에서는 메시지 내용이 노출되지 않습니다.</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block3">
                                            <div class="row">
                                                <div class="th th2">카테고리 <span class="color_red">*</span></div>
                                                <div class="td template_category_td">
                                                    <!-- select 영역1 시작 -->
                                                    <div class="select bizContsVal_group" name="edmDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="${cateLst[0].cd_sn}">${cateLst[0].cd_desc}</div>
                                                        <ol class="option">
                                                            <c:forEach var="cate" items="${cateLst}">
                                                                <li value="${cate.cd_sn}">${cate.cd_desc}</li>
                                                            </c:forEach>
                                                        </ol>
                                                    </div>
                                                    <!-- select 영역1 끝 -->
                                                    <!-- select 영역2 시작 -->
                                                    <div class="select select2 bizContsVal" name="edmDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="${cateSubLst[0].cd_sn}">${cateSubLst[0].cd_desc}</div>
                                                        <ol class="option">
                                                            <c:forEach var="cateSub" items="${cateSubLst}">
                                                                <li class="cate_op_${cateSub.par_nm}" value="${cateSub.cd_sn}">${cateSub.cd_desc}</li>
                                                            </c:forEach>
                                                        </ol>
                                                    </div>
                                                    <!-- select 영역2 끝 -->
                                                    <p class="template_category_p">
                                                        카테고리 그룹, 카테고리를 모두 설정해주세요.
                                                    </p>
                                                    <c:forEach var="guideMsg" items="${cateSubGidLst}">
                                                        <p class="template_category_p gid_${guideMsg.par_nm}" hidden>
                                                            ${guideMsg.cd_desc}
                                                        </p>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">템플릿명 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <input type="text" class="txt_input" name="tmpl_nm" style="width: 100%;"
                                                           placeholder="템플릿명 입력 (최대 200자)"/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block_group">
                                            <div class="block block4 template_msg">
                                                <div class="row">
                                                    <div class="th">메시지유형 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <!-- select 영역 시작 -->
                                                        <div class="select bizMsgVal" name="edmDB">
                                                            <!-- selected value -->
                                                            <div class="value" data="${msgTpLst[0].cd_sn}">${msgTpLst[0].cd_desc}</div>
                                                            <ol class="option">
                                                                <c:forEach var="msgTp" items="${msgTpLst}">
                                                                    <li value="${msgTp.cd_sn}">${msgTp.cd_desc}</li>
                                                                </c:forEach>
                                                            </ol>
                                                        </div>
                                                        <!-- select 영역 끝 -->
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block block4">
                                                <div class="row">
                                                    <div class="th">강조유형 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <!-- select 영역 시작 -->
                                                        <div class="select bizEmphVal" name="edmDB">
                                                            <!-- selected value -->
                                                            <div class="value" data="0">선택안함</div>
                                                            <ol class="option">
                                                                <c:forEach var="empTp" items="${empTpLst}">
                                                                    <li value="${empTp.cd_sn}">${empTp.cd_desc}</li>
                                                                </c:forEach>
                                                            </ol>
                                                        </div>
                                                        <!-- select 영역 끝 -->
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block_group emphtxt_block display-none">
                                            <div class="block block4">
                                                <div class="row">
                                                    <div class="th">강조 표기 타이틀 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <input type="text" class="txt_input3" name="tmplEmphTitle" placeholder="강조 표기 타이틀 입력 (최대 50자)">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block block4 emphtxt_block2">
                                                <div class="row">
                                                    <div class="th" style="line-height: 18px;">강조 표기<br>보조 문구 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <input type="text" class="txt_input3" name="tmplEmphTxt" placeholder="강조 표기 보조 문구 입력 (최대 50자)">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block emphImg_block display-none">
                                            <div class="row">
                                                <div class="th">이미지 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <div class="template_add_img">
                                                        click here to upload
                                                    </div>
                                                    <p class="color_red">
                                                        - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                        - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="emphItemList_block display-none">
                                            <div class="block emphItemList_img">
                                                <div class="row" style="height: auto;">
                                                    <div class="th">이미지</div>
                                                    <div class="td">
                                                        <input type="checkbox" id="img_check">
                                                        <label for="img_check">설정</label>

                                                        <div class="itemlist_img_on dis_flex display-none">
                                                            <div class="template_add_img">
                                                                click here to upload
                                                            </div>
                                                            <p class="color_red">
                                                                - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                                - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="block emphItemList_header">
                                                <div class="row" style="height: auto;">
                                                    <div class="th">헤더</div>
                                                    <div class="td">
                                                        <input type="checkbox" id="header_check">
                                                        <label for="header_check">설정</label>

                                                        <input type="text" class="header-check-on border display-none" placeholder="헤더 내용 입력 (최대 16자)">
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="block emphItemList_highlight">
                                                <div class="row" style="height: auto;">
                                                    <div class="th" style="line-height: 17px;">아이템<br>하이라이트</div>
                                                    <div class="td">
                                                        <div class="highlight_div">
                                                            <input type="checkbox" id="highlight_check">
                                                            <label for="highlight_check">설정 (아이템 하이라이트 체크 시, 하이라이트 타이틀 및 디스크립션 설정이 필수입니다.)</label>
                                                        </div>

                                                        <div class="highlight_div highlight_check_on display-none">
                                                            <input type="text" class="txt_input4 first border" placeholder="타이틀 입력 (최대 30자)">
                                                            <input type="text" class="txt_input4 border" placeholder="디스크립션 입력 (최대 19자)">
                                                        </div>

                                                        <div class="highlight_div highlight_check_on display-none">
                                                            <input type="checkbox" id="highlight_img_check">
                                                            <label for="highlight_img_check">이미지 (썸네일을 추가하면 타이틀은 21자, 디스크립션은 13자까지 입력 가능합니다.)</label>
                                                        </div>

                                                        <div class="highlight_div highlight_img_on dis_flex display-none">
                                                            <div class="template_add_img">
                                                                click here to upload
                                                            </div>
                                                            <p class="color_red">
                                                                - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                                - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="block template_table emphItemList_list">
                                                <div class="row" style="height: auto;">
                                                    <div class="th" style="line-height: 17px;">
                                                        아이템<br/>리스트
                                                        <div class="button" onclick="addRowItemList()">추가</div>
                                                    </div>
                                                    <div class="td">
                                                        <table id="emphItemList_list_table">
                                                            <colgroup>
                                                                <col width="8%">
                                                                <col width="35%">
                                                                <col width="45%">
                                                                <col width="12%">
                                                            </colgroup>
                                                            <thead>
                                                                <th>순서</th>
                                                                <th>아이템명</th>
                                                                <th>아이템내용</th>
                                                                <th>삭제</th>
                                                            </thead>
                                                            <tbody>
                                                                <tr class="itemList_add_table1" id="itemList_add_table1">
                                                                    <td>1</td>
                                                                    <td>
                                                                        <input class="border" type="text" placeholder="아이템 명 (6자 이내)">
                                                                    </td>
                                                                    <td>
                                                                        <input class="border" type="text" placeholder="아이템 내용 (23자 이내)">
                                                                    </td>
                                                                    <td>
                                                                        <div class="table_btn">
                                                                            <div class="up" onclick="upRow3(this)"><i class="fa-solid fa-square-caret-up"></i></div>
                                                                            <div class="down" onclick="downRow3(this)"><i class="fa-solid fa-square-caret-down"></i></div>
                                                                            <div class="del" onclick="deleteRow3(this)"><i class="fa-solid fa-square-xmark"></i></div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr class="itemList_add_table2" id="itemList_add_table2">
                                                                    <td>2</td>
                                                                    <td>
                                                                        <input class="border" type="text" placeholder="아이템 명 (6자 이내)">
                                                                    </td>
                                                                    <td>
                                                                        <input class="border" type="text" placeholder="아이템 내용 (23자 이내)">
                                                                    </td>
                                                                    <td>
                                                                        <div class="table_btn">
                                                                            <div class="up" onclick="upRow3(this)"><i class="fa-solid fa-square-caret-up"></i></div>
                                                                            <div class="down" onclick="downRow3(this)"><i class="fa-solid fa-square-caret-down"></i></div>
                                                                            <div class="del" onclick="deleteRow3(this)"><i class="fa-solid fa-square-xmark"></i></div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="block emphItemList_itemInfo">
                                                <div class="row" style="height: auto;">
                                                    <div class="th" style="line-height: 17px;">아이템<br>요약정보</div>
                                                    <div class="td">
                                                        <div class="itemInfo_div">
                                                            <input type="checkbox" id="itemInfo_check">
                                                            <label for="itemInfo_check">설정 (요약정보의 아이템내용은 변수 및 화폐 단위, 숫자, 쉼표, 마침표만 사용 가능합니다.)</label>
                                                        </div>

                                                        <div class="itemInfo_div itemInfo_check_on display-none">
                                                            <input type="text" class="txt_input4 first border" placeholder="아이템 명 (최대 6자)">
                                                            <input type="text" class="txt_input4 border" placeholder="아이템 내용 입력 (최대 14자, 화폐단위 및 숫자(쉼표 마침표 혀용) , 변수만 사용가능)">
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="block">
                                            <div class="row template_textarea">
                                                <div class="th">템플릿내용 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <textarea rows="8" name="tmplTxt" placeholder="텍스트 입력 (최대 1000자)"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block addinfo_block">
                                            <div class="row template_textarea">
                                                <div class="th">부가 정보 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <textarea rows="8" name="tmplAddInfo" placeholder="텍스트 입력 (최대 500자)"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block adver_msg_block">
                                            <div class="row template_textarea">
                                                <div class="th">광고성 메시지 <span class="color_red">*</span><br>(수신 동의 요청 또는 간단 광고 문구)
                                                </div>
                                                <div class="td">
                                                    <textarea rows="8" name="tmpl_ad" placeholder="텍스트 입력 (최대 500자)"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block2 addchannel_block">
                                            <div class="row template_textarea2">
                                                <div class="th">채널 추가<br>안내 메시지</div>
                                                <div class="td">
                                                    <textarea rows="2" placeholder="채널 추가하고 이 채널의 광고와 마케팅 메시지 받기" readonly ></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block3 addchannel_block">
                                            <div class="row row2 template_textarea3">
                                                <div class="th"></div>
                                                <div class="td">
                                                    <p class="color_red">
                                                        * 메시지 유형이 "채널 추가형" 혹은 "복합형"인 경우 "채널 추가" 버튼이 필수이며 메시지 하단에 채널 추가 안내 메시지가 함께 노출됩니다.<br>
                                                        (발송 시점 이미 채널을 추가한 수신자에게는 채널추가 버튼과 채널추가 안내 메시지는 미노출됩니다.)<br>
                                                        * 채널 추가 버튼과 부가정보를 함께 사용하고 싶으면 '복합형' 유형을 선택해주세요.
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block template_table template_btn_table">
                                            <div class="row" style="height: auto;">
                                                <div class="th">
                                                    버튼
                                                    <div class="button" onclick="addRowBtn()">추가</div>
                                                </div>
                                                <div class="td">
                                                    <table id="template_btn_table">
                                                        <colgroup>
                                                            <col width="8%">
                                                            <col width="15%">
                                                            <col width="20%">
                                                            <col>
                                                            <col width="16%">
                                                        </colgroup>
                                                        <thead>
                                                            <th>순서</th>
                                                            <th>버튼타입</th>
                                                            <th>버튼명</th>
                                                            <th>버튼링크</th>
                                                            <th>삭제</th>
                                                        </thead>
                                                        <tbody>
                                                            <tr class="type_table_no_info">
                                                                <td colspan="5">
                                                                    버튼 정보가 없습니다.
                                                                </td>
                                                            </tr>

                                                            <tr class="channel_add_table display-none" id="channel_add_table">
                                                                <td>1</td>
                                                                <td>
                                                                    <select class="border" id="channel_add_select" disabled>
                                                                        <option>채널추가</option>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <input class="border" type="text" placeholder="채널 추가" disabled readonly>
                                                                </td>
                                                                <td>
                                                                    <p class="color_red">* 채널 추가 버튼은 단독 혹은 최상단에 위치한 경우에만 가능</p>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block template_table template_link_table">
                                            <div class="row" style="height: auto;">
                                                <div class="th">
                                                    바로연결
                                                    <div class="button" onclick="addRowLink()">추가</div>
                                                </div>
                                                <div class="td">
                                                    <table id="template_link_table">
                                                        <colgroup>
                                                            <col width="8%">
                                                            <col width="15%">
                                                            <col width="20%">
                                                            <col>
                                                            <col width="16%">
                                                        </colgroup>
                                                        <thead>
                                                            <th>순서</th>
                                                            <th>바로연결 타입</th>
                                                            <th>바로연결명</th>
                                                            <th>바로연결 링크</th>
                                                            <th>삭제</th>
                                                        </thead>
                                                        <tbody>
                                                            <tr class="link_table_no_info">
                                                                <td colspan="5">
                                                                    바로연결 정보가 없습니다.
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="viewer_area">
                                    <div class="top">문자 본문 입력창</div>
                                    <div class="inner">
<%--                                        <div class="sms_title" id="sms_title"></div>--%>
<%--                                        <div class="sms_img"></div>--%>
                                        <textarea name="sms_body" id="" class="sms_txt textarea" cols="30" rows="10"
                                                  onkeyup="smsCreate.byteCount(this, 'sms');"></textarea>
                                    </div>
                                    <div class="byte">
                                        <span class="en_font sms_byte">0</span><span class="en_font">byte</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
<%--                    </div>--%>
                    </form:form>
                    <div class="btn_row bottom-border" id="js-btn-area">
                        <input type="button" class="btn_save btn_bg btn_center btn_size1" id="previewBtn" value="저장"/>
                    </div>
                </div>
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
</div>
<!-- 새 이미지 파일 업로드 팝업 영역 시작 -->
<span id="imgListHtml"></span>
<!-- 새 이미지 파일 업로드 팝업 영역 끝 -->

<form:form id="tblmisetForm" name="tblmisetForm" onsubmit="return false">
    <span id="callPopUp">
    </span>
</form:form>

<form:form id="imgSetForm" name="imgSetForm" onsubmit="return false">
<span id="imgPopUp">
        <div class="layer_pop imagePopup">
    <div class="pop_container popup_size2">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">이미지 선택</div>
        <div class="pop_inner">
            <div class="form_search">
                <!-- 검색 영역 시작 -->
                <input type="text" class="calendar" name="reg_dt" id="from" placeholder="등록일 선택"/>
                <span class="hyphen"></span>
                <input type="text" class="calendar" name="reg_dt_range" id="to" placeholder="등록일 선택"/>
                <div class="input_txt left-border-none">
                    <input type="text"  name='img_nm' placeholder="이미지 명 입력"/>
                    <input type="button" class="btn_search" onclick="imageListPaging('1')" value="검색"/>
                </div>
                <!-- 검색 영역 끝 -->

                <!-- 새 이미지 등록 버튼 -->
                <div class="btn_new_image" onclick="imgUploadPop();">새 이미지 등록</div>
            </div>
            <form action="" id="imagePop">
                <div class="image_container" id="bodyDom">
                </div>
        </form>
        <div class="btn_row bottom-border left-border right-border">
            <ul class="pager" id="pagingDom">
            </ul>
            <input type="hidden" id="imgType" name="imgType" value=""/>
        </div>
        <div class="pop_error_txt blue_point_color"></div>
        <div class="btn_row">
            <input type="button" class="btn_bg btn_size2 btn_center imageSave" id="" value="저장"
                   onclick="imgSendSave();"/>
        </div>
    </div>
</div>
</div>
</span>
</form:form>

<form:form id="saveForm" name="saveForm" onsubmit="return false">
    <span id="preview"></span>
</form:form>


<script>
    let beforeSub = $('input[name="rcs_msg_tp"]:checked').val();
    let slideData = $('.slide_type').find('.value').attr('data') == undefined ? '0' : $('.slide_type').find('.value').attr('data');

    function getDBValue() {
        let dbValue = $('input[name="dbInfo"]:checked').val();
        let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
        let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();

        $('.rcsTitleVal[name="edmDB"] .option').html(edmDB);
        $('.rcsContsVal[name="edmDB"] .option').html(edmDB);
        $('.rcsTitleVal[name="defaultDB"] .option').html(defaultDB);
        $('.rcsContsVal[name="defaultDB"] .option').html(defaultDB);

        if (dbValue == '0') {
            $('div[name="edmDB"]').show();
            $('div[name="defaultDB"]').hide();
        }
        if (dbValue == '1') {
            $('div[name="edmDB"]').hide();
            $('div[name="defaultDB"]').show();
        }
    }

    /*----- 알림톡 템플릿 테이블 ------*/
    // 버튼 열 추가
    function addRowBtn() {
        $('.type_table_no_info').addClass('display-none');

        let table = document.getElementById('template_btn_table');

        let newRow = table.insertRow();
        let newCell1 = newRow.insertCell(0);
        let newCell2 = newRow.insertCell(1);
        let newCell3 = newRow.insertCell(2);
        let newCell4 = newRow.insertCell(3);
        let newCell5 = newRow.insertCell(4);

        let addCell1 = '';
        let addCell2 = '';
        let addCell3 = '';
        let addCell4 = '';

        addCell1 += '<select class="border" id="table_btn_type" onchange="selectType(this.value, this)">' +
            '<option value="" selected disabled>버튼타입 선택</option>' +
            '<option value="0">웹링크</option>'+
            '<option value="1">앱링크</option>'+
            '<option value="2">배송조회</option>'+
            '<option value="3">봇키워드</option>'+
            '<option value="4">메시지전달</option>'+
            '<option value="5">상담톡전환</option>'+
            '<option value="6">봇전환</option>'+
            '<option value="7">이미지 보안 전송 플러그인</option>'+
            '<option value="8">개인정보이용 플러그인</option>'+
            '<option value="9">원클릭 결제 플러그인</option>'+
            '</select>';

        addCell2 += '<input class="border" type="text" placeholder="버튼명 입력 (14자 이내)">';

        addCell3 += '<div class="webLink-on display-none">' +
                    '<p class="btn_link_title_first">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>'+
                    '<div class="appLink-on display-none">'+
                    '<p class="color_red">* Android, iOS, Mobile 중 2가지 이상 입력 필수</p>'+
                    '<p class="btn_link_title">Android</p>'+
                    '<input type="text" class="border" placeholder="scheme android 링크">'+
                    '<p class="btn_link_title">iOS</p>'+
                    '<input type="text" class="border" placeholder="scheme iOS 링크">'+
                    '<p class="btn_link_title">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>'+
                    '<div class="plugin-on display-none">'+
                    '<input type="text" class="border" placeholder="플러그인 ID">'+
                    '</div>';
        addCell4 += '<div class="table_btn">'+
                    '<div class="up" onclick="upRow(this)"><i class="fa-solid fa-square-caret-up"></i></div>'+
                    '<div class="down" onclick="downRow(this)"><i class="fa-solid fa-square-caret-down"></i></div>'+
                    '<div class="del" onclick="deleteRow(this)"><i class="fa-solid fa-square-xmark"></i></div>'+
                    '</div>';

        let dis = $('.channel_add_table').hasClass('display-none');

        if(dis == false){
            newCell1.innerText = table.tBodies[0].rows.length -1;
        } else if (dis == true) {
            newCell1.innerText = table.tBodies[0].rows.length -2;
        }

        newCell2.innerHTML = addCell1;
        newCell3.innerHTML = addCell2;
        newCell4.innerHTML = addCell3;
        newCell5.innerHTML = addCell4;
    }

    // 바로연결 열 추가
    function addRowLink() {
        $('.link_table_no_info').addClass('display-none');

        let table = document.getElementById('template_link_table');

        let newRow = table.insertRow();
        let newCell1 = newRow.insertCell(0);
        let newCell2 = newRow.insertCell(1);
        let newCell3 = newRow.insertCell(2);
        let newCell4 = newRow.insertCell(3);
        let newCell5 = newRow.insertCell(4);

        let addCell1 = '';
        let addCell2 = '';
        let addCell3 = '';
        let addCell4 = '';

        addCell1 += '<select class="border" id="table_link_type" onchange="selectType2(this.value, this)">' +
            '<option value="" selected disabled>바로연결 타입 선택</option>' +
            '<option value="0">웹링크</option>'+
            '<option value="1">앱링크</option>'+
            '<option value="2">봇키워드</option>'+
            '<option value="3">메시지전달</option>'+
            '<option value="4">상담톡전환</option>'+
            '<option value="5">봇전환</option>'+
            '</select>';

        addCell2 += '<input class="border" type="text" placeholder="바로연결명 입력 (14자 이내)">';

        addCell3 += '<div class="webLink-on display-none">' +
                    '<p class="btn_link_title_first">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>'+
                    '<div class="appLink-on display-none">'+
                    '<p class="color_red">* Android, iOS, Mobile 중 2가지 이상 입력 필수</p>'+
                    '<p class="btn_link_title">Android</p>'+
                    '<input type="text" class="border" placeholder="scheme android 링크">'+
                    '<p class="btn_link_title">iOS</p>'+
                    '<input type="text" class="border" placeholder="scheme iOS 링크">'+
                    '<p class="btn_link_title">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>';

        addCell4 += '<div class="table_btn">'+
                    '<div class="up" onclick="upRow2(this)"><i class="fa-solid fa-square-caret-up"></i></div>'+
                    '<div class="down" onclick="downRow2(this)"><i class="fa-solid fa-square-caret-down"></i></div>'+
                    '<div class="del" onclick="deleteRow2(this)"><i class="fa-solid fa-square-xmark"></i></div>'+
                    '</div>';

        newCell1.innerText = table.tBodies[0].rows.length -1;
        newCell2.innerHTML = addCell1;
        newCell3.innerHTML = addCell2;
        newCell4.innerHTML = addCell3;
        newCell5.innerHTML = addCell4;
    }

    // 아이템리스트 열 추가
    function addRowItemList() {
        let table = document.getElementById('emphItemList_list_table');

        let newRow = table.insertRow();
        let newCell1 = newRow.insertCell(0);
        let newCell2 = newRow.insertCell(1);
        let newCell3 = newRow.insertCell(2);
        let newCell4 = newRow.insertCell(3);

        let addCell2 = '';
        let addCell3 = '';
        let addCell4 = '';

        addCell2 += '<input class="border" type="text" placeholder="아이템 명 (6자 이내)">';
        addCell3 += '<input class="border" type="text" placeholder="아이템 내용 (23자 이내)">';

        addCell4 += '<div class="table_btn">'+
                    '<div class="up" onclick="upRow3(this)"><i class="fa-solid fa-square-caret-up"></i></div>'+
                    '<div class="down" onclick="downRow3(this)"><i class="fa-solid fa-square-caret-down"></i></div>'+
                    '<div class="del" onclick="deleteRow3(this)"><i class="fa-solid fa-square-xmark"></i></div>'+
                    '</div>';

        newCell1.innerText = table.tBodies[0].rows.length;
        newCell2.innerHTML = addCell2;
        newCell3.innerHTML = addCell3;
        newCell4.innerHTML = addCell4;
    }

    // 열 위로 이동
    function upRow(n){
        let i = n.parentNode.parentNode.parentNode;

        if(i.rowIndex <= 3) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }
        cellNum();
    }
    function upRow2(n){
        let i = n.parentNode.parentNode.parentNode;

        if(i.rowIndex <= 2) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }
        cellNum2();
    }
    function upRow3(n){
        let i = n.parentNode.parentNode.parentNode;

        if(i.rowIndex <= 1) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }
        cellNum3();
    }

    // 열 아래로 이동
    function downRow(n){
        let table = document.getElementById('template_btn_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if(i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }

        cellNum();
    }
    function downRow2(n){
        let table = document.getElementById('template_link_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if(i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }
        cellNum2();
    }
    function downRow3(n){
        let table = document.getElementById('emphItemList_list_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if(i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }
        cellNum3();
    }

    // 열 삭제
    function deleteRow(n){
        let table = document.getElementById('template_btn_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        table.deleteRow(i);

        let dis = $('.channel_add_table').hasClass('display-none');

        if(dis == false){
            let cnt = table.tBodies[0].rows.length;
            if(cnt <= 1) {
                $('.type_table_no_info').removeClass('display-none');
            }
        } else if (dis == true){
            let cnt = table.tBodies[0].rows.length;
            if(cnt <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }
        }

        cellNum();
    }
    function deleteRow2(n){
        let table = document.getElementById('template_link_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        table.deleteRow(i);

        let cnt = table.tBodies[0].rows.length;
        if(cnt <= 1) {
            $('.link_table_no_info').removeClass('display-none');
        }
        cellNum2();
    }

    function deleteRow3(n){
        let table = document.getElementById('emphItemList_list_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        let cnt = table.tBodies[0].rows.length;
        if(cnt <= 2) {
            let msg = '아이템 리스트는 최소 2개이상 설정 가능합니다.';
            alertMsg2(msg)
            return false;
        } else {
            table.deleteRow(i);
        }
        cellNum3();
    }

    function alertMsg2(msg) {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">아이템 리스트</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + msg + '</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this);" value="확인" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
    }

    // 행 번호 리셋
    function cellNum() {
        let table = document.getElementById('template_btn_table');
        let cnt = table.tBodies[0].rows.length;
        let row = "";

        let dis = $('.channel_add_table').hasClass('display-none');
        console.log(table.tBodies[0].rows)
        // 채널추가 열이 display block인 경우
        if(dis == false){
            for(let i = 0; i < cnt; i++){
                row = table.tBodies[0].rows[i];
                let cell = row.getElementsByTagName('td')[0];
                cell.innerText = String(i);
            }
        // 채널추가 열이 display none인 경우
        } else if(dis == true){
            for(let i = 0; i < cnt; i++){
                row = table.tBodies[0].rows[i];
                let cell = row.getElementsByTagName('td')[0];
                cell.innerText = String(i-1);
            }
        }
    }
    function cellNum2() {
        let table = document.getElementById('template_link_table');
        let cnt = table.tBodies[0].rows.length;

        let row = "";
        for(let i = 0; i < cnt; i++){
            row = table.tBodies[0].rows[i];
            let cell = row.getElementsByTagName('td')[0];
            cell.innerText = String(i);
        }
    }
    function cellNum3() {
        let table = document.getElementById('emphItemList_list_table');
        let cnt = table.tBodies[0].rows.length;

        let row = "";
        for(let i = 0; i < cnt; i++){
            row = table.tBodies[0].rows[i];
            let cell = row.getElementsByTagName('td')[0];
            cell.innerText = String(i+1);
        }
    }

    // 버튼 타입 선택
    function selectType(val, i){

        if(val == 0){
            typeFirstOption(i);
        } else if (val == 1){
            typeSecondOption(i);
        } else if (val >= 2 && val <= 6){
            typeAllNone(i);
        } else if (val >= 7){
            typeThirdOption(i);
        }
    }
    function typeAllNone(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');

        let NodeLen = n.parentNode.parentNode.childNodes[3].childNodes.length;

        let plugin = "";
        let pluginBlock = "";
        if(NodeLen == 3){
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if(webLinkBlock == true && appLinkBlock == true && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.add('display-none');
                plugin.classList.add('display-none');
            }

        } else {
            if(webLinkBlock == true && appLinkBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.add('display-none');
            }
        }

    }

    function typeFirstOption(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');

        let NodeLen = n.parentNode.parentNode.childNodes[3].childNodes.length;

        let plugin = "";
        let pluginBlock = "";
        if(NodeLen == 3) {
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if(webLinkBlock == false && appLinkBlock == true && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.remove('display-none');
                appLink.classList.add('display-none');
                plugin.classList.add('display-none');
            }

        } else {

            if(webLinkBlock == false && appLinkBlock == true) {
                return false;
            } else {
                webLink.classList.remove('display-none');
                appLink.classList.add('display-none');
            }
        }

    }

    function typeSecondOption(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');

        let NodeLen = n.parentNode.parentNode.childNodes[3].childNodes.length;

        let plugin = "";
        let pluginBlock = "";
        if(NodeLen == 3) {
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if(webLinkBlock == true && appLinkBlock == false && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.remove('display-none');
                plugin.classList.add('display-none');
            }

        } else {
            if(webLinkBlock == true && appLinkBlock == false) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.remove('display-none');
            }
        }

    }

    function typeThirdOption(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');
        let pluginBlock = plugin.classList.contains('display-none');

        if (webLinkBlock == true && appLinkBlock == true && pluginBlock == false) {
            return false;
        } else {
            webLink.classList.add('display-none');
            appLink.classList.add('display-none');
            plugin.classList.remove('display-none');
        }
    }

    // 바로연결 타입 선택
    function selectType2(val, i){

        if(val == 0){
            typeFirstOption(i);
        } else if (val == 1){
            typeSecondOption(i);
        } else if (val >= 2){
            typeAllNone(i);
        }
    }
    /*-------  알림톡 템플릿 테이블 끝  ------*/

    $(function () {
        /*-------  알림톡 템플릿  ------*/

        // 카테고리 선택
        $('.bizContsVal_group .option li').on('click', function(){
            let val = $(this).val();
            let list = $(".bizContsVal .option").find('li[class="cate_op_' + val + '"]');
            let not_list = $(".bizContsVal .option").find('li[class!="cate_op_' + val + '"]');

            if(val == 1){
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 2) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 3) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 4) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 5) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 6) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 7) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 8) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 9) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 10) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            }

            // 소분류 변경
            $('.bizContsVal .value').html($(list).eq(0).html());
            $('.bizContsVal .value').val($(list).eq(0).val());
        });
        // 카테고리 소분류 선택
        $('.bizContsVal .option li').on('click', function(){
            let val = $(this).index();
            $('.template_category_p').hide();
            $(`.template_category_p.gid_`+val).show();
        })

            // 메시지유형 선택
        $('.bizMsgVal .option li').on('click', function(){
            let val = $(this).val();
            console.log(val)

            if(val == 1){  // 기본형
                allNone();
            } else if (val == 2){  //부가정보형
                BlockNone();
            } else if (val == 3){  // 광고추가형
                NoneBlock();
                let msg = '메시지 유형이 "채널 추가형"으로 변경되어,<br/>첫번째 버튼의 타입이 "채널추가"로 변경 입력되며<br/>기존 입력한 버튼정보는 유지되지 않습니다.';
                alertMsg(msg)
            } else if (val == 4){  // 복합형
                allBlock();
                let msg = '메시지 유형이 "복합형"으로 변경되어,<br/>첫번째 버튼의 타입이 "채널추가"로 변경 입력되며<br/>기존 입력한 버튼정보는 유지되지 않습니다.';
                alertMsg(msg)
            }
        })

        function alertMsg(msg) {
            let html = '';
            html +=
                '<div class="layer_pop alert active">' +
                '<div class="pop_container popup_size3">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title">경고</div>' +
                '<div class="pop_inner">' +
                '<div class="alert_txt">' + msg + '</div>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this);" value="확인" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.alert').remove();
            $('body').append(html);
        }

        function allBlock() {
            $('.addinfo_block').css('display', 'block');
            $('.adver_msg_block').css('display', 'block');
            $('.addchannel_block').css('display', 'block');
            $('.channel_add_table').removeClass('display-none');
            $('.type_table_no_info').addClass('display-none');

            cellNum();
        }
        function BlockNone() {
            $('.addinfo_block').css('display', 'block');
            $('.adver_msg_block').css('display', 'none');
            $('.addchannel_block').css('display', 'none');
            $('.channel_add_table').addClass('display-none');

            let table = document.getElementById('template_btn_table');

            if(table.tBodies[0].rows.length <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }
        }

        function NoneBlock() {
            $('.addinfo_block').css('display', 'none');
            $('.adver_msg_block').css('display', 'none');
            $('.addchannel_block').css('display', 'block');
            $('.channel_add_table').removeClass('display-none');
            $('.type_table_no_info').addClass('display-none');

            cellNum();
        }

        function allNone() {
            $('.addinfo_block').css('display', 'none');
            $('.adver_msg_block').css('display', 'none');
            $('.addchannel_block').css('display', 'none');
            $('.channel_add_table').addClass('display-none');

            let table = document.getElementById('template_btn_table');

            if(table.tBodies[0].rows.length <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }

        }

        //강조유형 선택
        $('.bizEmphVal .option li').on('click', function(){
            let val = $(this).val();

            if(val == 1){
                emphAllNone();
            } else if (val == 2){
                emphFirstOption();
            } else if (val == 3){
                emphSecondOption();
            } else if (val == 4){
                emphThirdOption();
            }
        })

        function emphAllNone() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').addClass('display-none');
        }

        function emphFirstOption() {
            $('.emphtxt_block').removeClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').addClass('display-none');
        }

        function emphSecondOption() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').removeClass('display-none');
            $('.emphItemList_block').addClass('display-none');
        }

        function emphThirdOption() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').removeClass('display-none');
        }

        //강조유형 - 아이템리스트 - 이미지
        $('#img_check').on('click', function() {
            $('.itemlist_img_on').toggleClass('display-none');
        })

        //강조유형 - 아이템리스트 - 헤더
        $('#header_check').on('click', function() {
            $('.header-check-on').toggleClass('display-none');
        })

        //강조유형 - 아이템리스트 - 하이라이트
        $('#highlight_check').on('click', function() {
            $('.highlight_check_on').toggleClass('display-none');
        })

        $('#highlight_img_check').on('click', function() {
            $('.highlight_img_on').toggleClass('display-none');
        })

        //강조유형 - 아이템리스트 - 아이템 요약정보
        $('#itemInfo_check').on('click', function() {
            $('.itemInfo_check_on').toggleClass('display-none');
        })

        // textarea 글자수 제한
        $('.template_textarea textarea').on('keyup', function() {
            if($(this).val().length > 1000) {
                $(this).val($(this).val().substring(0, 1000));
            }
        });

        $('.addinfo_block textarea').on('keyup', function() {
            if($(this).val().length > 500) {
                $(this).val($(this).val().substring(0, 500));
            }
        });

        $('.emphtxt_block textarea').on('keyup', function() {
            if($(this).val().length > 50) {
                $(this).val($(this).val().substring(0, 50));
            }
        });

        $('.emphtxt_block2 textarea').on('keyup', function() {
            if($(this).val().length > 50) {
                $(this).val($(this).val().substring(0, 50));
            }
        });
       /*-------  알림톡 템플릿 끝  ------*/

        $('input[name="dbInfo"]').on('change', function () {
            getDBValue();
        });//end
        getDBValue();
        //load 시 byte 계산

        let minInx = '';

        /*//load 시 컨텐츠 포맷 체크 후 주요 옵션 표시
        $('.formatType').each(function () {
            let checkLength = $('.formatType').filter(':checked').length;
            let state = $(this).is(':checked');

            if(state == true){
                let tabInx = $('.formatType').index(this);
                $('#js-smsTab li').eq(tabInx).show();

                if(minInx === '' && minInx > tabInx){
                    minInx = tabInx;
                }
                $('#js-smsTab li').eq(minInx).addClass('on').siblings().removeClass('on');
                $('.tab_contents').eq(minInx).addClass('active').siblings().removeClass('active');
            }

            if(checkLength > 0){
                $('.no_data').hide();
                $('#js-btn-area').show();
            }else{
                $('.no_data').show();
                $('#js-btn-area').hide();
            }
        });*/


        //카카오 링크 버튼 생성 event
        $('.kakaoLinkBtn').on('click', function () {
            let btnState = $(this).val();
            let link = $('.kakao_btn_link');
            let name = $('.kakao_btn_name');
            let btnLink = link.val();
            let btnName = name.val();

            if (btnState == '생성') {
                if (btnName != '') {
                    if (btnLink != '') {
                        if (btnLink.substring(0, 4) == 'http') {
                            $(this).parents('#kakao').find('.viewer_area .inner').append('<a href="' + btnLink + '" class="kakao_link" target="_blank">' + btnName + '</a>');
                            //name.attr('disabled', true);
                            //link.attr('disabled', true);
                            name.attr('readonly', true);
                            link.attr('readonly', true);
                            $(this).val('삭제');
                        } else {
                            popup.popAlert('정확한 링크 URL을 입력해주세요.');
                            return false;
                        }
                    } else {
                        popup.popAlert('버튼 클릭시 이동할 URL을 입력해주세요.');
                        return false;
                    }
                } else {
                    popup.popAlert('메시지에 노출될 링크 버튼의 이름을 입력해주세요!');
                    return false;
                }
            } else {
                $(this).val('생성');
                $(this).parents('#kakao').find('.kakao_link').remove();
                link.val('');
                name.val('');
                //name.attr('disabled', false);
                //link.attr('disabled', false);
                name.attr('readonly', false);
                link.attr('readonly', false);
            }
        });


        // MMS, 카카오 이미지 삭제
        $('.delete_img').on('click', function () {
            let imgElement = $(this).parents('.sms_form').find('.sms_img').children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();
            let data = $(this).attr('data');

            if (imgcount > 0 || imgUrl != '') {
                if(data == "mms") {
                    // 문자 : 이미지 X버튼 누르면 초기화
                    $("input[name='mds_img_cd']").val('');
                    $("#smsImage").val('');
                    if($("input[name='mms_imgurl']") != '') {
                        $("input[name='mms_imgurl']").val('')
                        $("#js-sms-img").empty();
                    }
                } else if(data == 'kakao') {
                    if($('input[name="kko_img_cd"]').val() != '') {
                        // 카카오 : 이미지 X버튼 누르면 초기화
                        $("#kakaoImage").val('');
                        $("input[name='kko_img_cd']").val('');
                        $("input[name='kko_view_img_url']").val('');
                        $("#js-kakao-img").empty();
                    }
                }
            } else {
                return false;
            }
        });

        // 추적 링크 생성 동작
        $('.tmplCodeBtn').on('click', function () {
            $('#tmplCode').val(uuidv4())

            /*let link = $(this).prev('input').val();
            let text = $(this).parents('.sms_form').find('.textarea').val();
            let type = $(this).parent().find('.txt_input').attr('id');

            if (type == 'kakaoTracking') {
                $('input[name="kko_trackinglink"]').val('')
                $('input[name="kko_trackinglink"]').val(link)
            } else if (type == 'smsTracking') {
                $('input[name="sms_trackinglink"]').val('')
                $('input[name="sms_trackinglink"]').val(link)
            }

            if (link != '') {
                if (link.substring(0, 4) == 'http') {
                    $(this).parents('.sms_form').find('.textarea').val(text + '{{' + link + '}}');
                    $(this).prev('input').val('');
                } else {
                    popup.popAlert('정확한 링크 URL을 입력해주세요.');
                }
            } else {
                popup.popAlert('추적 링크를 입력해주세요.');
            }*/
        });

        $(document).on('click', '#rcs .vertical_delete_img', function () {
            let deleteInx = $('#rcs .vertical_delete_img').index(this);
            let imgElement = $('.img_area').eq(deleteInx).children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();
            $("#verticalImg").val('')

            if (imgcount > 0 || imgUrl != '') {
                $(this).next('.txt_input').val('');
                imgElement.remove();
            } else {
                return false;
            }
        });

        // 프리뷰에서 저장 버튼 누르기
        $(document).on('click', '#saveBtn' , function() {
            console.log("저장")
            $("#form").submit();
        });

        // RCS 선택 이미지 삭제
        $(document).on('click', '#rcs .delete_img', function () {
            let deleteInx = $('#rcs .delete_img').index(this);
            let imgElement = $('.img_area').eq(deleteInx).children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();

            if(deleteInx == 0) {
                // 1번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_1"]').val('');
            } else if(deleteInx == 1) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_2"]').val('');
            } else if(deleteInx == 2) {
                // 3번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_3"]').val('');
            } else if(deleteInx == 3) {
                // 4번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_4"]').val('');
            } else if(deleteInx == 4) {
                // 5번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_5"]').val('');
            } else if(deleteInx == 5) {
                // 6번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_6"]').val('');
            }

            if (imgcount > 0 || imgUrl != '') {
                $(this).next('.txt_input').val('');
                imgElement.remove();
            } else {
                return false;
            }
        });

        // 카카오 개인 변수 option click event
        $('#kakaoValue .option li').on('click', function () {
            let data = $(this).attr('data');
            let txt = $('.kakao_txt').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다. ");
                $('.kakao_txt').val(txt + data);
            }
        });



        //이미지 선택 팝업 검색 영역 달력 event
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
        });

        //시작일 달력
        $('#from').datepicker({
            onSelect: function (selected) {
                $("#to").datepicker("option", "minDate", selected)
            }
        });

        //종료일 달력
        $('#to').datepicker({
            onSelect: function (selected) {
                $("#from").datepicker("option", "maxDate", selected)
            }
        });

        //이미지 선택 팝업 저장 event
        $('.imageSave').on('click', function () {
            $('#imagePop').submit();
        });

        //이미지 선택 팝업 유효성 검사
        $('#imagePop').validate({
            errorPlacement: $.noop
            , invalidHandler: function (form, validator) {
                let errors = validator.numberOfInvalids();
                if (errors) {
                    $('#imagePop').siblings('.pop_error_txt').html(validator.errorList[0].message);
                }
            }
            , submitHandler: function (form) {
                let imageCheck = $('input[name="contentsImg"]:checked').length;
                let imageUrl = $('input[name="contentsImg"]:checked').val();
                let image = $('input[name="contentsImg"]:checked');
                if (imageCheck > 0) {
                    let popParents = $(form).parents('.layer_pop').attr('data');
                    $('#' + popParents).val(imageUrl);
                    $(form).parents('.layer_pop').removeClass('active');
                    smsCreate.imageCreate(popParents, image);
                    $('#imagePop').siblings('.pop_error_txt').html('');
                } else {
                    return false;
                }
            }
            , rules: {
                contentsImg: {
                    required: true
                }
            }
            , messages: {
                contentsImg: {
                    required: "이미지를 선택해주세요."
                }
            }
        });

        //발신 번호 선택 팝업 event
        $('.numberSave').on('click', function () {
            let callCheck = $('.call:checked').length;
            let callNumber = $('.call:checked').val();
            if (callCheck > 0) {
                //$('input[name="send_to"]').val(callNumber);
                $('input[name="send_to_list"]').val(callNumber);
                $('.smsNumber').parent('.column_2').removeClass('outline');
                popupClose(this);
            } else {
                return false;
            }
        });

        $('.js-ad').on('click',function(){
        });

        // 버튼 셀렉트박스
        $(document).on('click', '.action_select ul li', function () {
            let actionVal = $(this).attr('data');
            let area = $(this).parents('.row').siblings('.custom_box');
            let layout = '';
            let parentValue = $(this).parents('.action_select').attr('data');

            $(area).children().remove();

            let num = 0;
            let rcsType = $("input[name='rcs_format_type']:checked").val().trim();

            if (rcsType === "slide") {
                let dataValue = "slide_rcs_btn_" + parentValue;
                let index = $('.cardOn.on').index() + 1;

                if (parentValue == 1) {
                    // 첫번째 버튼 항목 클릭
                    if (index == 1) {
                        $("#slide_rcs_btn_tp_1").val(actionVal);
                    } else if (index == 2) {
                        $("#slide_rcs_btn_tp_3").val(actionVal);
                    } else if (index == 3) {
                        $("#slide_rcs_btn_tp_5").val(actionVal);
                    } else if (index == 4) {
                        $("#slide_rcs_btn_tp_7").val(actionVal);
                    } else if (index == 5) {
                        $("#slide_rcs_btn_tp_9").val(actionVal);
                    } else if (index == 6) {
                        $("#slide_rcs_btn_tp_11").val(actionVal)
                    }
                } else if (parentValue == 2) {
                    // 두번째 버튼 항목 클릭
                    if (index == 1) {
                        $("#slide_rcs_btn_tp_2").val(actionVal);
                    } else if (index == 2) {
                        $("#slide_rcs_btn_tp_4").val(actionVal);
                    } else if (index == 3) {
                        $("#slide_rcs_btn_tp_6").val(actionVal);
                    } else if (index == 4) {
                        $("#slide_rcs_btn_tp_8").val(actionVal);
                    } else if (index == 5) {
                        $("#slide_rcs_btn_tp_10").val(actionVal);
                    } else if (index == 6) {
                        $("#slide_rcs_btn_tp_12").val(actionVal)
                    }
                }
            } else {
                let dataValue = "rcs_btn_tp_" + parentValue;
                if (parentValue == 1) {
                    $("input[name='rcs_btn_tp_1']").val(actionVal);
                } else if (parentValue == 2) {
                    $("input[name='rcs_btn_tp_2']").val(actionVal);
                } else if (parentValue == 3) {
                    $("input[name='rcs_btn_tp_3']").val(actionVal);
                }
            }
            $(this).parents('.row').siblings('.row').find('.action_name').val('');
            $(this).parents('.row').siblings('.row').find('.text-count span').html('0');

            if (actionVal == "RBTN01") {

                layout += '<div class="row">' +
                    '<div class="th top-border">복사할 값</div>' +
                    '<div class="td top-border">' +
                    '<input type="text" name="copy_value" class="txt_input width" placeholder="복사할 값을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name ="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN02") {

                layout += '<div class="row">' +
                    '<div class="th top-border">URL</div>' +
                    '<div class="td top-border">' +
                    '<input type="text" name="url_value" class="txt_input width en_font url_link" data="url" placeholder="URL 입력 (http:// 또는 https://필수입력)" />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN03") {

                layout += '<div class="row">' +
                    '<div class="th top-border">전화번호</div>' +
                    '<div class="td top-border">' +
                    '<input type="text" name="phone_value_03" class="txt_input width en_font" placeholder="전화번호를 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN04") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">위도/경도</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="latitude_value" class="txt_input en_font half right-border" placeholder="위도를 입력해주세요." />' +
                    '<input type="text" name="longitude_value" class="txt_input en_font half" placeholder="경도를 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th bottom-border">위치 이름</div>' +
                    '<div class="td bottom-border">' +
                    '<input type="text" name="location_value_04" class="txt_input width" placeholder="위치 이름을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">Fallback URL</div>' +
                    '<div class="td">' +
                    '<input type="text" name="fallback_url_04" class="txt_input width en_font url_link" data="url" placeholder="Fallback URL 입력 (http:// 또는 https://필수입력)" />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN05") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">위치 이름</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="location_value_05" class="txt_input width" placeholder="위치 이름을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">Fallback URL</div>' +
                    '<div class="td">' +
                    '<input type="text" name="fallback_url_05" class="txt_input width en_font url_link" data="url" placeholder="Fallback URL 입력 (http:// 또는 https://필수입력)" />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN06") {
                layout +=
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name= "fallback_url_05" value =" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value =" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN07") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">시작일 / 종료일</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="start_date" class="start_date txt_input en_font calendar right-border" placeholder="시작일" />' +
                    '<input type="text" name="end_date" class="end_date txt_input en_font calendar" placeholder="종료일" />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th bottom-border">제목</div>' +
                    '<div class="td bottom-border">' +
                    '<input type="text" name="calendar_title" class="txt_input width" placeholder="제목을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">내용</div>' +
                    '<div class="td">' +
                    '<input type="text" name="calendar_body" class="txt_input width" placeholder="내용을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
                $(document).find(".start_date").removeClass('hasDatepicker').datepicker({
                    onSelect: function (selected) {
                        $('.start_date').next('.end_date').datepicker("option", "minDate", selected);
                    }
                });
                $(document).find(".end_date").removeClass('hasDatepicker').datepicker({
                    onSelect: function (selected) {
                        $('.end_date').prev('.start_date').datepicker("option", "maxDate", selected);
                    }
                });
            }
            if (actionVal == "RBTN08") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">전화번호</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="phone_value_08" class="txt_input width en_font" placeholder="전화번호를 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">문자메시지 내용</div>' +
                    '<div class="td">' +
                    '<input type="text" name="message_value" class="txt_input width" placeholder="문자메시지 내용을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>';
                $(area).html(layout);
            }
            let actionButton = $('.rcs_btn_wrap').find('div[data="' + parentValue + '"]').length;
            let typeSlide = $(this).parents('.rcs_slide_conts').length;

            if (typeSlide == 0) {
                if (actionVal != 0 && actionButton == 0) {
                    $('.rcs_btn_wrap').append('<div class="rcs_btn" data="' + parentValue + '">버튼' + parentValue + '</div>');
                }
                if (actionVal != 0 && actionButton >= 1) {
                    $('.rcs_btn_wrap').find('div[data="' + parentValue + '"]').html('버튼' + parentValue);
                }
                if (actionVal == 0) {
                    $('.rcs_btn_wrap').find('div[data="' + parentValue + '"]').remove();
                }
            } else {
                let sectionInx = $(this).parents('.rcs_slide_conts.on').index() - 1;
                let buttonLength = $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap div[data="' + parentValue + '"]').length;

                if (actionVal != 0 && buttonLength == 0) {
                    $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap').append('<div class="rcs_btn" data="' + parentValue + '">버튼' + parentValue + '</div>');
                }
                if (actionVal != 0 && buttonLength >= 1) {
                    $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap div[data="' + parentValue + '"]').html('버튼' + parentValue);
                }
                if (actionVal == 0) {
                    $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap div[data="' + parentValue + '"]').remove();
                }
            }
        });


        $('#previewBtn').on('click', function () {
            $('.create_sms').find('.outline').removeClass('outline');
            let smsSubmit = tmplValidate();
            if (smsSubmit == true) {
                isCheckTemplateName();
            } else {
                return false;
            }
        });

    });

    // 카카오, SMS 유효성 검사
    function kakaoValidate() {
        let kakaoOption = $('input[name="kko_option"]').val();
        let kakaoTitle = $('.kakaoTitle');
        let kakaoTxt = $('.kakao_txt');
        let kakaoSenderNo = $('.smsNumber_kko');

        //console.log("kakaoOption : " + kakaoOption);


        if(kakaoSenderNo.val() == '' || kakaoSenderNo.val() == null){
            popup.popAlert("카카오톡 발신 번호를 입력해주세요");
            //kakaoSenderNo.parent('.column_2').addClass('outline');
            return false;
        }

        if (kakaoOption == 'ad') {
            if (kakaoTitle.val().indexOf('(광고)') != -1) {
                if (kakaoTxt.val() != '') {
                    let type = kakaoTypeValidate();
                    if (type == true) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    popup.popAlert('카카오톡 메시지 내용을 입력해주세요.');
                    kakaoTxt.focus();
                    return false;
                }
            } else {
                kakaoTitle.parent('.column_1').addClass('outline');
                kakaoTitle.focus();
                popup.popAlert("카카오톡 광고성 메시지 제목에 '(광고)'입력이 필수 입니다.");
                return false;
            }
        }
        if (kakaoOption == 'guide') {
            if (kakaoTitle.val() != '') {
                let type = kakaoTypeValidate();
                if (type == true) {
                    return true;
                } else {
                    return false;
                }
            } else {
                kakaoTitle.parent('.column_1').addClass('outline');
                kakaoTitle.focus();
                popup.popAlert("카카오톡 문자 제목을 입력해주세요.");
                return false;
            }
            /*if ($('.kakao_txt').val() != '') {
                let type = kakaoTypeValidate();
                if (type == true) {
                    return true;
                } else {
                    return false;
                }
            } else {
                popup.popAlert('카카오톡 메시지 내용을 입력해주세요.');
                $('.kakao_txt').focus();
                return false;
            }*/
        }
        return false;
    }

    //카카오 유효성 검사
    function kakaoTypeValidate() {
        // 카카오의 경우 이미지 필수 -> 이미지 선택으로 바뀜
        let kakaoByte = Number($('.kakao_byte').html());
        let kakaoImage = $('#kakaoImage');
        let kakaoTxt = $('.kakao_txt');

        // 본문 byte 체크
        if(kakaoImage.val() == '' || kakaoImage.val() == null){
            if(kakaoByte > 2000){
                kakaoTxt.focus();
                popup.popAlert("카카오톡 본문 내용이 2000byte를 초과할 수 없습니다.");
                return false;
            }
        }else if(kakaoImage.val() != '' || kakaoImage.val() != null){
            if (kakaoByte > 400) {
                kakaoTxt.focus();
                popup.popAlert("카카오톡 본문 내용이 400byte를 초과할 수 없습니다.");
                return false;
            }
        }
        return true;
    }

    // 문자 유효성 검사
    function smsValidate() {
        let smsOption = $('input[name="sms_option"]').val();
        let smsTitle = $('.smsTitle');
        let smsTxt = $('.sms_txt');
        let smsNumber = $('.smsNumber')
        let smsNumberValue = $('#sms_send_to').val().trim();

        if(smsNumberValue == '' || smsNumberValue == null) {
            smsNumber.parent('.column_2').addClass('outline');
            popup.popAlert("문자 발신 번호를 입력해주세요.");
            return false;
        }

        if (smsOption == 'ad') {
            if (smsTitle.val().indexOf('(광고)') != -1) {
                if (smsNumber != '' || smsNumber != null) {
                    if (smsTxt.val() != '') {
                        let type = smsTypeValidate();
                        if (type == true) {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        smsTxt.focus().addClass('on');
                        popup.popAlert("문자 메시지 내용을 입력해주세요.");
                        return false;
                    }
                } /*else {
                    smsNumber.parent('.column_2').addClass('outline');
                    popup.popAlert("발신 번호를 입력해주세요.");
                    return false;
                }*/
            } else {
                smsTitle.parent('.column_3').addClass('outline');
                smsTitle.focus();
                popup.popAlert("광고성 메시지 제목에 '(광고)'입력이 필수 입니다.");
                return false;
            }
        }
        if (smsOption == 'guide') {
            if (smsTitle.val() != '') {
                let type = smsTypeValidate();
                if (type == true) {
                    return true;
                } else {
                    return false;
                }
            } else {
                smsTitle.parent('.column_3').addClass('outline');
                smsTitle.focus();
                popup.popAlert("문자 제목을 입력해주세요.");
                return false;
            }
        }
        return true;
    }

    // 문자 종류별 유효성 체크
    function smsTypeValidate() {
        let smsType = $('.smsType:checked').val();
        let smsByte = Number($('.sms_byte').html());
        let smsImage = $('#smsImage');
        let smsTxt = $('.sms_txt');

        if (smsType == 'LMS') {
            //$("#mds_img_cd").val('');
            if (smsByte > 2000) {
                smsTxt.focus();
                popup.popAlert("LMS의 경우 본문 내용이 2000byte를 초과할 수 없습니다.");
                return false;
            }
        }

        // 우선적으로 이미지 1개만 고려, 차후 이미지 멀티 저장 기능이 추가되면 수정 필요
        // MMS 테스트
        // 이미지 1개 : 2000 Byte 까지만 허용 , 이미지 여러개 : 1000 Byte 까지 허용
        if (smsType == 'MMS') {
            if (smsImage.val() != '') {
                if (smsByte > 2000) {
                    smsTxt.focus();
                    popup.popAlert("MMS의 경우 본문 내용이 2000byte를 초과할 수 없습니다.");
                    return false;
                }
            } else {
                smsImage.parent('.td').addClass('outline');
                smsImage.focus();
                popup.popAlert("MMS를 선택하셨습니다. 이미지를 선택해 주세요.");
                return false;
            }
        }
        if (smsType == 'SMS') {
            //$("#mds_img_cd").val('');
            if (smsByte > 90) {
                smsTxt.focus();
                popup.popAlert("SMS의 경우 본문 내용이 90byte를 초과할 수 없습니다.");
                return false;
            }
        }
        return true;
    }

    // 알림톡 템플릿 유효성 검사
    function tmplValidate() {

        let senderKey = $('#kko_send_to');  //발신 프로필
        let tmplCode = $('input[name="tmpl_cd"]');  //템플릿 코드
        let tmplCate1 = $('.bizContsVal_group .value');  //카테고리그룹
        let tmplCate2 = $('.bizContsVal .value');  //카테고리
        let tmplName = $('input[name="tmpl_nm"]');  //템플릿명
        let tmplMsg = $('.bizMsgVal .value'); //메시지 유형
        let tmplEmph = $('.bizEmphVal .value');  //강조유형
        let tmplTxt = $('textarea[name="tmplTxt"]');  //템플릿내용

        if(senderKey.val() == '' || senderKey.val() == null) {
            senderKey.focus().addClass('outline');
            popup.popAlert("발신 프로필을 선택해주세요.");
            return false;
        }

        if(tmplCode.val() == '' || tmplCode.val() == null) {
            tmplCode.focus().addClass('outline');
            popup.popAlert("템플릿코드를 입력해주세요.");
            return false;
        }

        if(tmplCate1.text() == "카테고리 그룹") {
            tmplCate1.focus().addClass('outline');
            popup.popAlert("카테고리 그룹을 선택해주세요.");
            return false;
        } else if (tmplCate1.text() != "카테고리 그룹" && tmplCate2.text() == "카테고리") {
            tmplCate2.focus().addClass('outline');
            popup.popAlert("카테고리를 선택해주세요.");
            return false;
        }

        if(tmplName.val() == '' || tmplName.val() == null) {
            tmplName.focus().addClass('outline');
            popup.popAlert("템플릿명을 입력해주세요.");
            return false;
        }

        if(tmplTxt.val() == '' || tmplTxt.val() == null) {
            tmplTxt.focus().addClass('outline');
            popup.popAlert("템플릿내용을 입력해주세요.");
            return false;
        }

        //부가정보형, 복합형인 경우 부가정보
        let tmplAddInfo = $('textarea[name="tmplAddInfo"]');
        let tmplAd = $('textarea[name="tmpl_ad"]');

        if(tmplMsg.text() == "부가 정보형" || tmplMsg.text() == "복합형"){
            if(tmplAddInfo.val() == '' || tmplAddInfo.val() == null) {
                tmplAddInfo.focus().addClass('outline');
                popup.popAlert("부가 정보를 입력해주세요.");
                return false;
            }

            if(tmplMsg.text() == "복합형"){
                if(tmplAd.val() == '' || tmplAd.val() == null) {
                    tmplAd.focus().addClass('outline');
                    popup.popAlert("광고성 메시지를 입력해주세요.");
                    return false;
                }
            }
        }


        //강조표기형
        let tmplEmphTitle = $('input[name="tmplEmphTitle"]');
        let tmplEmphTxt = $('input[name="tmplEmphTxt"]');

        if(tmplEmph.text() == "강조표기형"){
            if(tmplEmphTitle.val() == '' || tmplEmphTitle.val() == null) {
                tmplEmphTitle.focus().addClass('outline');
                popup.popAlert("강조 표기 타이틀을 입력해주세요.");
                return false;
            }

            if(tmplEmphTxt.val() == '' || tmplEmphTxt.val() == null) {
                tmplEmphTxt.focus().addClass('outline');
                popup.popAlert("강조 표기 보조 문구를 입력해주세요.");
                return false;
            }
        }else if(tmplEmph.text() == "이미지형"){
            console.log("이미지형")
        }
        return true;
    }


    // blur 유효성 체크
    $(function () {
        $('.template_name').on('blur', function () {
            if ($(this).val() != '') {
                $(this).removeClass('outline');
            }
            return false;
        });

        $('.kakaoTitle').on('blur', function () {
            let kakaoSMS = $('.kakaoOption:checked').val();
            if (kakaoSMS == 'ad') {
                if ($(this).val().indexOf('(광고)') != -1 && $(this).val() != '') {
                    $(this).parent('.column_1').removeClass('outline');
                }
            }
            if (kakaoSMS == 'guide') {
                if ($(this).val() != '') {
                    $(this).parent('.column_1').removeClass('outline');
                }
            }
            return false;
        });

        $('.smsTitle').on('blur', function () {
            let kakaoSMS = $('.smsOption:checked').val();
            if (kakaoSMS == 'ad') {
                if ($(this).val().indexOf('(광고)') != -1 && $(this).val() != '') {
                    $(this).parent('.column_3').removeClass('outline');
                }
            }
            if (kakaoSMS == 'guide') {
                if ($(this).val() != '') {
                    $(this).parent('.column_3').removeClass('outline');
                }
            }
            return false;
        });
    });

    // 템플릿 명 유효성 검사
    function isCheckTemplateName() {
        const cont_nm = $("input[name='tmpl_nm']").val();
        const res = function (response) {
            if (response.status == 200) {
                popup.confirmAlertCallback("템플릿을 등록 하시겠습니까?", createTmpl());

            } else {
                // 중복된 명칭 존재
                popup.popAlert(response.message)
            }
        }
        let param = {cont_nm: cont_nm}
        com_ajax.ajax('post', '${baseURL}/cont/kko/isCheckTmplNm.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}')
    }

    // 프리뷰 서비스 랜딩 하기
    function createTmpl() {

        const res = function(response) {
            let $doc = new DOMParser().parseFromString(response, 'text/html');
            let html = $('#js-area-popup',$doc).html();
            let dynamic = $('#preview').html(html);
            $('#smsContentsPopup').addClass('active');
            previewSlideLoad();
        }
        let data = $('#form').serializeArray();
        console.log(data)

    }

    <%--com_ajax.ajax('post', '${baseURL}/cont/kko/tmplCreate.service', data, res, '${_csrf.headerName}', '${_csrf.token}')--%>

    // $("#smsContentsPopup").addClass("active");
    /*const res = function(response) {
        let $doc = new DOMParser().parseFromString(response, "text/html");
        let html = $("#js-area-popup",$doc).html();
        let dynamic = $("#preview").html(html);
        $("#smsContentsPopup").addClass("active");
        previewSlideLoad();
    }
    let data = $("#form").serializeArray();
    com_ajax.ajax('post', '${baseURL}/cont/preview.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}')*/
    // 발신자 리스트 불러오기
    function mobileSenderPopup(nowPage, type) {

        if (typeof type == "undefined") {
            // Type이 정의 되어 있지 않다면 페이징에서 넘겨주지 않았으므로 type 변경
            type = $("#mSendType").val();
        }
        var res = function (response) {
            $("#callPopUp").html(response);
            $("#mSendType").val(type);
        };

        var param = $("#tblmisetForm").serializeArray();

        param.push({name: 'list_tp_id', value: 'CH02'});
        param.push({name: 'list_dt_id', value: 'DMTP03'});

        param.push({name: 'pageNo', value: nowPage})

        com_ajax.ajax('post', '${baseURL}/cont/senderMobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 발신자 번호 input 저장하기
    function mobileSendSave(type) {
        let send_to = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNumber"]').val();  // 보낼 번호
        let send_nm = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNm"]').val(); // 발신자 명
        let sender = send_nm + "(" + send_to + ")";

        $("#kko_send_to").val(sender);
        $("#send_key").val(send_to);

        $('.mobilePopup').removeClass('active');
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
            //$("#form")[0].reset();
            $("#file").val();
            $(".img_viewer").children().remove();
            $(".img_view").addClass('noImg');
            imageListPaging('1');
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


    function uuidv4() {
       /* return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
            (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
        );*/
        const uint32 = window.crypto.getRandomValues(new Uint32Array(1))[0];
        const  current = new Date();

        return uint32.toString(16)+"_"
            +current.getFullYear().toString()+current.getMonth().toString()+current.getDate().toString()
            +current.getHours().toString()+current.getMinutes()+current.getSeconds().toString();
    }

</script>



