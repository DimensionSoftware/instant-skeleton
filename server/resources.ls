
require! {
  \koa
  \level-live-stream
}

@init = (sdb, primus) ->
  primus.on \connection (spark) ->
    spark.send \CHANGESET process.env.CHANGESET

  # example "foo" resource
  foo = primus.resource \foo
    ..oncommand = (spark, command, cb) ->
      cb "got command #command"

  # TODO move into App
  # stream level db user sessions
  level-live-stream.install sdb
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
