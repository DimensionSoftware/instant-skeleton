
require! {
  \level-live-stream
}


@init = (app, primus) ->
  level-live-stream.install app.sdb

  primus.on \connection (spark) ~>
    spark.send \CHANGESET app.changeset

    # stream level db user session
    session = primus.channel \session
      ..on \connection (spark) ~>
        sdb-stream = app.sdb.create-live-stream!
        sdb-stream.pipe session, {-end}
        sdb-stream.on \data (data) ->
          if data.key is spark.request.key
            session.write (JSON.parse data.value)

        spark.on \data (data) ->
          console.log \GOT data



# TODO flesh out TODO service
@example-service =
  find: (params, cb) ->
  get: (id, params, cb) ->
  create: (data, params, cb) ->
  update: (id, data, params, cb) ->
  patch: (id, data, params, cb) ->
  remove: (id, params, cb) ->
  setup: (app, path) ->
