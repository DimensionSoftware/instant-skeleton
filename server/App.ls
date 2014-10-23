global.React = require \react/addons
require! {
  fs
  http
  lodash
  \pretty-error

  koa
  \koa-jade
  \koa-static
  \koa-locals
  \koa-logger
  \koa-livereload

  \./pages
  \./middleware
}

env  = global.ENV  = process.env.NODE_ENV  or \development
port = global.PORT = process.env.NODE_PORT or 80
pe   = new pretty-error!

module.exports =
  class App
    (@port, @changeset, @vendorset) ->

    start: (cb = (->)) ->
      @app = app = koa!

      koa-locals app, {@port, @changeset, @vendorset} # init locals

      app
        ..on \error (err) ->
          console.error(pe.render err) # error handler
        ..use middleware.app-cache     # offline support
        ..use(koa-static './public')   # static assets handler
        ..use middleware.config-locals # load config into locals
        ..use koa-jade.middleware {    # use minimalistic jade layout (escape-hatch from react)
          view-path: \shared/views
          pretty:    env isnt \production
          no-cache:  env isnt \production
          helper-path: [_: lodash]
          -compile-debug
          -debug
        }
        ..use pages # apply pages

      # config environment
      if env isnt \test then app.use koa-logger!
      if env isnt \production then app.use koa-livereload!

      # listen
      app.server = http.create-server app.callback!
        ..listen port

      # TODO websockets
      # TODO db

      app

    stop: (cb = (->)) !->
      # TODO cleanup
      @app.server.close cb # quit listening
