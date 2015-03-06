
# destructure only what's needed
{strong,div,hr,form,button,h1,label,input} = DOM

require! {
  \./Input
  \./Footer
}

# HomePage
module.exports = component page-mixins, ({props}) ->
  key    = \name
  path   = [\session, key]
  value  = props.get-in path

  on-click = ~>
    sync-session! # sync across sessions
    @navigate R(\TodoPage)

  div class-name: \HomePage,
    # allow name to be set
    h1 void if value then "Greetings #value!" else 'Hello! What\'s Your Name?'
    hr void
    form {on-submit:-> false} [
      Input {props:(props.cursor path), ref:\focus, placeholder:'Your Name'}
      button {title:'Open multiple browsers to test', on-click} \Save
    ]
    Footer {props}
