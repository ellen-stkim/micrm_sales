let edmCreate = {
    urlTab: true
    ,
    mapTab: true
    ,
    baseLayout: '<div class="edm_layout" style="position:relative; padding:0;"><div class="subTitle" style="text-align:center; font-size:12px;"></div><div class="edm_source"></div><div class="edm_link" style="position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(255,255,255,0.3);"></div></div>'
    ,
    browserLayout: '<div class="link" id="browserLink" style="display:block; width:100%; padding:20px 0; text-align:center;"><span style="display:inline-block; text-decoration:underline; font-size:12px; color:#666666;">이 메일이 제대로 보이지 않을 경우 이 곳을 클릭하면 브라우저에서 볼 수 있습니다.</span></div>'

    ,
    rejectionLayout: '<div class="rejection_layout" id="rejectionLink" style="text-align:center; line-height:1.3;">' +
        '<p style="font-size:12px; color:#cccccc;">메일 수신을 원치 않으시면 <span style="color:#666666;">[수신거부]</a>를 클릭하시오.</span>' +
        '<p style="font-size:12px; color:#cccccc;">If you don&#39;t want this type of information or e-mail, please click the<span style="color:#666666;">[unsubscription]</span></p>' +
        '</div>'
    ,
    browserLink: function (link) {
        let linkValue = $(link).is(':checked');
        let viewer = $('#preview').contents().find('body');
        if (linkValue == true) {
            viewer.find('.edm_link').css('top', '56px');
            if (viewer.find('.edm_source').length > 0) {
                if (viewer.find('.link').length == 0) {
                    let html = edmCreate.browserLayout + viewer.find('.edm_source').html();
                    viewer.find('.edm_source').html(html);
                }
            } else {
                viewer.html(edmCreate.baseLayout);
                let html = edmCreate.browserLayout + viewer.find('.edm_source').html();
                viewer.find('.edm_source').html(html);
            }
        } else {
            viewer.find('.edm_link').css('top', '0');
            viewer.find('.link').remove();
        }
        return false;
    }// browserLink end
    ,
    brejectionLink: function (link) {
        let linkValue = $(link).is(':checked');
        let viewer = $('#preview').contents().find('body');
        if (linkValue == true) {
            if (viewer.find('.edm_source').length > 0) {
                if (viewer.find('.rejection_layout').length == 0) {
                    let html = viewer.find('.edm_source').html() + edmCreate.rejectionLayout;
                    viewer.find('.edm_source').html(html);
                }
            } else {
                viewer.html(edmCreate.baseLayout);
                let html = viewer.find('.edm_source').html() + edmCreate.rejectionLayout;
                viewer.find('.edm_source').html(html);
            }
        } else {
            viewer.find('.rejection_layout').remove();
        }
    }// brejectionLink end
    ,
    linkAnalysis: function () {
        let _this = this;
        let viewer = $('#preview').contents().find('.edm_source');
        let navHtml = '';
        let noneHtml = '';
        let num = 1;
        let aLink = [];
        let mapLink = [];
        let linkInfoForm = '';

        viewer.find('a').each(function () {
            let linkNum = num >= 10 ? '0' + num : '00' + num;
            if ($(this).attr('id') == null) {
                $(this).attr('id', 'Link' + linkNum);
            }
            if ($(this).attr('name') == null) {
                $(this).attr('name', 'Link' + linkNum);
            }
            if ($(this).attr('linkType') == null) {
                $(this).attr('linkType', 0);
            }
            aLink.push({
                map_id: $(this).parent('map').attr('id') == null ? "" : $(this).parent('map').attr('id'),
                link_url: $(this).attr('href') == null ? "" : $(this).attr('href'),
                link_id: $(this).attr('id') == null ? $(this).attr('id', 'Link' + linkNum) : $(this).attr('id'),
                link_name: $(this).attr('name') == null ? $(this).attr('name', 'Link' + linkNum) : $(this).attr('name'),
                link_target: "_blank",
                link_type: $(this).attr('linkType') == null ? "0" : $(this).attr('linkType'),
                tag_type: "a"
            });
            num = num + 1;
        });

        viewer.find('area').each(function () {
            let linkNum = num >= 10 ? '0' + num : '00' + num;
            if ($(this).attr('id') == null) {
                $(this).attr('id', 'Link' + linkNum);
            }
            if ($(this).attr('name') == null) {
                $(this).attr('name', 'Link' + linkNum);
            }
            if ($(this).attr('linkType') == null) {
                $(this).attr('linkType', 0);
            }

            mapLink.push({
                map_id: $(this).parent('map').attr('id') == null ? "" : $(this).parent('map').attr('id'),
                link_url: $(this).attr('href') == null ? "" : $(this).attr('href'),
                link_id: $(this).attr('id') == null ? 'Link' + linkNum : $(this).attr('id'),
                link_name: $(this).attr('name') == null ? 'Link' + linkNum : $(this).attr('name'),
                link_coords: $(this).attr('coords') == null ? "" : $(this).attr('coords'),
                link_target: "_blank",
                link_type: $(this).attr('linkType') == null ? "0" : $(this).attr('linkType'),
                tag_type: "map"
            });
            num = num + 1;
        });


        let totalList = aLink.concat(mapLink);

        let aCount = aLink.length;
        let mapCount = mapLink.length;
        $('.a_link span').html(aCount + ' 개');
        $('.map_link span').html(mapCount + ' 개');

        let total = aCount + mapCount;

        if (total > 0) {
            if (aCount > 0) {
                if (_this.urlTab == true) {
                    $('.a_link').addClass('on');
                } else {
                    $('.a_link').removeClass('on');
                }
            }
            if (mapCount > 0) {
                if (_this.mapTab == true) {
                    $('.map_link').addClass('on');
                } else {
                    $('.map_link').removeClass('on');
                }
            }
            navHtml = '';

            if (_this.urlTab == true && _this.mapTab == false) {
                for (let b = 0; b < aCount; b++) {
                    let navNum = b + 1;
                    navHtml += '<li id="' + aLink[b].link_id + '" data="' + aLink[b].tag_type + '">' + navNum + '</li>';
                }
            }
            if (_this.urlTab == false && _this.mapTab == true) {
                for (let c = 0; c < mapCount; c++) {
                    let navNum = c + 1;
                    navHtml += '<li id="' + mapLink[c].link_id + '" data="' + mapLink[c].tag_type + '">' + navNum + '</li>';
                }
            }
            if ((_this.urlTab == true && _this.mapTab == true) || (_this.urlTab == false && _this.mapTab == false)) {
                for (let i = 0; i < total; i++) {
                    let navNum = i + 1;
                    navHtml += '<li id="' + totalList[i].link_id + '" data="' + totalList[i].tag_type + '">' + navNum + '</li>';
                }// for end
            }
            $('.link_nav').html(navHtml);
            $('.link_nav li').eq(0).addClass('on').siblings().removeClass('on');

            let dbType = $('input[name="dbInfo"]').filter(':checked').val();
            let edmDB = $('#edmDB .option').html();
            let defaultDB = $('#defaultDB .option').html();
            for (let a = 0; a < total; a++) {
                let dataNum = a + 1;
                linkInfoForm += '<div class="form_tbl" data="' + totalList[a].tag_type + '">' +
                    '<input type="hidden" name="map_id" value="' + totalList[a].map_id + '"/>' +
                    '<input type="hidden" name="url_tag" value="' + totalList[a].tag_type + '"/>' +
                    '<input type="hidden" name="url_type" value=""/>' +
                    '<div class="row">' +
                    '<div class="th">링크 주소</div>' +
                    '<div class="td">' +
                    '<input type="text" class="en_font" name="url" value="' + totalList[a].link_url + '" placeholder="바로가기 링크 주소를 입력하세요."/>' +
                    '<div class="btn_sm_line right" onclick="updateLink(\'' + totalList[a].link_id + '\',this)">수정</div>' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">링크 <span class="en_font">ID</span></div>' +
                    '<div class="td"><input type="text" name="url_id" class="en_font" value="' + totalList[a].link_id + '" placeholder="바로가기 링크 ID 속성을 입력하세요. (HTML TAG)"/></div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">링크 <span class="en_font">NAME</span></div>' +
                    '<div class="td"><input type="text" name="link_name" class="en_font" value="' + totalList[a].link_name + '" placeholder="바로가기 링크 NAME 속성을 입력하세요. (HTML TAG)"/></div>' +
                    '</div>' +
                    '<div class="row bottom-border">' +
                    '<div class="th">링크 주소 개인화</div>' +
                    '<div class="td">';
                if (dbType == 'db') {
                    linkInfoForm += '<div class="select left linkVariable">' +
                        '<div class="value" data="0">링크 주소 개인화 변수</div>' +
                        '<ul class="option">' +
                        edmDB +
                        '</ul>' +
                        '</div>';
                }
                if (dbType == 'upload') {
                    linkInfoForm += '<div class="select left linkVariable">' +
                        '<div class="value" data="0">링크 주소 개인화 변수</div>' +
                        '<ul class="option">' +
                        defaultDB +
                        '</ul>' +
                        '</div>';
                }
                linkInfoForm += '<div class="btn_sm_line right" onclick="edmCreate.variableInput(this)">입력</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';

            }// for end
            $('.link_list').html(linkInfoForm);

            let linkIndex = $('.link_nav li[data="a"].on').index();
            let mapIndex = $('.link_nav li[data="map"].on').index();
            if ($('.link_nav li.on').attr('data') == 'a') {
                $('.form_tbl[data="a"]').eq(linkIndex).addClass('on').siblings().removeClass('on');
            } else {
                $('.form_tbl[data="map"]').eq(mapIndex).addClass('on').siblings().removeClass('on');
            }

        } else {
            noneHtml += '<div class="none">' + '<span>발견된 링크 주소가 없습니다.</span>' + '</div>';
            $('.link_list').html(noneHtml);
            $('.a_link span').html('0개');
            $('.map_link span').html('0개');
            $('.a_link span').removeClass('on');
            $('.map_link span').removeClass('on');
        }// else end
        let tableSize = $('#preview').contents().find('.edm_source table').outerWidth();
        let wrapSize = $('#preview').contents().find('.edm_layout').outerWidth();
        $('#preview').contents().find('.edm_layout').css('width', wrapSize + 'px');
    }// linkAnalysis end
    ,
    linkTypeActive: function (now) {
        let link = edmCreate.urlTab;
        let map = edmCreate.mapTab;

        if (now == 'a') {
            if (link == true && map == true) {
                edmCreate.urlTab = false;
            }
            if (link == false && map == true) {
                edmCreate.urlTab = true;
            }
        } else {
            if (map == true && link == true) {
                edmCreate.mapTab = false;
            }
            if (map == false && link == true) {
                edmCreate.mapTab = true;
            }
        }
        edmCreate.linkAnalysis();
    } // linkTypeActive end
    ,
    linkArea: function () {
        let sourceArea = $('#preview').contents().find('.edm_source');
        let canvasArea = $('#preview').contents().find('.edm_link');
        let html = '';
        let coverWd = $('#preview').contents().find('.edm_layout').width();
        let coverHt = $('#preview').contents().find('.edm_layout').offset().top;
        let scrollTop = $('#preview').contents().find('body').scrollTop();
        let a = 1;
        if (sourceArea.find('img').length > 0) {
            let img = new Image();
            img.src = sourceArea.find('img').attr('src');
            img.onload = function () {
                sourceArea.find('img').each(function () {
                    if ($(this).is('[usemap]') != false) {
                        //이미지의 아이디 값 , 이미지 위치 값 , 넓이 , 높이 , 탑 위치에서 전체 높이 - scrolltop+
                        let id = $(this).attr('usemap').replace('#', '');
                        let clientRect = $(this)[0].getBoundingClientRect();
                        //console.log("---변경 값");
                        //console.log( $(this)[0].getBoundingClientRect());
                        let imgWd = clientRect.width;
                        let imgHt = clientRect.height;
                        let top = clientRect.top - coverHt + scrollTop;
                        let left;
                        if (($(this).offset().left - 8) == 0) {
                            left = 0;
                        } else {
                            left = ((coverWd - imgWd) / 2);
                        }
                        let bottom = clientRect.bottom - coverHt + scrollTop;
                        let right = (coverWd / 2) - (imgWd / 2) + imgWd;
                        html += '<canvas id="' + (id + 'area') + '" width="' + imgWd + 'px" height="' + imgHt + 'px" style="position: absolute; display: block; top: ' + top +
                            'px; left: ' + left + 'px; bottom: ' + bottom + 'px; right: ' + right + 'px;"></canvas>';
                    }
                });

                sourceArea.find('a').each(function () {
                    $(this).css('display', 'inline-block');
                    let aId = $(this).attr('id');
                    let aRect = $(this)[0].getBoundingClientRect();
                    let aWd = aRect.width;
                    let aHt = aRect.height;
                    let minus = (($('#preview').outerWidth() - coverWd) / 2);
                    let left;
                    if (aRect.left == 0) {
                        left = 0;
                    } else {
                        left = (aRect.left - minus) + 8;
                    }
                    let right = (coverWd / 2) - (aWd / 2) + aWd;
                    let top = aRect.top - coverHt + scrollTop;
                    let bottom = aRect.bottom - coverHt + scrollTop;
                    if (aHt < 25) {
                        html +=
                            '<div id="' + (aId + 'A') + '" width="' + aWd + '" height="' + aHt + '" style="position:absolute; top:' + top +
                            'px; left:' + left + 'px; right:' + right + 'px; bottom:' + bottom + 'px; width:' + aWd + 'px; height:' + aHt + 'px; background:rgba(150, 249, 255, 0.5);' + 'font-family:Gotham;' + '">' +
                            '<span class="linkArea" style="box-sizing:border-box; position:absolute; left:0; top:23px; display:block; min-width:100%; height:23px; background-color:rgba(51,51,51,0.8); color:#FFFFFF; padding:0 10px; font-size:11px; line-height:23px; z-index:10; white-space:pre;">' + a + ' (' + aId + ')</span>' +
                            '</div>';
                    } else {
                        html +=
                            '<div id="' + (aId + 'A') + '" width="' + aWd + '" height="' + aHt + '" style="position:absolute; top:' + top +
                            'px; left:' + left + 'px; right:' + right + 'px; bottom:' + bottom + 'px; width:' + aWd + 'px; height:' + aHt + 'px; background:rgba(150, 249, 255, 0.5);' + 'font-family:Gotham;' + '">' +
                            '<span class="linkArea" style="box-sizing:border-box; position:absolute; left:0; top:0; display:block; min-width:100%; height:23px; background-color:rgba(51,51,51,0.8); color:#FFFFFF; padding:0 10px; font-size:11px; line-height:23px; z-index:10; white-space:pre;">' + a + ' (' + aId + ')</span>' +
                            '</div>';
                    }


                    a = a + 1;
                });

                canvasArea.html(html);

                if (canvasArea.find('canvas').length > 0) {
                    mapArea();
                } else {
                    return false;
                }
            };

            function mapArea() {
                sourceArea.find('map').each(function () {
                    let mapId = $(this).attr('id');
                    mapId = mapId == null ? $(this).attr('name') : mapId;
                    let areaId = mapId + 'area';
                    let canvas = document.preview.document.getElementById(areaId);
                    let ctx = canvas.getContext('2d');
                    let ctxFont = canvas.getContext('2d');
                    $(this).children('area').each(function () {
                        let string = $(this).attr('coords');
                        let linkId = $(this).attr('name');
                        let array = string.split(',');
                        let x1 = parseInt(array[0]);
                        let y1 = parseInt(array[1]);
                        let x2 = parseInt(array[2]);
                        let y2 = parseInt(array[3]);
                        ctx.beginPath();
                        ctx.moveTo(x1, y1);
                        ctx.lineTo(x2, y1);
                        ctx.lineTo(x2, y2);
                        ctx.lineTo(x1, y2);
                        ctx.closePath();
                        ctx.fillStyle = 'rgba(150, 249, 255, 0.5)';
                        ctx.strokeStyle = 'rgba(150, 249, 255, 0.5)';
                        ctx.lineWidth = 0;
                        ctx.fill();
                        ctx.stroke();
                        ctx.beginPath();
                        ctx.moveTo(x1 + 1, y1 + 1);
                        ctx.lineTo(x2 - 1, y1 + 1);
                        ctx.lineTo(x2 - 1, y1 + 24);
                        ctx.lineTo(x1 + 1, y1 + 24);
                        ctx.closePath();
                        ctx.fillStyle = 'rgba(51,51,51,0.8)';
                        ctx.fill();
                        ctxFont.font = "11px Gotham";
                        ctxFont.fillStyle = '#FFFFFF';
                        ctxFont.fillText(a + " (" + linkId + ")", (x1 + 10), (y1 + 16));
                        a = a + 1;
                    });
                });
            }
        }
    }// linkArea end
    ,
    setLinkData: function () {
        let viewer = $('#preview').contents().find('.edm_source');
        let aLink = [];
        let mapLink = [];
        let aData = [];
        let mapData = [];
        let a = 1;

        viewer.find('a').each(function () {
            aLink.push($(this));
        });

        viewer.find('area').each(function () {
            mapLink.push($(this));
        });


        $('.tab_contents').find('.form_tbl').each(function () {
            if ($(this).attr('data') == 'a') {
                aData.push({
                    link_url: $(this).find('[name="link_url"]').val(),
                    link_id: $(this).find('[name="link_id"]').val(),
                    link_name: $(this).find('[name="link_name"]').val(),
                    link_type: $(this).find('[name="linkType' + a + '"]:checked').val(),
                });
                a = a + 1;
            } else {
                mapData.push({
                    link_url: $(this).find('[name="link_url"]').val(),
                    link_id: $(this).find('[name="link_id"]').val(),
                    link_name: $(this).find('[name="link_name"]').val(),
                    link_type: $(this).find('[name="linkType' + a + '"]:checked').val(),
                });
                a = a + 1;
            }
        });

        for (let i = 0; i < aLink.length; i++) {
            $(aLink[i]).attr('href', aData[i].link_url);
            $(aLink[i]).attr('id', aData[i].link_id);
            $(aLink[i]).attr('name', aData[i].link_name);
            $(aLink[i]).attr('linkType', aData[i].link_type);
        }

        for (let c = 0; c < mapLink.length; c++) {
            $(mapLink[c]).attr('href', mapData[c].link_url);
            $(mapLink[c]).attr('id', mapData[c].link_id);
            $(mapLink[c]).attr('name', mapData[c].link_name);
            $(mapLink[c]).attr('linkType', mapData[c].link_type);
        }

        let removeHtml = viewer.html();
        let div = $(document.createElement('div'));
        div.html(removeHtml);
        div.find('#browserLink').remove();
        div.find('#rejectionLink').remove();
        removeHtml = div.html();
        div.remove();
        return removeHtml;
    } // setLinkData end
    ,
    variableInput: function (variable) {
        let button = $(variable);
        let input = $(variable).parents('.form_tbl').find('input[name="url"]').val();
        let dataVal = $(variable).siblings('.linkVariable').find('.value').attr('data');

        if (dataVal != '0') {
            $(variable).parents('.form_tbl').find('input[name="url"]').val(input + dataVal);
        } else {
            popup.popAlert("링크 주소 개인화 변수를 선택해주세요.");
        }

    }

}    