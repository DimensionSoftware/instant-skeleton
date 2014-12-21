
require! {
  fs
  url
  lodash
  replacestream
  'geoip-lite': geo

  \koa-jade
  'koa-static-cache': koa-static
  'koa-better-ratelimit': limit

  react: {create-element, DOM}:React

  \../shared/features
  \../shared/react/App
  \../shared/helpers
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
export config-locals = (next) ->*
  [@locals[k] = v for k,v of merge] # ...and localize!

  if @locals.port isnt 80 # add port to urls
    for k,v of merge when k.to-lower-case!match \url
      @locals[k] = if typeof! v is \Array
        v |> map (~> "#it:#{@locals.port}")
      else
        "#v:#{@locals.port}"
  yield next


# static asset server
static-fn = void
export static-assets = (next) ->* # apply our config
  if features.static-assets
    unless static-fn then static-fn := koa-static './public' { # lazy singleton
      buffer: @locals.env is \production
      cache-control:
        if @locals.env is \production
          'public, max-age=86400'
        else
          'no-store, no-cache, must-revalidate'
    }
    yield (static-fn.bind @) next
  else
    yield next


# jade templates
jade-fn = void
export jade = (next) ->*
  unless jade-fn then jade-fn := koa-jade.middleware {
    view-path: \shared/views
    pretty:    @locals.env isnt \production
    no-cache:  @locals.env isnt \production
    helper-path: [_: lodash]
    -compile-debug
    -debug
  }
  yield (jade-fn.bind @) next


# rate limiting
rate-fn = void
export rate-limit = (next) ->* # apply our config
  unless rate-fn then rate-fn := limit { # lazy singleton
    max:@locals.limits?max or 500
    duration:@locals.limits?duration or (1000 * 60 * 60 * 1)
    white-list:@locals.limits?white-list or []
    black-list:@locals.limits?black-list or []
  }
  yield (rate-fn.bind @) next


export geoip = (next) ->*
  @locals.geo = geo.lookup @ip
  yield next


export etags = (next) ->*
  yield next                  # wait for body
  if @locals.body?to-string!  # ...and digest if exists on way up
    @etag = helpers.digest that


export webpack = (next) ->*
  if @locals.env isnt \production # webpackdev headers
    @set \Access-Control-Allow-Origin "http://#{config.subdomain}:#{config.node_port}"
    @set \Access-Control-Allow-Headers \X-Requested-With
  yield next


# react
export react = (next) ->* # set body to react tree
  locals = {} <<< @locals
  path   = url.parse (@url or '/') .pathname
  @locals.body = React.render-to-string(create-element App, {path, locals})
  yield @render \layout @locals

# figure out whether the requester wants html or json and send the appropriate response
export react-or-json = (next) ->*
  surf = ~> @body = {} <<< @locals
  if @query[\_surf] then surf! else switch @type # explicit or content negotiation
    | \application/json => surf!
    | otherwise         => yield react


# vim:fdm=indent
