
# Input
module.exports = component ({props,key,ref,placeholder,title,class-name}) ->
  auto-focus = ref is \focus
  on-change  = (e) ->
    v = e.current-target.value
    if v?0 isnt ' ' # disallow space as first char
      props.update -> v

  DOM.input {key, ref, auto-focus, value:(props.deref!), type:\text, placeholder, on-change, title, class-name}
