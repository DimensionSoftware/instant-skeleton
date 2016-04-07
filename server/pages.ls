
require! {
  \koa
  \koa-router
  './middleware': mw
  '../shared/features'
  '../shared/routes': {R, list}
  \react-rethinkdb : {Session}
  \ws : global.WebSocket
}

[app, router] = [koa!, koa-router!]
# export pages for all routes by default
for let [route, path] in list
  router.get R(route), (next) ->*
    @session.on-page = route
    yield mw.react-or-json
    yield next


# <CUSTOM PAGE HANDLERS>
router.get R(\HomePage), (next) ->*
  # TODO something
  # XXX using @session will result the inability to cache & bugs!
  # [@session.last-page, @session.on-page] =
  #   @session.on-page
  #   route
  console.log 'Navigated to HomePage!'
  yield mw.react-or-json
  yield next
# </CUSTOM PAGE HANDLERS>

module.exports = router.routes!
