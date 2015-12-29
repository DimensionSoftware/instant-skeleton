
# destructure only what's needed

require! {
  \./mixins
  \./Check
  \./Header
  \./Footer
  \./TodoList
}

# MyTodoPage
MyTodoPage = component page-mixins, ({{path,locals,session,everyone}:props}) ->
  [name, todo-count] =
    session.get \name
    if session.get \todos then that.count! else 0

  DOM.div class-name: \MyTodoPage, [
    Header do
      key:          \header
      name:         name
      after-save:   -> sync-session!
      save-cursor:  session.cursor \todos
      title-cursor: locals.cursor \current-title
    # render my session todos
    DOM.h4 void todo-count
    TodoList do # props
      todos:     session.cursor \todos
      visible:   locals.cursor \visible
      search:    locals.cursor \search
      name:      "#{if name then "#name's TODO" else 'My TODO'}"
      on-delete: -> sync-session!
      on-change: -> sync-session!
    Link {href:R(\PublicPage)} 'Public →'
    Footer {name, path, last-page:(session.get \lastPage)}
  ]

module.exports = ignore <[ titleCursor afterSave saveCursor ]> MyTodoPage
