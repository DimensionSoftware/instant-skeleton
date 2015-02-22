
# Input
module.exports = component common-mixins, ({props,ref,placeholder}) ->
  auto-focus = ref is \focus
  on-change  = ->
    v = it.current-target.value
    if v?0 isnt ' ' # disallow space as first char
      props.update -> v

  DOM.input {ref, auto-focus, value:(props.deref!), type:\text, placeholder, on-change}
