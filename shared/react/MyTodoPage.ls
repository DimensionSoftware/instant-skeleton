
# destructure only what's needed

require! {
  \./mixins
  \./Check
  \./Header
  \./Footer
  \./TodoList
}

# MyTodoPage
module.exports = component \MyTodoPage page-mixins, ({{path,locals,session,everyone}:props}) ->
  name = session.get \name

  DOM.div class-name: \MyTodoPage, [
    Header {title-cur:(locals.cursor \current-title), name}, {after-save:(-> sync-session!), save-cursor:(session.cursor \todos)}
    # render my session todos
    TodoList { # props
      todos:   (session.cursor \todos)
      visible: (locals.cursor \visible)
      search:  (locals.cursor \search)
      name:      "#{if name then "#name's TODO" else 'My TODO'}"
      on-delete: (-> sync-session!)
      on-change: (-> sync-session!)
    }
    Link {href:R(\PublicPage)} 'Public →'
    Footer {name, path, last-page:(session.get \lastPage)}
  ]

