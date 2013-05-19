(function(){var helpers,__slice=[].slice;CodeSync.Document=Backbone.Model.extend({callbackDelay:150,initialize:function(e,t){var n,r,i=this;this.attributes=e;if(n=this.attributes.localStorageKey)(r=this.attributes).contents||(r.contents=localStorage.getItem(n));return Backbone.Model.prototype.initialize.apply(this,arguments),this.on("change:contents",this.onContentChange),this.on("change:name",function(){return i.set("mode",i.determineMode()),i.set("display",i.nameWithoutExtension())}),this.on("change:mode",function(){return i.set("extension",i.determineExtension(),{silent:!0})})},url:function(){return CodeSync.get("assetCompilationEndpoint")},saveToDisk:function(){if(this.isSaveable())return this.sendToServer(!0,"saveToDisk")},loadSourceFromDisk:function(e){var t=this;return $.ajax({url:""+this.url()+"?path="+this.get("path"),type:"GET",success:function(n){n==null&&(n={});if(n.success===!0&&n.contents!=null)return t.set("contents",n.contents,{silent:!0}),e(t)}})},toJSON:function(){return{name:this.nameWithoutExtension(),path:this.get("path"),extension:this.get("extension")||this.determineExtension(),contents:this.toContent()}},nameWithoutExtension:function(){var e;return e=this.get("extension")||this.determineExtension(),(this.get("name")||"untitled").replace(e,"")},toMode:function(){var e,t;return e=this.get("mode")||this.determineMode(),t=CodeSync.Modes.getMode(e)},toCodeMirrorMode:function(){var e;return(e=this.toMode())!=null?e.get("codeMirrorMode"):void 0},toCodeMirrorDocument:function(){return CodeMirror.Doc(this.toContent(),this.toCodeMirrorMode(),0)},toCodeMirrorOptions:function(){return this.toMode().get("codeMirrorOptions")},toContent:function(){var e;return""+(this.get("contents")||((e=this.toMode())!=null?e.get("defaultContent"):void 0)||" ")},onContentChange:function(){var e;return(e=this.get("localStorageKey"))&&localStorage.setItem(e,this.get("contents")),this.sendToServer(!1,"onContentChange")},sendToServer:function(e,t){var n,r=this;return e==null&&(e=!1),t==null&&(t=""),this.isSaveable()||(e=!1),n=e===!0?this.toJSON():_(this.toJSON()).pick("name","extension","contents"),CodeSync.log("Sending Data To "+CodeSync.get("assetCompilationEndpoint"),n),$.ajax({type:"POST",url:CodeSync.get("assetCompilationEndpoint"),data:JSON.stringify(n),error:function(e){return CodeSync.log("Document Process Error",arguments)},success:function(e){var n,i;CodeSync.log("Document Process Response",e),e.success===!0&&r.trigger("status",{type:"success",message:r.successMessage(t)}),e.success===!0&&e.compiled!=null&&r.set("compiled",e.compiled);if(e.success===!1&&e.error!=null)return r.set("error",(n=e.error)!=null?n.message:void 0),r.trigger("status",{type:"error",message:(i=e.error)!=null?i.message:void 0})}})},loadInPage:function(e){e==null&&(e={});if(this.type()==="stylesheet")return helpers.processStyleContent.call(this,this.get("compiled"));if(this.type()==="script"||this.type()==="template"){helpers.processScriptContent.call(this,this.get("compiled"));if(e.complete)return _.delay(e.complete,e.delay||this.callbackDelay)}},type:function(){switch(this.get("mode")){case"css":case"sass":case"scss":case"less":return"stylesheet";case"coffeescript":case"javascript":return"script";case"skim":case"mustache":case"jst":case"haml":case"eco":return"template"}},missingFileName:function(){var e;return e=this.get("path")||this.get("name"),e==null||e.length===0},determineExtension:function(){var e,t;t=this.get("path")||this.get("name");if(e=CodeSync.Document.getExtensionFor(t))return e;if(this.get("mode")!=null)return CodeSync.Modes.guessExtensionFor(this.get("mode")||CodeSync.get("defaultFileType"))},determineMode:function(){var e;return e=this.get("path")||this.get("name")||this.get("extension"),CodeSync.Modes.guessModeFor(e)},successMessage:function(e){if(this.type()==="template")return'Success.  Template will be available as JST["'+this.nameWithoutExtension()+'"]'},isSticky:function(){return this.get("sticky")!=null==1},isSaveable:function(){var e;return((e=this.get("path"))!=null?e.length:void 0)>0&&!this.get("doNotSave")}}),CodeSync.Document.getFileNameFrom=function(e){return e==null&&(e=""),e.split("/").pop()},CodeSync.Document.getExtensionFor=function(e){var t,n,r,i,s;e==null&&(e=""),t=CodeSync.Document.getFileNameFrom(e),s=t.split("."),n=s[0],r=2<=s.length?__slice.call(s,1):[];if(i=r.length>0&&r.join("."))return"."+i},CodeSync.Documents=Backbone.Collection.extend({model:CodeSync.Document,nextId:function(){return this.models.length+1},findOrCreateForPath:function(e,t){var n,r,i,s,o,u=this;return e==null&&(e=""),r=this.detect(function(t){var n;return(n=t.get("path"))!=null?n.match(e):void 0}),r!=null?typeof t=="function"?t(r):void 0:(o=CodeSync.Document.getFileNameFrom(e),i=CodeSync.Document.getExtensionFor(o),n=o.replace(i,""),s=this.nextId(),r=new CodeSync.Document({name:o,extension:i,display:n,path:e,id:s}),r.loadSourceFromDisk(function(){return typeof t=="function"?t(r):void 0}))}}),helpers={processStyleContent:function(e){return $("head style[data-codesync-document]").remove(),$("head").append("<style type='text/css' data-codesync-document=true>"+e+"</style>")},processScriptContent:function(code){var doc,evalRunner;return doc=this,evalRunner=function(code){try{return eval(code)}catch(e){throw doc.trigger("status",{type:"error",message:"JS Error: "+e.message,sticky:!0}),e}},evalRunner.call(window,code)}}}).call(this);