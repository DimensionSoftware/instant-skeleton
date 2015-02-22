
# Checkbox
module.exports = component common-mixins, ({props,ref,placeholder,label}) ->
  on-change = ->
    props.update -> not props.deref!

  # got a label?
  el = DOM.input {ref, value:props.deref!, type:\checkbox, checked:props.deref!, on-change}
  if label
    DOM.label void [ el, DOM.span void " #label" ]
  else
    el
