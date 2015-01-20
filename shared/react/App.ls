
require! {
  immstruct
  react: {create-element}:React
  omniscient: component
  'react-router-component': {Location,Locations,Pages,Page,NotFound,Link,NavigatableMixin}:Router
  '../routes'
}

# Dynamically load components referenced in routes.list.
pages = routes.list.reduce ((namespace, route) ->
  namespace[route.0] = require "./#{route.0}"
  namespace), {}

module.exports = component ({cursor}:props) ->

  location = (route) ->
    name = route.0
    Location { key: name, ref: name, path: route.1, handler: pages[name], props:cursor }

  locations-for-routes = routes.list
    .filter (-> pages[it.0])
    .map    (-> location it)
  Locations { path: cursor.get \path } [
    ...locations-for-routes
  ]
