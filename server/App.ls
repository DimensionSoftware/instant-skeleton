
global <<< require \prelude-ls # immutable (ease-of-access)

# App
#####
require! {
  fs
  http
  lodash
  'pretty-error': PrettyError

  koa
  \koa-jade
  \koa-locals
  \koa-logger
  \koa-livereload
  'koa-helmet': helmet
  'koa-static-cache': koa-static

  primus: Primus
  \primus-emitter

  \./pages
  \./services
  \./middleware

  \../shared/features
}

env = process.env.NODE_ENV or \development
pe  = new PrettyError!

### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=\ephemeral, @changeset=\latest, @vendorset=\latest) ->

    start: (cb = (->)) ->
      console.log "[1;37;30m+ [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 7].join ''}"

      @app = koa!

      koa-locals @app, {env, @port, @changeset, @vendorset} # init locals

      @app
        ..on \error (err) ->
          console.error(pe.render err) # error handler
        ..use middleware.error-handler # 404 & 50x handler
        ..use middleware.config-locals # load env-sensitive config into locals
        ..use middleware.rate-limit    # rate limiting for all requests (override in config.json)
        ..use helmet.defaults!         # solid secure base
        ..use koa-static './public' {  # static assets handler -- XXX slated for moving to separate process
          buffer: env is \production
          cache-control: if env is \production then 'public, max-age=86400' else 'no-store, no-cache, must-revalidate'
        }
        ..use middleware.app-cache     # offline support
        ..use koa-jade.middleware {    # use minimalistic jade layout (escape-hatch from react)
          view-path: \shared/views
          pretty:    env isnt \production
          no-cache:  env isnt \production
          helper-path: [_: lodash]
          -compile-debug
          -debug
        }
        ..use middleware.etags # auto etag every page for caching
        ..use pages            # apply pages

      # config environment
      if env isnt \test then @app.use koa-logger!
      if env isnt \production then @app.use koa-livereload!

      # listen
      @app.server = http.create-server @app.callback!

      # services
      @primus = new Primus @app.server, transformer: \engine.io
        ..use \emitter primus-emitter
        ..remove \primus.js
      services.init @primus, @changeset

      unless env is \test then @app.server.listen @port, cb

      # TODO db

      @app

    stop: (cb = (->)) ->
      console.log "[1;37;30m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 7].join ''}"
      # cleanup & quit listening
      @primus.destroy!
      @app.server.close cb
