
global <<< require \prelude-ls # immutable (ease-of-access)

# App
#####
require! {
  fs
  http
  'pretty-error': PrettyError

  koa
  \koa-level
  \koa-logger
  'koa-helmet': helmet

  'level-sublevel'
  \level-live-stream
  'level-party': level

  'koa-generic-session': koa-session

  primus: Primus
  \primus-emitter
  \primus-multiplex
  \primus-resource

  \./pages
  \./resources
  \./middleware

  \../shared/features
}

pe   = new PrettyError!
env  = process.env.NODE_ENV or \development
prod = env is \production

db      = level-sublevel(level './shared/db' {value-encoding:\json})
sdb     = db.sublevel \session
pdb     = db.sublevel \public
store   = koa-level {db:sdb}
session = koa-session {store}

### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=\ephemeral, @changeset=\latest) ->

    start: (cb = (->)) ->
      console.log "[1;37;30m+ [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"

      @app = koa! # attach middlewares
        ..keys = ['iAsNHei275_#@$#%^&']   # cookie session secrets
        ..on \error (err) ->
          console.error(pe.render err)    # error handler
        ..use helmet.defaults!            # solid secure base
        ..use middleware.webpack
        ..use middleware.error-handler    # 404 & 50x handler
        ..use middleware.config-locals @  # load env-sensitive config into locals
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
      @server = http.create-server @app.callback!
      @primus = new Primus @server, transformer: \engine.io, parser: \JSON
        ..before (middleware.primus-koa-session store, @app.keys)
        ..use \multiplex primus-multiplex
        ..use \emitter primus-emitter
        ..use \resource primus-resource
        ..remove \primus.js

      # init realtime resources
      resources.init sdb, @primus
      # init live streams
      live-stream @primus, pdb, \public
      live-stream @primus, sdb, \session, (key, spark) -> key is spark.request.key

      # listen
      unless @port is \ephemeral then @server.listen @port, cb
      @app

    stop: (cb = (->)) ->
      console.log "[1;37;30m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"
      # cleanup & quit listening
      <~ @primus.destroy
      <~ @server.close
      db.close cb


function live-stream primus, db, name, key-compare-fn
  level-live-stream.install db
  channel = primus.channel name
    ..on \connection (spark) ->
      # -> send live updates to client
      send = ->
        now = new Date!get-time!
        it.updated = now
        spark.write it
      s-stream = db.create-live-stream!
        ..pipe channel # pipe updates
        ..on \data (data) ->
          v = if typeof! data.value is \Object then data.value else JSON.parse data.value # FIXME huh?
          if key-compare-fn and key-compare-fn data.key, spark
            send v
          else
            send v

      # <- save live updates from client
      spark.on \data (data) ->
        db.put name, JSON.stringify data # FIXME huh?
