
require! {
  react: {create-element}:React
  omniscient: component
  immutable: Immutable
  'react-router-component': {Location,Locations,Pages,Page,NotFound,Link,NavigatableMixin}:Router
  '../routes': {R}:routes
  'react-async': {Mixin}
  \./mixins
}
common-mixins = [Mixin, mixins.initial-state-async, NavigatableMixin, mixins.focus-input] # common Page mixins

# statics for ease-of-use DSL in Pages
global <<< {R, React, Router, common-mixins, component, Immutable}
global.DOM = React.DOM
global.Link = Router.Link


# Dynamically load components referenced in routes.list.
pages = routes.list.reduce ((namespace, route) ->
  namespace[route.0] = require "./#{route.0}"
  namespace), {}


module.exports = component (props) ->
  location = (route) ->
    name = route.0
    Location { key:name, ref:name, path:route.1, handler:pages[name], props }

  locations-for-routes = routes.list
    .filter (-> pages[it.0])
    .map    (-> location it)

  # render page
  Locations { path: props.get \path } [
    ...locations-for-routes
  ]
