
require! {
  \./Footer
  \./LastVisited
}

# destructure only what's needed
{DOM:{small,strong,div,hr,form,button,h1,h2,label,input,code}} = React
{NavigatableMixin,Link} = Router

# HomePage
module.exports = component middleware, ({props}) ->
  key       = \greetings
  path      = [\session, key]
  update    = (val) -> props.update-in path, -> val
  value     = props.get-in path
  on-change = (e) ->
    update e.current-target.value

  div class-name: \HomePage,
    # allow greetings to be set
    h1 void (value or 'Hello! What\'s Your Name?')
    hr void
    form {on-submit:-> false} [
      label void [
        strong void \Greetings
        input {key, value, on-change, +auto-focus, type:\text, placeholder:'Your Name'}
      ]
      # sync greetings across sessions
      button {title:'Open multiple browsers to test', on-click:(-> session-sync key, props.get-in path)} \Save
    ]

    # navigation sync'd across sessions
    div void
      Link {href:R(\HelloPage)}, "HelloPage →"
    LastVisited {props}
    Footer {props}
