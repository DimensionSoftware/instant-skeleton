
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

