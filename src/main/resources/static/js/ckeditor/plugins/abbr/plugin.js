/*
CKEDITOR.plugins.add( 'abbr', {
    icons: 'abbr',
    init: function( editor ) {
    	var config = editor.config, lang = editor.lang.format;
    	
    	var tags = [];
    	
    	tags[0]=["@dnName", "후원자명", "후원자명"];
        tags[1]=["@dnMobile", "핸드폰 번호", "핸드폰 번호"];
        tags[2]=["@dnGift", "총후원금", "총후원금"];
    	
    	editor.ui.addRichCombo( 'Abbr', {
    	            label : "개인화 변수",
    	            title : "개인화 변수",
    	            multiSelect : false,
    	            className: 'cke_format', 
   
    	            panel : {
    	               css : [ config.contentsCss, CKEDITOR.getUrl( this.path + 'css/editor.css' ) ],
    	               voiceLabel : lang.panelVoiceLabel
    	            },

    	            
    	            init : function() {
    	               for (var this_tag in tags){
    	                  this.add(tags[this_tag][0], tags[this_tag][1], tags[this_tag][2]);
    	               }
    	            },

    	            onClick : function( value ){         
    	               editor.focus();
    	               editor.insertHtml(value);
    	            }
    	         });
    	
    }
});
*/