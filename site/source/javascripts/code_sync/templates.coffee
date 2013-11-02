CodeSync.template = (templateIdentifier, variables={})->
  if tmpl = JST[templateIdentifier]
    return tmpl(variables)

  regex = new RegExp("#{ templateIdentifier }$")

  for templateName, templateFunction of JST when templateName.match(regex)
    return templateFunction(variables)

#CodeSync.template.namespaces = ["JST"]
