
require! {
  \../routes
}

# destructure only what's needed
{nav,ul,li,small} = DOM

module.exports = component \Navigation ({name, path, last-page}:props) ->
  # show all routes besides current
  nav class-name: \navigation, [
    small void name
    ul void [
      routes.list
        .filter (-> it?1 isnt path)
        .map (route) ->
          li void [
            Link {href:R(route.0)}, "#{page-title route.0} →"
          ]
      if last-page
        li {class-name:\last-visited} [
          # render last visited (sync'd across all sessions)
          small void 'Last visited '
          Link {href:R(last-page)} page-title(last-page)
        ]
    ]
  ]

function page-title
  it.replace /Page$/ ''
