
global <<< require \prelude-ls # immutable (ease-of-access)

# App
#####
require! {
  fs
  http
  'pretty-error': PrettyError

  koa
  \koa-level
  \koa-locals
  \koa-logger
  'koa-helmet': helmet

  'level-sublevel'
  'level-party': level

  'koa-generic-session': sess

  primus: Primus
  \substream
  \primus-emitter

  \./pages
  \./services
  \./middleware

  \../shared/features
}

pe = new PrettyError!

env  = process.env.NODE_ENV or \development
prod = env is \production

db  = level-sublevel(level './shared/db' {encoding:\json})
sdb = db.sublevel \session

### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=\ephemeral, @changeset=\latest, @vendorset=\latest) ->

    start: (cb = (->)) ->
      console.log "[1;37;30m+ [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 7].join ''}"

      @app = koa! # boot!

      koa-locals @app, {env, @port, @changeset} # init locals

      @app # attach middlewares
        ..keys = ['iAsNHei275_#@$#%^&']   # cookie session secrets
        ..on \error (err) ->
          console.error(pe.render err)    # error handler
        ..use middleware.error-handler    # 404 & 50x handler
        ..use middleware.config-locals    # load env-sensitive config into locals
        ..use middleware.rate-limit       # rate limiting for all requests (override in config.json)
        #..use helmet.defaults xframe:prod # solid secure base
        ..use middleware.static-assets    # static assets handler
        ..use middleware.app-cache        # offline support
        ..use sess store:koa-level db:sdb # session support
        ..use middleware.jade             # use minimalistic jade layout (escape-hatch from react)
        ..use middleware.etags            # auto etag every page for caching
        ..use pages                       # apply pages

      # config environment
      if env isnt \test then @app.use koa-logger!

      # listen
      @app.server = http.create-server @app.callback!
      unless env is \test then @app.server.listen @port, cb

      # init real-time
      @primus = new Primus @app.server, transformer: \engine.io
        ..use \substream substream
        ..use \emitter primus-emitter
        ..remove \primus.js

      # boot real-time, streaming services
      services.init @primus, @changeset, sdb

      @app

    stop: (cb = (->)) ->
      console.log "[1;37;30m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 7].join ''}"
      # cleanup & quit listening
      <~ @primus.destroy
      <~ @app.server.close
      db.close cb
