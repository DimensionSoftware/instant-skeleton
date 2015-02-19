
# destructure only what's needed
{strong,div,hr,form,button,h1,label,input} = DOM

require! {
  \./Input
  \./Footer
}

# HomePage
module.exports = component common-mixins, ({props}) ->
  key    = \greetings
  path   = [\session, key]
  value  = props.get-in path

  div class-name: \HomePage,
    # allow greetings to be set
    h1 void if value then "#key #value!" else 'Hello! What\'s Your Name?'
    hr void
    form {on-submit:-> false} [
      label void [
        strong void \Greetings
        Input {props, path, ref:\focus, placeholder:'Your Name'}
        # sync greetings across sessions
        button {title:'Open multiple browsers to test', on-click:(-> session-sync key, props.get-in path)} \Save
      ]
    ]
    Footer {props}
