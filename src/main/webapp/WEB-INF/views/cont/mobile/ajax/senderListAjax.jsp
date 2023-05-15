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
<!-- container 영역 시작 -->
<!-- 발신자 메일 주소 선택 팝업 영역 시작 -->
<div class="layer_pop emailPopup active">
   <div class="pop_container popup_size4">
      <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
      <div class="pop_title">발신자 메일 주소</div>
      <div class="pop_inner">
         <table class="pop_table" summary="table">
            <colgroup>
               <col width="35" />
               <col style="width:calc(50% - 17.5px);" />
               <col style="width:calc(50% - 17.5px);" />
            </colgroup>
            <thead>
            <tr>
               <th></th>
               <th>발신자명</th>
               <th>설명</th>
               <th>주소</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
               <c:when test="${not empty list}">
                  <c:forEach var="item" items="${list}" varStatus="status">
                     <tr>
                        <td>
                           <label class="custom_radio">
                              <input type="hidden" name="send_to" value="${item.seq}"/>
                              <input name="emailAddress" type="radio" value="${item.list_nm}(${item.list_val})" <c:if test="${item.def_yn eq 'Y'}">checked</c:if>>
                             <span> </span>
                           </label>
                        </td>
                        <td>${item.list_nm}</td>
                        <td>${item.list_etc}</td>
                        <td class="en_font">${item.list_val}</td>
                     </tr>
                  </c:forEach>
               </c:when>
               <c:otherwise></c:otherwise>
            </c:choose>
            </tbody>
         </table>
         <div class="btn_row bottom-border">
            <ul class="pager">
               <ui:pagination paginationInfo="${page}" type="image" jsFunction="emailPopup"/>
            </ul>
         </div>
         <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
         <input type ="hidden" id="totCnt" name ="totCnt" value ="${listCnt}"/>
         <div class="pop_error_txt">※ 이메일 발신자 주소를 선택해주세요.</div>
         <div class="btn_row">
            <input type="button" class="btn_bg btn_size2 btn_center addressSave" onclick="addressSave();" value="저장" />
         </div>
      </div>
   </div>
</div>
