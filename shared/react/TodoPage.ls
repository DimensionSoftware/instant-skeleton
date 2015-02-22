
# destructure only what's needed
{hr,input,form,ol,li,div,button,h1,h2,small,label} = DOM

require! {
  co
  uuid
  \./Input
  \./Check
  \./Footer
}

todo-list = component ({props}) ->
  ol void [
    if l = props?toJS!
      for k in Object.keys l
        li void [
          Check {props:(props.cursor [k, \completed])}
          Input {props:(props.cursor [k, \title])}
        ]
  ]

# TodoPage
module.exports = component common-mixins, ({props}) ->
  paths = {
    title: [\locals, \current-title]
    is-public: [\session, \is-public]
    public-todo:  [\public, \todos]
    session-todo: [\session, \todos]
  }
  greeting  = props.get-in [\session, \greetings]
  is-public = props.cursor paths.is-public

  on-click = -> # save session or public
    if title = props.get-in paths.title
      path = if is-public.deref! then paths.public-todo else paths.session-todo
      props
        ..cursor path .set uuid.v4!, Immutable.fromJS {title, -completed} # add
        ..set-in paths.title, ''                                          # reset ui
      if path is paths.public-todo then sync-public! else sync-session!   # save

  div class-name: \TodoPage, [
    h1 void "#{if greeting then "#greeting\'s " else 'My '}TODO"
    form {on-submit:-> it.prevent-default!} [
      Input {props:(props.cursor paths.title), placeholder:'Add an Item ...'}
      button {on-click} \Save
      small void [
        Check {props:is-public, label:'is public?'}
      ]
    ]
    hr void
    todo-list {props:(props.cursor paths.session-todo)} # render session todos
    h2 void 'Everyone\'s TODO'
    todo-list {props:(props.cursor paths.public-todo)}  # render public todos
    Footer {props}
  ]

