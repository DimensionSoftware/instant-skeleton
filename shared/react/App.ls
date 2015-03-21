
require! {
  'react/addons': {create-element,{class-set:cx}:addons}:React
  omniscient: component
  immutable: Immutable
  'react-router-component': {Location,Locations,Pages,Page,NotFound,Link,NavigatableMixin}:Router
  '../routes': {R}:routes
  'react-async': {Mixin}
  \./mixins
}
page-mixins = [Mixin, mixins.initial-state-async, NavigatableMixin, mixins.focus-input, mixins.scroll] # common Page mixins

# statics for ease-of-use DSL in Pages
global <<< {R, React, cx, Router, page-mixins, component, Immutable}
global.DOM = React.DOM
global.Link = Router.Link


# Dynamically load components referenced in routes.list.
pages = routes.list.reduce ((namespace, route) ->
  namespace[route.0] = require "./#{route.0}"
  namespace), {}


module.exports = component \App (props) ->
  location = (route) ->
    name = route.0
    page-props = { # export page cursors
      path: props.get \path
      locals: props.cursor \locals
      session: props.cursor \session
      everyone: props.cursor \everyone
    }
    Location { key:name, ref:name, path:route.1, handler:pages[name], props:page-props }

  locations-for-routes = routes.list
    .filter (-> pages[it.0])
    .map    (-> location it)

  # render page
  Locations { class-name:\Page, path: props.get \path } [
    ...locations-for-routes
  ]
