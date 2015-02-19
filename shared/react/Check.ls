
# Checkbox
module.exports = component common-mixins, ({props,path,ref,placeholder,label}) ->
  on-change = ->
    props.update-in path, -> !props.get-in path

  # got a label?
  el = DOM.input {ref, value:(props.get-in path), type:\checkbox, checked:(props.get-in path), on-change}
  if label
    DOM.label void [ el, DOM.span void " #label" ]
  else
    el
