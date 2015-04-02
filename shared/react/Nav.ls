
require! {
  \../routes
}

# destructure only what's needed
{label,input,span,a,nav,ul,li,small} = DOM

module.exports = component \Nav ({name, path, last-page}:props) ->
  # show all routes besides current
  nav void [
    label {class-name:\switch} [
      # hamburger menu (visible in mobile view)
      input {class-name: 'hamburger nofx', type:\checkbox}
      span {class-name: 'fx'}
      span {class-name: 'bg'}
      # items inside
      ul void [
        small void name
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
  ]

function page-title
  it.replace /Page$/ ''
