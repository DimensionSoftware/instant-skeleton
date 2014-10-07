
require! {
  express
}


module.exports =
  class App
    (@port) ->

    start: (cb = (->)) ->
      # TODO boot app instance
      @app = express!
      @

    stop: (cb = (->)) !->
      # TODO stop app instance
      @app.close cb
