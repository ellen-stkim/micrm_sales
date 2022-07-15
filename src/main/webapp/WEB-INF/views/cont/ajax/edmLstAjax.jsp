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
<!-- container 영역 시작 -->
<span id="body">
<c:forEach var="item" items="${list}" varStatus="status">
    <!-- column 1단위 영역 시작 -->
    <div class="column <c:if test="${item.use_yn eq 'N'}">off</c:if>">
        <!-- 비활성화 cover -->
        <div class="hidden_cover"></div>
        <div class="row_head cf">
            <!-- 체크박스 -->
            <label class="custom_check1"><input type="checkbox" value="${item.seq}"
                                                name="list"/><span></span></label>
            <!-- 템플릿명 -->
            <h3>${item.cont_nm}</h3>
            <div class="remove_info">
                <input type="button"  value="${item.use_yn}" class="en_font useState" onclick="useState('${item.seq}', this);"/>
                <a href="#" onclick="detailEdm('${item.seq}');">수정</a>
            </div>
        </div>
        <div class="row_top cf">
            <!-- 컨텐츠 type -->
            <div class="contents_type">
                <c:if test="${item.send_tp eq 'SENDTP01'}">광고</c:if>
                <c:if test="${item.send_tp eq 'SENDTP02'}">안내</c:if>
            </div>
            <!-- 제목 -->
            <h4>${item.cont_sub}</h4>
        </div>
        <div class="row_body">
            <!-- edm 이미지 영역 -->
            <div class="edm">
                     <img src='${filePath}${item.thm_url}' alt=""  onerror="this.src = '/image/bg_none_wide.png'">
            </div>
        </div>
        <div class="row_footer">
            <!-- 수정일 -->
            <div class="date">수정일&nbsp;&nbsp;
                <span>
                 <c:choose>
                     <c:when test="${cutil:isEmptyObject(item.upd_dt)}"> ${cutil:stringDateParse(item.reg_dt)}</c:when>
                     <c:otherwise>${cutil:stringDateParse(item.upd_dt)}</c:otherwise>
                 </c:choose>
                </span>
            </div>
            <!-- 등록일 -->
            <div class="date">등록일
                <span>
                    ${cutil:stringDateParse(item.reg_dt)}
                </span>
            </div>
        </div>
    </div>
</c:forEach>
</span>
    <!-- list_container 영역 끝 -->
<span id="pageHtml">
    <c:choose>
         <c:when test="${nextCk eq true}">
             <div class="btn_more" onclick="getEdmList('${pageNo}');">
             <img src="/image/bullet_arrw1.png" alt=""/>더보기
             </div>
         </c:when>
        <c:otherwise>
            <c:if test="${empty list}">
                 <div class="none list_ht bottom-border">
                    조회된 결과가 없습니다.
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</span>
