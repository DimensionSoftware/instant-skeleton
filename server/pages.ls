
require! {
  \koa
  \koa-router

  './middleware': mw

  '../shared/features'
  '../shared/routes': {r, rn}
}

app = koa!
module.exports = koa-router app

# <PAGES>
app.get r(\HomePage), (next) ->*
  @session.foo = \bar
  yield mw.react-or-json
  yield next

if features.hello-page # example rendering only jade (no react)
  app.get '/hello' mw.geoip, (next) ->*
    @locals.body = "Hello #{@ip or \World} from #{@locals.geo?country or \Earth}!"
    yield @render \layout @locals
    yield next
# </PAGES>
