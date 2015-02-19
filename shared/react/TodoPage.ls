
# destructure only what's needed
{hr,input,form,ol,li,div,button,h1,label} = DOM

require! {
  co
  uuid
  \./Input
  \./Check
  \./Footer
}

# TodoPage
module.exports = component common-mixins, ({props}) ->
  path = {
    greeting: [\session, \greetings]
    title: [\locals, \current-title]
    todos: [\session, \todos]
    is-public: [\session, \is-public]
  }
  [todos, greeting] = [(props.get-in path.todos), (props.get-in path.greeting)]

  on-click = ->
    # TODO save session or public
    if title = props.get-in path.title
      cur = default-in props, path.todos, uuid.v4!, {title, -completed}
      session-sync \todos, cur.toJS! # save
      props.set-in path.title, ''    # reset

  div class-name: \TodoPage, [
    h1 void "#{if greeting then greeting + '\'s ' else ''}TODOs"
    form {on-submit:-> it.prevent-default!} [
      Input {props, path:path.title, placeholder:'Add an Item ...'}
      button {on-click} \Save
      div void [
        Check {props, path:path.is-public, label: 'is public?'}
      ]
    ]
    hr void
    # render todos
    ol void [
      if todos?toJS!
        for k in Object.keys that
          li void [
            Check {props, path:path.todos ++ [k, \completed]}
            Input {props, path:path.todos ++ [k, \title]}
          ]
    ]
    Footer {props}
  ]

