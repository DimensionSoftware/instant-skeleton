
require! {
  react: {create-factory}:React
  classnames: cx
  omniscient: component
  immutable: Immutable
  omnipotent: {{ignore}:decorator}
  'react-router-component': {Pages,Page,NotFound,NavigatableMixin}:Router
  '../routes': {R}:routes
  #'react-async': {Mixin}
  \./mixins
}
page-mixins = [mixins.initial-state-async, NavigatableMixin, mixins.focus-input, mixins.scroller] # common Page mixins

# factories
Location  = create-factory Router.Location
Locations = create-factory Router.Locations

# statics for ease-of-use DSL in Pages
global <<< {R, React, cx, Router, page-mixins, component, Immutable, ignore}
global.DOM = React.DOM
global.Link = create-factory Router.Link


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
  Locations { class-name:\Page, path: (props.get \path) }, ...locations-for-routes
