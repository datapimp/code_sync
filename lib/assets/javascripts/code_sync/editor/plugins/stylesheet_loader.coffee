CodeSync.plugins.StylesheetLoader = CodeSync.ToolbarPanel.extend
  buttonIcon: "cloud"
  className: "stylesheet-loader"
  tooltip: "Load external stylesheets"
  panel_template: "stylesheet_loader"
  availableInModes:"stylesheet"