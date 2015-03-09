
# Input
module.exports = component \Input (props, s={}) ->
  auto-focus = s.ref is \focus
  on-change  = (e) ->
    v = e.current-target.value
    if v?0 isnt ' ' # disallow space as first char
      props.update -> v

  DOM.input {
    auto-focus
    on-change
    key:         s.key
    ref:         s.ref
    value:       props.deref!
    type:        \text
    placeholder: s.placeholder
    title:       s.title
    class-name:  s.class-name
  }
