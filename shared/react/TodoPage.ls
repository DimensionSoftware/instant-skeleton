
# destructure only what's needed
{header,a,form,div,button,small,label} = DOM

require! {
  uuid
  \./mixins
  \./Input
  \./Check
  \./Footer
  \./TodoList
}

# TodoPage
module.exports = component \TodoPage page-mixins ++ mixins.scroll, ({{path,locals,session,everyone}:props}) ->
  [name, is-public] = [(session.get \name), (session.cursor \is-public)]

  div class-name: \TodoPage, [
    header void [
      form {on-submit:-> it.prevent-default!} [
        div {class-name:\clip} [
          Input (locals.cursor \current-title), {key:\focus, ref:\focus, placeholder:'Add an Item ...'}
        ]
        small void [ Check is-public, {label:'Public', title:'Seen by Everyone'} ]
        button {on-click:-> # save session or public
          if title = locals.get \current-title
            date = new Date!get-time!
            todo = {title, -completed, name, date}
            if is-public.deref!
              everyone.cursor \todos .set uuid.v4!, Immutable.fromJS todo # add
              sync-public!
            else
              session.cursor \todos .set uuid.v4!, Immutable.fromJS todo # add
              sync-session!
            locals.set \current-title, '' # reset ui
        }, \Save
      ]
    ]

    # render my session todos
    TodoList { # props
      todos:   (session.cursor \todos),
      visible: (session.cursor \visible)
    }, { # statics
      name:      "#{if name then name else 'My TODO'}"
      on-delete: (-> sync-session!)
      on-change: (-> sync-session!)
    }

    # render public todos
    TodoList { # props
      todos: (everyone.cursor \todos),
      visible: (everyone.cursor \visible)
    }, { # statics
      +show-name
      name:      \Public,
      on-delete: (-> sync-public!), on-change:(-> sync-public!)
    }

    Footer {path, last-page:(session.get \lastPage)}
  ]

