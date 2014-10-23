
require! {
  fs
  url
  replacestream

  \../shared/react/App
}

global <<< require \prelude-ls

config = JSON.parse(fs.read-file-sync './config.json') # intentionally crashes if malformed & sync

export four-oh-four-handler = (next) ->*
  return unless @status is 404 # guard
  @status = 404 # so koa doesn't 200 or 404
  switch (@accepts \html \json)
  | \json =>
    @body = message: 'Page Not Found!'
  | otherwise => # TODO load static jade assets
    @type = \html
    @body = '404, Page Not Found!'

# app-cache manifest needs headers
export app-cache = (next) ->*
  if @path is '/manifest.appcache'
    if @locals.env is \production # use appcache
      @type = \text/cache-manifest
      @body = fs.create-read-stream 'public/manifest.appcache'
        .pipe replacestream '%changeset%', @locals.changeset # use changeset to blow cache
    else
      @status = 404
  else
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
