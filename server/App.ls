
require! {
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

env = global.ENV = process.env.NODE_ENV or \development
pe  = new pretty-error!

module.exports =
  class App
    (@port) ->

    start: (cb = (->)) ->
      @app = app = koa!

      app.on \error (err) -> # error handler
        console.error(pe.render err)

      app.use koa-static('./public')

      # config environment
      koa-locals app, {} # init locals
      if env isnt \test then app.use koa-logger!
      if env isnt \production then app.use koa-livereload!
      app.use middleware.config-locals

      # apply pages
      app.use koa-jade.middleware {
        view-path: \shared/views
        pretty:    global.ENV isnt \production
        no-cache:  global.ENV isnt \production
        helper-path: [_: lodash]
        -compile-debug
        -debug
      }
      app.use pages

      # listen
      app.server = http.create-server app.callback!
        ..listen process.env.NODE_PORT or 80

      # TODO websockets
      # TODO db

      app

    stop: (cb = (->)) !->
      # TODO stop app instance
      @app.server.close cb
