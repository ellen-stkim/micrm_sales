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
<div id="textArea">
<div class="flex_box">
   <div class="left_area">
      <!-- start -->
      <div class="row body">
         <div class="th">카드 양식</div>
         <div class="column_1">
            <label class="custom_radio en_font">SMS<input name="rcs_msg_tp" class="lowType"
                                                          type="radio" value="sms" checked
            /><span></span></label>
            <label class="custom_radio en_font">LMS<input name="rcs_msg_tp" class="lowType"
                                                          type="radio" value="lms"
            /><span></span></label>
         </div>
      </div>
       <span id="js-title-area">
          <input type="hidden" class="title rcsTitle" name="cont_sub_list" readonly >
       </span>
      <div class="row body">
         <div class="th">발신 번호</div>
         <div class="column_1" id ="send_text_column">
            <input type="text" class="sms_number smsNumber" id="send_text_rcs"
                    <c:if test = "${fn:trim(rcsSender[0].list_nm)!= ''}">
                       value="${rcsSender[0].list_nm}(${cutil:numberToPhone(rcsSender[0].list_val)})"
                    </c:if>
                    <c:if test = "${fn:trim(rcsSender[0].list_nm) == ''}">
                       placeholder="발신 번호를 입력해주세요."
                    </c:if>
                   readonly/>
            <input type="hidden" name="send_to_list" id="text_send_num" value="${rcsSender[0].seq}"/>
            <span class="btn_sm_line" onclick="mobileSenderPopup('1','textrcs')">변경</span>
         </div>
      </div>
      <div class="input_area left">
         <div class="block">
            <div class="row">
               <div class="th">개인화 변수</div>
               <div class="td">
                  <!-- select 영역 시작 -->
                  <div class="select rcsContsVal" name="edmDB">
                     <!-- selected value -->
                     <div class="value" data="0">개인화 변수</div>
                     <ul class="option mappingLst">
                        <c:forEach var="item" items="${column}" varStatus="status">
                           <li data="${item.list_val}">${item.list_nm}</li>
                        </c:forEach>
                     </ul>
                  </div>
                  <!-- select 영역 끝 -->
               </div>
            </div>
            <div class="row rcs_textarea">
               <div class="th top-border">내용</div>
               <div class="td top-border">
                        <textarea class="rcsContents" name="rcs_body" id="" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this, 0);"></textarea>
               </div>
            </div>
         </div>
          <div id="btn-action-area">
             <div class="block">
                <div class="row">
                   <div class="th bottom-border">버튼 액션 선택</div>
                   <div class="td bottom-border">
                      <!-- select 영역 시작 -->
                      <input type="hidden" name="rcs_btn_tp_1" value=""/>
                      <input type="hidden" name="rcs_btn_tp_2" value=""/>
                      <input type="hidden" name="rcs_btn_tp_3" value=""/>
                      <div class="select action_select" data="1">
                         <!-- selected value -->
                         <div class="value" data="0">액션선택</div>
                         <!-- option -->
                         <ul class="option">
                            <li data="0">액션선택</li>
                            <li data="RBTN01">복사하기</li>
                            <li data="RBTN02">URL연결</li>
                            <li data="RBTN03">전화걸기</li>
                            <li data="RBTN04">지도보여주기(좌표)</li>
                            <li data="RBTN05">지도보여주기(쿼리)</li>
                            <li data="RBTN06">현재위치공유</li>
                            <li data="RBTN07">캘린더등록</li>
                            <li data="RBTN08">메시지전송</li>
                         </ul>
                      </div>
                      <!-- select 영역 끝 -->
                   </div>
                </div>
                <div class="row">
                   <div class="th">버튼 명</div>
                   <div class="td button-name">
                      <input type="text" name="rcs_btn_1" class="txt_input action_name"
                             data="1" onkeyup="rcsCreate.buttonCount(this, 'text');"
                             placeholder="버튼 명을 입력해주세요."/>
                      <span class="text-count en_font"><span>0</span>/17</span>
                   </div>
                </div>
                <div class="custom_box"></div>
             </div>
         </div>
          <input type ="hidden" name ="rcs_btn_tp_1" value =""/>
          <input type ="hidden" name ="rcs_btn_tp_2" value =""/>
          <input type ="hidden" name ="rcs_btn_tp_3" value =""/>
         <div class="block" id="rejection">
            <div class="row">
               <div class="th">무료수신거부</div>
               <div class="td">
                  <input type="text" name="rcs_footer"
                         class="txt_input rejection_num width"
                         oninput="rcsCreate.rejection(this);"
                         placeholder="수신거부 번호를 입력해주세요."/>
               </div>
            </div>
         </div>
      </div>
   </div>
   <div class="viewer_area">
      <div class="rcs_inner text">
         <div class="rcs_head">[WEB발신]광고</div>
          <span id="js-txt-replace">
             <div class="text_type">
                <div class="scroll_txt">
                   <p class="rcs_area" id="textArea0">내용 영역</p>
                </div>
                <div class="rcs_btn_wrap">
                </div>
             </div>
             <div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>
             <div class="text_count">
                <span class="num en_font"><span id="textByte0">0</span>/100</span>
                <p>※ 본문내용 : <span class="en_font">100</span>글자 이내</p>
             </div>
          </span>
      </div>
   </div>
   <!-- end -->
</div>
</div>
</div>
