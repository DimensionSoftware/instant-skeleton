
require! {
  \./Footer
  \./Navigation
  \./LastVisited
}

# destructure only what's needed
{Link} = Router
{DOM:{div,hr,h1,footer,small,code}} = React


# HelloPage
module.exports = component common-mixins, ({props}) ->
  geo = ->
    if props.get-in <[locals geo]>
      "#{that.get \city}, #{that.get \region} (#{that.get \country})"

  div class-name: \HelloPage,
    h1 void "Hello #{props.get-in [\session, \greetings] or \World}, From #{geo! or \Earth}!"
    hr void

    Navigation {props}
    LastVisited {props} # sync'd across sessions
    Footer {props}
