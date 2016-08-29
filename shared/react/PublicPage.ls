
# destructure only what's needed

require! {
  \react-rethinkdb : {r}
  uuid
  \./mixins
  \./Header
  \./Footer
  \./TodoList
}

# PublicPage
PublicPage = component page-mixins, ({RethinkSession,locals,session,everyone}) ->
  [name, path, todo-count] =
    (session.get \name) or \Anonymous
    @context.router.get-path!
    if everyone then that.count! else 0

  DOM.div key: \PublicPage class-name: \PublicPage, [
    Header do
      key:          \header
      name:         name
      after-save:   (key, todo) ->
        RethinkSession.run-query <| # save in rethinkdb
          r.table \everyone
            .insert todo
            #.update updated: r.now!
      save-cursor:  everyone
      title-cursor: locals.cursor \current-title
    # render everyone's todos
    DOM.h4 do
      key: \count
      title: 'Total # of TODOs'
      class-name: cx do
        hidden: todo-count is 0
      todo-count
    TodoList {
      key:     \todo-list
      todos:   everyone
      visible: locals.cursor \visible
      search:  locals.cursor \search
      +show-name
      name: "TODO Items for Everyone"
      on-delete: (key) ->
        RethinkSession.run-query <| # save in rethinkdb
          r.table \everyone .delete key
      on-change: (key, todo) ->
        RethinkSession.run-query <|
          r.table \everyone
            .get todo.id
            .update todo
    }
    Link {key:\link href:R(\MyTodoPage)} 'Back →'
    Footer {key:\footer name, path}
  ]

module.exports = ignore <[ titleCursor afterSave saveCursor ]> PublicPage
