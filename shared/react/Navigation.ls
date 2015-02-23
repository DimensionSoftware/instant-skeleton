
require! {
  \../routes
}

# destructure only what's needed
{div,small} = DOM

# Footer
module.exports = component ({props}) ->
  # show all routes besides current
  path = props.get \path
  div class-name: \Navigation, [
    routes.list
      .filter (-> it.1 isnt path)
      .map (route) ->
        div void [
          Link {href:R(route.0)}, "#{route.0.replace /Page$/ ''} →"
        ]
  ]
