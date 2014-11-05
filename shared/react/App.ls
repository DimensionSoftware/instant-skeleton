
require! {
  react: {DOM}:React
  'react-router': {DefaultRoute,NotFoundRoute,Route,Routes,Link}:Router

  '../routes'
}


# Dynamically load components referenced in routes.list.
pages = routes.list |> fold ((namespace, route) ->
  c = try
    React.create-factory(require "./#{route.0}")
  catch
    console?warn "Could not load #{route.0}", e
  namespace[route.0] = c if c
  namespace), {}

module.exports = React.create-class {
  display-name: \App

  location: (route) ->
    name = route.0
    pages[name]

  render: ->
    #locations-for-routes = routes.list |> filter (-> pages[it.0]) |> map (~> @location it)
    DOM.div void 'Hello from app!'
}
