
require! {
  \rethinkdb-websocket-server : {r, RP}
}

module.exports = [
  r.table \sessions
    .filter {sid: RP.ref \sid}
    .validate (({sid}, session) -> session.sid === sid)
  r.table \sessions
    .changes {+include-states, +include-initial}
    .validate (({sid}, session) -> console.log \sid: sid, \ref: (RP.ref \sid), \session: session; session.sid === sid)
#  // List moves for a game with changefeed
#  RQ(
#    RQ.CHANGES(
#      RQ.FILTER(
#        RQ.TABLE("moves"),
#        {"gameId": x => typeof x === 'string'}
#      )
#    ).opt("include_states", true).opt("include_initial", true)
#  ).opt("db", RQ.DB(cfg.dbName)),
]
