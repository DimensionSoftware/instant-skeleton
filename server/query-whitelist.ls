
require! {
  \rethinkdb-websocket-server : {r, RP}
}

module.exports = [
  r.table \sessions
    .filter {sid: RP.ref \sid}
    .validate (({sid}, session) -> session.sid === sid)
  r.table \sessions
    .changes {+include-states, +include-initial}
    .validate (({sid}, session) -> session.sid === sid)
]
