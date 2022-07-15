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
<div id="slideArea">
   <div class="flex_box" id="js-rcs-area">
      <div class="left_area">
         <!-- start -->
         <div class="row body">
            <div class="th">카드 양식</div>
            <div class="column_1">
               <div class="select slide_type">
                  <div class="value" data="0">Small / 3장</div>
                  <ul class="option">
                     <li data="0">Small / 3장</li>
                     <li data="1">Small / 4장</li>
                     <li data="2">Small / 5장</li>
                     <li data="3">Small / 6장</li>
                     <li data="4">Medium / 3장</li>
                     <li data="5">Medium / 4장</li>
                     <li data="6">Medium / 5장</li>
                     <li data="7">Medium / 6장</li>
                  </ul>
               </div>
            </div>
         </div>
         <div class="row body">
            <div class="th">발신 번호</div>
            <div class="column_1">
               <input type="text" class="sms_number smsNumber" id="send_slice_rcs" placeholder="발신 번호를 입력해주세요."
                       <c:if test = "${fn:trim(rcsSender[0].list_nm)!= ''}">
                          value="${rcsSender[0].list_nm}(${cutil:numberToPhone(rcsSender[0].list_val)})"
                       </c:if>
                       <c:if test = "${fn:trim(rcsSender[0].list_nm) == ''}">
                          placeholder="발신 번호를 입력해주세요."
                       </c:if>
                      readonly />
               <input type="hidden" name="send_to_list" id="slide_send_num" value="${rcsSender[0].seq}"/>
               <span class="btn_sm_line" onclick="mobileSenderPopup('1','slidercs')">변경</span>
            </div>
         </div>
         <div class="input_area left">
            <div class="block line_none">
               <div class="slide_tab cf">
                  <div class="cardOn on" data="1">카드1</div>
                  <div class="cardOn" data="2">카드2</div>
                  <div class="cardOn" data="3">카드3</div>
               </div>
            </div>
               <div class="rcs_slide_conts on">
                  <div class="block">
                     <div class="row">
                        <div class="th">이미지 선택</div>
                        <div class="td">
                           <div class="delete_img"><img src="/image/btn_delete1.png" alt="삭제"></div><input type="text" name=""
                                                                                                                class="txt_input en_font rcsImage" id="slide0" placeholder="이미지를 선택해 주세요." readonly=""><input
                                type="hidden" name="rcs_img_cd_1" class="txt_input en_font rcsImage"><span class="btn_sm_line"
                                                                                                           data="slide0" onclick="imageListPopUp('1','slideRcsImage')">선택</span>
                        </div>
                     </div>
                  </div>
                  <div class="block">
                     <div class="row">
                        <div class="th">개인화 변수</div>
                        <div class="td">
                           <div class="select rcsTitleVal" name="edmDB">
                              <div class="value" data="0">개인화 변수</div>
                              <ul class="option">
                                 <c:forEach var="item" items="${columnNm}"
                                            varStatus="status">smsNumber
                                    <li data="{{${columnValue[status.count]}}}">${item}</li>
                                 </c:forEach>
                              </ul>
                           </div>
                           <div class="select rcsTitleVal" name="defaultDB">
                              <div class="value" data="0">개인화 변수</div>
                              <ul class="option" id="">
                                 <li data="{{USR_ID}}">회원번호</li>
                                 <li data="{{USR_NM}}">이름</li>
                                 <li data="{{USR_MOB}}">모바일</li>
                                 <li data="{{USR_EDM}}">이메일</li>
                                 <li data="{{USR_GDR}}">성별</li>
                                 <li data="{{USR_ADDR}}">주소</li>
                                 <li data="{{USR_ETC1}}">ETC1</li>
                                 <li data="{{USR_ETC2}}">ETC2</li>
                                 <li data="{{USR_ETC3}}">ETC3</li>
                                 <li data="{{USR_ETC4}}">ETC4</li>
                                 <li data="{{USR_ETC5}}">ETC5</li>
                                 <li data="{{USR_ETC6}}">ETC6</li>
                                 <li data="{{USR_ETC7}}">ETC7</li>
                                 <li data="{{USR_ETC8}}">ETC8</li>
                                 <li data="{{USR_ETC9}}">ETC9</li>
                                 <li data="{{USR_ETC10}}">ETC10</li>
                              </ul>
                           </div>
                        </div>
                     </div>
                     <div class="row">
                        <div class="th top-border">문자 제목</div>
                        <div class="td top-border"><input type="text" name="slide_cont_sub" class="txt_input width rcsTitle"
                                                          placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this,0);"></div>
                     </div>
                  </div>
                  <div class="block">
                     <div class="row">
                        <div class="th">개인화 변수</div>
                        <div class="td">
                           <div class="select column_4 rcsContsVal" name="edmDB">
                              <div class="value" data="0">개인화 변수</div>
                              <ul class="option">
                                 <c:forEach var="item" items="${columnNm}"
                                            varStatus="status">
                                    <li data="{{${columnValue[status.count]}}}">${item}</li>
                                 </c:forEach>
                              </ul>
                           </div>
                           <div class="select column_4 rcsContsVal" name="defaultDB">
                              <div class="value" data="0">개인화 변수</div>
                              <ul class="option" id="">
                                 <li data="{{USR_ID}}">회원번호</li>
                                 <li data="{{USR_NM}}">이름</li>
                                 <li data="{{USR_MOB}}">모바일</li>
                                 <li data="{{USR_EDM}}">이메일</li>
                                 <li data="{{USR_GDR}}">성별</li>
                                 <li data="{{USR_ADDR}}">주소</li>
                                 <li data="{{USR_ETC1}}">ETC1</li>
                                 <li data="{{USR_ETC2}}">ETC2</li>
                                 <li data="{{USR_ETC3}}">ETC3</li>
                                 <li data="{{USR_ETC4}}">ETC4</li>
                                 <li data="{{USR_ETC5}}">ETC5</li>
                                 <li data="{{USR_ETC6}}">ETC6</li>
                                 <li data="{{USR_ETC7}}">ETC7</li>
                                 <li data="{{USR_ETC8}}">ETC8</li>
                                 <li data="{{USR_ETC9}}">ETC9</li>
                                 <li data="{{USR_ETC10}}">ETC10</li>
                              </ul>
                           </div>
                        </div>
                     </div>
                     <div class="row rcs_textarea">
                        <div class="th top-border">내용</div>
                        <div class="td top-border"><textarea class="rcsContents" name="slide_cont_body" id="" cols="30" rows="10"
                                                             placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this,0);"></textarea></div>
                     </div>
                  </div>
                  <div class="block">
                     <div class="row">
                        <div class="th bottom-border">버튼 액션 선택</div>
                        <div class="td bottom-border">
                           <div class="select action_select" data="1"><span id="btnHidden1"></span>
                              <div class="value" data="0">액션선택</div>
                              <ul class="option">
                                 <li data="0">액션선택</li>
                                 <li data="RBTN01">복사하기</li>
                                 <li data="RBTN02">URL연결</li>
                                 <li data="RBTN03">전화걸기</li>
                                 <li data="RBTN04">지보보여주기(좌표)</li>
                                 <li data="RBTN05">지도보여주기(쿼리)</li>
                                 <li data="RBTN06">현재위치공유</li>
                                 <li data="RBTN07">캘린더등록</li>
                                 <li data="RBTN08">메시지전송</li>
                              </ul>
                           </div>
                        </div>
                     </div>
                     <div class="row">
                        <div class="th">버튼 명</div>
                        <div class="td button-name"><input type="text" name="slide_rcs_btn_1" class="txt_input action_name" data="1"
                                                           placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideSmall');"><span
                                class="text-count en_font"><span>0</span>/5</span></div>
                     </div>
                     <div class="custom_box"> </div>
                  </div>
                  <div class="block">
                     <div class="row">
                        <div class="th bottom-border">버튼 액션 선택</div>
                        <div class="td bottom-border">
                           <div class="select action_select" data="2"><span id="btnHidden2"></span>
                              <div class="value" data="0">액션선택</div>
                              <ul class="option">
                                 <li data="0">액션선택</li>
                                 <li data="RBTN01">복사하기</li>
                                 <li data="RBTN02">URL연결</li>
                                 <li data="RBTN03">전화걸기</li>
                                 <li data="RBTN04">지보보여주기(좌표)</li>
                                 <li data="RBTN05">지도보여주기(쿼리)</li>
                                 <li data="RBTN06">현재위치공유</li>
                                 <li data="RBTN07">캘린더등록</li>
                                 <li data="RBTN08">메시지전송</li>
                              </ul>
                           </div>
                        </div>
                     </div>
                     <div class="row">
                        <div class="th">버튼 명</div>
                        <div class="td button-name"><input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2"
                                                           placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideSmall');"><span
                                class="text-count en_font"><span>0</span>/5</span></div>
                     </div>
                     <div class="custom_box"></div>
                  </div>
                   <input type="hidden" name="slide_rcs_btn_tp_1" value="" id="slide_rcs_btn_tp_1">
                   <input type="hidden" name="slide_rcs_btn_tp_2" value="" id="slide_rcs_btn_tp_2">
               </div>
            <div class="rcs_slide_conts">
               <div class="block">
                  <div class="row">
                     <div class="th">이미지 선택</div>
                     <div class="td">
                        <div class="delete_img"><img src="/image/btn_delete1.png" alt="삭제"></div><input type="text" name=""
                                                                                                             class="txt_input en_font rcsImage" id="slide1" placeholder="이미지를 선택해 주세요." readonly=""><input
                             type="hidden" name="rcs_img_cd_2" class="txt_input en_font rcsImage"><span class="btn_sm_line"
                                                                                                        data="slide2" onclick="imageListPopUp('1','slideRcsImage')">선택</span>
                     </div>
                  </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th">개인화 변수</div>
                     <div class="td">
                        <div class="select rcsTitleVal" name="edmDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option">
                              <c:forEach var="item" items="${columnNm}"
                                         varStatus="status">
                                 <li data="{{${columnValue[status.count]}}}">${item}</li>
                              </c:forEach>
                           </ul>
                        </div>
                        <div class="select rcsTitleVal" name="defaultDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option" id="">
                              <li data="{{USR_ID}}">회원번호</li>
                              <li data="{{USR_NM}}">이름</li>
                              <li data="{{USR_MOB}}">모바일</li>
                              <li data="{{USR_EDM}}">이메일</li>
                              <li data="{{USR_GDR}}">성별</li>
                              <li data="{{USR_ADDR}}">주소</li>
                              <li data="{{USR_ETC1}}">ETC1</li>
                              <li data="{{USR_ETC2}}">ETC2</li>
                              <li data="{{USR_ETC3}}">ETC3</li>
                              <li data="{{USR_ETC4}}">ETC4</li>
                              <li data="{{USR_ETC5}}">ETC5</li>
                              <li data="{{USR_ETC6}}">ETC6</li>
                              <li data="{{USR_ETC7}}">ETC7</li>
                              <li data="{{USR_ETC8}}">ETC8</li>
                              <li data="{{USR_ETC9}}">ETC9</li>
                              <li data="{{USR_ETC10}}">ETC10</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="th top-border">문자 제목</div>
                     <div class="td top-border"><input type="text" name="slide_cont_sub" class="txt_input width rcsTitle"
                                                       placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this,1);"></div>
                  </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th">개인화 변수</div>
                     <div class="td">
                        <div class="select column_4 rcsContsVal" name="edmDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option">
                              <c:forEach var="item" items="${columnNm}"
                                         varStatus="status">
                                 <li data="{{${columnValue[status.count]}}}">${item}</li>
                              </c:forEach>
                           </ul>
                        </div>
                        <div class="select column_4 rcsContsVal" name="defaultDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option" id="">
                              <li data="{{USR_ID}}">회원번호</li>
                              <li data="{{USR_NM}}">이름</li>
                              <li data="{{USR_MOB}}">모바일</li>
                              <li data="{{USR_EDM}}">이메일</li>
                              <li data="{{USR_GDR}}">성별</li>
                              <li data="{{USR_ADDR}}">주소</li>
                              <li data="{{USR_ETC1}}">ETC1</li>
                              <li data="{{USR_ETC2}}">ETC2</li>
                              <li data="{{USR_ETC3}}">ETC3</li>
                              <li data="{{USR_ETC4}}">ETC4</li>
                              <li data="{{USR_ETC5}}">ETC5</li>
                              <li data="{{USR_ETC6}}">ETC6</li>
                              <li data="{{USR_ETC7}}">ETC7</li>
                              <li data="{{USR_ETC8}}">ETC8</li>
                              <li data="{{USR_ETC9}}">ETC9</li>
                              <li data="{{USR_ETC10}}">ETC10</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row rcs_textarea">
                     <div class="th top-border">내용</div>
                     <div class="td top-border"><textarea class="rcsContents" name="slide_cont_body" id="" cols="30" rows="10"
                                                          placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this,1);"></textarea></div>
                  </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th bottom-border">버튼 액션 선택</div>
                     <div class="td bottom-border">
                        <div class="select action_select" data="1"><span id="btnHidden3"></span>
                           <div class="value" data="0">액션선택</div>
                           <ul class="option">
                              <li data="0">액션선택</li>
                              <li data="RBTN01">복사하기</li>
                              <li data="RBTN02">URL연결</li>
                              <li data="RBTN03">전화걸기</li>
                              <li data="RBTN04">지보보여주기(좌표)</li>
                              <li data="RBTN05">지도보여주기(쿼리)</li>
                              <li data="RBTN06">현재위치공유</li>
                              <li data="RBTN07">캘린더등록</li>
                              <li data="RBTN08">메시지전송</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="th">버튼 명</div>
                     <div class="td button-name"><input type="text" name="slide_rcs_btn_1" class="txt_input action_name" data="1"
                                                        placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideSmall');"><span
                             class="text-count en_font"><span>0</span>/5</span></div>
                  </div>
                  <div class="custom_box"> </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th bottom-border">버튼 액션 선택</div>
                     <div class="td bottom-border">
                        <div class="select action_select" data="2"><span id="btnHidden4"></span>
                           <div class="value" data="0">액션선택</div>
                           <ul class="option">
                              <li data="0">액션선택</li>
                              <li data="RBTN01">복사하기</li>
                              <li data="RBTN02">URL연결</li>
                              <li data="RBTN03">전화걸기</li>
                              <li data="RBTN04">지보보여주기(좌표)</li>
                              <li data="RBTN05">지도보여주기(쿼리)</li>
                              <li data="RBTN06">현재위치공유</li>
                              <li data="RBTN07">캘린더등록</li>
                              <li data="RBTN08">메시지전송</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="th">버튼 명</div>
                     <div class="td button-name"><input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2"
                                                        placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideSmall');"><span
                             class="text-count en_font"><span>0</span>/5</span></div>
                  </div>
                  <div class="custom_box"></div>
               </div><input type="hidden" name="slide_rcs_btn_tp_1" value="" id="slide_rcs_btn_tp_3"><input type="hidden"
                                                                                                            name="slide_rcs_btn_tp_2" value="" id="slide_rcs_btn_tp_4">
            </div>
            <div class="rcs_slide_conts">
               <div class="block">
                  <div class="row">
                     <div class="th">이미지 선택</div>
                     <div class="td">
                        <div class="delete_img"><img src="/image/btn_delete1.png" alt="삭제"></div><input type="text" name=""
                                                                                                             class="txt_input en_font rcsImage" id="slide2" placeholder="이미지를 선택해 주세요." readonly=""><input
                             type="hidden" name="rcs_img_cd_3" class="txt_input en_font rcsImage"><span class="btn_sm_line"
                                                                                                        data="slide2" onclick="imageListPopUp('1','slideRcsImage')">선택</span>
                     </div>
                  </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th">개인화 변수</div>
                     <div class="td">
                        <div class="select rcsTitleVal" name="edmDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option">
                              <c:forEach var="item" items="${columnNm}"
                                         varStatus="status">
                                 <li data="{{${columnValue[status.count]}}}">${item}</li>
                              </c:forEach>
                           </ul>
                        </div>
                        <div class="select rcsTitleVal" name="defaultDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option" id="">
                              <li data="{{USR_ID}}">회원번호</li>
                              <li data="{{USR_NM}}">이름</li>
                              <li data="{{USR_MOB}}">모바일</li>
                              <li data="{{USR_EDM}}">이메일</li>
                              <li data="{{USR_GDR}}">성별</li>
                              <li data="{{USR_ADDR}}">주소</li>
                              <li data="{{USR_ETC1}}">ETC1</li>
                              <li data="{{USR_ETC2}}">ETC2</li>
                              <li data="{{USR_ETC3}}">ETC3</li>
                              <li data="{{USR_ETC4}}">ETC4</li>
                              <li data="{{USR_ETC5}}">ETC5</li>
                              <li data="{{USR_ETC6}}">ETC6</li>
                              <li data="{{USR_ETC7}}">ETC7</li>
                              <li data="{{USR_ETC8}}">ETC8</li>
                              <li data="{{USR_ETC9}}">ETC9</li>
                              <li data="{{USR_ETC10}}">ETC10</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="th top-border">문자 제목</div>
                     <div class="td top-border"><input type="text" name="slide_cont_sub" class="txt_input width rcsTitle"
                                                       placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this,2);"></div>
                  </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th">개인화 변수</div>
                     <div class="td">
                        <div class="select column_4 rcsContsVal" name="edmDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option">
                              <c:forEach var="item" items="${columnNm}"
                                         varStatus="status">
                                 <li data="{{${columnValue[status.count]}}}">${item}</li>
                              </c:forEach>
                           </ul>
                        </div>
                        <div class="select column_4 rcsContsVal" name="defaultDB">
                           <div class="value" data="0">개인화 변수</div>
                           <ul class="option" id="">
                              <li data="{{USR_ID}}">회원번호</li>
                              <li data="{{USR_NM}}">이름</li>
                              <li data="{{USR_MOB}}">모바일</li>
                              <li data="{{USR_EDM}}">이메일</li>
                              <li data="{{USR_GDR}}">성별</li>
                              <li data="{{USR_ADDR}}">주소</li>
                              <li data="{{USR_ETC1}}">ETC1</li>
                              <li data="{{USR_ETC2}}">ETC2</li>
                              <li data="{{USR_ETC3}}">ETC3</li>
                              <li data="{{USR_ETC4}}">ETC4</li>
                              <li data="{{USR_ETC5}}">ETC5</li>
                              <li data="{{USR_ETC6}}">ETC6</li>
                              <li data="{{USR_ETC7}}">ETC7</li>
                              <li data="{{USR_ETC8}}">ETC8</li>
                              <li data="{{USR_ETC9}}">ETC9</li>
                              <li data="{{USR_ETC10}}">ETC10</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row rcs_textarea">
                     <div class="th top-border">내용</div>
                     <div class="td top-border"><textarea class="rcsContents" name="slide_cont_body" id="" cols="30" rows="10"
                                                          placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this,2);"></textarea></div>
                  </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th bottom-border">버튼 액션 선택</div>
                     <div class="td bottom-border">
                        <div class="select action_select" data="1"><span id="btnHidden5"></span>
                           <div class="value" data="0">액션선택</div>
                           <ul class="option">
                              <li data="0">액션선택</li>
                              <li data="RBTN01">복사하기</li>
                              <li data="RBTN02">URL연결</li>
                              <li data="RBTN03">전화걸기</li>
                              <li data="RBTN04">지보보여주기(좌표)</li>
                              <li data="RBTN05">지도보여주기(쿼리)</li>
                              <li data="RBTN06">현재위치공유</li>
                              <li data="RBTN07">캘린더등록</li>
                              <li data="RBTN08">메시지전송</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="th">버튼 명</div>
                     <div class="td button-name"><input type="text" name="slide_rcs_btn_1" class="txt_input action_name" data="1"
                                                        placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideSmall');"><span
                             class="text-count en_font"><span>0</span>/5</span></div>
                  </div>
                  <div class="custom_box"> </div>
               </div>
               <div class="block">
                  <div class="row">
                     <div class="th bottom-border">버튼 액션 선택</div>
                     <div class="td bottom-border">
                        <div class="select action_select" data="2"><span id="btnHidden6"></span>
                           <div class="value" data="0">액션선택</div>
                           <ul class="option">
                              <li data="0">액션선택</li>
                              <li data="RBTN01">복사하기</li>
                              <li data="RBTN02">URL연결</li>
                              <li data="RBTN03">전화걸기</li>
                              <li data="RBTN04">지보보여주기(좌표)</li>
                              <li data="RBTN05">지도보여주기(쿼리)</li>
                              <li data="RBTN06">현재위치공유</li>
                              <li data="RBTN07">캘린더등록</li>
                              <li data="RBTN08">메시지전송</li>
                           </ul>
                        </div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="th">버튼 명</div>
                     <div class="td button-name"><input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2"
                                                        placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideSmall');"><span
                             class="text-count en_font"><span>0</span>/5</span></div>
                  </div>
                  <div class="custom_box"></div>
               </div><input type="hidden" name="slide_rcs_btn_tp_1" value="" id="slide_rcs_btn_tp_5"><input type="hidden"
                                                                                                            name="slide_rcs_btn_tp_2" value="" id="slide_rcs_btn_tp_6">
            </div>
            <div class="block" id="rejection">
               <div class="row">
                  <div class="th">무료수신거부</div>
                  <div class="td"><input type="text" name="rcs_footer" class="txt_input rejection_num width"
                                         placeholder="수신거부 번호를 입력해주세요." oninput="rcsCreate.rejection(this);"></div>
               </div>
            </div>

         </div>
      </div>
      <div class="viewer_area" id="">
         <div class="rcs_inner rcs_slide">
            <div class="slide_area">
               <div class="rcs_prev"><img src="/image/ico_rcs_prev.png" alt=""/></div>
               <div class="rcs_next"><img src="/image/ico_rcs_next.png" alt=""/></div>
               <div class="swiper-container slideSwiper small">
                  <div class="swiper-wrapper">
                     <div class="swiper-slide slide0">
                        <div class="rcs_head">[WEB발신]광고</div>
                        <section>
                           <div class="img_area"></div>
                           <input type="hidden" name="rcs_img_url_1" value=""/>
                           <div class="txt_area">
                              <h3 id="titleArea0">제목 영역</h3>
                              <p id="textArea0">내용 영역</p>
                              <div class="rcs_btn_wrap"></div>
                           </div>
                        </section>
                        <div class="text_count">
                           <span class="num en_font"><span id="textByte0">0</span>/30</span>
                        </div>
                     </div>
                     <div class="swiper-slide slide1">
                        <div class="rcs_head">[WEB발신]광고</div>
                        <section>
                           <div class="img_area"></div>
                           <input type="hidden" name="rcs_img_url_2" value=""/>
                           <div class="txt_area">
                              <h3 id="titleArea1">제목 영역</h3>
                              <p id="textArea1">내용 영역</p>
                              <div class="rcs_btn_wrap"></div>
                           </div>
                        </section>
                        <div class="text_count">
                           <span class="num en_font"><span id="textByte1">0</span>/30</span>
                        </div>
                     </div>
                     <div class="swiper-slide slide2">
                        <div class="rcs_head">[WEB발신]광고</div>
                        <section>
                           <div class="img_area"></div>
                           <input type="hidden" name="rcs_img_url_3" value=""/>
                           <div class="txt_area">
                              <h3 id="titleArea2">제목 영역</h3>
                              <p id="textArea2">내용 영역</p>
                              <div class="rcs_btn_wrap"></div>
                           </div>
                        </section>
                        <div class="text_count">
                           <span class="num en_font"><span id="textByte2">0</span>/30</span>
                        </div>
                     </div>
                  </div>
                  <div class="rcs_paging en_font">1/3</div>
                  <div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>
                  <div class="text_count">
                     <p>
                        ※ 본문내용 : 카드 당 <span class="en_font">30</span>글자 이내<br/>
                        본문길이 : 최대 4줄<br/>
                        모든 카드내용의 총합 : 1300글자
                     </p>
                  </div>
               </div>
            </div>
         </div>
      </div>
      <input type="hidden" name="cont_sub_list" value="">
      <input type="hidden" name="rcs_msg_tp" value="small">
      <!-- end -->
   </div>
   </div>
</div>
