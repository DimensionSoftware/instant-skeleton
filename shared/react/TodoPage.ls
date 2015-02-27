
# destructure only what's needed
{header,a,input,form,ol,li,div,button,h2,small,label} = DOM

require! {
  co
  uuid
  \./Input
  \./Check
  \./Footer
}

# TodoPage
module.exports = component page-mixins, ({props}) ->

  # TodoList
  todo-list = component ({name, prefs, props, on-delete, on-change, show-name}) ->
    cn      = -> cx {active:visible is it}
    visible = (prefs.get \visible) or \all
    show    = (active) ->
      prefs.update \visible -> active
      sync-session!

    # FIXME hack until "for x from y!" es6 iterators
    # https://github.com/gkz/LiveScript/issues/667
    list = (Object.keys props.toJS!).filter (k) ->
      c  = props.get-in [k, \completed]
      switch visible
        | \all       => true
        | \active    => !c
        | \completed => c

    # todo list
    ol void [
      h2 void name
      if list.length
        for let key in list
          li {key} [
            Check {props:(props.cursor [key, \completed]), on-change}
            Input {props:(props.cursor [key, \title])}
            div {
              title: \Delete
              class-name: \delete,
              on-click: ->
                if confirm 'Permanently delete?'
                  props.delete key
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

  paths = {
    title:        [\locals, \current-title]
    is-public:    [\session, \is-public]
    public-todo:  [\public, \todos]
    session-todo: [\session, \todos]
  }
  name = props.get-in [\session, \name]
  is-public = props.cursor paths.is-public

  div class-name: \TodoPage, [
    header void [
      form {on-submit:-> it.prevent-default!} [
        div {class-name:\clip} [
          Input {key:\focus, ref:\focus, props:(props.cursor paths.title), placeholder:'Add an Item ...'}
        ]
        small void [ Check {props:is-public, label:'Public', title:'Seen by Everyone'} ]
        button {on-click:-> # save session or public
          if title = props.get-in paths.title
            path = if is-public.deref! then paths.public-todo else paths.session-todo
            date = new Date!get-time!
            todo = {title, -completed, name, date}
            props
              ..cursor path .set uuid.v4!, Immutable.fromJS todo              # add
              ..set-in paths.title, ''                                        # reset ui
            if path is paths.public-todo then sync-public! else sync-session! # save
        }, \Save
      ]
    ]

    # render my session todos
    todo-list {
      name:      "#{if name then name else 'My TODO'}"
      prefs:     props.cursor [\session, \todos, \my-visible]
      props:     props.cursor paths.session-todo
      on-delete: (-> sync-session!)
      on-change: (-> sync-session!)
    }

    # render public todos
    todo-list {
      +show-name
      name:      \Public,
      prefs:     props.cursor [\session, \todos, \public-visible]
      props:     props.cursor paths.public-todo
      on-delete: (-> sync-public!), on-change:(-> sync-public!)
    }

    Footer {props}
  ]

