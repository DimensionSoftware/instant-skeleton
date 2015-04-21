
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
    +controlled
    type: \text
    on-focus: -> if auto-focus then it.current-target.select! # select, too!
  } <<< statics

  # how to bind this input
  v = props.deref!
  if options.controlled
    options.value = v
  else # only default
    options.default-value = v

  DOM.input options
