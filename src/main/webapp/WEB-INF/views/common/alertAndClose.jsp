<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script type="text/javascript">
    $(document).ready(function () {

        var message = '${message}';
        let html = '';
        html +=
            '<div class="layer_pop alert active">'+
            '<div class="pop_container popup_size3">'+
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose();"/>'+
            '<div class="pop_title"></div>'+
            '<div class="pop_inner">'+
            '<div class="alert_txt">' + message +'</div>' +
            '<div class="btn_row">'+
            '<input type="button" class="btn_bg btn_size2 btn_center" onclick="goRoot();" value="확인" />'+
            '</div>'+
            '</div>'+
            '</div>'+
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
    });

    function goRoot() {
        var hrefUrl = '${url}';

        location.href = hrefUrl;
    }
</script>