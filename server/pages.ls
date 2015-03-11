
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
  @session.last-page = @session.on-page
  @session.on-page   = \HomePage
  yield mw.react-or-json
  yield next

if features.todo-example
  app.get R(\MyTodoPage), (next) ->*
    @session.last-page = @session.on-page
    @session.on-page   = \MyTodoPage
    yield mw.react-or-json
    yield next
  app.get R(\PublicPage), (next) ->*
    @session.last-page = @session.on-page
    @session.on-page   = \PublicPage
    yield mw.react-or-json
    yield next
# </PAGES>
