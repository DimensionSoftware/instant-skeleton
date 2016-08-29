
# destructure only what's needed
{strong,b,i,a,ol,li,div,h2} = DOM

require! {
  \./ActiveDate
  \./Input
  \./Check
}


# TodoList
TodoList = component \TodoList ({todos, visible, search, name, on-delete, on-change=->, show-name}) ->
  # figure visible todos from ui selection
  cn = -> cx {active:(visible.deref! or \all) is it}
  [show-only, save-edit] =
    (active) ->
      visible.update -> active
      window.scroll-to 0 0
    (e, key) ->
      cur = todos.update-in [key, \title], ->
        e.current-target.value
      on-change key, (cur.get key .toJS!)

  list = todos
    .to-ordered-map!
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
      (todo.get \title .index-of v) >= 0
    .sort (a, b) -> # reverse chron
      (b.get \date) - (a.get \date)

  # todo list
  ol {key: \ol} [
    Input {type:\search, key:\search cursor: search, tab-index: 1, placeholder: 'Search', results: 5, auto-save: \search, +spell-check}
    h2 key: \name, name
    if count = list.count!
      list.key-seq!map (key) ->
        show-date = if todos.has-in [key, \completed-at] then [key, \completed-at] else [key, \date]
        li {key} [
          Check {
            key:       "c-#key"
            cursor:    todos.cursor [key, \completed]
            on-change: -> # save completion
              cur = if it.deref!
                todos.update-in [key, \completed-at], -> new Date!get-time!
              else
                todos.delete-in [key, \completed-at]
              on-change key, (cur.get key .toJS!)
          }
          Input { # saves edits
            key: \title
            cursor: (todos.cursor [key, \title])
            on-blur:   -> save-edit it, key
            on-key-up: -> if it.key-code is 13 then save-edit it, key
            +spell-check
          }
          div {key:\fx class-name:\fx}
          ActiveDate {key: \date, cursor: (todos.cursor show-date), title:(todos.get-in [key, \name])} # author's name
          div {
            key: \delete
            title: \Delete
            class-name: \delete,
            on-click: ->
              if confirm 'Permanently delete?'
                todos.delete key
                if on-delete then on-delete key
          }, \x
        ]
    else
      li key:\placeholder, [ ]
    if search.deref!
      li do
        key: \results
        class-name: \results
        b {key: \b} count
        strong {key: \strong} " search result#{if count > 1 or count is 0 then \s else ''}"

    # filters
    div {key:\actions class-name:\actions} [
      a {key: \all on-click:(-> show-only \all), class-name:'nofx ' + cn \all} \All
      a {key: \active on-click:(-> show-only \active), class-name:'nofx ' + cn \active} \Active
      a {key: \completed on-click:(-> show-only \completed), class-name:'nofx ' + cn \completed} \Completed
    ]
  ]

module.exports = ignore <[ name onDelete onChange showName ]> TodoList
