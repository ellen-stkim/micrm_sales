<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>

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
                    <li>알림톡 템플릿 수정</li>
                </ul>
            </div>
        </div>
        <div class="row tooltip_area bottom-border min-width cf">
            <div class="right tmplAcDiv">
                <p id="updTmplBtn"
                   class="btn_basic checkDelete left left-border">상태 업데이트</p>
                <p id="reqCancleBtn" class="btn_basic rejection left left-border ${dto.kep_status eq 'I'? '' : 'display-none'}">검수요청 취소</p>
                <p id="reqTmplBtn"
                   class="btn_basic ico_test left left-border ${dto.kep_status eq 'I'? 'display-none' : ''}">템플릿 검수요청</p>
                 <%--<p id="appCancleBtn"
                    class="btn_basic delete left left-border " >승인 취소</p>--%>
               <%-- <p id="delTmplBtn"
                   class="btn_basic delete left left-border ${dto.kep_status eq 'I'? 'display-none' : ''}" >삭제</p>--%>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <form:form id="atForm" action="/cont/kko/tmplUpate.service" method="post">
            <input name="seq" id="tmplSeq" value="${dto.seq}" readonly hidden>
            <div class="create_sms cf">
                <div class="tab_contents active">
                    <div class="sms_form cover" id="kakao">
                        <h2>알림톡 템플릿 수정</h2>
                        <div class="flex_box">
                            <div class="left_area">
                                <div class="input_area left">
                                    <div class="block_group">
                                        <div class="block block4 template_msg">
                                            <div class="row">
                                                <div class="th">검수 상태 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <span class="filx_data">${dto.kep_status_nm}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block4">
                                            <div class="row">
                                                <div class="th">탬플릿 상태 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <span class="filx_data">${dto.tmpl_status_nm}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block_group">
                                        <div class="block block4 template_msg">
                                            <div class="row">
                                                <div class="th">차단 상태 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <span class="filx_data">${dto.tmpl_block eq 'Y' ? '차단' : '정상'}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block4">
                                            <div class="row">
                                                <div class="th">휴면 상태 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <span class="filx_data">${dto.tmpl_dormant eq 'Y' ? '휴면' : '정상'}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">발신 프로필 <span class="color_red">*</span></div>
                                            <div class="td">
                                                <input type="text" class="sms_number smsNumber" id="kko_send_to"
                                                       style="width: 90%; height: 100%;"
                                                       placeholder="발신 프로필을 선택해주세요." value="${dto.sender}" readonly/>
                                                <input type="hidden" name="send_key" id="send_key" value="${dto.send_key}"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">템플릿코드 <span class="color_red">*</span></div>
                                            <div class="td">
                                                <input type="text" class="txt_input txt_input2" name="newTemplateCode"
                                                       id="tmplCode" value="${dto.tmpl_cd}"
                                                       placeholder=""  />
                                                <span class="btn_sm_line btn_sm_line2 tmplCodeBtn">코드 자동 생성</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block block3">
                                        <div class="row">
                                            <div class="th th2">보안템플릿</div>
                                            <div class="td template_check_td">
                                                <input type="checkbox" name="securityFlag" value="Y" ${dto.secur_flag eq "Y"? 'checked' : ''}
                                                       id="template_check">
                                                <label for="template_check">보안 템플릿 설정 시, 메인 디바이스 모바일 외 모든 서브 디바이스에서는 메시지
                                                    내용이 노출되지 않습니다.</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block block3">
                                        <div class="row">
                                            <div class="th th2">카테고리 <span class="color_red">*</span></div>
                                            <div class="td template_category_td">
                                                <!-- select 영역1 시작 -->
                                               <%-- <div class="select bizContsVal_group" name="edmDB">
                                                    <!-- selected value -->
                                                    <div class="value"
                                                         data="${dto.cate_cd_val}">${dto.cate_cd_desc}</div>
                                                    <ol class="option">
                                                        <c:forEach var="cate" items="${cateLst}">
                                                            <li value="${cate.cd_sn}">${cate.cd_desc}</li>
                                                        </c:forEach>
                                                    </ol>
                                                </div>--%>
                                                <div class="select bizContsVal_group" name="edmDB">
                                                    <!-- selected value -->
                                                    <div class="value"
                                                         data="${dto.cate_cd_val}">${dto.cate_cd_desc}</div>
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
                                                    <div class="value"
                                                         data="${dto.cate_sub_cd_val}">${dto.cate_sub_cd_desc}</div>
                                                    <ol class="option">
                                                        <c:forEach var="cateSub" items="${cateSubLst}">
                                                            <li class="cate_op_${cateSub.par_nm}"  ${cateSub.par_nm eq '1' ? '' :'hidden'}
                                                                data_sn="${cateSub.cd_sn}"
                                                                value="${cateSub.cd_val}">${cateSub.cd_desc}</li>
                                                        </c:forEach>
                                                    </ol>
                                                    <input class="selValue" name="newCategoryCode"
                                                           value="${dto.cate_sub_cd_val}" readonly hidden>
                                                </div>
                                                <!-- select 영역2 끝 -->
                                                <p class="template_category_p display-none">
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
                                                <input type="text" class="txt_input" name="newTemplateName"
                                                       style="width: 100%;" value="${dto.tmpl_nm}"
                                                       placeholder="템플릿명 입력 (최대 200자)"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block">
                                        <div class="row template_textarea">
                                            <div class="th">템플릿내용 <span class="color_red">*</span></div>
                                            <div class="td">
                                                <textarea name="newTemplateContent"  cols="30"
                                                          rows="10">${dto.tmpl_cont}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block">
                                        <div class="row flex_row">
                                            <div class="row flex_row input-img on">
                                                <div class="th">개인화 변수</div>
                                                <div class="td">
                                                    <span style="font-size: 9px">※ 아래 박스에서 개인화 변수를 드래그한 후, 텍스트 상자에 넣거나 클릭하여 추가할 수 있습니다.</span><br>
                                                    <span class="color_red" style="font-size: 9px">   ※ 개인화 변수는 최대 10개까지 사용할 수 있습니다.</span>
                                                    <div id="kakaoValue" style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;">
                                                        <c:forEach var="item" items="${column}"
                                                                   varStatus="status">
                                                            <input type="button" data="\#{${item.list_val}}" value="${item.list_nm}" class="drag-button" draggable="true">
                                                        </c:forEach>
                                                        <c:forEach var="item" items="${extention}"
                                                                   varStatus="status">
                                                            <input type="button" data="\#{${item}}" value="${item}" class="drag-button" draggable="true">
                                                        </c:forEach>
                                                    </div>
                                                </div>
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
                                                        <div class="value"
                                                             data="${dto.msg_tp}">${dto.msg_tp_nm}</div>
                                                        <ol class="option">
                                                            <c:forEach var="msgTp" items="${msgTpLst}">
                                                                <li data_sn="${msgTp.cd_sn}"
                                                                    value="${msgTp.cd_val}">${msgTp.cd_desc}</li>
                                                            </c:forEach>
                                                        </ol>
                                                        <input class="selValue" type="text" name="newTemplateMessageType" value="${dto.msg_tp}"
                                                               readonly hidden>
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
                                                        <div class="value"
                                                             data="${dto.emp_tp}">${dto.emp_tp_nm}</div>
                                                        <ol class="option">
                                                            <c:forEach var="empTp" items="${empTpLst}">
                                                                <li value="${empTp.cd_val}"
                                                                    data_sn="${empTp.cd_sn}">${empTp.cd_desc}</li>
                                                            </c:forEach>
                                                        </ol>
                                                        <input type="text" class="selValue" name="newTemplateEmphasizeType" value="${dto.emp_tp}"
                                                               readonly hidden>
                                                    </div>
                                                    <!-- select 영역 끝 -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block_group emphtxt_block  ${dto.emp_tp ne 'TEXT'? 'display-none':''} " name="emph_sel_box">
                                        <div class="block block4">
                                            <div class="row">
                                                <div class="th">강조 표기 타이틀 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <input type="text" class="txt_input3" name="newTemplateTitle" ${!empty dto.tmpl_tit ?'value="'+= dto.tmpl_tit+= '"' :''}                                                            placeholder="강조 표기 타이틀 입력 (최대 50자)">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block4 emphtxt_block2">
                                            <div class="row">
                                                <div class="th" style="line-height: 18px;">강조 표기<br>보조 문구 <span
                                                        class="color_red">*</span></div>
                                                <div class="td">
                                                    <input type="text" class="txt_input3" name="newTemplateSubtitle" ${!empty dto.tmpl_subtit ?'value="'+= dto.tmpl_subtit+= '"' :''}
                                                           placeholder="강조 표기 보조 문구 입력 (최대 50자)">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block emphImg_block ${dto.emp_tp ne 'IMAGE'? 'display-none':''}"  name="emph_sel_box">
                                        <div class="row flex_row" style="height: auto; min-height: 145px;">
                                            <div class="th">이미지 <span class="color_red">*</span></div>
                                            <div class="td">
                                                <div name="newImgBtn" class="imgBtn newImgDiv ${!empty dto.img_seq ? 'display-none' :''}">
                                                    <div class="template_add_img col_img" name="addImgBtn"
                                                         onclick="imageListPopUp(1,'img')">
                                                        click here to upload
                                                    </div>
                                                    <p class="color_red">
                                                        - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                        - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.</p>
                                                </div>
                                                <div class="col_img prv_col_img" name="prevImg">
                                                    <c:if test="${!empty dto.img_seq}">
                                                        <div class="delete_img" data="img" style="right: 10px;">
                                                            <img src="/image/btn_delete1.png" alt="삭제"></div>
                                                        <a href="${dto.kko_img_url}" target="_blank" rel="noopener">
                                                            <img src="${dto.kko_img_url}" onerror="this.src='/image/bg_none.png'" alt="kko">
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div name="emph_sel_box" id="img_data">
                                        <input type="text" id="tmplImgSeq" name="img_seq"  value="${dto.img_seq}" readonly hidden>
                                        <input type="text" id="tmplImgUrl" name="newTemplateImageUrl"  value="${dto.kko_img_url}" readonly hidden>
                                        <input type="text" id="tmplImgNm" name="newTemplateImageName"  value="${dto.img_org_nm}" readonly hidden>
                                    </div>
                                    <div class="emphItemList_block ${dto.emp_tp ne 'ITEM_LIST'? 'display-none':''} " name="emph_sel_box">
                                        <div class="block emphItemList_img">
                                            <div class="row flex_row" style="height: auto;">
                                                <div class="th">이미지</div>
                                                <div class="td">
                                                    <input type="checkbox" id="img_check" ${!empty dto.img_seq ? 'checked' :''}>
                                                    <label for="img_check">설정</label>
                                                    <div class="itemlist_img_on dis_flex ${!empty dto.img_seq ? '' :'display-none'}">
                                                        <div name="newImgBtn"  class="imgBtn newImgDiv ${!empty dto.img_seq ? 'display-none' :''}">
                                                            <div class="template_add_img col_img" name="addImgBtn"
                                                                 onclick="imageListPopUp(1,'img')">
                                                                click here to upload
                                                            </div>
                                                            <p class="color_red">
                                                                - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                                - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야
                                                                합니다.
                                                            </p>
                                                        </div>
                                                        <div class="col_img prv_col_img" name="prevImg">
                                                            <c:if test="${!empty dto.img_seq}">
                                                                <div class="delete_img" data="img" style="right: 10px;">
                                                                    <img src="/image/btn_delete1.png" alt="삭제"></div>
                                                                <a href="${dto.kko_img_url}" target="_blank" rel="noopener">
                                                                    <img src="${dto.kko_img_url}" onerror="this.src='/image/bg_none.png'" alt="kko">
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="block emphItemList_header">
                                            <div class="row" style="height: auto;">
                                                <div class="th">헤더</div>
                                                <div class="td">
                                                    <input type="checkbox" id="header_check" ${!empty dto.tmpl_header? 'checked':''}>
                                                    <label for="header_check">설정</label>

                                                    <input type="text" class="header-check-on border ${!empty dto.tmpl_header? '':'display-none'}"
                                                           name="newTemplateHeader"  ${!empty dto.tmpl_header? 'value="' += dto.tmpl_header += '"' : ''}
                                                           placeholder="헤더 내용 입력 (최대 16자)">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="block emphItemList_highlight ${dto.emp_tp ne 'ITEM_LIST'? 'display-none':''}">
                                            <div class="row" style="height: auto;">
                                                <div class="th" style="line-height: 17px;">아이템<br>하이라이트</div>
                                                <div class="td">
                                                    <div class="highlight_div">
                                                        <input type="checkbox" id="highlight_check" ${!empty dto.item_highlight_json? 'checked':''} >
                                                        <label for="highlight_check">설정 (아이템 하이라이트 체크 시, 하이라이트 타이틀 및
                                                            디스크립션 설정이 필수입니다.)</label>
                                                    </div>

                                                    <c:if test="${empty dto.item_highlight_json}" >
                                                        <div class="highlight_div highlight_check_on ${!empty dto.item_highlight_json? '':'display-none'}">
                                                            <input type="text" class="txt_input4 first border" name="title"
                                                                   placeholder="타이틀 입력 (최대 30자)">
                                                            <input type="text" class="txt_input4 border" name="description"
                                                                   placeholder="변수 및 화폐 단위, 숫자, 쉼표, 마침표만 사용 가능 (최대 19자)">
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${!empty dto.item_highlight_json}" >
                                                        <div class="highlight_div highlight_check_on ${!empty dto.item_highlight_json? '':'display-none'}">
                                                            <input type="text" class="txt_input4 first border" name="title" value="${dto.highlight_json.title}"
                                                                   placeholder="타이틀 입력 (최대 30자)">
                                                            <input type="text" class="txt_input4 border" name="description" value="${dto.highlight_json.description}"
                                                                   placeholder="변수 및 화폐 단위, 숫자, 쉼표, 마침표만 사용 가능 (최대 19자)">
                                                        </div>
                                                    </c:if>

                                                    <div class="highlight_div highlight_check_on ${!empty dto.item_highlight_json? '':'display-none'}">
                                                        <input type="checkbox" id="highlight_img_check" ${!empty dto.item_img_seq? 'checked':''}>
                                                        <label for="highlight_img_check">이미지 (썸네일을 추가하면 타이틀은 21자, 디스크립션은
                                                            13자까지 입력 가능합니다.)</label>
                                                    </div>
                                                    <div class="highlight_div highlight_img_on dis_flex ${!empty dto.item_highlight_json && !empty  dto.item_img_seq  ? '':'display-none'}">
                                                        <div name="newItemImgBtn"  class="imgBtn ${empty dto.item_img_seq || !fn:contains(dto.item_highlight_json,'\"imageUrl\"') ? '':'display-none'}">
                                                            <div class="template_add_img col_img"
                                                                 onclick="imageListPopUp(1,'img_item')">
                                                                click here to upload
                                                            </div>
                                                            <p class="color_red">
                                                                - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                                - 이미지 파일은 가로 108px 이상이며 가로:세로 비율이 1:1 이어야 합니다.
                                                            </p>
                                                        </div>
                                                        <c:if test="${empty dto.item_img_seq || !fn:contains(dto.item_highlight_json,'\"imageUrl\"')}">
                                                            <input id="itemImgSeq" name="item_img_seq"  readonly hidden>
                                                            <input id="imageUrl" name="imageUrl" disabled readonly hidden>
                                                            <div class="col_img prv_col_img" name="prevItemImg"></div>
                                                        </c:if>
                                                        <c:if test="${!empty dto.item_img_seq && fn:contains(dto.item_highlight_json,'\"imageUrl\"')}">
                                                            <input id="itemImgSeq" name="item_img_seq"
                                                                   value="${dto.item_img_seq}" readonly hidden>
                                                            <input id="imageUrl" name="imageUrl"
                                                                   value="${dto.highlight_json.imageUrl}" disabled
                                                                   readonly hidden>
                                                            <div class="col_img prv_col_img" name="prevItemImg">
                                                                <div class="delete_img" data="img_item"  style="right: 20px; top: 110px;">
                                                                    <img src="/image/btn_delete1.png" alt="삭제"></div>

                                                                <a href="${dto.highlight_json.imageUrl}" target="_blank" rel="noopener">
                                                                    <img src="${dto.highlight_json.imageUrl}" onerror="this.src='/image/bg_none.png'" style="height: 175px; width: 175px;" alt="img">
                                                                </a>
                                                            </div>
                                                        </c:if>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="block template_table emphItemList_list ${dto.emp_tp ne 'ITEM_LIST'? 'display-none':''}">
                                            <div class="row" style="height: auto;">
                                                <div class="th" style="line-height: 17px;">
                                                    아이템<br/>리스트
                                                    <div class="button" onclick="addRowItemList()">추가</div>
                                                </div>
                                                <div class="td">
                                                    <table id="emphItemList_list_table" summary="list">
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
                                                        <c:if test="${empty dto.item_list_json || !fn:contains(dto.item_json,'\"list\"')}">
                                                            <tr class="itemList_add_table1" id="itemList_add_table1">
                                                                <td>1</td>
                                                                <td>
                                                                    <input class="border" type="text" data_name="title"
                                                                           placeholder="아이템 명 (6자 이내)">
                                                                </td>
                                                                <td>
                                                                    <input class="border" type="text"
                                                                           data_name="description"
                                                                           placeholder="아이템 내용 (23자 이내)">
                                                                </td>
                                                                <td>
                                                                    <div class="table_btn">
                                                                        <div class="up" onclick="upRow3(this)"><i
                                                                                class="fa-solid fa-square-caret-up"></i>
                                                                        </div>
                                                                        <div class="down" onclick="downRow3(this)"><i
                                                                                class="fa-solid fa-square-caret-down"></i>
                                                                        </div>
                                                                        <div class="del" onclick="deleteRow3(this)"><i
                                                                                class="fa-solid fa-square-xmark"></i></div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr class="itemList_add_table2" id="itemList_add_table2">
                                                                <td>2</td>
                                                                <td>
                                                                    <input class="border" type="text" data_name="title"
                                                                           placeholder="아이템 명 (6자 이내)">
                                                                </td>
                                                                <td>
                                                                    <input class="border" type="text"
                                                                           data_name="description"
                                                                           placeholder="아이템 내용 (23자 이내)">
                                                                </td>
                                                                <td>
                                                                    <div class="table_btn">
                                                                        <div class="up" onclick="upRow3(this)"><i
                                                                                class="fa-solid fa-square-caret-up"></i>
                                                                        </div>
                                                                        <div class="down" onclick="downRow3(this)"><i
                                                                                class="fa-solid fa-square-caret-down"></i>
                                                                        </div>
                                                                        <div class="del" onclick="deleteRow3(this)"><i
                                                                                class="fa-solid fa-square-xmark"></i></div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                        <c:if test="${!empty dto.item_list_json && fn:contains(dto.item_json,'\"list\"')}">
                                                            <c:forEach var="item" items="${dto.item_list_json.list}" varStatus="st">
                                                                <tr class="itemList_add_table1" id="itemList_add_table1">
                                                                    <td>${st.index+1}</td>
                                                                    <td>
                                                                        <input class="border" type="text" data_name="title" value="${item.title}"
                                                                               placeholder="아이템 명 (6자 이내)">
                                                                    </td>
                                                                    <td>
                                                                        <input class="border" type="text" value="${item.description}"
                                                                               data_name="description"
                                                                               placeholder="아이템 내용 (23자 이내)">
                                                                    </td>
                                                                    <td>
                                                                        <div class="table_btn">
                                                                            <div class="up" onclick="upRow3(this)"><i
                                                                                    class="fa-solid fa-square-caret-up"></i>
                                                                            </div>
                                                                            <div class="down" onclick="downRow3(this)"><i
                                                                                    class="fa-solid fa-square-caret-down"></i>
                                                                            </div>
                                                                            <div class="del" onclick="deleteRow3(this)"><i
                                                                                    class="fa-solid fa-square-xmark"></i>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:if>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>

                                        <c:if test="${!empty dto.item_list_json  && fn:contains(dto.item_json,'\"summary\"')}">
                                            <c:set var="summary" value="${dto.item_list_json.summary}" />
                                            <div class="block emphItemList_itemInfo ${dto.emp_tp ne 'ITEM_LIST'? 'display-none':''}">
                                                <div class="row" style="height: auto;">
                                                    <div class="th" style="line-height: 17px;">아이템<br>요약정보</div>
                                                    <div class="td">
                                                        <div class="itemInfo_div">
                                                            <input type="checkbox" id="itemInfo_check" ${!empty summary? 'checked':''}>
                                                            <label for="itemInfo_check">설정 (요약정보의 아이템내용은 변수 및 화폐 단위, 숫자, 쉼표,
                                                                마침표만 사용 가능합니다.)</label>
                                                        </div>

                                                        <div class="itemInfo_div itemInfo_check_on ${!empty summary ? '':'display-none'}">
                                                            <input type="text" class="txt_input4 first border" value="${summary.title}"
                                                                   data_name="title"
                                                                   placeholder="아이템 명 (최대 6자)">
                                                            <input type="text" class="txt_input4 border"  value="${summary.description}"
                                                                   data_name="description"
                                                                   placeholder="아이템 내용 입력 (최대 14자, 화폐단위 및 숫자(쉼표 마침표 혀용) , 변수만 사용가능)">
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${empty dto.item_list_json || !fn:contains(dto.item_json,'\"summary\"')}">
                                            <div class="block emphItemList_itemInfo">
                                                <div class="row" style="height: auto;">
                                                    <div class="th" style="line-height: 17px;">아이템<br>요약정보</div>
                                                    <div class="td">
                                                        <div class="itemInfo_div">
                                                            <input type="checkbox" id="itemInfo_check">
                                                            <label for="itemInfo_check">설정 (요약정보의 아이템내용은 변수 및 화폐 단위, 숫자, 쉼표,
                                                                마침표만 사용 가능합니다.)</label>
                                                        </div>

                                                        <div class="itemInfo_div itemInfo_check_on display-none">
                                                            <input type="text" class="txt_input4 first border"
                                                                   data_name="title"
                                                                   placeholder="아이템 명 (최대 6자)">
                                                            <input type="text" class="txt_input4 border"
                                                                   data_name="description"
                                                                   placeholder="아이템 내용 입력 (최대 14자, 화폐단위 및 숫자(쉼표 마침표 혀용) , 변수만 사용가능)">
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>

                                    </div>
                                        <%--<div class="block">
                                            <div class="row template_textarea">
                                                <div class="th">템플릿내용 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <textarea rows="8" name="templateContent"
                                                              placeholder="텍스트 입력 (최대 1000자)"></textarea>
                                                </div>
                                            </div>
                                        </div>--%>
                                    <div class="block addinfo_block ${dto.tmpl_msg_tp ne 'EX'  && dto.tmpl_msg_tp ne 'MI'? 'display-none':''}" name="sel_box">
                                        <div class="row template_textarea">
                                            <div class="th">부가 정보 <span class="color_red">*</span></div>
                                            <div class="td">
                                                <textarea rows="8" name="newTemplateExtra"
                                                          placeholder="텍스트 입력 (최대 500자)">${dto.tmpl_ext}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                        <%--<div class="block adver_msg_block">
                                            <div class="row template_textarea">
                                                <div class="th">광고성 메시지 <span class="color_red">*</span><br>(수신 동의 요청 또는 간단
                                                    광고 문구)
                                                </div>
                                                <div class="td">
                                                    <textarea rows="8" name="tmpl_ad"
                                                              placeholder="텍스트 입력 (최대 500자)"></textarea>
                                                </div>
                                            </div>
                                        </div>--%>
                                    <div class="block block2 addchannel_block ${dto.tmpl_msg_tp ne 'AD'  && dto.tmpl_msg_tp ne 'MI'? 'display-none':''}" >
                                        <div class="row template_textarea2">
                                            <div class="th">채널 추가<br>안내 메시지</div>
                                            <div class="td">
                                                <textarea rows="2" name="newTemplateAd"
                                                          readonly>채널 추가하고 이 채널의 광고와 마케팅 메시지 받기</textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block block3 addchannel_block  ${dto.tmpl_msg_tp ne 'AD'  && dto.tmpl_msg_tp ne 'MI'? 'display-none':''}">
                                        <div class="row row2 template_textarea3">
                                            <div class="th"></div>
                                            <div class="td">
                                                <p class="color_red">
                                                    * 메시지 유형이 "채널 추가형" 혹은 "복합형"인 경우 "채널 추가" 버튼이 필수이며 메시지 하단에 채널 추가 안내
                                                    메시지가 함께 노출됩니다.<br>
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
                                                <table id="template_btn_table" summary="list">
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
                                                    <c:set var="buttons" value="${dto.btn_json}" />
                                                    <c:if test="${fn:length(buttons) ==0}">
                                                        <tr class="type_table_no_info">
                                                            <td colspan="5">
                                                                버튼 정보가 없습니다.
                                                            </td>
                                                        </tr>
                                                    </c:if>

                                                    <tr class="channel_add_table use_btn ${dto.tmpl_msg_tp eq 'MI'  || dto.tmpl_msg_tp eq 'AD' ? '' :'display-none'} "
                                                        id="channel_add_table">
                                                        <td>1</td>
                                                        <td>
                                                            <select class="border btn_type" id="channel_add_select"
                                                                    disabled>
                                                                <option value="AC" selected>채널추가</option>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <input class="border" type="text" placeholder="채널 추가"
                                                                   name='name' value="채널 추가"
                                                                   disabled readonly>
                                                        </td>
                                                        <td>
                                                            <p class="color_red">* 채널 추가 버튼은 단독 혹은 최상단에 위치한 경우에만
                                                                가능</p>
                                                        </td>
                                                        <td></td>
                                                    </tr>
                                                    <c:forEach var="button" items="${buttons}" varStatus="st">
                                                        <c:if test="${((dto.tmpl_msg_tp eq 'MI'|| dto.tmpl_msg_tp eq 'AD')  && st.index ne 0)
                                                         or (dto.tmpl_msg_tp ne 'MI' and dto.tmpl_msg_tp ne 'AD')}">
                                                            <tr class="use_btn">
                                                                <td>${st.index +1}</td>
                                                                <td><select class="border btn_type" id="table_btn_type"
                                                                            onchange="selectType(this, this)">
                                                                    <option value="" selected="" disabled="">버튼타입 선택
                                                                    </option>
                                                                    <c:forEach var="btn" items="${btnLst}">
                                                                        <option value="${btn.cd_val}"
                                                                                data_sn="${btn.cd_sn}"
                                                                            ${button.linkType eq btn.cd_val ? 'selected' : ''}>${btn.cd_desc}</option>
                                                                    </c:forEach>
                                                                </select></td>
                                                                <td><input class="border" type="text" name="name"
                                                                           value="${button.name}"
                                                                           placeholder="버튼명 입력 (14자 이내)"></td>
                                                                <td>
                                                                    <div class="webLink-on ${button.linkType ne 'WL'? 'display-none': ''}">
                                                                        <p
                                                                                class="btn_link_title_first">Moblie</p>
                                                                        <input
                                                                                type="text" class="border" name="linkMo"
                                                                                value="${button.linkMo}"
                                                                                placeholder="http:// 또는 https:// 가 포함된 URL">
                                                                        <p class="btn_link_title">PC(선택)</p><input
                                                                            type="text"
                                                                            class="border"
                                                                            name="linkPc" value="${button.linkPc}"
                                                                            placeholder="http:// 또는 https:// 가 포함된 URL">
                                                                    </div>
                                                                    <div class="appLink-on ${button.linkType ne 'AL'? 'display-none': ''}">
                                                                        <p class="color_red">*
                                                                            Android, iOS, Mobile 중 2가지 이상 입력 필수</p>
                                                                        <p class="btn_link_title">Android</p><input
                                                                            type="text"
                                                                            class="border"
                                                                            name="linkAnd" value="${button.linkAnd}"
                                                                            placeholder="scheme android 링크">
                                                                        <p class="btn_link_title">iOS</p><input
                                                                            type="text"
                                                                            class="border"
                                                                            name="linkIos" value="${button.linkIos}"
                                                                            placeholder="scheme iOS 링크">
                                                                        <p class="btn_link_title">Moblie</p><input
                                                                            type="text"
                                                                            class="border"
                                                                            name="linkMo" value="${button.linkMo}"
                                                                            placeholder="http:// 또는 https:// 가 포함된 URL">
                                                                        <p class="btn_link_title">PC(선택)</p><input
                                                                            type="text"
                                                                            class="border"
                                                                            name="linkPc" value="${button.linkPc}"
                                                                            placeholder="http:// 또는 https:// 가 포함된 URL">
                                                                    </div>
                                                                    <div class="plugin-on display-none"><input
                                                                            type="text"
                                                                            class="border"
                                                                            name="pluginId" value="${button.pluginId}"
                                                                            placeholder="플러그인 ID">
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="table_btn">
                                                                        <div class="up" onclick="upRow(this)"><i
                                                                                class="fa-solid fa-square-caret-up"></i>
                                                                        </div>
                                                                        <div class="down" onclick="downRow(this)"><i
                                                                                class="fa-solid fa-square-caret-down"></i>
                                                                        </div>
                                                                        <div class="del" onclick="deleteRow(this)"><i
                                                                                class="fa-solid fa-square-xmark"></i>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                    </tbody>
                                                </table>

                                            </div>
                                        </div>
                                    </div>
                                    <%--<div class="block template_table template_link_table">
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
                                    </div>--%>

                                    <div class="block template_table template_link_table">
                                        <div class="row" style="height: auto;">
                                            <div class="th">검수 결과</div>
                                            <div class="td">
                                                <table summary="list">
                                                    <colgroup>
                                                        <col width="10%">
                                                        <col width="16%">
                                                        <col width="7%">
                                                        <col width="67%">
                                                    </colgroup>
                                                    <thead>
                                                    <tr>
                                                        <th>작성자</th>
                                                        <th>등록시간</th>
                                                        <th>상태</th>
                                                        <th>결과 및 요청사항</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:forEach var="comment" items="${dto.comment_json}" varStatus="st" >
                                                        <tr class="itemList_add_table1">
                                                            <td>${comment.commentUserName}</td>
                                                            <td>${comment.commentCreateAt}</td>
                                                            <td>
                                                                <c:forEach var="cmtSt" items="${cmtStLst}">
                                                                    <c:if test="${cmtSt.cd_val eq comment.commentStatus}">${cmtSt.cd_desc}</c:if>
                                                                </c:forEach>
                                                                    </td>
                                                            <td style="line-height: 1.5;">
                                                                    ${comment.commentContent}
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="viewer_area">
                                <div class="top"><span class="marg-lf">템플릿 내용</span>
                                    <span class="prev_btn" onclick="prevAtTmplImg()">미리보기</span>
                                </div>
                                <div class="at_inner template_body">
                                    <div class="text">
                                        <div class="row_body">
                                            <div class="round_box" id="prev_cont">
                                                <div class="round_box head">
                                                    <p>알림톡 도착</p>
                                                </div>
                                                <div class="sms_txt at_tmpl_data"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%--<div class="byte">
                                    <span class="en_font sms_byte">0</span><span class="en_font">byte</span>
                                </div>--%>
                            </div>
                        </div>
                    </div>
                </div>
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
                    <input type="text" name='img_nm' placeholder="이미지 명 입력"/>
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

