
global <<< require \prelude-ls # immutable (ease-of-access)

# App
#####
require! {
  co
  http
  'pretty-error': PrettyError

  koa
  \koa-logger
  'koa-helmet': helmet

  \koa-generic-session-rethinkdb : RethinkSession
  \koa-generic-session : session

  'rethinkdbdash': rethinkdb
  'rethinkdb-websocket-server': {r, RQ, listen}
  'react-rethinkdb/dist/node': {Session}

  \./pages
  \./middleware

  \../shared/features
}

pe   = new PrettyError!
env  = process.env.NODE_ENV or \development
prod = env is \production

#db      = level-sublevel(level './shared/db' {value-encoding:\json})
#sdb     = db.sublevel \session
#edb     = db.sublevel \everyone
#store   = koa-level {db:sdb}

#store = new Session!
#console.log \store: store

#session = koa-session {store}
db-host    = \localhost
db-port    = 28015
connection = rethinkdb {db-host, db-port}

store = new RethinkSession {connection}
co store.setup! .then void, -> console.error "RethinkDB Error: #it"


### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=8080, @changeset=\latest) ->

    start: (cb = (->)) ->
      console.log "[1;37;30m+ [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"

      @app = koa! # attach middlewares
        ..keys = ['iAsNHei275_#@$#%^&']   # cookie session secrets
        ..on \error (err) ->
          console.error(pe.render err)    # error handler
        ..use helmet!                     # solid secure base
        ..use middleware.webpack          # proper dev-server headers
        ..use middleware.error-handler    # 404 & 50x handler
        ..use middleware.config-locals @  # load env-sensitive config into locals
        ..use middleware.health-probe     # for upstream balancers, proxies & caches 
        ..use middleware.rate-limit       # rate limiting for all requests (override in package.json config)
        ..use middleware.app-cache        # offline support
        ..use middleware.static-assets    # static assets handler
        ..use session {store}             # rethinkdb session support
        ..use middleware.jade             # use minimalistic jade layout (escape-hatch from react)
        ..use middleware.etags            # auto etag every page for caching
        ..use pages                       # apply pages

      # config environment
      if env isnt \test then @app.use koa-logger!

      # boot http & websocket servers
      @server = http.create-server @app.callback!
      listen do
        http-server: @server
        http-path:   \/db
        db-host:     db-host
        db-port:     db-port

      # listen
      unless @port is \ephemeral then @server.listen @port, cb
      @app

    stop: (cb = (->)) ->
      console.log "[1;37;30m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"
      # cleanup & quit listening
      # TODO close rethinkdb
      <~ @server.close
