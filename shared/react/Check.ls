
# Checkbox
module.exports = component \Check (props, {label,title,on-change}:statics) ->
  do-change = ->
    new-props = props.update -> not props.deref!
    if on-change then on-change new-props

  # got a label?
  el = DOM.input statics <<< {value:props.deref!, type:\checkbox, checked:props.deref!, on-change:do-change}
  if label
    DOM.label {title} [ el, DOM.span void " #label" ]
  else
    el
