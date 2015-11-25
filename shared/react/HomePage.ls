
# destructure only what's needed
{strong,div,hr,form,button,h1,label,input} = DOM

require! {
  \./Input
  \./Footer
}

# HomePage
module.exports = component \HomePage page-mixins, ({{path,locals,session,everyone}:props}) ->
  name = session.get \name

  on-click = ~>
    sync-session! # sync across sessions
    @navigate (R \MyTodoPage)

  # allow name to be set
  div do
    class-name: \HomePage

    h1 void if name then "Greetings #name!" else 'Hello! What\'s\u00a0Your\u00a0Name?'
    hr void

    form do
      on-submit: -> it.prevent-default!
      Input {cursor:(session.cursor \name), ref:\focus, placeholder:'Your Name', +spell-check, -controlled}

      button do
        title:    'Open multiple browsers to test'
        on-click: on-click
        \Save

    Footer {name, path, last-page: (session.get \lastPage)}
