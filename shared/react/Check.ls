
# Checkbox
module.exports = component common-mixins, ({props,ref,placeholder,label,title,class-name}) ->
  on-change = ->
    props.update -> not props.deref!

  # got a label?
  el = DOM.input {ref, value:props.deref!, type:\checkbox, checked:props.deref!, on-change, title, class-name}
  if label
    DOM.label {title} [ el, DOM.span void " #label" ]
  else
    el
