
require! {
  \koa
  \koa-router
}

app = koa!
module.exports = koa-router app

# <page routes>
app.get '/hello' (next) ->*
  @body = "Hello #{@ip or \World}!"
# </page routes>
