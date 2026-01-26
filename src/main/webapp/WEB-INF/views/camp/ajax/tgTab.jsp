<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<div id="body">
    <div id="${prefix}" class="sheet">
        <!-- 추출조건 -->
        <div class="left">
            <h3>+ 추출 조건</h3>
            <div class="dropzone" id="${prefix}_add">
                <div class="btn_base" id="${prefix}_addSegF"><span lang="en">Segment</span> 추가하기</div>
            </div>
            <input type="button"  class="btn_segment top-border left-border" id="${prefix}_addSeg" value="추가" />
        </div>
        <!-- 제외 조건 -->
        <div class="right">
            <h3>- 제외 조건</h3>
            <div class="dropzone" id="${prefix}_exc">
                <div class="btn_base" id="${prefix}_excSegF"><span lang="en">Segment</span> 추가하기</div>
            </div>
            <input type="button"  class="btn_segment top-border left-border" id="${prefix}_excSeg" value="추가"/>
        </div>
    </div>
</div>
<div id="url">${tableauUrl}</div>
