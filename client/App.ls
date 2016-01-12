
require! {
  react: {create-factory}:React
  \react-rethinkdb : {Session}
  \react-dom
  immutable: window.Immutable
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


# main
# ----
rethink-session = new Session!
  ..connect do
    host:   locals.domain
    port:   locals.port
    path:   '/db'
    secure: false
init-react {rethink-session}

window.application-cache.add-event-listener \noupdate ->
  window.toggle-class body, \loaded # force ui load when 100% cache


function init-react data
  if data.session === {} then data.session = window.storage.get \session # use local storage
  [locals, path] = [window.locals, window.location.pathname]
  state = immstruct { # default
    path,
    locals,
    rethink-session: data.rethink-session
    session:   {} <<< data.session
    everyone:  {} <<< data.everyone
  }
  render = -> # update on animation frames (avoids browser janks)
    window.app = cur = state.cursor!
    react-dom.render (App cur), react # render app to body
    cur
  set-timeout (-> state.on \next-animation-frame render), 1000ms
  window.toggle-class body, \loaded # trigger ui loaded
  render!

function capitalize s
  (s.char-at 0 .to-upper-case!) + s.slice 1

if features.dimension # front!
  console?log "·▄▄▄▄  ▪  • ▌ ▄ ·. ▄▄▄ . ▐ ▄ .▄▄ · ▪         ▐ ▄ \n██▪ ██ ██ ·██ ▐███▪▀▄.▀·•█▌▐█▐█ ▀. ██ ▪     •█▌▐█\n▐█· ▐█▌▐█·▐█ ▌▐▌▐█·▐▀▀▪▄▐█▐▐▌▄▀▀▀█▄▐█· ▄█▀▄ ▐█▐▐▌\n██. ██ ▐█▌██ ██▌▐█▌▐█▄▄▌██▐█▌▐█▄▪▐█▐█▌▐█▌.▐▌██▐█▌\n▀▀▀▀▀• ▀▀▀▀▀  █▪▀▀▀ ▀▀▀ ▀▀ █▪ ▀▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪\nHey, you-- join us!  https://dimensionsoftware.com"
