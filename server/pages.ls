
require! {
  \koa
  \koa-router

  './middleware': mw
}

app = koa!
module.exports = koa-router app

# <page routes>
app.get '/hello' (next) ->*
  @locals.body = "Hello #{@ip or \World}!"
  yield @render \layout @locals

app.get '/' (next) ->*
  yield mw.react-or-json
  yield @render \layout @locals
# </page routes>
