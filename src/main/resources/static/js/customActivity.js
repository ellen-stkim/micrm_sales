define(["postmonger"], function (Postmonger) {
	"use strict";

	var connection = new Postmonger.Session();
	
	var payload = {};
	var fuelapiRestHost = null;
	var fuel2token = null;
	var eventDefinitionKey = null;
	var flag = true;
	var usr_grp_cd = null;

	$(window).ready(onRender);

	connection.on("initActivity", initialize);
	connection.on("requestedTokens", onGetTokens);
	connection.on("requestedEndpoints", onGetEndpoints);
	
	connection.on('requestedInteraction', onRequestedInteraction);
	connection.on('requestedTriggerEventDefinition', onRequestedTriggerEventDefinition);
	connection.on('requestedDataSources', onRequestedDataSources);
	
	connection.on('clickedNext', save);

	function onRender() {
		// 최초 호출 시 initActivity를 호출하고 payload 전달
		connection.trigger('ready');

		connection.trigger('requestTokens');
		connection.trigger('requestEndpoints');
		
		connection.trigger('requestInteraction');
		connection.trigger('requestTriggerEventDefinition');
		connection.trigger('requestDataSources');
		
		// refresh
		connection.trigger('ready');

		/**
		setTimeout(function() {
			if(flag) {
				location.href='error';
			}
		}, 1000);
		*/
	}
	
	function onRequestedDataSources(dataSources){
		console.log('dataSources == ' + JSON.stringify(dataSources));
	}

	function onRequestedInteraction (interaction) {	
		console.log('interaction == ' + JSON.stringify(interaction));
	 }

	 function onRequestedTriggerEventDefinition(eventDefinitionModel) {
		console.log('eventDefinitionModel == ' + JSON.stringify(eventDefinitionModel));
		
		eventDefinitionKey = eventDefinitionModel.eventDefinitionKey;
	}

	function initialize(data) {
		if (data) {
			payload = data;
			document.getElementById('configuration').value = JSON.stringify(data, null, 2);
			flag = false;
		}
		
		var hasInArguments = Boolean(
			payload["arguments"] &&
				payload["arguments"].execute &&
				payload["arguments"].execute.inArguments &&
				payload["arguments"].execute.inArguments.length > 0
		);

		var inArguments = hasInArguments ? payload["arguments"].execute.inArguments : {};

		$.each(inArguments, function (index, inArgument) {
			$.each(inArgument, function (key, val) {
				if(key === 'usr_grp_cd') {
				    usr_grp_cd = val;
				} else if(key === 'host') {
				    fuelapiRestHost = val;
				} else if(key === 'token') {
				    fuel2token = val;
				}
			});
		});

        // payload에 usr_grp_cd가 없으면 DB에서 조회한다.
		if(usr_grp_cd == '' || usr_grp_cd == null) {
		    getUser(fuelapiRestHost, fuel2token);
		} else {
		    // mappingLst(usr_grp_cd);

		}
	}

    // 사용자 조회
	function getUser(host, token) {
	    const res = function(response) {
            if (response.status == "true") {
                usr_grp_cd = response.usr_grp_cd;
                alert(usr_grp_cd);
                // mappingLst(usr_grp_cd);
            } else {
                // 조회실패
                alert('사용자 조회에 실패하였습니다.');
            }
        }
        let param = {host: host, token: token}
        com_ajax.ajax('post', '/sf/getUser.ajax', param, res, null, null)
	}

	function onGetTokens(tokens) {
		console.log("tokens == " + JSON.stringify(tokens));
		
		if(tokens) {
			fuel2token = tokens.fuel2token;
		}
	}

	function onGetEndpoints(endpoints) {
		console.log("endpoints == " + JSON.stringify(endpoints));
		
		if(endpoints) {
			fuelapiRestHost = endpoints.fuelapiRestHost;
		}
	}
	
	function save() {
		if($('#kakao_recv').val() == '' || $('#kakao_recv').val() == null) {
			alert('수신 번호를 선택해 주세요.');
			connection.trigger('ready');
		} else {
		    // 저장과 동일한 구성


			payload["arguments"].execute.inArguments = [{
			    formatType
				phone: "{{Event." + eventDefinitionKey + "." + $('#kakao_recv').val() + "}}",

			}];
	
			payload["metaData"].isConfigured = true;
	
			connection.trigger("updateActivity", payload);
		}		
	}
});