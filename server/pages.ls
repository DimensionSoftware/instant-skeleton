
require! {
  \koa
  \koa-router

  './middleware': mw

  '../shared/features'
  '../shared/routes': {R}
}

app = koa!
module.exports = koa-router app

# <PAGES>
app.get R(\HomePage), (next) ->*
  @locals.greeting   = 'Hello World!' # default
  @session.last-page = \HomePage
  yield mw.react-or-json
  yield next

if features.hello-page
  app.get R(\HelloPage), mw.geoip, (next) ->*
    @session.last-page = \HelloPage
    yield mw.react-or-json
    yield next
# </PAGES>
