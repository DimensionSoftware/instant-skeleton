
require! {
  react: {create-factory}:React
  immutable: window.Immutable
  immstruct
  \../shared/react/App
  \../shared/features
  \./stylus/master
  \./resources
}

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

window.toggle-class = (elem, class-name, add=true) -> # add & remove class names
  if add # add
    if (body.class-name.index-of class-name) is -1
      body.class-name += " #class-name"
  else # remove
    if (body.class-name.index-of class-name) > -1
      body.class-name = body.class-name.replace " #class-name", ''


# main
# ----
init-primus!    # setup realtime socket
init-realtime!  # socket data + react

window.application-cache.add-event-listener \noupdate ->
  <- set-timeout _, 1000ms          # yield
  window.toggle-class body, \loaded # force ui load when 100% cache


function init-primus
  primus = window.primus = Primus.connect!
    ..on \close ->
      # count seconds disconnected
      if locals.env is \production
        window.closed-duration   = 0
        window.closed-duration-i = set-interval (-> window.closed-duration++), 1000ms

    ..on \changeset (c) ->
      # alert on newer application version launch
      if locals.env is \production
        if c isnt locals.changeset
          notify 'Reload' {body:'A newer version has launched!'}

    ..on \open ->
      # alert user of a stale page?
      if locals.env is \production and window.closed-duration-i
        clear-interval that
        if window.closed-duration > 3s
          notify 'Reload' {body:'A newer version of this page is ready!'}
      window.spark-id <- primus.id # easy identify primus connection

  resources primus # init primus-resources

function init-live-stream name, cb=(->)
  # create realtime "live" data streams w/ leveldb
  force-response = set-timeout cb, 1000ms
  ch = window.primus.channel name
    ..once \data (data) ->
      # stream initial data from server
      clear-timeout force-response
      cb (force-object data)
    ..on \data (data) ->
      # stream updates from server
      cur = force-object data
      if cur and window.app then window.app.update name, -> Immutable.fromJS cur
    ..on \open ->
      # fn to stream updates to server
      window["sync#{capitalize name}"] = ->
        app = window.app
        owned = app.update-in [name, \spark-id], -> window.spark-id # add update's owner
        ch.write (owned.get name .toJS!)
    ..on \close ->
      # cleanup
      delete window["#{name}Sync"]

function init-realtime
  # setup realtime streams w/ leveldb
  [stream, load] = [{}, (key, val) -->
    stream[key] = val or {} # default
    init-react stream]
  init-live-stream \everyone (load \everyone)
  init-live-stream \session (load \session)

function force-object data
  # FIXME workaround for levelup's broken transforms
  if typeof! data is \Object then data else JSON.parse data

function init-react data
  return unless data.session and data.everyone
  [locals, path] = [window.locals, window.location.pathname]
  state = immstruct { # default
    path,
    locals,
    session:  {} <<< data.session
    everyone: {} <<< data.everyone
  }
  render = -> # update on animation frames (avoids browser janks)
    window.app = cur = state.cursor!
    React.render App(cur), react # render app to body
    cur
  set-timeout (-> state.on \next-animation-frame render), 1000ms
  window.toggle-class body, \loaded # trigger ui loaded after session applies
  render!

function capitalize s
  (s.char-at 0 .to-upper-case!) + s.slice 1

if features.dimension # front!
  console?log "·▄▄▄▄  ▪  • ▌ ▄ ·. ▄▄▄ . ▐ ▄ .▄▄ · ▪         ▐ ▄ \n██▪ ██ ██ ·██ ▐███▪▀▄.▀·•█▌▐█▐█ ▀. ██ ▪     •█▌▐█\n▐█· ▐█▌▐█·▐█ ▌▐▌▐█·▐▀▀▪▄▐█▐▐▌▄▀▀▀█▄▐█· ▄█▀▄ ▐█▐▐▌\n██. ██ ▐█▌██ ██▌▐█▌▐█▄▄▌██▐█▌▐█▄▪▐█▐█▌▐█▌.▐▌██▐█▌\n▀▀▀▀▀• ▀▀▀▀▀  █▪▀▀▀ ▀▀▀ ▀▀ █▪ ▀▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪\nHey, you-- join us!  https://dimensionsoftware.com"
