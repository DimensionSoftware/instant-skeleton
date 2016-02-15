
require! {
  react: {create-factory}:React
  classnames: cx
  omniscient: component
  immutable: Immutable
  omnipotent: {{ignore}:decorator}
  'react-rethinkdb': {Session, r, QueryRequest, DefaultMixin, PropsMixin}
  'react-router-component': {Pages,Page,NotFound,NavigatableMixin}:Router
  '../routes': {R}:routes
  'react-async': {Mixin}
  \./mixins
}
page-mixins = [mixins.rethinkdb, NavigatableMixin, mixins.focus-input, mixins.scroller] # common Page mixins

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
  rethink-session = new Session!
    ..connect do
      host: props.get-in [\locals \domain]
      port: props.get-in [\locals \port]
      path: '/db'
      secure: false
    ..once-done-loading ~>
      # XXX on server, response already sent without session
      #session = (props.get-in [\session]).toJS!

  location = (route) ->
    name = route.0
    page-props = do # export page cursors
      path:     props.get \path
      locals:   props.cursor \locals
      session:  props.cursor \session
      everyone: props.cursor \everyone
    Location { rethink-session, key:name, ref:name, path:route.1, handler:pages[name], props:page-props }

  locations-for-routes = routes.list
    .filter (-> pages[it.0])
    .map    (-> location it)

  # render page
  Locations { class-name:\Page, path: (props.get \path) }, ...locations-for-routes
