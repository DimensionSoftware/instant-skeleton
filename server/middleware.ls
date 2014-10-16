
require! {
  fs
  url

  \../shared/react/App
}

config = JSON.parse(fs.read-file-sync './config.json') # intentionally crashes if malformed & sync

# localize config.json for env
export config-locals = (next) ->*
  config <<< config[global.ENV] # merge in current env's config
  [@locals[k] = v for k,v of config] # localize
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
