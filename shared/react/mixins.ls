
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
        window.cursor.update \locals, -> immutable.fromJS res.body.locals
        window.cursor.update \path, -> res.body.path
        cb void res.body
