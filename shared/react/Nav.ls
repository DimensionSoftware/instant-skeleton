
require! {
  \../routes
}

# destructure only what's needed
{label,input,span,a,nav,ul,li,small} = DOM

module.exports = component \Nav ({name, path, last-page}:props) ->
  # show all routes besides current
  nav do
    class-name: \nav
    label do
      class-name: \switch

      # hamburger menu (visible in mobile view)
      input do
        class-name: 'hamburger nofx'
        type:       \checkbox
      span do
        class-name: \fx
      span do
        class-name: \bg

      # page links inside
      ul do
        class-name: \items
        small void (name or \\u0001) # don't jank the dom
        routes.list
          .filter (-> it?1 isnt path)
          .map (route) ->
            li do
              key: route.0
              class-name: \route
              Link do
                href: (R route.0)
                "#{page-title route.0} →"

        # render last visited (sync'd across all sessions)
        if last-page
          li do
            class-name: \last-visited
            small void 'Last visited '
            Link do
              href: (R last-page)
              (page-title last-page)

function page-title
  it.replace /Page$/ ''
