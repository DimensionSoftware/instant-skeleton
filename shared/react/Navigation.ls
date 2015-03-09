
require! {
  \../routes
}

# destructure only what's needed
{div,small} = DOM

module.exports = component \Navigation ({path, last-page}:props) ->
  # show all routes besides current
  div class-name: \navigation, [
    routes.list
      .filter (-> it.1 isnt path)
      .map (route) ->
        div void [
          Link {href:R(route.0)}, "#{route.0.replace /Page$/ ''} →"
        ]
    if last-page
      div {class-name:\last-visited} [
        # render last visited (sync'd across all sessions)
        small void 'Last visited '
        Link {href:R(last-page)} last-page
      ]
    else
      div!
  ]
