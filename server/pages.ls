
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
  @locals.greeting   = 'Hello World!' # default
  @session.last-page = \HomePage
  yield mw.react-or-json
  yield next

if features.hello-page
  app.get r(\HelloPage), mw.geoip, (next) ->*
    @session.last-page = \HelloPage
    yield mw.react-or-json
    yield next
# </PAGES>
