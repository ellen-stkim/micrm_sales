define(["postmonger"], function (Postmonger) {
	"use strict";

	var connection = new Postmonger.Session();
	
	var payload = {};
	var fuelapiRestHost = null;
	var fuel2token = null;
	var eventDefinitionKey = null;
	var flag = true;

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
		
		setTimeout(function() {
			if(flag) {
				location.href='error';
			}
		}, 1000);
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
				console.log(key + ": " + val);
			});
		});
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
		if($('#recv_to').val() == '' || $('#recv_to').val() == null) {
			alert('수신 번호를 선택해 주세요.');
			connection.trigger('ready');
		} else {
			payload["arguments"].execute.inArguments = [{
				phone: "{{Event." + eventDefinitionKey + "." + $('#recv_to').val() + "}}",
			}];
	
			payload["metaData"].isConfigured = true;
	
			connection.trigger("updateActivity", payload);
		}		
	}
});