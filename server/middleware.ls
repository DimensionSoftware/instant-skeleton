
require! {
  fs
  url
  replacestream

  \../shared/react/App
}

global <<< require \prelude-ls

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
    if @locals.env is \production # use appcache
      @type = \text/cache-manifest
      @body = fs.create-read-stream 'public/manifest.appcache'
        .pipe replacestream '%changeset%', @locals.changeset # use changeset to blow cache
    else
      @status = 404
  yield next


# localize config.json for env
export config-locals = (next) ->*
  config <<< config[@locals.env]     # merge in current env's config
  [@locals[k] = v for k,v of config] # ...and localize!

  if @locals.port isnt 80 # add port to urls
    for k,v of config when k.to-lower-case!match \url
      @locals[k] = if typeof! v is \Array
        v |> map (~> "#it:#{@locals.port}")
      else
        "#v:#{@locals.port}"
  yield next


# react
export react = (next) ->* # set body to react tree
  locals  = {} <<< @locals
  path    = url.parse (@url or '/') .pathname
  app     = App {path, locals}
  @locals.body = React.render-component-to-string app

# figure out whether the requester wants html or json and send the appropriate response
export react-or-json = (next) ->*
  surf = ~> @body = {} <<< @locals
  if @query[\_surf] then surf! else switch @type # explicit or content negotiation
  | \application/json => surf!
  | otherwise         => yield react
