
require! {
  react: {create-factory}:React
  \react-rethinkdb : {r}
  \react-dom
  superagent: request
  immutable
  immstruct
  \../shared/react/App
  \../shared/features
  \./stylus/master
}

if locals.env isnt \production # hot-load stylus
  require \./stylus/master.styl

[body, react] = # cache
  [document.get-elements-by-tag-name \body .0,
   document.get-elements-by-class-name \react .0]

# statics
# -------
window.storage = {} <<< # to better use local storage
  del: (k)    -> local-storage.remove-item k
  get: (k)    -> try local-storage.get-item k |> JSON.parse
  has: (k)    -> local-storage.has-own-property k
  set: (k, v) -> local-storage.set-item k, JSON.stringify v

window.notify = (title, obj={body:''}) -> # to better use desktop notifications
  icon = './images/apple-touch-icon-72x72.png'
  show = -> new Notification title, {icon} <<< obj
  if Notification.permission is \granted then show!
  else
    <- Notification.request-permission
    show!

window.toggle-class = (elem, class-name, add=true) -> # add & remove class names (XXX: outside react, only!)
  if add # add
    if (body.class-name.index-of class-name) is -1
      body.class-name += " #class-name"
  else # remove
    if (body.class-name.index-of class-name) > -1
      body.class-name = body.class-name.replace " #class-name", ''

window.application-cache.add-event-listener \noupdate ->
  window.toggle-class body, \loaded # force ui load when 100% cache

window.sync-session = ->
  s = window.app.get \session .toJS! # current session
  storage.set \session s             # save in local storage
  global.RethinkSession.run-query <| # save in rethinkdb
    r.table \sessions .get s.id
      .update s

# XXX automagically save
window.sync-everyone = ->
  s = window.app.get \everyone .toJS! # current everyone
  storage.set \everyone s             # save in local storage
  global.RethinkSession.run-query <|  # save in rethinkdb
    r.table \everyone .insert s


# main
# ----
init-react! # immediately boot react & render
init-rethinkdb (err, session) ->
  if err then throw err # guard
  storage.set \session session
  s = window.app.update \session -> immutable.fromJS session


function init-rethinkdb cb
  request # GET initial session
    .get \/session
    .set \Accept \application/json
    .end (err, res) -> cb err, res.body

function init-react data={session:storage.get(\session), everyone: storage.get(\everyone)}
  [locals, path] = [window.locals, window.location.pathname]
  state = immstruct { # default
    path,
    locals,
    session:   {} <<< data.session
    everyone:  {} <<< data.everyone
  }
  render = (new-cur, old-cur, path) -> # render app to <body>
    window.app = cur = state.cursor!
    console.log \render:
    if new-cur then console.log new-cur.toJS!, old-cur.toJS!, path.0 else ''
    react-dom.render (App cur), react
    cur
  render!                                                       # initial render
  window.toggle-class body, \loaded                             # trigger ui rendered
  set-timeout (-> state.on \next-animation-frame render), 500ms # avoids browser janks

if features.dimension # front!
  console?log "·▄▄▄▄  ▪  • ▌ ▄ ·. ▄▄▄ . ▐ ▄ .▄▄ · ▪         ▐ ▄ \n██▪ ██ ██ ·██ ▐███▪▀▄.▀·•█▌▐█▐█ ▀. ██ ▪     •█▌▐█\n▐█· ▐█▌▐█·▐█ ▌▐▌▐█·▐▀▀▪▄▐█▐▐▌▄▀▀▀█▄▐█· ▄█▀▄ ▐█▐▐▌\n██. ██ ▐█▌██ ██▌▐█▌▐█▄▄▌██▐█▌▐█▄▪▐█▐█▌▐█▌.▐▌██▐█▌\n▀▀▀▀▀• ▀▀▀▀▀  █▪▀▀▀ ▀▀▀ ▀▀ █▪ ▀▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪\nHey, you-- join us!  https://dimensionsoftware.com"
