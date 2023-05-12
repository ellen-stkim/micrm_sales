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
<script src="/js/edmCreate.js"></script>
<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>메세지</li>
                    <li>이메일</li>
                    <li>이메일 컨텐츠 생성</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
<%--                <div class="tooltip_icon">--%>
<%--                    <img src="${baseURL}/image/ico_tooltip.png" alt="Tooltip" />--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                    스타일론 직장인이 26.69억(29.1%), <br />--%>
<%--                    스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
<%--                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <form:form id="saveContForm" name="saveContForm" action="/cont/saveContForm.mi" onsubmit="return false" >
            <div class="section">
                <div class="create_edm">
                    <div class="row bottom-border">
                        <div class="th">템플릿 명</div>
                        <input type="text" class="left template txt_input name" name="cont_nm" id="cont_nm"
                               placeholder="템플릿 명을 입력하세요." />
                        <div class="column2 error_txt" id ="cont_nmErr"></div>
                    </div><!-- //row end -->
                    <div class="cf">
                        <div class="create_article left right_border bottom-border">
                            <div class="row bottom-border">
                                <div class="th">메일 제목</div>
                                <div class="column1">
                                    <input type="text" name="cont_sub" id="cont_sub" class="edm_title txt_input left"
                                           placeholder="메일 제목을 입력하세요." />
                                    <div class="error_txt" id="cont_subErr"></div>
                                </div>
                            </div><!-- //row end -->
                            <div class="row bottom-border">
                                <div class="th">서브 제목</div>
                                <div class="column1">
                                    <input type="text" name="cont_top_body" id="cont_top_body" class="edm_title txt_input left"
                                           placeholder="서브 제목을 입력하세요." />
                                    <div class="error_txt"></div>
                                </div>
                            </div><!-- //row end -->
                            <div class="row bottom-border">
                                <div class="th left">발신자</div>
                                <div class="column1 caller">
                                    <input type="text" class="txt_input left" <%--placeholder="발신자를 입력하세요."--%>
                                           name="send_nm" id="send_nm" readonly value="${slist[0].list_nm}(${slist[0].list_val})"/>
                                    <input type="hidden"  name="send_to" id="send_to" value="" />
                                    <div class="error_txt" id="send_toErr"></div>
                                    <div class="btn_sm_line" onclick="emailPopup('1');">변경</div>
                                </div>
                            </div><!-- //row end -->
                            <div class="create_article">
                                <h2>컨텐츠</h2>
                                <div class="form_viewer">
                                    <iframe name="preview" id="preview" frameborder="0" title="viwer"></iframe>
                                </div>
                            </div>
                        </div>
                        <div class="create_article right bottom-border">
                            <div class="row bottom-border">
                                <div class="td left">
                                    <span class="td_tit">개인화 구분</span>
                                </div>
                                <div class="td left radioType">
                                    <label class="custom_radio">DB<input name="dbInfo" type="radio" value="db" checked /><span></span></label>
                                    <label class="custom_radio">업로드<input name="dbInfo" type="radio" value="upload"/><span></span></label>
                                </div>
                            </div><!-- //row end -->
                            <div class="row bottom-border">
                                <div class="column2 left">
                                    <!-- select 영역 시작 -->
                                    <div class="select td right-border" id="edmDB">
                                        <!-- selected value -->
                                        <div class="value" data="0">제목 개인화 변수</div>
                                        <!-- option -->
                                        <ul class="option">
                                            <c:forEach var="item" items="${columnNm}" varStatus="status">
                                                <li data="{{${columnValue[status.count]}}}">${item}</li>
                                            </c:forEach>

                                        </ul>
                                    </div>
                                    <div class="select td right-border" id="defaultDB">
                                        <!-- selected value -->
                                        <div class="value" data="0">제목 개인화 변수</div>
                                        <!-- option -->
                                        <ul class="option">
                                            <li data="{{USR_ID}}">회원번호</li>
                                            <li data="{{USR_NM}}">이름</li>
                                            <li data="{{USR_MOB}}">모바일</li>
                                            <li data="{{USR_EDM}}">이메일</li>
                                            <li data="{{USR_GDR}}">성별</li>
                                            <li data="{{USR_ADDR}}">주소</li>
                                            <li data="{{USR_ETC1}}">ETC1</li>
                                            <li data="{{USR_ETC2}}">ETC2</li>
                                            <li data="{{USR_ETC3}}">ETC3</li>
                                            <li data="{{USR_ETC4}}">ETC4</li>
                                            <li data="{{USR_ETC5}}">ETC5</li>
                                            <li data="{{USR_ETC6}}">ETC6</li>
                                            <li data="{{USR_ETC7}}">ETC7</li>
                                            <li data="{{USR_ETC8}}">ETC8</li>
                                            <li data="{{USR_ETC9}}">ETC9</li>
                                            <li data="{{USR_ETC10}}">ETC10</li>
                                        </ul>
                                    </div>
                                    <!-- select 영역 끝 -->
                                    <!-- 유형 선택 영역 시작 -->
                                    <div class="td left">
                                        <span class="td_tit">유형 선택</span>
                                        <div class="edm_type">
                                            <label class="block_radio on">
                                                <input type="radio" name="send_tp" value="SENDTP01" checked />
                                                <span>광고</span>
                                            </label>
                                            <label class="block_radio">
                                                <input type="radio" name="send_tp" value="SENDTP02" />
                                                <span>안내</span>
                                            </label>
                                        </div>
                                    </div>
                                    <!-- 유형 선택 영역 끝 -->
                                </div>
                            </div><!-- //row end -->

                            <div class="row bottom-border">
                                <div class="column2 left">
                                    <!-- select 영역 시작 -->
                                    <div class="td left right-border">
                                        <span class="td_tit">브라우저 링크</span>
                                        <!-- 브라우저 링크 버튼 -->
                                        <label class="btn_switch right">
                                            <input type="checkbox" name="br_yn" id="br_yn" onchange="edmCreate.browserLink(this);" value="Y"/>
                                            <span></span>
                                        </label>
                                    </div>
                                    <!-- select 영역 끝 -->
                                    <!-- 유형 선택 영역 시작 -->
                                    <div class="td left">
                                        <span class="td_tit">수신거부 링크</span>
                                        <div class="btn_tip left">
                                            <img src="/image/ico_tooltip2.png" alt="">
                                            <div class="tip_box">
                                                <div class="bullet"></div>
                                                광고성 메일은 수신거부 링크를 필수적으로 삽입해야 합니다.
                                            </div>
                                        </div>
                                        <!-- 수신거부 링크 버튼 -->
                                        <label class="btn_switch right">
                                            <input type="checkbox" name="sup_yn" id="sup_yn" onchange="edmCreate.brejectionLink(this);" value="Y"/>
                                            <span></span>
                                        </label>
                                    </div>
                                    <!-- 유형 선택 영역 끝 -->
                                </div>
                            </div><!-- //row end -->
                            <!-- 링크 버튼 -->
                            <div class="link_switch">
                                <span class="td_tit">링크</span>
                                <label class="btn_switch right">
                                    <input type="checkbox" name="linkView" />
                                    <span></span>
                                </label>
                            </div>
                            <!-- tab menu -->
                            <ul class="tab_nav">
                                <li class="on">내용편집기</li>
                                <li>링크 편집</li>
                            </ul>
                            <!-- editor -->
                            <div class="tab_contents active">
                                <textarea name="cont_body" id="cont_body" cols="30" rows="10"></textarea>
                            </div>
                            <!--  -->
                            <div class="tab_contents">
                                <div class="link_count cf">
                                    <div class="a_link" onclick="edmCreate.linkTypeActive('a');">A 링크 <span>0 개</span></div>
                                    <div class="map_link" onclick="edmCreate.linkTypeActive('map');">MAP 링크<span>0 개</span></div>
                                </div>
                                <div class="link_info">
                                    <ul class="link_nav cf"></ul>
                                    <div class="link_list"></div>
                                </div>
                            </div>
                            <div class="btn_row">
                                <input type="hidden" name="ch_tp" id="ch_tp" value="CH01"/>
                                <input type="hidden" name="cont_tp" id="cont_tp" value="DMTP01"/>
                                <input type="hidden" name="sent_tp" id="sent_tp" value="SENDTP01"/>
                                <input type="button" value="저장" class="btn_full save" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form:form>
        <!-- section 영역 끝 -->
        <!-- footer 영역 시작 -->
        <footer class="footer">
            &copy; Milvus Corp.
        </footer>
        <!-- footer 영역 끝 -->
    </div>
    <!-- 컨텐츠 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>

