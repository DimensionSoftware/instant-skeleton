
# destructure only what's needed
{a,ol,li,span,div,h2} = DOM

require! {
  \./Input
  \./Check
}

# TodoList
module.exports = component \TodoList ({todos,visible}:props, {name, on-delete, on-change, show-name}) ->
  # figure visible todos from ui selection
  cn   = -> cx {active:visible.deref! is it}
  show = (active) ->
    visible.update -> active
    sync-session!
  # show visible todos only
  list = todos.filter (todo) ->
    c = todo.get \completed
    switch visible.deref! or \all
      | \all       => true
      | \active    => !c
      | \completed => c
  save-edit = (e, key) ->
    todos.update-in [key, \title], ->
      on-change!
      e.current-target.value

  # todo list
  ol void [
    h2 void name
    if list.count!
      # FIXME hack until "for x of* y!" es6 iterators
      # https://github.com/gkz/LiveScript/issues/667
      h = list.entries!
      while h.next!value
        let key = that.0
          title = todos.get-in [key, \name]
          li {key} [
            Check (todos.cursor [key, \completed]), {on-change}
            Input (todos.cursor [key, \title]), { # save edits
              on-blur:   -> save-edit it, key
              on-key-up: -> if it.key-code is 13 then save-edit it, key
            }
            if show-name then span {title} title
            div {
              title: \Delete
              class-name: \delete,
              on-click: ->
                console.log key
                if confirm 'Permanently delete?'
                  todos.delete key
                  if on-delete then on-delete!
            }, \x
          ]
    else
      li void [ div void '(empty)' ]

    # filters
    div {class-name:\actions} [
      a {on-click:(-> show \all), class-name:(cn \all)} \All
      a {on-click:(-> show \active), class-name:(cn \active)} \Active
      a {on-click:(-> show \completed), class-name:(cn \completed)} \Completed
    ]
  ]
