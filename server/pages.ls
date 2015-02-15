
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
  @locals.greetings  = '' # default
  @session.last-page = @session.on-page
  @session.on-page   = \HomePage
  yield mw.react-or-json
  yield next

app.get R(\TodoPage), (next) ->*
  @session.last-page = @session.on-page
  @session.on-page   = \TodoPage
  yield mw.react-or-json
  yield next
# </PAGES>
