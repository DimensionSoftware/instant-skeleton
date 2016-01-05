
# destructure only what's needed

require! {
  uuid
  \./mixins
  \./Header
  \./Footer
  \./TodoList
}

# PublicPage
PublicPage = component page-mixins, ({{path,locals,session,everyone}:props}) ->
  [name, todo-count] =
    (session.get \name) or \Anonymous
    if everyone.get \todos then that.count! else 0

  DOM.div key: \PublicPage class-name: \PublicPage, [
    Header do
      key:          \header
      name:         name
      after-save:   -> sync-everyone!
      save-cursor:  everyone.cursor \todos
      title-cursor: locals.cursor \current-title
    # render everyone's todos
    DOM.h4 do
      key: \count
      title: 'Total # of TODOs'
      class-name: cx do
        hidden: todo-count is 0
      todo-count
    TodoList { # props
      key:     \todo-list
      todos:   everyone.cursor \todos
      visible: locals.cursor \visible
      search:  locals.cursor \search
      +show-name
      name: "TODO Items for Everyone"
      on-delete: (-> sync-everyone!), on-change:(-> sync-everyone!)
    }
    Link {key:\link href:R(\MyTodoPage)} 'Back →'
    Footer {key:\footer name, path, last-page:(session.get \lastPage)}
  ]

module.exports = ignore <[ titleCursor afterSave saveCursor ]> PublicPage
