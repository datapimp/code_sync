CodeMirror.defineMode("htmlmixed",function(e,t){function a(e,t){var s=t.htmlState.tagName,o=n.token(e,t.htmlState);if(s=="script"&&/\btag\b/.test(o)&&e.current()==">"){var u=e.string.slice(Math.max(0,e.pos-100),e.pos).match(/\btype\s*=\s*("[^"]+"|'[^']+'|\S+)[^<]*$/i);u=u?u[1]:"",u&&/[\"\']/.test(u.charAt(0))&&(u=u.slice(1,u.length-1));for(var a=0;a<i.length;++a){var f=i[a];if(typeof f.matches=="string"?u==f.matches:f.matches.test(u)){f.mode&&(t.token=l,t.localMode=f.mode,t.localState=f.mode.startState&&f.mode.startState(n.indent(t.htmlState,"")));break}}}else s=="style"&&/\btag\b/.test(o)&&e.current()==">"&&(t.token=c,t.localMode=r,t.localState=r.startState(n.indent(t.htmlState,"")));return o}function f(e,t,n){var r=e.current(),i=r.search(t),s;if(i>-1)e.backUp(r.length-i);else if(s=r.match(/<\/?$/))e.backUp(r.length),e.match(t,!1)||e.match(r[0]);return n}function l(e,t){return e.match(/^<\/\s*script\s*>/i,!1)?(t.token=a,t.localState=t.localMode=null,a(e,t)):f(e,/<\/\s*script\s*>/,t.localMode.token(e,t.localState))}function c(e,t){return e.match(/^<\/\s*style\s*>/i,!1)?(t.token=a,t.localState=t.localMode=null,a(e,t)):f(e,/<\/\s*style\s*>/,r.token(e,t.localState))}var n=CodeMirror.getMode(e,{name:"xml",htmlMode:!0}),r=CodeMirror.getMode(e,"css"),i=[],s=t&&t.scriptTypes;i.push({matches:/^(?:text|application)\/(?:x-)?(?:java|ecma)script$|^$/i,mode:CodeMirror.getMode(e,"javascript")});if(s)for(var o=0;o<s.length;++o){var u=s[o];i.push({matches:u.matches,mode:u.mode&&CodeMirror.getMode(e,u.mode)})}return i.push({matches:/./,mode:CodeMirror.getMode(e,"text/plain")}),{startState:function(){var e=n.startState();return{token:a,localMode:null,localState:null,htmlState:e}},copyState:function(e){if(e.localState)var t=CodeMirror.copyState(e.localMode,e.localState);return{token:e.token,localMode:e.localMode,localState:t,htmlState:CodeMirror.copyState(n,e.htmlState)}},token:function(e,t){return t.token(e,t)},indent:function(e,t){return!e.localMode||/^\s*<\//.test(t)?n.indent(e.htmlState,t):e.localMode.indent?e.localMode.indent(e.localState,t):CodeMirror.Pass},electricChars:"/{}:",innerMode:function(e){return{state:e.localState||e.htmlState,mode:e.localMode||n}}}},"xml","javascript","css"),CodeMirror.defineMIME("text/html","htmlmixed");