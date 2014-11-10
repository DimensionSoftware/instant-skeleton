
require! {
  fs
  url
  replacestream
  'geoip-lite':geo

  react: {DOM}:React
  'react-router': {DefaultRoute,NotFoundRoute,Route,Routes,Link}:Router

  \../shared/features
  \../shared/react/App
}

cwd     = process.cwd!
config  = require "#cwd/config.json"
html404 = fs.read-file-sync "#cwd/public/404.html" .to-string!
html50x = fs.read-file-sync "#cwd/public/50x.html" .to-string!


export error-handler = (next) ->*
  try
    yield next
    if @status is 404 then throw 404
  catch
    @status = if typeof! e is \Number then e else e.status or 500 # default 500
    switch @accepts(\html \text \json) # -> out!
    | \json =>
      @body = message: if @status is 404 then 'Page Not Found!' else 'Error, Try Again!'
    | otherwise =>
      @type = \html
      @body = if @status is 404 then html404 else html50x
    @app.emit \error, e, @ # report to koa, too


# app-cache manifest needs headers
export app-cache = (next) ->*
  if @path is '/manifest.appcache'
    if features.offline # use appcache
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


# localize config.json for env
export config-locals = (next) ->*
  config <<< config[@locals.env]     # merge in current env's config
  config.features = features         # merge in features
  [@locals[k] = v for k,v of config] # ...and localize!

  if @locals.port isnt 80 # add port to urls
    for k,v of config when k.to-lower-case!match \url
      @locals[k] = if typeof! v is \Array
        v |> map (~> "#it:#{@locals.port}")
      else
        "#v:#{@locals.port}"
  yield next


# geoip
export geoip = (next) ->*
  @locals.geo = geo.lookup @ip
  yield next


# react
export react = (next) ->* # set body to react tree
  locals = {} <<< @locals
  path   = url.parse (@url or '/') .pathname
  # FIXME this isn't working server-side
  #four04 = React.create-class {display-name:404, render: -> DOM.h1 {} \404}
  #hello  = React.create-class {render: -> DOM.div void 'Hello World!'}

  #app = Routes {on-error: -> throw it}, [
  #  Route path:'/', handler:(create-element hello, {})
  #  NotFoundRoute handler:(create-element four04, {})
  #]
  # https://github.com/rackt/react-router/issues/57
  # https://github.com/rackt/react-router/pull/181
  @locals.body = yield Router.render-routes-to-string App, path, _
  yield @render \layout @locals

# figure out whether the requester wants html or json and send the appropriate response
export react-or-json = (next) ->*
  surf = ~> @body = {} <<< @locals
  if @query[\_surf] then surf! else switch @type # explicit or content negotiation
    | \application/json => surf!
    | otherwise         => yield react

function create-element
  React.create-element ...
