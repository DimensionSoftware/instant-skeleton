
# destructure only what's needed
{input,form,ol,li,div,button,h1,h2,small,label} = DOM

require! {
  co
  uuid
  \./Input
  \./Check
  \./Footer
}

todo-list = component ({props, on-delete}) ->
  ol void [
    # FIXME hack until "for x from y!" es6 iterators
    # https://github.com/gkz/LiveScript/issues/667
    if l = props?toJS!
      for let k in Object.keys l
        li void [
          Check {props:(props.cursor [k, \completed])}
          Input {props:(props.cursor [k, \title])}
          div {
            title: \Delete
            class-name: \delete,
            on-click: ->
              if confirm 'Permanently delete?'
                props.delete k
                if on-delete then on-delete!
          }, \x
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
      Input {ref:\focus, props:(props.cursor paths.title), placeholder:'Add an Item ...', class-name:\indent}
      small void [
        Check {props:is-public, label:'Public', title:'Seen by Everyone'}
      ]
      button {on-click} \Save
    ]

    # render my session todos
    todo-list {props:(props.cursor paths.session-todo), on-delete:-> sync-session!}

    # render public todos
    h2 void 'Everyone\'s TODO'
    todo-list {props:(props.cursor paths.public-todo), on-delete:-> sync-public!}
    Footer {props}
  ]

