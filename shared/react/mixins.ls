
require! {
  superagent: request
  immstruct
  immutable
}

export InitialStateAsync =
  get-initial-state-async: (cb) ->
    request # fetch state
      .get window.location.pathname
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .end (res) ->
        # update page & local cursor (state)
        window.app.update \locals, -> immutable.fromJS res.body.locals
        window.app.update \path,   -> res.body.path
        cb void res.body