<%--    href="./cancleTmplReq.service?seq=${dto.seq}" href="./updTmplSt.service?seq=${dto.seq}"
--%>

//  검수요청 취소
    $(document).on('click','#reqCancleBtn',()=>{
        const seq = $("#tmplSeq").val();
        const res = function (response) {
            popup.popAlert(response.msg)
            if (response.status == 200) {
                location.reload()
            }
        }
        let param = {seq :seq}
        com_ajax.ajax('post', '${baseURL}/cont/kko/cancleTmplReq.service', param, res, '${_csrf.headerName}', '${_csrf.token}')
    })

//  상태 업데이트
    $(document).on('click','#updTmplBtn',()=>{
        const seq = $("#tmplSeq").val();
        const res = function (response) {
            if (response.status == 200) {
                popup.popAlertCallback(response.msg, "window.location.reload();");
            }else {
                popup.popAlert(response.msg)
            }
        }
        let param = {seq :seq}
        com_ajax.ajax('post', '${baseURL}/cont/kko/updTmplSt.service', param, res, '${_csrf.headerName}', '${_csrf.token}')
    })

    //  검수요청
    $(document).on('click', '#reqTmplBtn', () => {
        const seq = $("#tmplSeq").val();
        const res = function (response) {
            popup.popAlert(response.msg)
            if (response.status == 200) {
                location.reload()
            }
        }
        let param = {seq: seq}
        com_ajax.ajax('post', '${baseURL}/cont/kko/updReqTmplSt.service', param, res, '${_csrf.headerName}', '${_csrf.token}')
    })

   /* //  템플릿 삭제
    $(document).on('click', '#appCancleBtn', () => {
        const seq = $("#tmplSeq").val();
        const res = function (response) {
            popup.popAlert(response.msg)
            if (response.status == 200) {
                location.reload()
            }
        }
        let param = {seq: seq}
        com_ajax.ajax('post', '${baseURL}/cont/kko/cancleTmplApp.service', param, res, '${_csrf.headerName}', '${_csrf.token}')
    })

    //  템플릿 삭제
    $(document).on('click', '#delTmplBtn', () => {
        const seq = $("#tmplSeq").val();
        const res = function (response) {
            popup.popAlert(response.msg)
            if (response.status == 200) {
                location.reload()
            }
        }
        let param = {seq: seq}
        com_ajax.ajax('post', '${baseURL}/cont/kko/removeTmpl.service', param, res, '${_csrf.headerName}', '${_csrf.token}')
    })*/


    /*----- 알림톡 템플릿 테이블 ------*/
    // 버튼 열 추가
    function addRowBtn() {
        $('.type_table_no_info').addClass('display-none');

        let table = document.getElementById('template_btn_table');

        let newRow = table.insertRow();
        $(newRow).addClass("use_btn");
        let newCell1 = newRow.insertCell(0);
        let newCell2 = newRow.insertCell(1);
        let newCell3 = newRow.insertCell(2);
        let newCell4 = newRow.insertCell(3);
        let newCell5 = newRow.insertCell(4);

        let addCell1 = '';
        let addCell2 = '';
        let addCell3 = '';
        let addCell4 = '';

        addCell1 += '<select class="border btn_type" id="table_btn_type" onchange="selectType(this, this)">' +
            '<option value="" selected disabled>버튼타입 선택</option>'
        <c:forEach var="btn" items="${btnLst}">
        addCell1 += '<option value="${btn.cd_val}" data_sn="${btn.cd_sn}">${btn.cd_desc}</option>'
        </c:forEach>
        addCell1 += '</select>';

        addCell2 += '<input class="border" type="text" name="name" placeholder="버튼명 입력 (14자 이내)">';

        addCell3 += '<div class="webLink-on display-none">' +
            '<p class="btn_link_title_first">Moblie</p>' +
            '<input type="text" class="border" name="linkMo" placeholder="http:// 또는 https:// 가 포함된 URL">' +
            '<p class="btn_link_title">PC(선택)</p>' +
            '<input type="text" class="border" name="linkPc" placeholder="http:// 또는 https:// 가 포함된 URL"></div>' +
            '<div class="appLink-on display-none">' +
            '<p class="color_red">* Android, iOS, Mobile 중 2가지 이상 입력 필수</p>' +
            '<p class="btn_link_title">Android</p>' +
            '<input type="text" class="border" name="linkAnd" placeholder="scheme android 링크">' +
            '<p class="btn_link_title">iOS</p>' +
            '<input type="text" class="border" name="linkIos" placeholder="scheme iOS 링크">' +
            '<p class="btn_link_title">Moblie</p>' +
            '<input type="text" class="border" name="linkMo" placeholder="http:// 또는 https:// 가 포함된 URL">' +
            '<p class="btn_link_title">PC(선택)</p>' +
            '<input type="text" class="border" name="linkPc" placeholder="http:// 또는 https:// 가 포함된 URL"></div>' +
            '<div class="plugin-on display-none">' +
            '<input type="text" class="border" name="pluginId" placeholder="플러그인 ID">' +
            '</div>';
        addCell4 += '<div class="table_btn">' +
            '<div class="up" onclick="upRow(this)"><i class="fa-solid fa-square-caret-up"></i></div>' +
            '<div class="down" onclick="downRow(this)"><i class="fa-solid fa-square-caret-down"></i></div>' +
            '<div class="del" onclick="deleteRow(this)"><i class="fa-solid fa-square-xmark"></i></div>' +
            '</div>';

        let dis = $('.channel_add_table').hasClass('display-none');

        if (dis == false) {
            newCell1.innerText = table.tBodies[0].rows.length - 1;
        } else if (dis == true) {
            newCell1.innerText = table.tBodies[0].rows.length - 2;
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

        addCell1 += '<select class="border" id="table_link_type" onchange="selectType2(this, this)">' +
            '<option value="" selected disabled>바로연결 타입 선택</option>'
        <c:forEach var="btnLink" items="${btnLinkLst}">
        addCell1 += '<option value="${btnLink.cd_val}" data_sn="${btnLink.cd_sn}">${btnLink.cd_desc}</option>'
        </c:forEach>
        addCell1 += '</select>';

        addCell2 += '<input class="border" name="name" type="text" placeholder="바로연결명 입력 (14자 이내)">';

        addCell3 += '<div class="webLink-on display-none">' +
            '<p class="btn_link_title_first">Moblie</p>' +
            '<input type="text" class="border" name="linkMo" placeholder="http:// 또는 https:// 가 포함된 URL">' +
            '<p class="btn_link_title">PC(선택)</p>' +
            '<input type="text" class="border" name="linkPc" placeholder="http:// 또는 https:// 가 포함된 URL"></div>' +
            '<div class="appLink-on display-none">' +
            '<p class="color_red">* Android, iOS, Mobile 중 2가지 이상 입력 필수</p>' +
            '<p class="btn_link_title">Android</p>' +
            '<input type="text" class="border" name="linkAnd" placeholder="scheme android 링크">' +
            '<p class="btn_link_title">iOS</p>' +
            '<input type="text" class="border" name="linkIos" placeholder="scheme iOS 링크">' +
            '<p class="btn_link_title">Moblie</p>' +
            '<input type="text" class="border" name="linkMo" placeholder="http:// 또는 https:// 가 포함된 URL">' +
            '<p class="btn_link_title">PC(선택)</p>' +
            '<input type="text" class="border" name="linkPc" placeholder="http:// 또는 https:// 가 포함된 URL"></div>';

        addCell4 += '<div class="table_btn">' +
            '<div class="up" onclick="upRow2(this)"><i class="fa-solid fa-square-caret-up"></i></div>' +
            '<div class="down" onclick="downRow2(this)"><i class="fa-solid fa-square-caret-down"></i></div>' +
            '<div class="del" onclick="deleteRow2(this)"><i class="fa-solid fa-square-xmark"></i></div>' +
            '</div>';

        newCell1.innerText = table.tBodies[0].rows.length - 1;
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

        addCell2 += '<input class="border" type="text" data_name="title" placeholder="아이템 명 (6자 이내)">';
        addCell3 += '<input class="border" type="text" data_name="description" placeholder="아이템 내용 (23자 이내)">';

        addCell4 += '<div class="table_btn">' +
            '<div class="up" onclick="upRow3(this)"><i class="fa-solid fa-square-caret-up"></i></div>' +
            '<div class="down" onclick="downRow3(this)"><i class="fa-solid fa-square-caret-down"></i></div>' +
            '<div class="del" onclick="deleteRow3(this)"><i class="fa-solid fa-square-xmark"></i></div>' +
            '</div>';

        newCell1.innerText = table.tBodies[0].rows.length;
        newCell2.innerHTML = addCell2;
        newCell3.innerHTML = addCell3;
        newCell4.innerHTML = addCell4;
    }

    // 열 위로 이동
    function upRow(n) {
        let i = n.parentNode.parentNode.parentNode;

        if (i.rowIndex <= 3) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }
        cellNum();
    }

    function upRow2(n) {
        let i = n.parentNode.parentNode.parentNode;

        if (i.rowIndex <= 2) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }
        cellNum2();
    }

    function upRow3(n) {
        let i = n.parentNode.parentNode.parentNode;

        if (i.rowIndex <= 1) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }
        cellNum3();
    }

    // 열 아래로 이동
    function downRow(n) {
        let table = document.getElementById('template_btn_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if (i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }

        cellNum();
    }

    function downRow2(n) {
        let table = document.getElementById('template_link_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if (i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }
        cellNum2();
    }

    function downRow3(n) {
        let table = document.getElementById('emphItemList_list_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if (i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }
        cellNum3();
    }

    // 열 삭제
    function deleteRow(n) {
        let table = document.getElementById('template_btn_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        table.deleteRow(i);

        let dis = $('.channel_add_table').hasClass('display-none');

        if (dis == false) {
            let cnt = table.tBodies[0].rows.length;
            if (cnt <= 1) {
                $('.type_table_no_info').children('td').text('버튼 정보가 없습니다.');
                $('.type_table_no_info').removeClass('display-none');
            } else {
                cellNum();
            }
        } else if (dis == true) {
            let cnt = table.tBodies[0].rows.length;
            if (cnt <= 2) {
                $('.type_table_no_info').children('td').text('버튼 정보가 없습니다.');
                $('.type_table_no_info').removeClass('display-none');
            } else {
                cellNum();
            }
        }
    }

    function deleteRow2(n) {
        let table = document.getElementById('template_link_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        table.deleteRow(i);

        let cnt = table.tBodies[0].rows.length;
        if (cnt <= 1) {
            $('.link_table_no_info').children('td').text('바로연결 정보가 없습니다.');
            $('.link_table_no_info').removeClass('display-none');
        } else {
            cellNum2();
        }
    }

    function deleteRow3(n) {
        let table = document.getElementById('emphItemList_list_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        let cnt = table.tBodies[0].rows.length;
        if (cnt <= 2) {
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

        // 채널추가 열이 display block인 경우
        if (dis == false) {
            for (let i = 0; i < cnt; i++) {
                row = table.tBodies[0].rows[i];
                let cell = row.getElementsByTagName('td')[0];
                cell.innerText = String(i);
            }
            // 채널추가 열이 display none인 경우
        } else if (dis == true) {
            for (let i = 0; i < cnt; i++) {
                row = table.tBodies[0].rows[i];
                let cell = row.getElementsByTagName('td')[0];
                cell.innerText = String(i - 1);
            }
        }
    }

    function cellNum2() {
        let table = document.getElementById('template_link_table');
        let cnt = table.tBodies[0].rows.length;

        let row = "";
        for (let i = 0; i < cnt; i++) {
            row = table.tBodies[0].rows[i];
            let cell = row.getElementsByTagName('td')[0];
            cell.innerText = String(i);
        }
    }

    function cellNum3() {
        let table = document.getElementById('emphItemList_list_table');
        let cnt = table.tBodies[0].rows.length;

        let row = "";
        for (let i = 0; i < cnt; i++) {
            row = table.tBodies[0].rows[i];
            let cell = row.getElementsByTagName('td')[0];
            cell.innerText = String(i + 1);
        }
    }

    // 버튼 타입 선택
    function selectType(item, i) {
        let sn = $(item).find('option:selected').attr("data_sn");

        if (sn == 1) {
            typeFirstOption(i);
        } else if (sn == 2) {
            typeSecondOption(i);
        } else if (sn >= 3 && sn <= 7) {
            typeAllNone(i);
        } else if (sn >= 8) {
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
        if (NodeLen == 3) {
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if (webLinkBlock == true && appLinkBlock == true && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.add('display-none');
                plugin.classList.add('display-none');
            }

        } else {
            if (webLinkBlock == true && appLinkBlock == true) {
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
        if (NodeLen == 3) {
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if (webLinkBlock == false && appLinkBlock == true && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.remove('display-none');
                appLink.classList.add('display-none');
                plugin.classList.add('display-none');
            }

        } else {

            if (webLinkBlock == false && appLinkBlock == true) {
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
        if (NodeLen == 3) {
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if (webLinkBlock == true && appLinkBlock == false && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.remove('display-none');
                plugin.classList.add('display-none');
            }

        } else {
            if (webLinkBlock == true && appLinkBlock == false) {
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
    function selectType2(item, i) {
        const sn = $(item).find('option:selected').attr("data_sn");
        if (sn == 1) {
            typeFirstOption(i);
        } else if (sn == 2) {
            typeSecondOption(i);
        } else if (sn >= 3) {
            typeAllNone(i);
        }
    }

    /*-------  알림톡 템플릿 테이블 끝  ------*/

    $(function () {
        /*-------  알림톡 템플릿  ------*/
        prevAtTmplImg();    // 미리보기

        // 카테고리 선택
        $('.bizContsVal_group .option li').on('click', function () {
            let val = $(this).val();
            let list = $(".bizContsVal .option").find('li[class="cate_op_' + val + '"]');
            let not_list = $(".bizContsVal .option").find('li[class!="cate_op_' + val + '"]');

            if (val == 1) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 2) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 3) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 4) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 5) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 6) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 7) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 8) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 9) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if (val == 10) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            }

            // 소분류 변경
            $('.bizContsVal .option li.cate_op_' + val + `:first`).trigger('click');
        });
        // 카테고리 소분류 선택
        $('.bizContsVal .option li').on('click', function () {
            let val = $(this).index()+1;
            $('.template_category_p').hide();
            $(`.template_category_p.gid_` + val).show();
        })

        // 메시지유형 선택
        $('.bizMsgVal .option li').on('click', function () {
            let idx = $(this).attr("data_sn");

            if (idx == 1) {  // 기본형
                allNone();
            } else if (idx == 2) {  //부가정보형
                BlockNone();
            } else if (idx == 3) {  // 채널추가형
                NoneBlock();
                let msg = '메시지 유형이 "채널 추가형"으로 변경되어,<br/>첫번째 버튼의 타입이 "채널추가"로 변경 입력되며<br/>기존 입력한 버튼정보는 유지되지 않습니다.';
                alertMsg(msg)
            } else if (idx == 4) {  // 복합형
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
            $('.addinfo_block').removeClass('display-none');
            $('.adver_msg_block').removeClass('display-none');
            $('.addchannel_block').removeClass('display-none');
            $('.channel_add_table').removeClass('display-none');
            $('.type_table_no_info').addClass('display-none');

            $('div[name="sel_box"] input[type="text"]').val('');
            $('div[name="sel_box"] textarea').val('');
            cellNum();
        }

        function BlockNone() {
            $('.addinfo_block').removeClass('display-none');
            $('.adver_msg_block').addClass('display-none');
            $('.addchannel_block').addClass('display-none');
            $('.channel_add_table').addClass('display-none');

            $('div[name="sel_box"] input[type="text"]').val('');
            $('div[name="sel_box"] textarea').val('');

            let table = document.getElementById('template_btn_table');

            if (table.tBodies[0].rows.length <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }
        }

        function NoneBlock() {
            $('.addinfo_block').addClass('display-none');
            $('.adver_msg_block').addClass('display-none');
            $('.addchannel_block').removeClass('display-none');
            $('.channel_add_table').removeClass('display-none');
            $('.type_table_no_info').addClass('display-none');

            $('div[name="sel_box"] input[type="text"]').val('');
            $('div[name="sel_box"] textarea').val('');
            cellNum();
        }

        function allNone() {
            $('.addinfo_block').addClass('display-none');
            $('.adver_msg_block').addClass('display-none');
            $('.addchannel_block').addClass('display-none');
            $('.channel_add_table').addClass('display-none');

            $('div[name="sel_box"] input[type="text"]').val('');
            $('div[name="sel_box"] textarea').val('');

            let table = document.getElementById('template_btn_table');

            if (table.tBodies[0].rows.length <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }

        }

        //강조유형 선택
        $('.bizEmphVal .option li').on('click', function () {
            let sn = $(this).attr("data_sn");
            if (sn == 1) {
                emphAllNone();
            } else if (sn == 2) {
                emphFirstOption();
            } else if (sn == 3) {
                emphSecondOption();
            } else if (sn == 4) {
                emphThirdOption();
            }
        })

        function emphAllNone() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').addClass('display-none');

            emphClear();
        }

        function emphFirstOption() {
            $('.emphtxt_block').removeClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').addClass('display-none');

            emphClear();
        }

        function emphSecondOption() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').removeClass('display-none');
            $('.emphItemList_block').addClass('display-none');

            emphClear();
        }

        function emphThirdOption() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').removeClass('display-none');

            emphClear();
        }

        function emphClear(){
            $('div[name="emph_sel_box"] input[type="checkbox"]:checked').trigger("click");
            $('div[name="emph_sel_box"] input[type="text"]').val('');
            // $('div[name="emph_sel_box"] textarea').val('');
            $('.prv_col_img').html('').hide();
            $('.imgBtn').show();
        }

        //강조유형 - 아이템리스트 - 이미지
        $('#img_check').on('click', function () {
            $('.itemlist_img_on').toggleClass('display-none');
            if($('.itemlist_img_on').hasClass('display-none')){
                $('#img_data input[type="text"]').val("");
                $('.newImgDiv').removeClass('display-none');
                $('div[name="prevImg"]').html('');
            }
        })

        //강조유형 - 아이템리스트 - 헤더
        $('#header_check').on('click', function () {
            $('.header-check-on').toggleClass('display-none');
            if($('.header-check-on').hasClass('display-none')){
                $('.header-check-on').val("");
            }
        })

        //강조유형 - 아이템리스트 - 하이라이트
        $('#highlight_check').on('click', function () {
            $('.highlight_check_on').toggleClass('display-none');
            if($('#highlight_check').prop("checked") != true){
                $('#highlight_img_check').prop("checked",false)
                $('.highlight_img_on').addClass('display-none');
                $(".highlight_div input").val(''); // 초기화
            }
        })

        $('#highlight_img_check').on('click', function () {
            $('.highlight_img_on').toggleClass('display-none');
            if($('#highlight_check').prop("checked") != true){
                $(".highlight_img_on input").val(''); // 초기화
            }
        })

        //강조유형 - 아이템리스트 - 아이템 요약정보
        $('#itemInfo_check').on('click', function () {
            $('.itemInfo_check_on').toggleClass('display-none');
        })

        // textarea 글자수 제한
        $('.template_textarea textarea').on('keyup', function () {
            if ($(this).val().length > 1000) {
                $(this).val($(this).val().substring(0, 1000));
            }
        });

        $('.addinfo_block textarea').on('keyup', function () {
            if ($(this).val().length > 500) {
                $(this).val($(this).val().substring(0, 500));
            }
        });

        $('.emphtxt_block textarea').on('keyup', function () {
            if ($(this).val().length > 50) {
                $(this).val($(this).val().substring(0, 50));
            }
        });

        $('.emphtxt_block2 textarea').on('keyup', function () {
            if ($(this).val().length > 50) {
                $(this).val($(this).val().substring(0, 50));
            }
        });
        /*-------  알림톡 템플릿 끝  ------*/

        // 템플릿 코드 자동 생성
        $('.tmplCodeBtn').on('click', function () {
            $('#tmplCode').val(uuidv4())
        });


        // 프리뷰에서 저장 버튼 누르기
        $(document).on('click', '#saveBtn', function () {
            $("#atForm").submit();
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

        $('.js-ad').on('click', function () {
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


    // 알림톡 템플릿 유효성 검사
    function tmplValidate() {

        let senderKey = $('#kko_send_to');  //발신 프로필
        let tmplCode = $('input[name="newTemplateCode"]');  //템플릿 코드
        let tmplCate1 = $('.bizContsVal_group .value');  //카테고리그룹
        let tmplCate2 = $('.bizContsVal .value');  //카테고리
        let tmplName = $('input[name="newTemplateName"]');  //템플릿명
        let tmplMsg = $('.bizMsgVal .value'); //메시지 유형
        let tmplEmph = $('.bizEmphVal .value');  //강조유형
        let tmplTxt = $('textarea[name="newTemplateContent"]');  //템플릿내용

        if (senderKey.val() == '' || senderKey.val() == null) {
            senderKey.focus().addClass('outline');
            popup.popAlert("발신 프로필을 선택해주세요.");
            return false;
        }

        if (tmplCode.val() == '' || tmplCode.val() == null) {
            tmplCode.focus().addClass('outline');
            popup.popAlert("템플릿코드를 입력해주세요.");
            return false;
        }

        if (tmplCate1.text() == "카테고리 그룹") {
            tmplCate1.focus().addClass('outline');
            popup.popAlert("카테고리 그룹을 선택해주세요.");
            return false;
        } else if (tmplCate1.text() != "카테고리 그룹" && tmplCate2.text() == "카테고리") {
            tmplCate2.focus().addClass('outline');
            popup.popAlert("카테고리를 선택해주세요.");
            return false;
        }

        if (tmplName.val() == '' || tmplName.val() == null) {
            tmplName.focus().addClass('outline');
            popup.popAlert("템플릿 명을 입력해주세요.");
            return false;
        }

        if (tmplTxt.val() == '' || tmplTxt.val() == null) {
            tmplTxt.focus().addClass('outline');
            popup.popAlert("템플릿 내용을 입력해주세요.");
            return false;
        } else {
            let regExp = /\{{(.*?)\}}/g
            if(regExp.test(tmplTxt.val())){
                popup.confirmAlertCallback("알림톡 개인화변수는 '\#{변수명}' 형식입니다.","regChange($(`textarea[name='newTemplateContent']`))");
                return false;
            }
        }

        //부가정보형, 복합형인 경우 부가정보
        let templateExtra = $('textarea[name="newTemplateExtra"]');
        // let tmplAd = $('textarea[name="tmpl_ad"]');

        if (tmplMsg.text() == "부가 정보형" || tmplMsg.text() == "복합형") {
            if (templateExtra.val() == '' || templateExtra.val() == null) {
                templateExtra.focus().addClass('outline');
                popup.popAlert("부가 정보를 입력해주세요.");
                return false;
            }

            // if (tmplMsg.text() == "복합형") {
            //     if (tmplAd.val() == '' || tmplAd.val() == null) {
            //         tmplAd.focus().addClass('outline');
            //         popup.popAlert("광고성 메시지를 입력해주세요.");
            //         return false;
            //     }
            // }
        }


        //강조표기형
        let tmplEmphTitle = $('input[name="newTemplateTitle"]');
        let tmplEmphTxt = $('input[name="newTemplateSubtitle"]');

        if (tmplEmph.text() == "강조표기형") {
            if (tmplEmphTitle.val() == '' || tmplEmphTitle.val() == null) {
                tmplEmphTitle.focus().addClass('outline');
                popup.popAlert("강조 표기 타이틀을 입력해주세요.");
                return false;
            }

            if (tmplEmphTxt.val() == '' || tmplEmphTxt.val() == null) {
                tmplEmphTxt.focus().addClass('outline');
                popup.popAlert("강조 표기 보조 문구를 입력해주세요.");
                return false;
            }
        } else if (tmplEmph.text() == "이미지형") {
            if($('#highlight_img_check').prop('checked')){
                if($('#imageUrl').val() == ''){
                    popup.popAlert("아이템 하이라이트 이미지를 선택해주세요.");
                }
                if($('.highlight_div input[name="title"]').val() == ''
                    || $('.highlight_div input[name="description"]').val() == ''){
                    popup.popAlert("아이템 하이라이트 이미지를 사용할 경우, 설정이 필수입니다.");
                }
            }
        }
        return true;
    }


    function regChange(tmplTxt){
        $(tmplTxt).val($(tmplTxt).val().replaceAll('{{', '\#{').replaceAll('}}','}'));
        $('.layer_pop ').removeClass('active');
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
    // 템플릿 등록

    function isCheckTemplateName() {
        const seq = $("#tmplSeq").val();
        const tmpl_nm = $("input[name='newTemplateName']").val();
        const send_key = $('#send_key').val();
        const res = function (response) {
            if (response.status == 200) {
                popup.confirmAlertCallback("템플릿을 수정 하시겠습니까?", "updateTmpl()");

            } else {
                // 중복된 명칭 존재
                popup.popAlert(response.msg)
            }
        }
        let param = {seq :seq ,tmpl_nm: tmpl_nm, send_key: send_key}
        com_ajax.ajax('post', '${baseURL}/cont/kko/isCheckUpdTmplNm.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}')
    }

    function updateTmpl() {
        const res = function (response) {
            popup.popAlert(response.msg)
            $('#smsContentsPopup').addClass('active');

            if(response.status == 200){
                window.location.href = '/cont/atTemplate.mi';
            }
        }
        let data = $('#atForm').serializeArray().map(function (x) {
            this[x.name] = x.value;
            return this;
        }.bind({}))[0];

        data.templateContent = data.templateContent.replace(/\u200B/g,'');
        data.categoryCode = $('.bizContsVal .value').attr("data")

        // --------- 버튼 정보 ---------
        const butLst = $('#template_btn_table tbody tr.use_btn:visible');

        if(butLst.length > 0){
            let buttonLst = [];
            for (let idx = 0; idx < butLst.length; idx++) {
                let button = butLst[idx]
                let obj = new Object();
                obj.ordering = idx + 1
                obj.linkType = $(button).find('.btn_type option:selected').val();
                obj.linkTypeName = $(button).find('.btn_type option:selected').html();
                obj.name = $(button).find(`[name='name']`).val();
                if(obj.linkType == "WL"){  //링크 버튼 / "target":"out" 속성 추가시 아웃링크
                    obj.target = "out"
                }

                // 버튼 링크
                const btnInpLst1 = $(button).find(".webLink-on input:visible");
                const btnInpLst2 = $(button).find(".appLink-on input:visible");
                const btnInpLst3 = $(button).find(".plugin-on input:visible");
                let btnLst;
                if (btnInpLst1.length > 0) {
                    btnLst = btnInpLst1
                } else if (btnInpLst2.length > 0) {
                    btnLst = btnInpLst2
                } else {
                    btnLst = btnInpLst3
                }

                for (btnInf of btnLst) {
                    obj[$(btnInf).attr("name")] = $(btnInf).val();
                }
                buttonLst.push(obj);
            }
            data.buttons = buttonLst;
        }

        //  ------ 바로 연결  ---------

        const quickLst = $('#template_link_table tbody tr:visible');
        if(quickLst.length > 0) {
            let quickReplies = [];
            for (quick of quickLst) {

                let obj = new Object();
                obj.linkType = $(quick).find('#table_link_type option:selected').val();
                obj.name = $(quick).find(`[name='name']`).val();

                const linkLst1 = $(quick).find(".appLink-on:visible");
                const linkLst2 = $(quick).find(".webLink-on:visible");
                let linkLst = linkLst1.length > 0 ? linkLst1 : linkLst2;

                const inpLst = $(linkLst).find('input')
                for (link of inpLst) {
                    obj[$(link).attr("name")] = $(link).val()
                }
                quickReplies.push(obj);
            }
            data.quickReplies = quickReplies
            //  ------ 바로 연결  end---------
        }

        //  ------ 아이템 하이라이트  ---------
        //  itemHigh => 이미지 추가

        const highLst = $('.highlight_div input[type="text"]:visible');
        if(highLst.length > 0) {
            let itemHigh = new Object();
            for (high of highLst) {
                itemHigh[$(high).attr("name")] = $(high).val();  // 이미지 추가
            }
            let imgUrl = $('#imageUrl').val()
            if(imgUrl != undefined && imgUrl != ''){
                itemHigh.imageUrl = $('#imageUrl').val();
            }
            data.newTemplateItemHighlight = itemHigh;
        }

        //  ------ 아이템 하이라이트 end ---------


        //  ------ 아이템 리스트  ---------
        const selItemTrLst = $('#emphItemList_list_table tbody tr:visible');""
        if(selItemTrLst.length >0){
            let tmplItem = new Object();
            let itemList = [];
            for (selItemTr of selItemTrLst) {
                const selItemLst = $(selItemTr).find('input[type="text"]:visible');
                let item = new Object();
                for (selItem of selItemLst) {
                    item[$(selItem).attr("data_name")] = $(selItem).val();  // 이미지 추가
                }
                itemList.push(item);
            }
            tmplItem.list = itemList;
            //  ------ 아이템 리스트 end ---------

            //  ------ 아이템 요약정보  ---------
            const itemInfoLst = $('.itemInfo_div input[type="text"]:visible');
            if(itemInfoLst.length >0) {
                let itemInfo = new Object();
                for (info of itemInfoLst) {
                    itemInfo[$(info).attr("data_name")] = $(info).val();  // 이미지 추가
                }
                tmplItem.summary = itemInfo;
            }

            data.newTemplateItem = tmplItem;
            //  ------ 아이템 요약정보 end ---------
        }
        let img_seq = $('#tmplImgSeq').val();
        let item_img_seq = $('#itemImgSeq').val();

        com_ajax.ajax_json('post', '${baseURL}/cont/kko/tmplUpate.service?seq='+$('#tmplSeq').val()+'&img_seq='+img_seq+"&item_img_seq="+item_img_seq, JSON.stringify(data), res, '${_csrf.headerName}', '${_csrf.token}')
    }

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
        if (imgNm == "" || imgNm == null) {
            popup.popAlert("이미지명을 입력해주세요.");
            return false;
        }
        if ($("#file").val() == "" || $("#file").val() == null) {
            popup.popAlert("업로드된 파일이 없습니다.");
            return false;
        }

        var res = function (response) {
            //TO-DO
            //리스트 새로 불러오기
            if (response.imgCheck == 0) {
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
        if (ch_tp == 'RCS') {
            data.append("ch_tp", $('.rcs_select .value').attr('data'));
        } else {
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
        const current = new Date();

        return uint32.toString(16) + "_"
            + current.getFullYear().toString() + current.getMonth().toString() + current.getDate().toString()
            + current.getHours().toString() + current.getMinutes() + current.getSeconds().toString();
    }

    // 셀렉트 값 변경
    $(document).on('click', '.select .option li', (e) => {
        const val = $(e.target).attr("value");
        const nm = $(e.target).html();
        const select = $(e.target).parents(".select");

        $(select).find('.value').attr('data', val);
        $(select).find('.value').html(nm);
        $(select).find('input.selValue').val(val);
    })

    function imageListPopUp(nowPage, type) {
        $('#imgType').val(type);
        imageListPaging(nowPage);
    }

    // 이미지 리스트 팝업
    function imageListPaging(nowPage) {

        let type = $('#imgType').val();

        const res = function (response) {
            $('.imagePopup').addClass('active');
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $("#bodyDom").html($("#bodyDom", $doc).html());
            $("#pagingDom").html($("#pagingDom", $doc).html());
            $('#imgType').val(type);
        };

        let param = $("#imgSetForm").serializeArray();
        if (type === 'img') {
            // 이미지 타입 : Kakao Image
            param.push({name: 'ch_tp', value: 'IMGTP09'});
        } else if (type === 'img_item') {
            // 이미지 타입 : 문자(MMS)
            param.push({name: 'ch_tp', value: 'IMGTP10'});
        }

        param.push({name: 'pageNo', value: nowPage});

        com_ajax.ajax('post', '${baseURL}/cont/mobileImgList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }


    // 이미지 추가 등록
    function imgUploadPop() {
        var html = '<form id="form"><div class="layer_pop uploadPopup active" style="z-index:960;">' +
            '<div class="pop_container popup_size1">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />' +
            '<div class="pop_title">새 이미지 파일 업로드</div>' +
            '<div class="pop_inner">' +
            '<table class="pop_table_type1">' +
            '<colgroup>' +
            '<col width="103" />' +
            '<col width="*" />' +
            '</colgroup>' +
            '<tbody>' +
            '<tr>' +
            '<th>채널</th>' +
            '<td>' +
            '<label class="custom_radio">친구톡<input name="ch_tp" type="radio" value="IMGTP03" checked><span></span></label>' +
            // '<label class="custom_radio">친구톡(와이드)<input name="ch_tp" type="radio" value="IMGTP11"><span></span></label>' +
            '<label class="custom_radio">알림톡<input name="ch_tp" type="radio" value="IMGTP09"><span></span></label>' +
            '<label class="custom_radio">알림톡(아이템)<input name="ch_tp" type="radio" value="IMGTP10"><span></span></label>' +
            '<label class="custom_radio">모바일<input name="ch_tp" type="radio" value="IMGTP02" ><span></span></label>' +
            '<label class="custom_radio">RCS<input name="ch_tp" type="radio" value="RCS"><span></span></label><br>' +
            '</td>' +
            '</br>' +
            '<tr class="rcsImgForm rcs_option">' +
            '<th>양식</th>' +
            '<td>' +
            '<div class="select style1 rcs_select">' +
            '<div class="value" data="">RCS 양식 선택</div>' +
            '<ul class="option">' +
            '<li data="0">RCS 양식 선택</li>' +
            '<li data="IMGTP05">세로형 / Tall</li>' +
            '<li data="IMGTP06">세로형 / Medium</li>' +
            '<li data="IMGTP07">슬라이드형 / Small</li>' +
            '<li data="IMGTP08">슬라이드형 / Medium</li>' +
            '</ul>' +
            '</div>' +
            '</td>' +
            '</tr>' +
            '<tr>' +
            '<th>이미지 명</th>' +
            '<td>' +
            '<input type="text" placeholder="이미지 명을 입력해주세요." id="img_nmCk" name="img_nm" class="input_type1" />' +
            '</td>' +
            '</tr>' +
            '<tr>' +
            '<th>이미지 파일</th>' +
            '<td>' +
            '<input type="text" id="fileName" name="fileName" class="input_file" placeholder="이미지 파일을 선택해주세요." readonly />' +
            '<span class="btn_file">파일 선택<input type="file" class="file" id="file"/></span>' +
            '</td>' +
            '</tr>' +
            '</tbody>' +
            '</table>' +
            '<ul class="guide_txt guide_lst">' +
            '<li>※ 세로형 : ① Tall : 568 X 528 (1MB 이하), ② Medium : 568 X 336 (1MB 이하)</li>' +
            '<li>※ 슬라이드형 : ① Small : 360 X 336, ② Medium : 696 X 504, 최대 사이즈 360 X 1569 , 1MB 이하</li>' +
            '</ul>' +
            '<ul class="at_guide1 guide_lst" hidden>' +
            '<li>※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.</li>' +
            '</ul>' +
            '<ul class="at_guide2 guide_lst" hidden>' +
            '<li>※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 108px 이상이며 가로:세로 비율이 1:1 이어야 합니다.</li>' +
            '</ul>' +
            '<ul class="ft_guide1 guide_lst">' +
            '<li>※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 500px 이상이며 또는 가로:세로 비율이 2:1 또는 3:4 이어야 합니다.</li>' +
            '</ul>' +
            '<ul class="ft_guide2 guide_lst" hidden>' +
            '<li>※ 이미지 파일은 용량이 2MB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 800px 세로 600px 파일만 등록 가능합니다.</li>' +
            '</ul>' +
            '<div class="left pop_error_txt other_guide guide_lst" hidden>※ 모바일 : Jpg(200KB 이하), 이메일 : jpg, png, gif</div>' +
            '<div class="right pop_error_txt blue_point_color"></div>' +
            '<div class="img_viewer noImg"></div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_center uploadSave" onclick="saveContentImg();" value="저장" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div></form>';
        $("#imgListHtml").html(html);
    }

    function saveContentImg() {
        var imgNm = $("#img_nmCk").val();
        if (imgNm == "" || imgNm == null) {
            popup.popAlert("이미지명을 입력해주세요.");
            return false;
        }
        if ($("#file").val() == "" || $("#file").val() == null) {
            popup.popAlert("업로드된 파일이 없습니다.");
            return false;
        }

        var res = function (response) {
            //TO-DO
            //리스트 새로 불러오기
            if (response.imgCheck == 0) {
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
        if (ch_tp == 'RCS') {
            data.append("ch_tp", $('.rcs_select .value').attr('data'));
        } else {
            data.append("ch_tp", ch_tp);
        }
        data.append("img_nm", imgNm);

        com_ajax.ajax_file('${baseURL}/cont/contentUpload.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 이미지 리스트 Input 저장하기
    function imgSendSave(seq) {
        let imgType = $("#imgType").val();  // 이미지 파일 타입
        let imgLength = $('input[name="contentsImg"]:checked').length;
        let imgCheck = $('input[name="contentsImg"]:checked').val() // 이미지 파일 seq
        let ImgNm = $('input[name="contentsImg"]:checked').parent('label').find('input[name="ImgOrgNm"]').val();    // 이미지 파일 본명
        let kkoImgUrl = $('input[name="contentsImg"]:checked').parent('label').find('input[name="kkoImgurl"]').val(); // 이미지 파일 url
        let imgUrl = `${fn:substring(filePath,0,fn:length(filePath)-2)}` +  $('input[name="contentsImg"]:checked').parent('label').find('input[name="imgurl"]').val(); // 아이템 이미지 파일 url

        if (imgLength > 0) {
            imageCreate(imgType, kkoImgUrl, imgUrl, ImgNm, imgCheck);
            $('#imagePop').siblings('.pop_error_txt').html('');
            $('.imagePopup').removeClass('active');
        } else {
            return false;
        }
    }

    function imageCreate(type, kkoImgUrl, imageUrl, ImgNm, imgCheck) {
        if (imageUrl != '' || kkoImgUrl != '') {
            if (type == 'img') {
                $("#tmplImgUrl").val(kkoImgUrl);
                $("#tmplImgNm").val(ImgNm);
                $('#tmplImgCd').val(imgCheck);
                // $('#kakaoImage').parent('.td').removeClass('outline');
                $('div[name="newImgBtn"]').addClass('display-none');
                $('div[name="prevImg"]').removeClass('display-none').html('<div class="delete_img" data="img" style="right: 10px;"><img src="/image/btn_delete1.png" alt="삭제"> </div><a href="' + kkoImgUrl + '" target="_blank">' + '<img src="' + kkoImgUrl + '" onerror="this.src=\'/image/bg_none.png\'" />' + '</a>');
            } else if (type == "img_item") {
                $("#imageUrl").val(kkoImgUrl);
                $('#itemImgSeq').val(imgCheck);
                $('div[name="newItemImgBtn"]').addClass('display-none');
                $('div[name="prevItemImg"]').removeClass('display-none').html('<div class="delete_img" data="img_item" style="right: 20px; top: 110px;"><img src="/image/btn_delete1.png" alt="삭제"> </div> <a href="' + kkoImgUrl + '" target="_blank">' + '<img src="' + kkoImgUrl + '" onerror="this.src=\'/image/bg_none.png\'" style="height: 175px; width: 175px;" />' + '</a>');
            }
        }
    }


    // 이미지 삭제
    $(document).on('click','.delete_img', function () {
        let data = $(this).attr('data');

        if (data == "img") {
            $("#tmplImgUrl").val('');
            $("#tmplImgNm").val('');
            $('#tmplImgCd').val('');
            $('div[name="newImgBtn"]').removeClass('display-none');
            $('div[name="prevImg"]').addClass('display-none').html('');
        } else if (data == 'img_item') {
            $("#imageUrl").val('');
            $('#itemImgSeq').val('');
            $('div[name="newItemImgBtn"]').removeClass('display-none');
            $('div[name="prevItemImg"]').addClass('display-none').html('');
        }
    });


function prevAtTmplImg(){
    let msgTp  = $('.bizMsgVal .selValue').val();
    let empTp = $('.bizEmphVal .selValue').val();
    let imgUrl = $('#img_data #tmplImgUrl').val()

    let contHtml=``;
    switch (empTp) {
        case 'NONE':
            contHtml +=  `<div class="at_msg_cont">`
            break;
        case 'TEXT':
            contHtml +=  `<div class="at_msg_cont">
                                  <div class="tmpl_subtit">`+ $('input[name="newTemplateTitle"]').val() +`</div>
                                  <div class="tmpl_tit">`+ $('input[name="newTemplateSubtitle"]').val() +`</div>`
            break;

        case 'IMAGE':
            contHtml += `<div class="kko_img_box">
                                <img src="` + imgUrl +`" onerror="this.src = '/image/bg_none.png'" alt="">
                            </div>`
            contHtml +=  `<div class="at_msg_cont">`
            break;

        case 'ITEM_LIST':
            if($('#img_check').is(':checked')){
                contHtml += `<div class="kko_img_box">
                                <img src="` + imgUrl +`" onerror="this.src = '/image/bg_none.png'" alt="">
                            </div>`
            }
            contHtml +=  `<div class="at_msg_cont">`
            if($('#header_check').is(':checked')){
                contHtml += `<div class="tmpl_header">`+ $('input[name="newTemplateHeader"]').val() +`</div>`
            }
            if($('#highlight_check').is(':checked')){
                contHtml += `<div class="tmpl_high">
                                     <div>` + $('.highlight_div input[name="title"]').val() + `</div>
                                     <div class="tmpl_subtit">` + $('.highlight_div input[name="description"]').val() + `</div>
                                 </div>`
            }
            if($('#highlight_img_check').is(':checked')){
                contHtml += `<div class="right_img_box">
                        <img src="`+ $('#imageUrl').val()  + `" onerror="this.src = '/image/bg_none.png'" alt=""></div>`
            }
            const selItemTrLst = $('#emphItemList_list_table tbody tr:visible');
            if(selItemTrLst.length > 0){
                contHtml += `<div class="item_table">`
                // 아이템 리스트 넣어주기
                for (var i = 0; i <selItemTrLst.length; i++) {
                    contHtml += `<div>
                            <span class="th">`+$(selItemTrLst[i]).find('input[data_name="title"]').val() +`</span>
                            <span class="td">`+$(selItemTrLst[i]).find('input[data_name="description"]').val() +`</span>
                        </div>`
                };
                contHtml += `</div>`
            }

            //아이템 요약정보 넣어주기
            break;
    }

    contHtml += `<div class="cont">`+$('textarea[name="newTemplateContent"]').val().replaceAll("\n", "<br/>")+`</div>`

    switch (msgTp) {
        case 'BA':
            contHtml += `</div>`
            break;
        case 'EX':
            contHtml += `<div class="etx">`+ $('textarea[name="newTemplateExtra"]').val() +`</div></div>`
            break;
        case 'AD':
            contHtml += `<div class="ad">`+ $('textarea[name="newTemplateAd"]').val() +`</div></div>`
            break;
        case 'MI':
            contHtml += `<div class="etx">`+ $('textarea[name="newTemplateExtra"]').val() +`</div>
                            <div class="ad">`+ $('textarea[name="newTemplateAd"]').val() +`</div></div>`
            break;
    }

    const butLst = $('#template_btn_table tbody tr.use_btn:visible');
    if(butLst.length > 0){
        for (var i = 0; i <butLst.length; i++) {
            contHtml += `<a target="_blank" class="sms_btn">`+$(butLst[i]).find('input[name="name"]').val()+`</a>`
        };
    }
    $('#prev_cont .at_tmpl_data').html(contHtml)
}


    //개인화 변수 드래그
    $(document).on('dragstart', function(ev){
        ev.originalEvent.dataTransfer.setData("text", $(ev.target).attr("data"));
    });

    $(document).on('drop', function(ev){
        dropTarget = $(ev.target);
    });

    $(document).on('dragend', function(ev){
        let value = dropTarget.val();
        dropTarget.val("");
        dropTarget.val(value);
    });

</script>



