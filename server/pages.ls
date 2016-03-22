
require! {
  \koa
  \koa-router

  './middleware': mw

  '../shared/features'
  '../shared/routes': {R}
  \react-rethinkdb : {Session}
}

global.WebSocket = require \ws # FIXME something smarter
[app, router] = [koa!, koa-router!]

# <PAGES>
# TODO make simple handler-less routes
router.get R(\HomePage), (next) ->*
  yield mw.react-or-json
  yield next

if features.todo-example
  router.get R(\MyTodoPage), (next) ->*
    yield mw.react-or-json
    yield next
  router.get R(\PublicPage), (next) ->*
    yield mw.react-or-json
    yield next
# </PAGES>

module.exports = router.routes!
