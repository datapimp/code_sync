(function(){var e,t;CodeSync.tour={step:0},e=function(e,t,n){var r;return r=document.createElement(e),t&&Backbone.$(r).attr(t),n!==null&&Backbone.$(r).html(n),r},t=function(t,n){var r,i,s,o;n==null&&(n={}),s="position: absolute;";for(i in n){o=n[i];if(o==null)continue;(""+o).match(/px/)||(o=""+o+"px"),s+=""+i+":"+o+";"}return r=e("div",{"class":"bubble",style:s},t),$(".next",r).on("click",function(){return $("body .bubble").addClass("animated bounceOutRight"),CodeSync.startTour({next:!0})}),$("body").append(r),$(r)},CodeSync.enableTour=function(){return $(".tour-button").off("click"),$(".tour-button").on("click",function(){return $(this).addClass("animated fadeOut"),CodeSync.startTour({restart:!0})})},CodeSync.startTour=function(e){var n,r,i,s,o,u,a,f,l,c,h,p;e==null&&(e={}),$(".codesync-tour-content").length===0&&$("body").append(JST["demos/tour"]()),e.restart===!0&&(CodeSync.tour.step=0),e.next===!0&&(CodeSync.tour.step=CodeSync.tour.step+1),u=CodeSync.tour.step,h=$(".codesync-tour-content .content[data-tour-step="+u+"]");if(h.length>0)return r=h[0].outerHTML,a=h.data("position")||"below",p=a==="below"?"bounceInDown":"bounceInUp",l=h.data("target"),$(l).length>0?(s=$(l).position(),a==="below"?(c=s.top+$(l).height()+25,o=s.left+80):(n="120px",f="15px")):(c="600px",o="600px"),i=t(r,{top:c,left:o,bottom:n,right:f}),i.addClass("animated "+p)}}).call(this);