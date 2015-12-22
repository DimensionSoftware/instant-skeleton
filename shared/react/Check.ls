
# Checkbox

Check = component \Check ({cursor,label,title,on-change}:props) ->
  do-change = ->
    new-props = cursor.update -> not cursor.deref!
    if on-change then on-change new-props

  options = {
    cursor
    type: \checkbox
    checked: cursor.deref!
  } <<< props
  options.on-change = do-change

  # got a label?
  el = DOM.input options
  if label
    DOM.label {title} [ el, DOM.span void " #label" ]
  else
    el

module.exports = ignore <[ label title onChange ]> Check
