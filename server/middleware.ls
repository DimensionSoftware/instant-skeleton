
require! {
  co
  fs
  url
  crypto
  immstruct
  replacestream
  keygrip: Keygrip

  \koa-jade
  \koa-locals
  'koa-static-cache': koa-static
  'koa-better-ratelimit': limit

  react: {create-element, DOM}:React

  \../shared/features
  \../shared/react/App
}

env    = process.env.NODE_ENV or \development
cwd    = process.cwd!
pkg    = require "#cwd/package.json"
config = pkg.config

html404 = fs.read-file-sync "#cwd/public/404.html" .to-string!
html50x = fs.read-file-sync "#cwd/public/50x.html" .to-string!


export error-handler = (next) ->*
  try
    yield next
    if @status is 404 then throw 404 # no stack trace needed
  catch
    @status = if typeof! e is \Number then e else e.status or 500 # default 500
    switch @accepts(\html \text \json) # -> out!
    | \json =>
      @body = message: if @status is 404 then 'Page Not Found!' else 'Error, Try Again!'
    | otherwise =>
      @type = \html
      @body = if @status is 404 then html404 else html50x
    unless @status is 404 then @app.emit \error, e, @ # report to koa, too


# app-cache manifest needs headers
export app-cache = (next) ->*
  if @path is '/manifest.appcache'
    if features.offline # use appcache
      @set \pragma \no-cache
      @set \cache-control \no-cache
      @type = \text/cache-manifest
      # TODO read once at boot time
      @body = fs.create-read-stream 'public/manifest.appcache'
        .pipe replacestream \%changeset%  @locals.changeset # use changeset to blow cache
        .pipe replacestream \%cacheUrls%  @locals.cache-urls.0
        .pipe replacestream \%cacheUrls1% @locals.cache-urls.1
        .pipe replacestream \%cacheUrls2% @locals.cache-urls.2
        .pipe replacestream \%cacheUrls3% @locals.cache-urls.3
    else
      @status = 404
  else yield next


# localize package.json config for env
merge = {}
merge{name,title,url,cache-urls,meta-keywords} = config # pick these
merge <<< config[env]                                   # merge in current env's config
merge.features = features                               # merge in features
export config-locals = (App) ->
  koa-locals App.app, {env, App.port, App.changeset}    # init koa locals support
  (next) ->*
    [@locals[k] = v for let k,v of merge]               # ...and localize our config

    unless @locals.env is \production
      if @locals.port isnt 80 # add port to urls
        for k,v of merge when k.to-lower-case!match \url
          @locals[k] = if typeof! v is \Array
            v |> map (~> "#it:#{@locals.port}")
          else
            "#v:#{@locals.port}"
    yield next


state = { # these middlewares are singletons
  static-fn: void
  jade-fn:   void
  rate-fn:   void
}

# static asset server
export static-assets = (next) ->* # apply our config
  if features.static-assets
    unless state.static-fn then state.static-fn := koa-static './public' { # lazy singleton
      buffer: @locals.env is \production
      cache-control:
        if @locals.env is \production
          'public, max-age=86400'
        else
          'no-store, no-cache, must-revalidate'
    }
    yield (state.static-fn.bind @) next
  else
    yield next


# jade templates
export jade = (next) ->*
  unless state.jade-fn then state.jade-fn := koa-jade.middleware {
    view-path: \shared/views
    pretty:    @locals.env isnt \production
    no-cache:  @locals.env isnt \production
    -compile-debug
    -debug
  }
  yield (state.jade-fn.bind @) next


# rate limiting
export rate-limit = (next) ->* # apply our config
  unless state.rate-fn then state.rate-fn := limit { # lazy singleton
    max:@locals.limits?max or 500
    duration:@locals.limits?duration or (1000 * 60 * 5) # 5mins.
    white-list:@locals.limits?white-list or []
    black-list:@locals.limits?black-list or []
  }
  yield (state.rate-fn.bind @) next

# for upstream balancers, proxies & caches
export health-probe = (next) ->*
  if @path is '/probe'
    @set \pragma \no-cache
    @set \cache-control \no-cache
    @body = \OK
  else
    yield next

export etags = (next) ->*
  yield next                  # wait for body
  if @locals.body?to-string!  # ...and digest if exists on way up
    @etag = digest that


export webpack = (next) ->*
  if @locals.env isnt \production # webpackdev headers
    @set \Access-Control-Allow-Origin "http://#{config.subdomain}:#{config.node_port}"
    @set \Access-Control-Allow-Headers \X-Requested-With
  yield next


# react
export react = (next) ->* # set body to react tree
  path  = url.parse (@url or '/') .pathname
  state = immstruct {path, @locals, @session}
  @locals.body = React.render-to-string (App state.cursor!)
  yield @render \layout @locals

# figure out whether the requester wants html or json and send the appropriate response
export react-or-json = (next) ->*
  delete @locals.limits # not needed on client
  path = url.parse (@url or '/') .pathname
  surf = ~> @body = {path, @locals}
  if @query[\_surf] then surf! else switch @type # explicit or content negotiation
    | \application/json => surf!
    | otherwise         => yield react


# primus-koa-leveldb session
export primus-koa-session = (store, keys) ->
  (req, res, next) ->
    req.key = "koa:sess:#{primus-koa-session-helper req, \koa.sid, keys}"
    co(store.get req.key).then (session) ->
      req.session = session
      next!

function primus-koa-session-helper req, name, keys
  # function used by Cookies
  # https://github.com/expressjs/cookies
  cache = {}
  get-pattern = (name) ->
    if cache[name] then return that
    cache[name] = new RegExp "(?:^|;) *#{name.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&")}=([^;]*)"

  # match name (session) cookie
  n-match = req.headers.cookie.match(get-pattern name)
  n-val   = n-match?1
  unless keys then return n-val # unsigned

  # verify signed cookies with keygrip
  s-match = req.headers.cookie.match(get-pattern "#name.sig")
  k = new Keygrip keys
  if k.index("#name=#n-val", s-match?1) < 0 then return void
  n-val

function digest body
  crypto.create-hash \md5 .update body .digest \hex

# vim:fdm=indent
