
require! {
  fs
  url

  \../shared/react/App
}

global <<< require \prelude-ls

config = JSON.parse(fs.read-file-sync './config.json') # intentionally crashes if malformed & sync

# app-cache manifest needs headers
export app-cache = (next) ->*
  if @path is '/manifest.appcache'
    @type = \text/cache-manifest
    @body = fs.create-read-stream 'public/manifest.appcache'
  else
    yield next

# localize config.json for env
export config-locals = (next) ->*
  config <<< config[global.ENV]      # merge in current env's config
  [@locals[k] = v for k,v of config] # ...and localize!

  if global.PORT isnt 80 # add port to urls
    for k,v of config when k.to-lower-case!match \url
      @locals[k] = if typeof! v is \Array
        v |> map (-> "#it:#{global.PORT}")
      else
        "#v:#{global.PORT}"
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
