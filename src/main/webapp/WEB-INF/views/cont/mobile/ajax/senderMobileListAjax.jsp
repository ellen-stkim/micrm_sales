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
      <div class="pop_title">발신자 번호 선택</div>
      <div class="pop_inner">
         <table class="pop_table">
            <colgroup>
               <col width="35" />
               <col style="width:calc(50% - 17.5px);" />
               <col style="width:calc(50% - 17.5px);" />
            </colgroup>
            <thead>
            <tr>
               <th></th>
               <th>발신자명</th>
               <th>번호</th>
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
               <ui:pagination paginationInfo="${page}" type="image" jsFunction="mobileSenderPopup"/>
            </ul>
         </div>
         <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
         <input type ="hidden" id="totCnt" name ="totCnt" value ="${listCnt}"/>
         <input type="hidden" id ="mSendType" name ="mSendType" value=""/>
         <div class="pop_error_txt">※ 문자 발신 번호를 선택해주세요.</div>
         <div class="btn_row">
            <input type="button" class="btn_bg btn_size2 btn_center numberSave" onclick="mobileSendSave()" value="저장" />
         </div>
      </div>
   </div>
</div>