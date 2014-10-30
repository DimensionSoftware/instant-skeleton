
require! {
  \koa
  \koa-router

  './middleware': mw

  '../shared/routes': {r, rn}
}

app = koa!
module.exports = koa-router app

# <page routes>
app.get '/hello' (next) ->*
  @locals.body = "Hello #{@ip or \World}!"
  yield mw.react-or-json
  yield next

app.get r(\HomePage), (next) ->*
  yield mw.react-or-json
  yield next
# </page routes>
