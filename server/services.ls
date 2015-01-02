
require! {
  \level-live-stream
}


@init = (app, primus) ->
  level-live-stream.install app.sdb

  primus.on \connection (spark) ~>
    spark.send \CHANGESET app.changeset

    # stream level db user sessions
    session = primus.channel \session
      ..on \connection (spark) ~>
        s-stream = app.sdb.create-live-stream!
          ..pipe session, {-end} # pipe session updates
          ..on \data (data) ->
            # send updated sessions to client
            if data.key is spark.request.key and v = data.value # XXX string & object?
              session.write (if typeof! v is \Object  then v else JSON.parse v)

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
