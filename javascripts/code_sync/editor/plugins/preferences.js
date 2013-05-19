(function(){CodeSync.plugins.PreferencesPanel=Backbone.View.extend({className:"preferences-panel",events:{"change select,input":function(){return this.trigger("update:preferences")}},renderHidden:!0,initialize:function(e){return this.editor=e.editor,this.$el.html(JST["code_sync/editor/templates/preferences_panel"]()),Backbone.View.prototype.initialize.apply(this,arguments)},values:function(){var e,t,n,r,i,s;n={},s=this.$("input,select");for(r=0,i=s.length;r<i;r++)e=s[r],t=$(e),n[t.attr("name")]=t.val();return n},toggle:function(){return this.syncWithEditorOptions(),this.$el.toggle()},syncWithEditorOptions:function(){return this.$('select[name="theme"]').val(this.editor.codeMirror.getOption("theme")),this.$('select[name="keyMap"]').val(this.editor.codeMirror.getOption("keyMap")),this.$('input[name="asset_endpoint"]').val(CodeSync.get("assetCompilationEndpoint")),this.$('input[name="editor_hotkey"]').val(CodeSync.get("editorToggleHotKey"))},render:function(){return this.renderHidden===!0&&this.$el.hide(),this}}),CodeSync.plugins.PreferencesPanel.setup=function(e){var t,n=this;return t=new CodeSync.plugins.PreferencesPanel({editor:this}),this.$(".toolbar-wrapper").append("<div class='button toggle-preferences'>Preferences</div>"),this.events["click .toggle-preferences"]=function(){return t.toggle()},this.$el.append(t.render().el),t.on("update:preferences",function(){var n;return n=t.values(),e.setTheme(n.theme),e.setKeyMap(n.keyMap),CodeSync.set("assetCompilationEndpoint",n.asset_endpoint),CodeSync.AssetEditor.setHotKey(n.editor_hotkey)}),e.on("codemirror:setup",function(e){return e.on("focus",function(){return t.$el.hide()})}),t.on("update:preferences",function(){var n;n=t.values();if(e.position!==n.position)return e.setPosition(n.position)})}}).call(this);