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
<!-- 발신자 메일 주소 선택 팝업 영역 시작 -->
<div class="layer_pop mobilePopup active">
   <div class="pop_container popup_size1">
      <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
      <div class="pop_title">수신거부 문구 선택</div>
      <div class="pop_inner">
         <span class="btn_sm_line right" style="margin-bottom: 10px;" onclick="rejectTextAddPopup()" >추가</span>
         <table class="pop_table" summary="table">
            <colgroup>
               <col width="35" />
               <col style="width:calc(50% - 17.5px);" />
               <col style="width:calc(50% - 17.5px);" />
            </colgroup>
            <thead>
            <tr>
               <th></th>
               <th>문구명</th>
               <th>문구 내용</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
               <c:when test="${not empty list}">
                  <c:forEach var="item" items="${list}" varStatus="status">
                        <tr>
                           <td>
                              <label class="custom_radio">
                                 <input name="callNumber" type="radio" value="${item.seq}"
                                    <c:if test="${status.index == 0}">
                                         checked
                                    </c:if>
                                 ><span>
                              <input type ="hidden" name ="sendNumber" value ="${cutil:numberToPhone(item.list_val)}"/>
                              <input type ="hidden" name ="sendNm" value ="${item.list_nm}"/>
                              </span>
                              </label>
                           </td>
                           <td>${item.list_nm}</td>
                           <td class="en_font">${cutil:numberToPhone(item.list_val)}</td>
                        </tr>
                  </c:forEach>
               </c:when>
               <c:otherwise></c:otherwise>
            </c:choose>
            </tbody>
         </table>
         <div class="btn_row bottom-border">
            <ul class="pager">
               <ui:pagination paginationInfo="${page}" type="image" jsFunction="mobileRejectTextPopup"/>
            </ul>
         </div>
         <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
         <input type ="hidden" id="totCnt" name ="totCnt" value ="${listCnt}"/>
         <input type="hidden" id ="mSendType" name ="mSendType" value=""/>
         <div class="pop_error_txt">※ 수신거부 문구를 선택해주세요.</div>
         <div class="btn_row">
            <input type="button" class="btn_bg btn_size2 btn_center numberSave" onclick="changeMobileRejectText()" value="저장" />
         </div>
      </div>
   </div>
   <!-- 수신거부 문구 추가 팝업 영역 시작 -->
   <div class="layer_pop rejectTextAddPopup">
      <div class="pop_container popup_size1">
         <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
         <div class="pop_title">수신거부 문구 추가</div>
         <div class="pop_inner">
            <form action="" id="postForm1">
               <table class="pop_table_type1" summary="수신거부 문구 추가">
                  <colgroup>
                     <col width="103" />
                     <col width="*" />
                  </colgroup>
                  <tbody>
                  <tr>
                     <th>문구명</th>
                     <td><input type="text" name="list_nm" id="list_nm" placeholder="문구명을 입력해주세요." class="input_type1" /></td>
                  </tr>
                  <tr>
                     <th>수신거부 문구</th>
                     <td><textarea name="list_val" id ="list_val" cols="30" rows="10" placeholder="수신거부 문구를 입력해주세요." style="width: 100%;height: 80px; padding: 0 15px; resize: none;"></textarea>
                     </td>
                  </tr>
                  </tbody>
               </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
               <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkRejectText();" value="저장" />
            </div>
         </div>
      </div>
   </div>
   <!-- 수신거부 문구 추가 팝업 영역 끝 -->
   <script>
      // 문자 저장 팝업 띄우기
      function rejectTextAddPopup() {
         $('.rejectTextAddPopup').addClass('active');
      }

      // 중복 체크하기
      function checkRejectText() {

         let textName = $("#list_nm").val().trim();
         let rejectText = $("#list_val").val().trim();

         if(textName == '') {
            $("#errorArea1").html("문구명을 입력해 주세요.")
            return false;
         }
         if(rejectText == '') {
            $("#errorArea1").html('수신거부 문구를 입력해 주세요.')
            return false;
         }

         const res = function(response) {
            if(response.status == true){
               saveText();
            }  else {
               $("#errorArea1").html('중복된 문구 입니다.')
               return false;
            }
         }

         let data = []
         data.push({name : "list_val" , value : rejectText})
         com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/sys/setting/isExistSmsAddress.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
      }

      // 수신거부 문구 저장하기
      function saveText() {

         const res = function(response){
            mobileRejectTextPopup(1);
         }

         let data = []
         data.push({name : "list_nm" , value : $("#list_nm").val().trim()})
         data.push({name : "list_val" , value : $("#list_val").val().trim()})

         com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/sys/setting/insertRejectText.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
      }
   </script>
</div>