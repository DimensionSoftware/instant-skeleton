
# Input
module.exports = component \Input (props, statics={}) ->
  auto-focus = statics.ref is \focus
  on-change  = (e) ->
    v = e.current-target.value
    if v?0 isnt ' ' # disallow space as first char
      props.update -> v

  options = {
    auto-focus
    on-change
    on-focus: -> if auto-focus then it.current-target.select! # select, too!
    value:       props.deref!
    type:        \text
    placeholder: statics.placeholder
  } <<< statics

  DOM.input options
