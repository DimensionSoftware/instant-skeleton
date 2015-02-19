
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
global.default-in = (props, path, key, value) ->
  test = props.get-in path
  if test
    test.set key, Immutable.fromJS value
  else # create
    props.update-in path, -> Immutable.fromJS {"#key":value}
      .get-in path


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