<!-- 발신자 메일 주소 선택 팝업 영역 시작 -->
<form:form id="tblmisetForm" name="tblmisetForm" onsubmit="return false">
    <span id = "callPopUp">
    </span>
    <%--TODO 발신자 TYPE 변수 지정--%>
    <input type="hidden" id="list_tp_id" name="list_tp_id" value="DMTP01"/>
    <input type="hidden" id="list_dt_id" name="list_dt_id" value="DMCH101"/>
</form:form>
<!-- 발신 번호 선택 팝업 영역 끝 -->

<script>
    let RegExClass = /(\s)(class)(\s)?=(\s)?(\"|\')[^<]+(\"|\')/gi;
    let RegExStyle = /<(style)([^<]+)(<\/style>|\s+\/>)/gi;
    let RegExScript = /<(script)([^<]+)(<\/script>|\s+\/>)/gi;
    let RegExOnAttr = /(\s)(on)[a-z]+(\s)?=(\s)?(\"|\')[^\/>]+(\"|\')/gi;

    function scriptCheck(str) {
        str = str.replace(RegExScript, '');
        str = str.replace(RegExOnAttr, '');
        str = str.replace(RegExStyle, '');
        str = str.replace(RegExClass, '');
        return str;
    }
    let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
    let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();
    let customDBValue;
    $(document).ready(function () {
        function getDBValue(){
            let dbValue = $('input[name="dbInfo"]:checked').val();
            if(dbValue == 'db'){
                customDBValue = edmDB;
                $('#edmDB').show();
                $('#defaultDB').hide();
                $('.cke_combo__abbr').show();
                $('.cke_combo__abbr2').hide();
            }if(dbValue == 'upload'){
                customDBValue = defaultDB;
                $('#edmDB').hide();
                $('#defaultDB').show();
                $('.cke_combo__abbr').hide();
                $('.cke_combo__abbr2').show();
            }
        }

        $('input[name="dbInfo"]').on('change',function(){
            getDBValue();
        });//end

        // 개인화 변수 선택 시 제목 입력 칸에 코드 추가 동작
        $(document).on('click','#edmDB .option li, #defaultDB .option li',function(){
            let dbValue = $(this).attr('data');
            let title = $('input[name="cont_sub"]').val();
            $('input[name="cont_sub"]').val(title + dbValue);
        });

        // 광고/안내 유형 선택 click event
        $('.edm_type .block_radio').on('click', function () {
            $(this).addClass('on').siblings().removeClass('on');
            $(this).siblings().children('input[type="radio"]').prop('checked', false);
            $(this).children('input[type="radio"]').prop('checked', true);
        });

        //서브 제목 blur event
        $('input[name="cont_top_body"]').on('blur',function(){
            let text = $(this).val();
            let viewer = $('#preview').contents().find('body');

            viewer.find('.subTitle').html(text);
        });

        // 저장 event
        $('.save').on('click', function () {
            var sendDefault = '${slist[0].seq}';
            $('#cont_nmErr').html("");
            $('#cont_subErr').html("");
            //템플릿명 중복 체크
            var contNmval = $('#cont_nm').val();
            var sendToVal = $('#send_to').val();
            if($.trim(contNmval) == null || $.trim(contNmval) == ""){
                $('#cont_nmErr').html("탬플릿명을 입력해주세요.");
                return false;
            }else if($.trim(sendToVal) == null || $.trim(sendToVal) == "") {
               $('#send_to').val(sendDefault);
            }

            let titleVal = $('[name="cont_sub"]').val();
            let rafioStatus = $('[name="send_tp"]:checked').val();
            var supYnCheck = $('input[name="sup_yn"]').is(':checked');
            if (rafioStatus == 'SENDTP01') {
                if (titleVal.indexOf('(광고)') != -1) {
                } else {
                    $('#cont_subErr').html('광고성 메일은 제목에 &#39;(광고)&#39;입력이 필수 입니다.');
                    return false;
                }
                if(!supYnCheck){
                    popup.confirmAlertCallback("광고성 메일은 수신거부 링크를 필수적으로 <br>삽입해야 합니다.", "saveEmdContent()");
                }else{
                    saveEmdContent();
                }
            }else{
                saveEmdContent();
            }

        });

        CKEDITOR.plugins.add( 'abbr', {
            icons: 'abbr',
            init: function( editor ) {
                $Editor = editor;
                    lang = editor.lang.format;
                editor.ui.addRichCombo( 'Abbr', {
                    label : "개인화",
                    title : "개인화",
                    toolbar: 'basicstyles,0',
                    panel: {
                        css: [ CKEDITOR.getUrl( this.path + 'css/editor.css' ) ],
                        multiSelect: false,
                        attributes: { 'aria-label': 'My Dropdown Title' }
                    },
                    init: function() {
                        <c:forEach var="item" items="${columnNm}" varStatus="status">
                            this.add( '{{${columnValue[status.count]}}}', '${item}' );
                        </c:forEach>
                    },
                    onClick: function( value ) {
                        editor.focus();
                        editor.insertHtml(value);
                    }
                });
            }
        });
        CKEDITOR.plugins.add( 'abbr2', {
            icons: 'abbr2',
            init: function( editor ) {
                $Editor = editor;
                lang = editor.lang.format;
                editor.ui.addRichCombo( 'Abbr2', {
                    label : "개인화",
                    title : "개인화",
                    toolbar: 'basicstyles,0',
                    panel: {
                        css: [ CKEDITOR.getUrl( this.path + 'css/editor.css' ) ],
                        multiSelect: false,
                        attributes: { 'aria-label': 'My Dropdown Title' }
                    },
                    init: function() {
                            this.add('{{USR_ID}','회원번호');
                            this.add('{{USR_NM}','이름');
                            this.add('{{USR_MOB}','모바일');
                            this.add('{{USR_EDM}','이메일');
                            this.add('{{USR_GDR}','성별');
                            this.add('{{USR_ADDR}','주소');
                            this.add('{{USR_ETC1}','ETC1');
                            this.add('{{USR_ETC2}','ETC2');
                            this.add('{{USR_ETC3}','ETC3');
                            this.add('{{USR_ETC4}','ETC4');
                            this.add('{{USR_ETC5}','ETC5');
                            this.add('{{USR_ETC6}','ETC6');
                            this.add('{{USR_ETC7}','ETC7');
                            this.add('{{USR_ETC8}','ETC8');
                            this.add('{{USR_ETC9}','ETC9');
                            this.add('{{USR_ETC10}','ETC10');
                    },
                    onClick: function( value ) {
                        editor.focus();
                        editor.insertHtml(value);
                    }
                });
            }
        });
        //ckeditor option
        CKEDITOR.replace('cont_body', {
            language: 'ko',
            height: 305,
            resize_dir: 'both',
            resize_minHeight: 305,
            resize_maxHeight: 305,
            resize_minWidth: 600,
            resize_maxWidth: 600,
            extraPlugins : 'abbr, abbr2',
            toolbar : [
                { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', '-', 'Templates' ] },
                { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
                { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', '-', 'SelectAll', '-', 'Scayt' ] },
                '/',
                { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
                '/',
                { name: 'insert', items: ['Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak'] },
                { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl'] },
                { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
                { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
                { name: 'tools', items: [] },{ name: 'abbr', items: ['Abbr'] },{ name: 'abbr2', items: ['Abbr2'] },
                '/'
            ],
            removeButtons : 'Underline, Subscript, Superscript,Save,Preview,Print',
            format_tags : 'p;h1;h2;h3;pre',
            resize_dir : 'both',
            removeDialogTabs : 'image:advanced;link:advanced',
            enterMode : CKEDITOR.ENTER_BR,
            toolbarCanCollapse : false,
            allowedContent : true,
            removePlugins : 'newpage, exportpdf, elementspath',
            docType : "<!DOCTYPE html>",
            //htmlEncodeOutput : true,
            autoParagraph : false,
            on:{
                instanceReady : function(){
                    let dbValue = $('input[name="dbInfo"]:checked').val();
                    if(dbValue == 'db'){
                        customDBValue = edmDB;
                        $('#edmDB').show();
                        $('#defaultDB').hide();
                        $('.cke_combo__abbr').show();
                        $('.cke_combo__abbr2').hide();
                    }if(dbValue == 'upload'){
                        customDBValue = defaultDB;
                        $('#edmDB').hide();
                        $('#defaultDB').show();
                        $('.cke_combo__abbr').hide();
                        $('.cke_combo__abbr2').show();
                    }
                }
            }
         });

        CKEDITOR.instances.cont_body.on('blur', function () {
            let data = CKEDITOR.instances.cont_body.getData();
            let viewer = $('#preview').contents().find('body');
            let browser = $('input[name="br_yn"]').is(':checked');
            let rejection = $('input[name="sup_yn"]').is(':checked');
            data = scriptCheck(data);
            CKEDITOR.instances.cont_body.setData(data);
            viewer.html(edmCreate.baseLayout);
            if (browser == true) {
                data = edmCreate.browserLayout + data;
            }
            if (rejection == true) {
                data = data + edmCreate.rejectionLayout;
            }
            let subTitle = $('input[name="cont_top_body"]').val();
            viewer.find('.subTitle').html(subTitle);
            viewer.find('.edm_source').html(data);
            edmCreate.linkAnalysis();
            $("#preview").contents().find('.edm_link').hide();
        });

        CKEDITOR.instances.cont_body.on('mode', function () {
            let data = CKEDITOR.instances.cont_body.getData();
            let viewer = $('#preview').contents().find('body');
            let browser = $('input[name="br_yn"]').is(':checked');
            let rejection = $('input[name="sup_yn"]').is(':checked');
            data = scriptCheck(data);
            CKEDITOR.instances.cont_body.setData(data);
            viewer.html(edmCreate.baseLayout);
            if (browser == true) {
                data = edmCreate.browserLayout + data;
            }
            if (rejection == true) {
                data = data + edmCreate.rejectionLayout;
            }
            let subTitle = $('input[name="cont_top_body"]').val();
            viewer.find('.subTitle').html(subTitle);
            viewer.find('.edm_source').html(data);
            edmCreate.linkAnalysis();
            $("#preview").contents().find('.edm_link').hide();

        });

        // tab menu click event
        $('ul.tab_nav li').on('click', function () {
            let now = $(this).index();
            $(this).addClass('on').siblings().removeClass('on');
            $('.tab_contents').eq(now).addClass('active').siblings().removeClass('active');

            let data = CKEDITOR.instances.cont_body.getData();
            let viewer = $('#preview').contents().find('body');
            let browser = $('input[name="br_yn"]').is(':checked');
            let rejection = $('input[name="sup_yn"]').is(':checked');

            data = scriptCheck(data);
            CKEDITOR.instances.cont_body.setData(data);
            viewer.html(edmCreate.baseLayout);

            if (browser == true) {
                data = edmCreate.browserLayout + data;
            }
            if (rejection == true) {
                data = data + edmCreate.rejectionLayout;
            }

            let subTitle = $('input[name="cont_top_body"]').val();
            viewer.find('.subTitle').html(subTitle);

            if (now === 0) {
                viewer.find('.edm_source').html(data);
                edmCreate.linkAnalysis();
                $("#preview").contents().find('.edm_link').hide();
                $('.link_switch').hide();
            } else {
                viewer.find('.edm_source').html(data);
                edmCreate.linkAnalysis();
                edmCreate.linkArea();
                $('.link_switch').show();
                if ($('.link_nav').children().length > 0) {
                    $('#preview').contents().find('.edm_link').show();
                    $('input[name="linkView"]').prop('checked', true);
                } else {
                    $('#preview').contents().find('.edm_link').hide();
                    $('input[name="linkView"]').prop('checked', false);
                }
            }
        });

        // 링크 편집  click
        $(document).on('click', '.link_nav li', function () {
            let linkIndex = $('.link_nav li[data="a"]').index(this);
            let mapIndex = $('.link_nav li[data="map"]').index(this);
            $(this).addClass('on').siblings().removeClass('on');
            if ($(this).attr('data') == 'a') {
                $('.form_tbl[data="a"]').eq(linkIndex).addClass('on').siblings().removeClass('on');
            } else {
                $('.form_tbl[data="map"]').eq(mapIndex).addClass('on').siblings().removeClass('on');
            }
        });

        // 링크 영역 표시 on/off
        $('input[name="linkView"]').change(function () {
            let linkState = $('input[name="linkView"]').is(':checked');
            if (linkState == false) {
                $("#preview").contents().find('.edm_link').hide();
            } else {
                $("#preview").contents().find('.edm_link').show();
            }
        });

        // 이메일 컨텐츠 유효성 검사
        $.validator.addMethod("adCheck", function (value) {
            let titleVal = $('[name="cont_sub"]').val();
            let rafioStatus = $('[name="send_tp"]:checked').val();
            if (rafioStatus == 'SENDTP01') {
                if (titleVal.indexOf('(광고)') != -1) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return true;
            }
        });

        // validator 유효성 검사
        $("#saveContForm").validate({
            //error 표시 위치
            errorPlacement: $.noop
            //입력된 값이 잘못된 샹태에서 submit 할 경우 호출
            , invalidHandler: function (form, validator) {
                let errors = validator.numberOfInvalids();
                $('.error_txt').html('');
                for (let i = 0; i < errors; i++) {
                    let errorElement = validator.errorList[i].element;
                    let errorMessage = validator.errorList[i].message;
                    $(errorElement).next('.error_txt').html(errorMessage);
                }
                return false;
            }
            , rules: {
                cont_nm: {
                    required: true
                },
                cont_sub: {
                    adCheck: true
                }
            }
            , messages: {
                cont_nm: {
                    required: '템플릿 명을 입력하세요.'
                }
                , cont_sub: {
                    adCheck: '광고성 메일은 제목에 &#39;(광고)&#39;입력이 필수 입니다.'
                }

            }
            ,submitHandler : function(form){
                form.submit();
            }
        });//end
    });

    // 발실자 메일 주소 팝업 open function
    function emailPopup(nowPage) {
        var res = function(response) {
            $("#callPopUp").html(response);
        };
        var param = $("#tblmisetForm").serializeArray();
        param.push({name: 'pageNo', value: nowPage});
        com_ajax.ajax('post', '${baseURL}/cont/senderList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function addressSave(){
        let emailCheck = $('input[name="emailAddress"]:checked').length;
        let emailAddress = $('input[name="emailAddress"]:checked').val();
        let html = $('input[name="emailAddress"]:checked').parents('label').find('input[name="send_to"]').val();
        if (emailCheck > 0) {
            $('input[name="send_nm"]').val(emailAddress);
            $('#send_to').val(html);
            $('.emailPopup').removeClass('active');
        } else {
            return false;
        }
    }
    
    function updateLink(urlId, thisValue) {
        let tempData = CKEDITOR.instances.cont_body.getData();
        var nextUrl = $(thisValue).siblings('input[name="url"]').val();
        let viewer = $('#preview').contents().find('body');
        let browser = $('input[name="br_yn"]').is(':checked');
        let rejection = $('input[name="sup_yn"]').is(':checked');
        $(viewer).find('#' + urlId).attr('href', nextUrl);
        var afterView = viewer.find('.edm_source').html();
        CKEDITOR.instances.cont_body.setData(afterView);
        //edmCreate.linkAnalysis();
    }
    function saveEmdContent(){
        $('.layer_pop.alert').removeClass('active');
        var res = function(response) {
            if(response > 0){
                $('#cont_nmErr').html("중복된 탬플릿명입니다. ");
                return false;
            }else{
                let viewer = $('#preview').contents().find('body');
                let data = CKEDITOR.instances.cont_body.getData();
                let browser = $('input[name="br_yn"]').is(':checked');
                let rejection = $('input[name="sup_yn"]').is(':checked');

                data = scriptCheck(data);
                CKEDITOR.instances.cont_body.setData(data);
                viewer.html(edmCreate.baseLayout);

                if (browser == true) {
                    data = edmCreate.browserLayout + data;
                }
                if (rejection == true) {
                    data = data + edmCreate.rejectionLayout;
                }
                let subTitle = $('input[name="cont_top_body"]').val();
                viewer.find('.subTitle').html(subTitle);
                viewer.find('.edm_source').html(data);
                edmCreate.linkAnalysis();
                let cont_body = CKEDITOR.instances.cont_body.getData();
                $('#cont_body').val(cont_body);
                $('#saveContForm').submit();
            }
        };
        var param = $("#saveContForm").serializeArray();
        com_ajax.ajax('post', '${baseURL}/cont/checkContNm.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
</script>