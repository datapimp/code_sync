CodeSync.plugins.StylesheetLoader = CodeSync.ToolbarPanel.extend
  buttonIcon: "cloud"
  className: "stylesheet-loader"
  tooltip: "Load external stylesheets"
  panelTemplate: "stylesheet_loader"
  availableInModes:"stylesheet"