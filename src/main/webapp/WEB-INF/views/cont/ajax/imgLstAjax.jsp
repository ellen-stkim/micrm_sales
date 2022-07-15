<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<!-- container 영역 시작 -->
<span id="body">
    <c:forEach var="item" items="${list}" varStatus="status">
        <div class="column image_column <c:if test="${item.use_yn eq 'N'}">off</c:if>">
            <!-- 비활성화 cover -->
            <div class="hidden_cover"></div>
            <div class="img_head bg_color cf">
                <!-- 체크박스 -->
                <label class="custom_check1"><input type="checkbox" value="${item.seq}"
                                                    name="list" /><span></span></label>
                <!-- 이미지 타입 -->
                <div class="image_type">${item.cd_nm}</div>
            </div>
            <div class="img_head cf">
                <!-- 이미지명 -->
                 <h3>${item.img_nm}</h3>
                <div class="remove_info">
                    <input type="button" value="${item.use_yn}" class="en_font useState right-border" name="use_yn" onclick="useState('${item.seq}', this);"/>
                        <%-- <span  onclick="updateImg('${item.seq}')">수정</span>--%>
                </div>
            </div>
            <div class="row_body">
                <!-- 예시 이미지 영역 -->
                <div class="image_box">
                    <img src="${filePath}${item.img_url}" alt="" onerror="this.src = '/image/bg_none.png'">
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
                <div class="date">등록일&nbsp;&nbsp;
                    <span>
                            ${cutil:stringDateParse(item.reg_dt)}
                    </span>
                </div>
            </div>
        </div>
    </c:forEach>
</span>
<span id="pageHtml">
    <c:choose>
        <c:when test="${nextCk eq true}">
            <div class="btn_more" onclick="getImgList('${pageNo}');"><img src="/image/bullet_arrw1.png" alt="" />더보기</div>
        </c:when>
        <c:otherwise>
            <c:if test="${empty list}">
                 <div class="none list_ht bottom-border">
                    조회된 결과가 없습니다.
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>

  <input type="hidden" name="nowPageNo" id="nowPageNo" value="${pageNo}"/>
  <input type="hidden" name="nowPage" id="nowPage" value="${page}"/>
</span>