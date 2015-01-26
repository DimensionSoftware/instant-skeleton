
require! {
  \koa
  \level-live-stream
}

# TODO resources are a work-in-progress

app = koa!


@init = (sdb, primus) ->
  level-live-stream.install sdb

  primus.on \connection (spark) ->
    spark.send \CHANGESET app.changeset

  # stream level db user sessions
  session = primus.channel \session
    ..on \connection (spark) ->
      # -> send sessions to client
      s-stream = sdb.create-live-stream!
        ..pipe session # pipe updates
        ..on \data (data) ->
          if data.key is spark.request.key and data.value
            v = if typeof! data.value is \Object then data.value else JSON.parse data.value
            now = new Date!get-time!
            v.updated = now
            spark.write v

      # <- save sessions from client
      spark.on \data (data) ->
        sdb.put spark.request.key, JSON.stringify data # FIXME huh?


