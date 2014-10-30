
# immutable (ease-of-access)
global.React  = require \react/addons
global.Router = require \react-router


# App
#####
require! {
  fs
  http
  lodash
  'pretty-error': PrettyError

  koa
  \koa-jade
  \koa-static
  \koa-locals
  \koa-logger
  \koa-livereload

  primus: Primus
  \primus-emitter

  \./pages
  \./services
  \./middleware
}

env  = process.env.NODE_ENV or \development
pe   = new PrettyError!

### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=\ephemeral, @changeset, @vendorset) ->

    start: (cb = (->)) ->
      console.log "[1;37;30m+ [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"

      @app = koa!

      koa-locals @app, {env, @port, @changeset, @vendorset} # init locals

      @app
        ..on \error (err) ->
          console.error(pe.render err) # error handler
        ..use middleware.error-handler # 404 & 50x handler
        ..use middleware.config-locals # load config into locals
        ..use middleware.app-cache     # offline support
        ..use(koa-static './public')   # static assets handler
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
      if env isnt \test then @app.use koa-logger!
      if env isnt \production then @app.use koa-livereload!

      # listen
      @app.server = http.create-server @app.callback!
      unless env is \test then @app.server.listen @port, cb

      # services
      @primus = new Primus @app.server, transformer: \engine.io
        ..use \emitter primus-emitter
        #..remove \primus.js
      services.init @primus, @changeset

      # TODO db

      @app

    stop: (cb = (->)) ->
      console.log "[1;37;30m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"
      # cleanup & quit listening
      @primus.destroy!
      @app.server.close cb
