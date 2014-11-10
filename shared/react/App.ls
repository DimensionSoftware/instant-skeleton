
require! {
  react: {DOM}:React
  'react-router': {DefaultRoute,NotFoundRoute,Route,Routes,Link}:Router

  '../routes'
}

# Dynamically load components referenced in routes.list.
pages = routes.list |> fold ((namespace, route) ->
  c = try
    require "./#{route.0}"
  catch
    console?warn "Could not load #{route.0}", e
  namespace[route.0] = c if c
  namespace), {}


# XXX - might want to do this manually instead of automatically if using react-router and nesting
module.exports = Routes location: \history,
  (pages |> obj-to-pairs |> map (([name, component]) -> Route path: routes.r(name), handler: component))

# https://github.com/rackt/react-router/issues/57
# https://github.com/rackt/react-router/pull/181
