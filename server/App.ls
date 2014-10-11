
require! {
  http

  koa
  \koa-locals
  \koa-logger
  \koa-livereload

  \./pages
  \./middleware
}

env = global.ENV = process.env.NODE_ENV or \development

module.exports =
  class App
    (@port) ->

    start: (cb = (->)) ->
      @app = app = koa!

      # config environment
      koa-locals app, {} # init locals
      if env isnt \test then app.use koa-logger!
      if env isnt \production then app.use koa-livereload!
      app.use middleware.config

      # apply routes
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
