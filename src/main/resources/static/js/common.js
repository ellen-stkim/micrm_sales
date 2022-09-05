window.onbeforeunload = function () {
    if (typeof onBeforeUnloadPage != 'undefined') {
        var chk = onBeforeUnloadPage();
        if (chk) {
            return '그냥 이동';
        } else {
            return _loading();
        }
    } else {
        return _loading();
    }
};

function _loading() {
    $('#commonLoading').addClass('active');
}

window.onload = function () {
    //tooltip 위치
    let tip =  $('.tooltip_icon').length;
    if(tip > 0){
        let leftLocation = $('.tooltip_icon').offset().left;
        let leftMinus = leftLocation - 200;
        let tooltipWd = ($('.tooltip_box').width() / 2) + 12;
        let tipArea = leftMinus - tooltipWd;
        $('.tooltip_box').css('left', tipArea);
    }
};

$(function () {
    // select
    $(document).on('click', '.select', function () {
        $('.select').removeClass('on');
        $('.select').children('.option').stop().slideUp();
        if ($(this).children('.option').css('display') == 'none') {
            $(this).addClass('on');
            $(this).children('.option').stop().slideDown();
        } else {
            $(this).removeClass('on');
            $(this).children('.option').stop().slideUp();
        }
    });

    $(document).on('click', '.select .option li', function () {
        let selectText = $(this).text();
        let selectVal = $(this).attr('data');
        $(this).parent().prev('.value').text(selectText);
        $(this).parent().prev('.value').attr('data', selectVal);
        $(this).parent().prev('.value').css('color', '#222222');
    });

    $('body, html').on('click', function (e) {
        // select close
        if ($('.select').hasClass('on')) {
            if (!$('.select').has(e.target).length) {
                $('.select').removeClass('on');
                $('.select .option').slideUp();
            }

        }
    });

    $(document).ajaxSend(function (e, xhr, options) {
        xhr.setRequestHeader("X-CSRF-TOKEN", $('meta[name="csfrVal"]').attr('content'));
    });

});

function searchCheck() {
    let standard = $('.searchSelect').attr('data');
    if (standard == '') {
        popup.searchAlert("기준을 선택해 주세요.");
        return false;
    } else {
        // submit 동작
        return false;
    }
}


const com_ajax = {
    ajax: function (c_method, c_url, c_data, c_callback, header, token) {
        $.ajax({
            name: "form",
            type: c_method,
            url: c_url,
            data: c_data,
            success: function (response, status, req) {
                c_callback(response);
            }, error: function(xhr, status, error){
                if(c_url.includes("/sf/")){
                    alert("Journey Builder 에 에러가 발생하였습니다.\nJourney Builder 를 새로고침 해주세요.");
                }else{
                    if (xhr.status === 401) {
                        alert("접속시간이 오래되어 세션이 만료되었습니다.");
                        window.location.reload();
                    } else if (xhr.status === 403) {
                        window.location.reload();
                    } else{
                        alert("에러가 발생하였습니다 화면을 새로 고쳐주세요");
                    }
                }
            }
            , beforeSend: function (e) {
                $('#commonLoading').addClass('active');
                if (header != null) {
                    e.setRequestHeader(header, token);
                }
            }, complete: function () {
                $('#commonLoading').removeClass('active');
            }
        });
    }
    , ajaxSync: function (c_method, c_url, c_data, c_callback, header, token) {
        $.ajax({
            name: "form",
            type: c_method,
            url: c_url,
            data: c_data,
            async: false,
            success: function (response, status, req) {
                c_callback(response);
            }, error: function(xhr, status, error){
                if (xhr.status === 401) {
                    alert("접속시간이 오래되어 세션이 만료되었습니다.");
                    window.location.reload();
                } else if (xhr.status === 403) {
                    window.location.reload();
                }

            }
            , beforeSend: function (e) {
                $('#commonLoading').addClass('active');
                if (header != null) {
                    e.setRequestHeader(header, token);
                }
            }, complete: function () {
                $('#commonLoading').removeClass('active');
            }
        });
    }
    , ajax_file: function (c_url, c_data, c_callback, header, token) {
        $.ajax({
            name: "form",
            type: "POST",
            url: c_url,
            data: c_data,
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            cache: false,
            success: function (response, status, req) {
                c_callback(response);
            }, error: function (xhr, status, error) {
                if (xhr.status === 403) {
                    window.location.reload();
                }
            }, beforeSend: function (e) {
                $('#commonLoading').addClass('active');
                if (header != null) {
                    e.setRequestHeader(header, token);
                }
            }, complete: function () {
                $('#commonLoading').removeClass('active');
            }
        });
    }
    , ajax_json: function (c_method, c_url, c_data, c_callback, header, token) {
        $.ajax({
            name: "form",
            type: c_method,
            url: c_url,
            data: c_data,
            contentType: "application/json;charset=UTF-8",
            success: function (response, status, req) {
                c_callback(response);
            }, error: function (request, xhr, error) {
                console.log(request.responseText);
                if (xhr.status === 403) {
                    window.location.reload();
                }
            }, beforeSend: function (e) {
                $('#commonLoading').addClass('active');
                if (header != null) {
                    e.setRequestHeader(header, token);
                }
            }, complete: function () {
                $('#commonLoading').removeClass('active');

            }
        });
    }
};

