
require! {
  http
  koa
  \koa-logger
  \koa-livereload

  \./pages
}


module.exports =
  class App
    (@port) ->

    start: (cb = (->)) ->
      @app = app = koa!

      # config environment
      if process.env.NODE_ENV isnt \test
        app.use koa-logger!

      if process.env.NODE_ENV isnt \production
        app.use koa-livereload!

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
