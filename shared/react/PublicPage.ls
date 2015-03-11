
# destructure only what's needed

require! {
  uuid
  \./mixins
  \./Header
  \./Footer
  \./TodoList
}

# PublicPage
module.exports = component \PublicPage page-mixins, ({{path,locals,session,everyone}:props}) ->
  name = (session.get \name) or \Anonymous

  DOM.div class-name: \PublicPage, [
    Header (locals.cursor \current-title), {after-save:(-> sync-everyone!), save-cursor:(everyone.cursor \todos)}

    # render everyone's todos
    TodoList { # props
      todos: (everyone.cursor \todos),
      visible: (everyone.cursor \visible)
    }, { # statics
      +show-name
      name:      'Public\'s TODO',
      on-delete: (-> sync-everyone!), on-change:(-> sync-everyone!)
    }
    Link {href:R(\MyTodoPage)} 'Add My items →'
    Footer {name, path, last-page:(session.get \lastPage)}
  ]

