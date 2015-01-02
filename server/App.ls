
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

  'koa-generic-session': koa-session

  primus: Primus
  \primus-emitter
  \primus-multiplex

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

store   = koa-level {db:sdb}
session = koa-session {store}

### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=\ephemeral, @changeset=\latest, @vendorset=\latest) ->

    build: -> [name, build] = @changeset.split \.; build or \latest

    start: (cb = (->)) ->
      console.log "[1;37;30m+ [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@build![to 7].join ''}"

      @app = koa! # boot!

      [@app.changeset, @app.sdb] = [@changeset, sdb] # stash

      koa-locals @app, {env, @port, @changeset} # init locals

      @app # attach middlewares
        ..keys = ['iAsNHei275_#@$#%^&']   # cookie session secrets
        ..on \error (err) ->
          console.error(pe.render err)    # error handler
        ..use helmet.defaults!            # solid secure base
        ..use middleware.error-handler    # 404 & 50x handler
        ..use middleware.config-locals    # load env-sensitive config into locals
        ..use middleware.webpack          # for webpack in develop
        ..use middleware.rate-limit       # rate limiting for all requests (override in package.json config)
        ..use middleware.static-assets    # static assets handler
        ..use middleware.app-cache        # offline support
        ..use session                     # leveldb session support
        ..use middleware.jade             # use minimalistic jade layout (escape-hatch from react)
        ..use middleware.etags            # auto etag every page for caching
        ..use pages                       # apply pages

      # config environment
      if env isnt \test then @app.use koa-logger!

      # boot http & websocket servers
      @app.server = http.create-server @app.callback!
      @primus = new Primus @app.server, transformer: \engine.io, parser: \JSON
        ..before (middleware.primus-koa-session store, @app.keys)
        ..use \multiplex primus-multiplex
        ..use \emitter primus-emitter
        ..remove \primus.js

      services.init @app, @primus

      # listen
      unless @port is \ephemeral then @app.server.listen @port, cb

      @app

    stop: (cb = (->)) ->
      console.log "[1;37;30m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@build![to 7].join ''}"
      # cleanup & quit listening
      <~ @primus.destroy
      <~ @app.server.close
      db.close cb
