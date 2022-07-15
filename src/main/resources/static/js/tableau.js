const tableauTab = {
    prefix: null
    , url: null
    , viz: null
    , workbook: null
    , onLoading : false
    , type: "0"
    , loading: false
    , tableauData: {}
    , tableauAddDataSeg: []
    , tableauAddMemberSeg: []
    , tableauExcDataSeg: []
    , tableauExcMemberSeg: []
    , Init: function(prefix, active){
        //초기화
        const _this = this;
        _this.prefix = prefix;
        let res = function(response){
            let $doc = new DOMParser().parseFromString(response, "text/html");
            if(active){
                $("#" + _this.prefix, $doc).addClass("active");
            }
            $("#sheet_area").html($("#body", $doc).html());
            _this.url = $("#url", $doc).html();
            _this.EventBind();
        };
        let param = { prefix : prefix};
        com_ajax.ajax('get', '/camp/tg/tgTab.ajax', param, res);
    }
    , EventBind: function(){
        //prefix 기준으로 이벤트 셋팅
        const _this = this;
        $("#" + _this.prefix).on('click', '#' + _this.prefix + "_addSeg", function(){ _this.AddSeg(); });
        $("#" + _this.prefix).on('click', '#' + _this.prefix + "_addSegF", function(){ _this.AddSeg(); });
        $("#" + _this.prefix).on('click', '#' + _this.prefix + "_excSeg", function(){ _this.ExcSeg(); });
        $("#" + _this.prefix).on('click', '#' + _this.prefix + "_excSegF", function(){ _this.ExcSeg(); });
    }
    , AddSeg: function () {
        const _this = this;
        _this.type = "0";
        if(_this.viz){
            _this.viz.revertAllAsync();
        }else{
            $('#commonLoading').addClass('active');
            let containerDiv = document.getElementById("tableauDiv")
                , url = _this.url
                , options = {
                    hideTabs : true
                    , hideToolbar : true
                    , device : "desktop"
                    , width : "100%"
                    , height : "100%"
                    , "화면_ON_OFF" : "0"
                    , onFirstInteractive: function () { }
                };
            _this.viz = new tableau.Viz(containerDiv, url, options);
            _this.viz.addEventListener(tableau.TableauEventName.CUSTOM_VIEW_LOAD, function(){
                _this.workbook = _this.viz.getWorkbook();
                _this.viz.pauseAutomaticUpdatesAsync();
                $('#commonLoading').removeClass('active');
            });
            _this.viz.addEventListener(tableau.TableauEventName.PARAMETER_VALUE_CHANGE, function(e){
                e.getParameterAsync().then(function(Parameter) {
                    let parameterName = Parameter.getName();
                    let parameterValue = Parameter.getCurrentValue().formattedValue;
                    if(parameterValue){
                        _this.tableauData[parameterName] = parameterValue;
                    }else{
                        delete _this.tableauData[parameterName];
                    }
                });
            });
        }
        $('#segmentPopup').addClass('active');
    }
    , ExcSeg: function () {
        const _this = this;
        _this.type = "1";
        if(_this.viz){
            _this.viz.revertAllAsync();
        }else{
            $('#commonLoading').addClass('active');
            let containerDiv = document.getElementById("tableauDiv")
                , url = _this.url
                , options = {
                    hideTabs : true
                    , hideToolbar : true
                    , device : "desktop"
                    , width : "100%"
                    , height : "100%"
                    , "화면_ON_OFF" : "0"
                    , onFirstInteractive: function () { }
                };
            _this.viz = new tableau.Viz(containerDiv, url, options);
            _this.viz.addEventListener(tableau.TableauEventName.CUSTOM_VIEW_LOAD, function(){
                _this.workbook = _this.viz.getWorkbook();
                _this.viz.pauseAutomaticUpdatesAsync();
                $('#commonLoading').removeClass('active');
            });
            _this.viz.addEventListener(tableau.TableauEventName.PARAMETER_VALUE_CHANGE, function(e){
                e.getParameterAsync().then(function(Parameter) {
                    let parameterName = Parameter.getName();
                    let parameterValue = Parameter.getCurrentValue().formattedValue;
                    if(parameterValue){
                        _this.tableauData[parameterName] = parameterValue;
                    }else{
                        delete _this.tableauData[parameterName];
                    }
                });
            });
        }
        $('#segmentPopup').addClass('active');
    }
    , Save: function(){
        const _this = this;
        _this.onLoading = true;
        $('#commonLoading').addClass('active');
        _this.viz.resumeAutomaticUpdatesAsync().always(function () {
            _this.viz.pauseAutomaticUpdatesAsync();
        });
    }
    , SetValue: function(){
        const _this = this;
        let sheet = _this.workbook.getActiveSheet().getWorksheets();
        let sheetLen = sheet.length - 1;
        let dataSheet = null;
        sheet.forEach(function (item, index, ele) {
            if(item.getName() === "Member List"){
                dataSheet = item;
            }
            item.getFiltersAsync().then(function (filter) {
                try {
                    let filterLength = filter.length;
                    for (let i = 0; i < filterLength; i++) {
                        let filterClass = filter[i];
                        let filterType = filterClass.getFilterType();
                        let filterName = filterClass.getFieldName();

                        if (filterType == tableau.FilterType.CATEGORICAL) {
                            let categoriValue = filterClass.getAppliedValues();
                            if (!filterClass.getIsAllSelected() && categoriValue) {
                                let arrayValue = [];
                                for (let a = 0; a < categoriValue.length; a++) {
                                    arrayValue.push(categoriValue[a].formattedValue);
                                }
                                _this.tableauData[filterName] = arrayValue;
                            }
                        } else if (filterType == tableau.FilterType.QUANTITATIVE) {
                            let rangeStart = filterClass.getMin();
                            let rangeEnd = filterClass.getMax();
                            _this.tableauData[filterName] = {rangeStart, rangeEnd};
                        } else if (filterType == tableau.FilterType.HIERARCHICAL) {
                            console.log(filterType);
                        } else if (filterType == tableau.FilterType.RELATIVE_DATE) {
                            console.log(filterType);
                        } else {
                            console.log(filterType);
                        }
                    }
                } catch (e) {
                    console.log(e);
                }
            }).always(function(){
                if(sheetLen === index) {
                    dataSheet.getSummaryDataAsync().always(function (data) {
                        let memberLst = [];
                        let dataArr = data.getData();
                        let len  = dataArr.length;
                        for(let z = 0; z < len; z++){
                            let temp = dataArr[z];
                            if(z === 0){
                                memberLst.push(temp[0].value);
                            }
                        }
                        if(_this.type === "0"){
                            $('#' + _this.prefix + "_addSeg").show();
                            $('#' + _this.prefix + "_addSegF").hide();
                            _this.tableauAddDataSeg.push(_this.copyObj(_this.tableauData));
                            _this.tableauAddMemberSeg.push(memberLst);
                        }else{
                            $('#' + _this.prefix + "_excSeg").show();
                            $('#' + _this.prefix + "_excSegF").hide();
                            _this.tableauExcDataSeg.push(_this.copyObj(_this.tableauData));
                            _this.tableauExcMemberSeg.push(memberLst);
                        }
                        //$('#commonLoading').removeClass('active');
                        //$('#segmentPopup').removeClass('active');
                    });
                }
            });
        });
    }
    , OnTabAppear: function() {
        // TAB이 비활성 후 다시 활성화 될때
        const _this = this;

    }
    , OnTabDisappear: function() {
        // TAB이 비활성화 될때
        const _this = this;

    }
    , OnTabRemove: function(){
        // TAB 이 삭제될때
        const _this = this;

    }
    , copyObj: function(obj){
        return JSON.parse(JSON.stringify(obj));
    }
    , Dispose: function(){
        const _this = this;
        _this.viz.dispose();
    }
};