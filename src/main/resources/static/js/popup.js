/* 팝업 */
function popupClose(close) {
    $(close).parents('.layer_pop').removeClass('active');
}

let popup = {
    popAlert: function (alertTxt) {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title"></div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + alertTxt + '</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_center" onclick="popupClose(this);" value="확인" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }
    , popAlertCallback: function (alertTxt, callback) {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title"></div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + alertTxt + '</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_center" onclick="' + callback + '" value="확인" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }
    , confirmAlertCallback: function (alertTxt, callback) {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title"></div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + alertTxt + '</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="' + callback + '" value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }
    , deleteAlert: function (promptState, deleteTxt) {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">삭제 안내</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + deleteTxt + '</div>';
        if (promptState == 'false') {
            html += '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_center" onclick="popupClose(this);" value="확인" />' +
                '</div>';
        } else {
            html += '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="popup.deleteClick(' + '&#39;&#39;,' + '&#39;true&#39;' + ');" value="확인" />' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>';
        }
        html += '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }
    , searchAlert: function (alertTxt) {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">기준 선택</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">' + alertTxt + '</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_center" onclick="popupClose(this);" value="확인" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }
    , deleteClick: function (type, state) {
        let checkbox = document.getElementsByName("list");
        let checkboxLength = checkbox.length;
        let count = 0;
        let listType;

        if (type != '' && type != "undefined") {
            if (type == 'image') {
                listType = "이미지";
            } else {
                listType = "컨텐츠";
            }
        }

        for (let a = 0; a < checkboxLength; a++) {
            if (checkbox[a].checked) {
                count++;
            }
        }

        if (count == 0) {
            popup.deleteAlert('false', "삭제할 " + listType + " 를 선택해주세요.");
        } else {
            popup.deleteAlert('true', count + "개의 " + listType + " 를 삭제하시겠습니까?");
        }

        if (state == "true") {
            for (let b = 0; b < count; b++) {
                for (let c = 0; c < checkboxLength; c++) {
                    if (checkbox[c] != null && checkbox[c].checked) {
                        var elementRemove = checkbox[c].parentElement.parentElement.parentElement;
                        elementRemove.remove();
                        popupClose($('.btn_size2'));
                    }
                }
            }
        }
        return false;
    }
};