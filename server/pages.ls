
require! {
  \koa
  \koa-router

  './middleware': mw

  '../shared/features'
  '../shared/routes': {R, list}
  \react-rethinkdb : {Session}
}

global.WebSocket = require \ws # FIXME something smarter
[app, router] = [koa!, koa-router!]
# export pages for all routes by default
for [route, path] in list
  router.get R(route), (next) ->*
    @session.last-page = @session.on-page
    @session.on-page = route
    console.log \sess: @session
    yield mw.react-or-json
    yield next


# <CUSTOM PAGE HANDLERS>
router.get R(\HomePage), (next) ->*
  # TODO something
  console.log 'Navigated to HomePage!'
  @session.page = \home + Math.random! * 20
  console.log \sess: @session
  yield mw.react-or-json
  yield next
# </CUSTOM PAGES>

module.exports = router.routes!
