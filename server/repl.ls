require! {
  \livescript
  events: EventEmitter

  \./App
}

global <<< require \prelude-ls

global.cl = console.log
global.cw = console.warn
global.React = require \react/addons
global.events = new EventEmitter
global.App = App

global.reload = (m) ->
  paths = require.resolve m
  if is-type \String, paths
    delete require.cache[paths]
  else
    paths.for-each (p) -> delete require.cache[p]
  require m

# vim:fdm=indent
