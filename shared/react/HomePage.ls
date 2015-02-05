
require! {
  \./Footer
  \./Navigation
  \./LastVisited
}

# destructure only what's needed
{DOM:{small,strong,div,hr,form,button,h1,h2,label,input,code}} = React
{Link} = Router

# HomePage
module.exports = component common-mixins, ({props}) ->
  key       = \greetings
  path      = [\session, key]
  update    = (val) -> props.update-in path, -> val
  value     = props.get-in path
  on-change = (e) ->
    v = e.current-target.value
    unless v?0 is ' ' then update v # disallow space first char

  div class-name: \HomePage,
    # allow greetings to be set
    h1 void (value or 'Hello! What\'s Your Name?')
    hr void
    form {on-submit:-> false} [
      label void [
        strong void \Greetings
        input {ref:\focus, key, value, on-change, +auto-focus, type:\text, placeholder:'Your Name'}
      ]
      # sync greetings across sessions
      button {title:'Open multiple browsers to test', on-click:(-> session-sync key, props.get-in path)} \Save
    ]

    Navigation {props}
    LastVisited {props} # sync'd across sessions
    Footer {props}
