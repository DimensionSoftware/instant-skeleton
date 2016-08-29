
# Checkbox

Check = component \Check ({cursor,label,title,on-change}:opts) ->
  do-change = ->
    change = cursor.update -> not cursor.deref!
    if on-change then on-change change

  options = {
    cursor
    type: \checkbox
    checked: cursor.deref!
  } <<< opts
  options.on-change = do-change

  # got a label?
  el = DOM.input options
  if label
    DOM.label {title} [ el, DOM.span void " #label" ]
  else
    el

module.exports = ignore <[ label title onChange ]> Check
