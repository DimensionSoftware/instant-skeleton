
# Checkbox
module.exports = component ({props,ref,placeholder,label,title,class-name,on-change}) ->
  do-change = ->
    props.update -> not props.deref!
    if on-change then on-change!


  # got a label?
  el = DOM.input {ref, value:props.deref!, type:\checkbox, checked:props.deref!, on-change:do-change, title, class-name}
  if label
    DOM.label {title} [ el, DOM.span void " #label" ]
  else
    el
