
global <<< require \prelude-ls # immutable (ease-of-access)

# App
#####
require! {
  co
  http
  \pretty-error : PrettyError
  \rethinkdb-websocket-server : {r, RQ, listen}
  \rethinkdbdash : rethinkdb
  \koa-generic-session : session
  \koa-helmet : helmet
  \koa-logger
  koa
  \./pages
  \./middleware : mw
  \./query-whitelist
}

pe  = new PrettyError!
env = process.env.NODE_ENV or \development

# connect to rethinkdb
[keys, db, db-host, db-port, http-path] =
  [[process.env.npm_package_config_keys_0         or \AEeaEUA3152589], # XXX only using first
   process.env.npm_package_config_database        or \test,
   process.env.npm_package_config_domain          or \develop.com,
   process.env.npm_package_config_rethinkdb_port  or 28015,
   '/db']
connection = rethinkdb {db, db-host, db-port}
store      = new mw.rethinkdb-koa-session {connection, db}
co <| init-rethinkdb db, connection # init rethinkdb tables & indexes

### App's purpose is to abstract instantiation from starting & stopping
module.exports =
  class App
    (@port=8080, @changeset=\latest) ->

    start: (cb=->) ->
      console.log "[1;37;32m+ [1;37;40m#env[0;m #{process.pid} @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"
      @app = koa! # attach middlewares
        ..keys = keys                  # cookie session secrets
        ..on \error (err) ->
          console.error(pe.render err) # error handler
        ..use helmet!                  # solid secure base
        ..use mw.webpack               # proper dev-server headers
        ..use mw.error-handler         # 404 & 50x handler
        ..use mw.config-locals @       # load env-sensitive config into locals
        ..use mw.health-probe          # for upstream balancers, proxies & caches 
        ..use mw.rate-limit            # rate limiting for all requests (override in package.json config)
        ..use mw.app-cache             # offline support
        ..use mw.static-assets         # static assets handler
        ..use mw.jade                  # use minimalistic jade layout (escape-hatch from react)
        ..use mw.etags                 # auto etag every page for caching
        ..use session {store}          # rethinkdb session support for koa
        ..use mw.session               # sends session to client
        ..use pages                    # apply pages

      # config environment
      if env isnt \test then @app.use koa-logger!

      # boot http server
      @server = http.create-server @app.callback!

      # boot websockets
      session-creator = (query-parms, {headers}:req) ->
        auth-token = "koa:sess:#{mw.rethinkdb-koa-session-helper {headers}, \koa.sid, keys}"
        co {auth-token}
      listen {db-host, http-path, http-server: @server, session-creator, unsafely-allow-any-query: env isnt \production, query-whitelist}

      # listen, bind last
      unless @port is \ephemeral then @server.listen @port, cb
      @app

    stop: (cb=->) ->
      console.log "[1;37;31m- [1;37;40m#env[0;m @ port [1;37;40m#{@port}[0;m ##{@changeset[to 5].join ''}"
      # cleanup & cleanly quit listening
      <~ @server.close
      connection.get-pool-master!drain!
      cb!

function* init-rethinkdb db, connection
  try yield connection.db-create db
  try yield connection.db db .table-create \everyone
  try yield connection.db db .table \everyone .index-create \date
