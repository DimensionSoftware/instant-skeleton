
global <<< require \prelude-ls # immutable (ease-of-access)

# App
#####
require! {
  co
  fs
  http
  'pretty-error': PrettyError

  koa
  \levelup
  'level-sublevel/legacy': sublevel
  \koa-level
  \koa-locals
  \koa-logger
  \koa-livereload
  'koa-helmet': helmet
  'koa-generic-session': sess

  primus: Primus
  \substream
  \primus-emitter

  \./pages
  \./services
  \./middleware

  \../shared/features
}

env = process.env.NODE_ENV or \development
pe  = new PrettyError!

db  = sublevel(levelup './shared/db')
sdb = db.sublevel \session

### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=\ephemeral, @changeset=\latest, @vendorset=\latest) ->

    start: (cb = (->)) ->
      console.log "[1;37;30m+ [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 7].join ''}"

      @app = koa! # boot!

      koa-locals @app, {env, @port, @changeset, @vendorset} # init locals

      @app # attach middlewares
        ..keys = ['iAsNHei275_#@$#%^&'] # cookie session secrets
        ..on \error (err) ->
          console.error(pe.render err)    # error handler
        ..use middleware.error-handler    # 404 & 50x handler
        ..use middleware.config-locals    # load env-sensitive config into locals
        ..use middleware.rate-limit       # rate limiting for all requests (override in config.json)
        ..use helmet.defaults!            # solid secure base
        ..use middleware.static-assets    # static assets handler
        ..use middleware.app-cache        # offline support
        ..use sess store:koa-level db:sdb # session support
        ..use middleware.jade             # use minimalistic jade layout (escape-hatch from react)
        ..use middleware.etags            # auto etag every page for caching
        ..use pages                       # apply pages

      # config environment
      if env isnt \test then @app.use koa-logger!
      if env isnt \production then @app.use koa-livereload!

      # listen
      @app.server = http.create-server @app.callback!

      # services
      @primus = new Primus @app.server, transformer: \engine.io
        ..use \substream substream
        ..use \emitter primus-emitter
        ..remove \primus.js
      services.init @primus, @changeset

      unless env is \test then @app.server.listen @port, cb

      @app

    stop: (cb = (->)) ->
      console.log "[1;37;30m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 7].join ''}"
      # cleanup & quit listening
      @primus.destroy!
      @app.server.close cb
      db.close!
