
# destructure only what's needed
{a,ol,li,div,h2} = DOM

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

  # todo list
  ol void [
    h2 void name
    if list.count!
      # FIXME hack until "for x of* y!" es6 iterators
      # https://github.com/gkz/LiveScript/issues/667
      h = list.entries!
      while h.next!value
        [key, value] = [that.0, that.1]
        li {key} [
          Check (todos.cursor [key, \completed]), {on-change}
          Input (todos.cursor [key, \title])
          div {
            title: \Delete
            class-name: \delete,
            on-click: ->
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
