
require! {
  react: {create-factory}:React
  classnames: cx
  omniscient: component
  immutable: Immutable
  omnipotent: {{ignore}:decorator}
  'react-rethinkdb': {QueryRequest, Session, r}
  'react-router-component': {Pages,Page,NotFound,NavigatableMixin}:Router
  '../routes': {R}:routes
  'react-async': {Mixin}
  \./mixins
}
page-mixins = [mixins.rethinkdb, Mixin, mixins.initial-state-async, NavigatableMixin, mixins.focus-input, mixins.scroller] # common Page mixins

# factories
Location  = create-factory Router.Location
Locations = create-factory Router.Locations

# statics for ease-of-use DSL in Pages
global <<< {R, React, cx, Router, page-mixins, component, Immutable, ignore, r, QueryRequest}
global.DOM = React.DOM
global.Link = create-factory Router.Link
global.RethinkSession = void # singleton


# Dynamically load components referenced in routes.list.
pages = routes.list.reduce ((namespace, route) ->
  namespace[route.0] = require "./#{route.0}"
  namespace), {}

module.exports = component \App (props) ->
  [prod, secure, host] =
    \production is props.get-in [\locals \env]
    window?location.protocol is \https:
    props.get-in [\locals \domain]
  port = if window?location.port then that else (if secure then 443 else 80)
  unless global.RethinkSession then global.RethinkSession = new Session!
    ..connect {host, port, secure, path: '/db'}
    ..once-done-loading ~>
      # XXX on server, response already sent without session

  props.update \path -> path
  location = ([name, path]:route) ->
    [locals, session, everyone] =
      props.cursor \locals
      props.cursor \session
      props.cursor \everyone
    Location { props, locals, session, everyone, global.RethinkSession, path, key:name, ref:name, handler:pages[name] }

  locations-for-routes = routes.list
    .filter (-> pages[it.0])
    .map    (-> location it)

  # render page @ path
  path = props.get \path
  Locations { class-name:\Page, path }, ...locations-for-routes
