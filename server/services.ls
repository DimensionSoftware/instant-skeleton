
require! {
  \koa
  \level-live-stream
}

# TODO services are a work-in-progress

app = koa!

@router = (next) ->*
  # TODO realtime service router
  # expose each service over 'service' channel
  yield next

@init = (sdb, primus) ->
  level-live-stream.install sdb

  primus.on \connection (spark) ->
    spark.send \CHANGESET app.changeset

    # stream level db user sessions
    session = primus.channel \session

      # send sessions to client
      ..on \connection (spark) ~>
        s-stream = sdb.create-live-stream!
          ..pipe session, {-end} # pipe updates
          ..on \data (data) ->
            if data.key is spark.request.key and v = data.value
              session.write (try JSON.parse v catch {})

        # save sessions from client
        spark.on \data (data) ->
          @session = data
          sdb.put spark.request.key, JSON.stringify data


## TODO flesh out TODO service
@session =
  find: (params, cb) ->
  get: (id, params, cb) ->
  create: (data, params, cb) ->
  update: (id, data, params, cb) ->
  patch: (id, data, params, cb) ->
  remove: (id, params, cb) ->
  setup: (app, path) ->
