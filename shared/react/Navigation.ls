
require! {
  \../routes
}

# destructure only what's needed
{div,small} = DOM

module.exports = component \Navigation ({name, path, last-page}:props) ->
  # show all routes besides current
  div class-name: \navigation, [
    small void name
    routes.list
      .filter (-> it?1 isnt path)
      .map (route) ->
        div void [
          Link {href:R(route.0)}, "#{page-title route.0} →"
        ]
    if last-page
      div {class-name:\last-visited} [
        # render last visited (sync'd across all sessions)
        small void 'Last visited '
        Link {href:R(last-page)} page-title(last-page)
      ]
    else
      div!
  ]

function page-title
  it.replace /Page$/ ''
