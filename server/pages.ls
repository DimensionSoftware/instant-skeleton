
require! {
  \koa
  \koa-router

  './middleware': mw

  '../shared/features'
  '../shared/routes': {R}
}

[app, router] = [koa!, koa-router!]

# <PAGES>
router.get R(\HomePage), (next) ->*
  @session.last-page = @session.on-page
  @session.on-page   = \HomePage
  yield mw.react-or-json
  yield next

if features.todo-example
  router.get R(\MyTodoPage), (next) ->*
    @session.last-page = @session.on-page
    @session.on-page   = \MyTodoPage
    yield mw.react-or-json
    yield next
  router.get R(\PublicPage), (next) ->*
    @session.last-page = @session.on-page
    @session.on-page   = \PublicPage
    yield mw.react-or-json
    yield next
# </PAGES>

module.exports = router.routes!
