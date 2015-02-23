
# destructure only what's needed
{div,footer,h3,code} = DOM

require! {
  \./Navigation
  \./LastVisited
}

# Footer
module.exports = component ({props}) ->
  footer void [
    Navigation {props}
    LastVisited {props} # sync'd across sessions
  ]
