
# destructure only what's needed
{div,footer,h4,code} = DOM

require! {
  \./Navigation
  \./LastVisited
}

# Footer
module.exports = component ({props}) ->
  footer void [
    Navigation {props}
    LastVisited {props} # sync'd across sessions

    div {class-name:\app-state} [
      # print entire app structure
      h4 void 'React App State'
      code void (JSON.stringify props.toJS!)
    ]
  ]
