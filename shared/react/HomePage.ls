
# destructure only what's needed
{strong,div,hr,form,button,h1,label,input} = DOM

require! {
  \./Input
  \./Footer
}

# HomePage
module.exports = component page-mixins, ({locals,session}) ->
  [name, path] =
    session.get \name
    @context.router.get-path!

  on-click = (e) ~>
    e.prevent-default!
    @navigate <| R \MyTodoPage
    sync-session! # sync across sessions

  # allow name to be set
  div do
    class-name: \HomePage
    h1 void if name then "Greetings #name!" else 'Hello! What\'s\u00a0Your\u00a0Name?'
    hr void
    form do
      on-submit: (.prevent-default!)
      Input do
        cursor:      session.cursor \name
        ref:         \focus
        placeholder: 'Your Name'
        spell-check: true
        auto-focus:  true
      button do
        title:    'Open multiple browsers to test'
        on-click: on-click
        \Save

    Footer {name, path, last-page: (session.get \lastPage)}
