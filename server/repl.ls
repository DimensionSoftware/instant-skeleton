require! {
  \LiveScript
  events: EventEmitter
}

global <<< require \prelude-ls

global.cl = console.log
global.cw = console.warn
global.React = require \react/addons
global.async = require \async
global.Promise = require \bluebird
global.moment = require \moment
global.accounting = require \accounting
global.shared = require '../shared/helpers'
global.__ = require \lodash
global.debounce = __.debounce
global.events = new EventEmitter

global.reload = (m) ->
  paths = require.resolve m
  if is-type \String, paths
    delete require.cache[paths]
  else
    paths.for-each (p) -> delete require.cache[p]
  require m

# vim:fdm=indent
