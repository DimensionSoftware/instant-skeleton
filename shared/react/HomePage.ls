
# destructure only what's needed
{DOM:{small,div,button,h1,h2,label,input,code}} = React
{NavigatableMixin,Link} = Router


# HomePage
module.exports = component middleware, ({props}) ->
  key       = \greeting
  path      = [\locals, key]
  update    = (val) -> props.update-in path, -> val
  value     = props.get-in path
  on-change = (e) ->
    update e.current-target.value

  div class-name: \HomePage,
    # allow greeting to be set
    h1 void value
    label void \Greeting: [
      input {key, value, on-change}
    ]

    # sync greeting across sessions
    button {title:'Open multiple browsers to test', on-click:(-> sync-session key, props.get-in path)} 'Sync to Session'

    # navigation sync'd across sessions
    div void "Last visited #{props.get-in [\session, \lastPage] or ''}"
    div void
      Link {href:R(\HelloPage)}, 'Go to HelloPage'

    # print entire app structure
    h2 void 'React App Structure:'
    small void
      code void (JSON.stringify props.toJS!)
