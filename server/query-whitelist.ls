
require! {
  \rethinkdb-websocket-server : {r, RP}
}

# XXX rethinkdb-websocket-server uses Promises

module.exports = [
  # everyone table
  r.table \everyone
    .order-by {index: (r.desc \date)}
    .changes {+include-states, +include-initial}
  r.table \everyone # new TODO
    .insert (refs [\name \title \completed \date])
    .validate session-name
  r.table \everyone # update TODO
    .get (RP.ref \id)
    .update (refs [\completed \date \id \name \title])
    .validate session-name
  r.table \everyone
    .get (RP.ref \id)
    .update (refs [\completed \date \id \name \title \completed-at])
    .validate session-name

  # session table
  r.table \sessions
    .get (RP.ref \sid)
    .changes {+include-states, +include-initial}
  r.table \sessions
    .changes {+include-states, +include-initial}
    .validate session-id
  r.table \sessions # add TODO
    .get (RP.ref \id)
    .update (refs [\cookie \id \onPage \sid \todos])
    .validate session-auth-token
  r.table \sessions # update TODO
    .get (RP.ref \id)
    .update (refs [\cookie \id \onPage \sid \name \todos])
    .validate session-auth-token
  r.table \sessions # update name
    .get (RP.ref \id)
    .update (refs [\cookie \id \onPage \sid \name])
    .validate session-auth-token
  r.table \sessions
    .filter {sid: RP.ref \sid}
    .validate session-id
]

function session-id {sid} session
  session.sid is sid

function session-auth-token {sid}, {auth-token}:rethinkdb-session
  auth-token is sid

function session-name {name}, {auth-token}:rethinkdb-session
  [session] <- run-query!table \sessions .get-all auth-token, {index: \sid} .then
  session.name ||= \Anonymous is name

function refs names=[]
  prev, cur <- fold _, {} names
  prev[cur] = RP.ref cur
  prev