const common = {
    // 숫자 콤마
    comma: function (e) {
        return e.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    , removeComma: function (e) {
        if (!e || e.length === 0) {
            return "";
        } else {
            return e.split(",").join("");
        }
    }
    , today: function (e) {
        let date = new Date();
        let year = date.getFullYear();
        let month = ("0" + (1 + date.getMonth())).slice(-2);
        let day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
    , todayTime: function () {
        let date = new Date();
        let hh =  ("0" + date.getHours()).slice(-2);
        let mm =  ("0" + date.getMinutes()).slice(-2);
        return hh + ":" + mm;
    }, emailcheck: function (obj) {
        //let regExp = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
        let regExp = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|\s|_+|.]*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/;

        if (obj === "" && obj == null) {
            return false;
        } else if (!regExp.test(obj)) {
            return false
        }
        return true;
    }, phonecheck: function (obj) {
        let regExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;

        if (obj === "" && obj == null) {
            return false;
        } else if (!regExp.test(obj)) {
            return false
        }
        return true;
    }, create_form: function (nm, mt, ac, tg) {
        let fm = document.createElement("form");
        fm.name = nm;
        fm.method = mt;
        fm.action = ac;
        fm.target = tg;
        this.add_input(fm, $('meta[name="csrfparameterName"]').attr('content'), $('meta[name="csfrVal"]').attr('content'));
        return fm;
    }, add_input: function (fm, nm, val) {
        $('<input>').attr({
            type: 'hidden'
            , name: nm
            , value: val
        }).appendTo(fm);
    }, popview: function (url, name, sw, sh, message){
    	let cw = screen.availWidth;     //화면 넓이
    	let ch = screen.availHeight;    //화면 높이

    	let ml = (cw-sw)/2;        //가운데 띄우기위한 창의 x위치
        ml += window.screenLeft;  //듀얼 모니터일때...
        let mt = (ch-sh)/2;         //가운데 띄우기위한 창의 y위치

    	let pop = window.open(url, name,'width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
    	pop.document.write(message);
    }
    ,calculate : function (text, target){
        let tcount = this.calByte(text);
        $('#' + target).html(Math.ceil(tcount) + "byte");
    }
    ,calByte : function (aquery){
        let abc = (aquery.length * 9 - encodeURIComponent(aquery).length) / 8;
        let strrbyte2 = (aquery.length - abc) * 2 + abc; // euc-kr인경우
        return strrbyte2;
    }
};

/* 숫자만 입력 가능 */
function numberReplace(number) {
    number.value = number.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
}


/* 날짜를 자동으로 계산해서 1개월 2개월 3개월 6개월 편하게 입력해줌 */
function quickDate(i, startName, endName){
    // i = 오늘 날짜로부터 계산할 개월 수
    // startName = 시작일을 입력할 input의 name 속성값
    // endName = 끝일을 입력할 input의 name 속성값
    var date = new Date();
    var endDate = $.datepicker.parseDate("yy-m-dd", date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate());
    endDate = $.datepicker.formatDate("yy-mm-dd", endDate);
    date.setMonth(date.getMonth() - i);
    var stDate = $.datepicker.parseDate("yy-m-dd", date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate());
    stDate = $.datepicker.formatDate("yy-mm-dd", stDate);
    $('input[name=' + startName + ']').val(stDate);
    $('input[name=' + endName + ']').val(endDate);
}

function numberToPhone(number){
    let formatNum = "";
    if(number.length === 11){
        formatNum = number.replace(/^(\d{3})(\d{3,4})(\d{4})$/, `$1-$2-$3`)
    }else if(number.length === 8){
        formatNum = number.replace(/^(\d{4})(\d{4})$/, `$1-$2`);
    }else{
        if(number.indexOf("02") == -1){
            formatNum = number.replace(/^(\d{3})(\d{3,4})(\d{4})$/, `$1-$2-$3`)
        }else{
            formatNum = number.replace(/^(\d{2})(\d{3,4})(\d{4})$/, `$1-$2-$3`)
        }
    }
    return formatNum;
}



