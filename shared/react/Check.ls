
# Checkbox

Check = component \Check ({cursor,label,title,on-change}:props) ->
  do-change = ->
    new-props = cursor.update -> not cursor.deref!
    if on-change then on-change new-props

  # got a label?
  el = DOM.input props <<< {value:cursor.deref!, type:\checkbox, checked:cursor.deref!, on-change:do-change}
  if label
    DOM.label {title} [ el, DOM.span void " #label" ]
  else
    el

module.exports = ignore <[ label title onChange ]> Check
