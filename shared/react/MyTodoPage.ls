
# destructure only what's needed

require! {
  \./mixins
  \./Check
  \./Header
  \./Footer
  \./TodoList
}

# MyTodoPage
MyTodoPage = component page-mixins, ({locals,session}) ->
  [name, path, todo-count] =
    session.get \name
    @context.router.get-path!
    if session.get \todos then that.count! else 0

  DOM.div key: \MyTodoPage class-name: \MyTodoPage, [
    Header do
      key:          \header
      name:         name
      save-cursor:  session.cursor \todos
      title-cursor: locals.cursor \current-title
    # render my session todos
    DOM.h4 do
      key: \count
      title: 'Total # of TODOs'
      class-name: cx do
        hidden: todo-count is 0
      todo-count
    TodoList do
      key: \todo-list
      todos:     session.cursor \todos
      visible:   locals.cursor \visible
      search:    locals.cursor \search
      name:      "#{if name then "#name's TODO" else 'My TODO'}"
    Link {key: \link, href:R(\PublicPage)} 'Public →'
    Footer {key: \footer, name, path}
  ]

module.exports = ignore <[ titleCursor afterSave saveCursor ]> MyTodoPage
