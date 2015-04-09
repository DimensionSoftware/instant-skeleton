
# destructure only what's needed
{a,ol,li,div,h2} = DOM

require! {
  \./ActiveDate
  \./Input
  \./Check
}

# TodoList
module.exports = component \TodoList ({todos,visible,search}:props, {name, on-delete, on-change, show-name}) ->
  # figure visible todos from ui selection
  cn = -> cx {active:(visible.deref! or \all) is it}
  show-only = (active) ->
    visible.update -> active
    window.scroll-to 0 0
    sync-session!

  list = todos
    .filter (todo) -> # show visible todos only
      return false unless todo.get # guard
      c = todo.get \completed
      switch visible.deref! or \all
        | \all       => true
        | \active    => !c
        | \completed => c
    .filter (todo) -> # show search-filtered todos only
      v = search.deref!
      return false unless todo.get # guard
      return true unless v         # guard
      ((todo.get \title).index-of v) >= 0

  save-edit = (e, key) ->
    todos.update-in [key, \title], ->
      on-change!
      e.current-target.value

  # todo list
  ol void [
    Input search, {placeholder: 'Search'}
    h2 void name
    if list.count!
      sorted = list.sort (a, b) -> (b.get \date) - (a.get \date) # reverse chron
        .entries!
      # FIXME hack until "for x of* y!" es6 iterators
      # https://github.com/gkz/LiveScript/issues/667
      while sorted.next!value
        let key = that.0
          show-date = if todos.has-in [key, \completed-at] then [key, \completed-at] else [key, \date]
          li {key} [
            Check (todos.cursor [key, \completed]), {on-change: ~>
              on-change if it.deref!
                todos.update-in [key, \completed-at], -> new Date!get-time!
              else
                todos.delete-in [key, \completed-at]}
            Input (todos.cursor [key, \title]), { # save edits
              on-blur:   -> save-edit it, key
              on-key-up: -> if it.key-code is 13 then save-edit it, key
            }
            div {class-name:\fx}
            ActiveDate (todos.cursor show-date), if show-name
              {title:(todos.get-in [key, \name])} # add author's name
            else
              {}
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
      li void [ div {class-name:\placeholder} '(empty)' ]

    # filters
    div {class-name:\actions} [
      a {on-click:(-> show-only \all), class-name:'nofx ' + cn \all} \All
      a {on-click:(-> show-only \active), class-name:'nofx ' + cn \active} \Active
      a {on-click:(-> show-only \completed), class-name:'nofx ' + cn \completed} \Completed
    ]
  ]
