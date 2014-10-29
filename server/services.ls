
@init = (primus, changeset) ->
  primus.on \connection (spark) ->
    spark.send \CHANGESET changeset


# TODO flesh out services
@example-service =
  find: (params, cb) ->
  get: (id, params, cb) ->
  create: (data, params, cb) ->
  update: (id, data, params, cb) ->
  patch: (id, data, params, cb) ->
  remove: (id, params, cb) ->
  setup: (app, path) ->
