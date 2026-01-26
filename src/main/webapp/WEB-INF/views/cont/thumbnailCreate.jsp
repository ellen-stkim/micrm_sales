<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<script src="/js/html2canvas.js"></script>
<script src="/js/edmCreate.js"></script>
<style type="text/css">
    section#thumb {
        position: relative;
        width: 100%;
        padding: 140px 70px 70px 300px;
        z-index: 0;
    }

    div.common-layer *,
    div.common-layer {
        box-sizing: border-box;
    }

    input.mainButton {
        position: relative;
        display: inline-block;
        padding: 20px 70px;
        border: none;
        background-color: #af9c6e;
        color: #fff;
        font-family: "NanumBarunGothic", sans-serif;
        font-weight: 400;
        font-size: 18px;
    }
</style>
<!-- container 영역 시작 -->
<!-- 컨텐츠 영역 시작 -->
<section id="thumb">
    <div id="temp">${temp}</div>
    <div id="previewImage"></div>
</section>

<!-- 컨텐츠 영역 끝 -->
<!-- container 영역 끝 -->
</div>


<script>
    var wid;
    var temp = 0;
    window.onload = function (){
        $('#commonLoading').addClass('active');
        popup.popAlert('썸네일 생성중입니다...');
        var brYn = '${br_yn}';
        var supYn = '${sup_yn}';
        var topBody = '${cont_top_body}';
        var brData = '';
        var supData = '';
        var topBodyData = '';
        var tempData = $('#temp').html();
        if (brYn == 'Y') {
            brData = '<div class="link" id="browserLink" style="display:block; width:100%; padding:20px 0; text-align:center;"><span style="display:inline-block; border-bottom:2px solid #666666; font-size:12px; color:#666666;">이 메일이 제대로 보이지 않을 경우 이 곳을 클릭하면 브라우저에서 볼 수 있습니다.</span></div>';
        }
        if (supYn == 'Y') {
            supData = '<div class="rejection_layout" id="rejectionLink" style="text-align:center; line-height:1.3;">' +
                '<p style="font-size:12px; color:#cccccc;">메일 수신을 원치 않으시면 <span style="color:#666666;">[수신거부]</a>를 클릭하시오.</span>' +
                '<p style="font-size:12px; color:#cccccc;">If you don&#39;t want this type of information or e-mail, please click the<span style="color:#666666;">[unsubscription]</span></p>' +
                '</div>';
        }
        if (topBody != null && topBody != "") {
            topBodyData = '<div class="subTitle" style="text-align:center; font-size:12px;">' + topBody + '</div>';
        }
        var data = topBodyData + brData + tempData + supData;
        $('#temp').html(data);
        var filename = '${filename}';
        setTimeout(function(){
            screenShot();
        },1000);

    };


    function screenShot() {
        if ($("#temp").children().find('table').outerWidth() != null) {
            $("#temp").children().find('table').each(function () {
                if ($(this).outerWidth() > temp) {
                    temp = $(this).outerWidth();
                }
            });
        }

        if ($("#temp").children().find('img').outerWidth() != null) {
            $("#temp").children().find('img').each(function () {
                if ($(this).outerWidth() > temp) {
                    temp = $(this).outerWidth();
                }
            });
        }
        if (temp === 0) {
            temp = $("#temp").width();
        }
        $("#temp").css("width", temp);
        var element = $("#temp");
        var getCanvas;

        html2canvas(document.querySelector('#temp'), {
            onrendered: function (canvas) {
                $("#previewImage").append(canvas);
                getCanvas = canvas;
                var dataUrl = canvas.toDataURL("image/png");
                var blob = dataURItoBlob(dataUrl);
                var form = new FormData();
                form.append("filename", "${filename}");
                form.append("file", blob, "temp.png");
                form.append("templist", "${list}");

                $.ajax({
                    type: "POST",
                    url: "${baseURL}/cont/thumbnailSave.ajax",
                    data: form,
                    contentType: false,
                    processData: false,
                    beforeSend: function (e) {
                        $('#commonLoading').addClass('active');
                        e.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
                    },
                    success: function (msg) {
                        $('#commonLoading').removeClass('active');
                        popup.popAlert("썸네일 생성 완료");
                        window.location.href = '${baseURL}/cont/edmLst.mi';
                    },
                    error: function (e) {
                        $('#commonLoading').removeClass('active');
                        popup.popAlert("썸네일 생성에 실패했습니다.");
                        window.location.href = '${baseURL}/cont/edmLst.mi';
                    }
                });
            }, width: temp
        });

    }

    function dataURItoBlob(dataURI) {
        // convert base64 to raw binary data held in a string
        var byteString = atob(dataURI.split(',')[1]);

        // separate out the mime component
        var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];

        // write the bytes of the string to an ArrayBuffer
        var arrayBuffer = new ArrayBuffer(byteString.length);
        var _ia = new Uint8Array(arrayBuffer);
        for (var i = 0; i < byteString.length; i++) {
            _ia[i] = byteString.charCodeAt(i);
        }

        var dataView = new DataView(arrayBuffer);
        var blob = new Blob([dataView.buffer], {type: mimeString});
        return blob;
    }

</script>