
# destructure only what's needed
{strong,div,hr,form,button,h1,label,input} = DOM

require! {
  \./Input
  \./Footer
}

# HomePage
module.exports = component \HomePage page-mixins, ({{path,locals,session,everyone}:props}) ->
  value = session.get \name

  on-click = ~>
    sync-session! # sync across sessions
    @navigate R(\TodoPage)

  div class-name: \HomePage,
    # allow name to be set
    h1 void if value then "Greetings #value!" else 'Hello! What\'s Your Name?'
    hr void
    form {on-submit:-> false} [
      Input (session.cursor \name), {ref:\focus, placeholder:'Your Name'}
      button {title:'Open multiple browsers to test', on-click} \Save
    ]
    Footer {path, last-page:(session.get \lastPage)}
