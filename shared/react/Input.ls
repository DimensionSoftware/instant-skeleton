
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
    on-focus:      -> if auto-focus then it.current-target.select! # select, too!
    type:          \text
    tabindex:      statics.tabindex
    placeholder:   statics.placeholder
    default-value: props.deref!
  } <<< statics
  console.log statics.tabindex

  DOM.input options
