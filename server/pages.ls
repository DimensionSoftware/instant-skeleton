
require! {
  \koa
  \koa-router

  './middleware': mw

  '../shared/features'
  '../shared/routes': {r, rn}
}

app = koa!
module.exports = koa-router app

# <page routes>
if features.hello-page
  app.get r(\Hello), mw.geoip, (next) ->*
    @locals.body = "Hello #{@ip or \World} from #{@locals.geo?country or \Earth}!"
    yield @render \layout @locals # XXX example rendering only jade (no react)
    yield next

app.get r(\HomePage), (next) ->*
  yield mw.react-or-json
  yield next
# </page routes>
