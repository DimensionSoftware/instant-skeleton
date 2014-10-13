
require! {
  \koa
  \koa-router
}

app = koa!
module.exports = koa-router app

# <page routes>
app.get '/hello' (next) ->*
  @locals.body = "Hello #{@ip or \World}!"
  yield @render \layout @locals
# </page routes>
