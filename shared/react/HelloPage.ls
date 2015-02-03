
require! {
  \./Footer
  \./LastVisited
}

# destructure only what's needed
{NavigatableMixin,Link} = Router
{DOM:{div,h1,h4,footer,small,code}} = React


# HelloPage
module.exports = component middleware, ({props}) ->
  geo = ->
    if props.get-in <[locals geo]>
      "#{that.get \city}, #{that.get \region} (#{that.get \country})"

  div class-name: \HelloPage,
    h1 void "Hello #{props.get-in [\session, \greetings] or \World}, From #{geo! or \Earth}!"
    Link {href:R(\HomePage)}, 'HomePage →'

    # navigation sync'd across sessions
    LastVisited {props}
    Footer {props}
