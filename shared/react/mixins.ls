
require! {
  superagent: request
}

export InitialStateAsync =
  get-initial-state-async: (cb) ->
    request # fetch state
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .get path
      .end (res) ->
        cb null, res
