
# destructure only what's needed
{strong,div,hr,form,button,h1,label,input} = DOM

require! {
  \./Input
  \./Footer
  '../routes': {R}
}

# HomePage
module.exports = component common-mixins, ({props}) ->
  key    = \greetings
  path   = [\session, key]
  value  = props.get-in path

  on-click = ~>
    sync-session! # sync across sessions
    @navigate R(\TodoPage)

  div class-name: \HomePage,
    # allow greetings to be set
    h1 void if value then "#key #value!" else 'Hello! What\'s Your Name?'
    hr void
    form {on-submit:-> false} [
      label void [
        Input {props:(props.cursor path), ref:\focus, placeholder:'Your Name'}
        button {title:'Open multiple browsers to test', on-click} \Save
      ]
    ]
    Footer {props}
