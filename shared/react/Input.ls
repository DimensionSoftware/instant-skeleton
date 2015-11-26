
# Input
module.exports = ignore <[ focus ]>, component \Input ({cursor}:props) ->
  auto-focus = props.ref is \focus or props.auto-focus
  on-change  = (e) ->
    v = e.current-target.value
    if v?0 isnt ' ' # disallow space as first char
      cursor.update -> v

  options = {
    auto-focus
    on-change
    +controlled
    type: \text
    on-focus: -> if auto-focus then it.current-target.select! # select, too!
  } <<< props

  # how to bind this input
  v = cursor.deref!
  if options.controlled
    options.value = v
  else # only default
    options.default-value = v

  DOM.input options
