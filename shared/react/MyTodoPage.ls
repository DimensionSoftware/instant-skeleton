
# destructure only what's needed

require! {
  \./mixins
  \./Input
  \./Check
  \./Header
  \./Footer
  \./TodoList
}

# MyTodoPage
module.exports = component \MyTodoPage page-mixins, ({{path,locals,session,everyone}:props}) ->
  name = session.get \name

  DOM.div class-name: \MyTodoPage, [
    Header (locals.cursor \current-title), {after-save:(-> sync-session!), save-cursor:(session.cursor \todos)}

    # render my session todos
    TodoList { # props
      todos:   (session.cursor \todos),
      visible: (session.cursor \visible)
    }, { # statics
      name:      "#{if name then "#name's TODO" else 'My TODO'}"
      on-delete: (-> sync-session!)
      on-change: (-> sync-session!)
    }
    Link {href:R(\PublicPage)} 'Add items for Everyone →'
    Footer {name, path, last-page:(session.get \lastPage)}
  ]

