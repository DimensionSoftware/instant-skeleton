
# Input
module.exports = component common-mixins, ({props,path,ref,placeholder}) ->
  auto-focus = ref is \focus
  on-change  = ->
    v = it.current-target.value
    if v?0 isnt ' ' # disallow space as first char
      props.update-in path, -> v

  DOM.input {ref, auto-focus, value:(props.get-in path), type:\text, placeholder, on-change}
