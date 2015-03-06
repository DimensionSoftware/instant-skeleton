
require! {
  react: {create-factory}:React
  immutable: window.Immutable
  immstruct
  \../shared/react/App
  \../shared/features
  \./stylus/master
  \./resources
}

body = document.get-elements-by-tag-name \body .0 # cache

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


# main
# ----
init-react!  # expose app cursor
init-primus! # setup realtime

# setup realtime streams w/ leveldb
init-live-stream \public
init-live-stream \session -> add-class body, \loaded # trigger ui loaded after session applies


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
  ch = window.primus.channel name
    ..once \data cb # ready
    ..on \data (data) ->
      # stream updates from server
      cur = if typeof! data is \Object then data else JSON.parse data # force Object
      if cur then app.update name, -> Immutable.fromJS cur
    ..on \open ->
      # fn to stream updates to server
      window["sync#{capitalize name}"] = ->
        app = window.app
        owned = app.update-in [name, \spark-id], -> window.spark-id # add update's owner
        ch.write (owned.get name .toJS!)
    ..on \close ->
      # cleanup
      delete window["#{name}Sync"]

function init-react
  [locals, path] = [window.locals, window.location.pathname]
  state = immstruct {path, locals, public:{}, session:{}} # default app state

  # update on animation frames (avoids browser janks)
  render = (cur, old) ->
    React.render App(window.app = state.cursor!), body # render app to body
  state.on \next-animation-frame render
  render!

  state.cursor! # expose immutable data structure

function capitalize s
  (s.char-at 0 .to-upper-case!) + s.slice 1

function add-class elem, class-name
  if body.class-name.index-of class-name isnt -1
    body.class-name += " #class-name"

if features.dimension # front!
  console?log "·▄▄▄▄  ▪  • ▌ ▄ ·. ▄▄▄ . ▐ ▄ .▄▄ · ▪         ▐ ▄ \n██▪ ██ ██ ·██ ▐███▪▀▄.▀·•█▌▐█▐█ ▀. ██ ▪     •█▌▐█\n▐█· ▐█▌▐█·▐█ ▌▐▌▐█·▐▀▀▪▄▐█▐▐▌▄▀▀▀█▄▐█· ▄█▀▄ ▐█▐▐▌\n██. ██ ▐█▌██ ██▌▐█▌▐█▄▄▌██▐█▌▐█▄▪▐█▐█▌▐█▌.▐▌██▐█▌\n▀▀▀▀▀• ▀▀▀▀▀  █▪▀▀▀ ▀▀▀ ▀▀ █▪ ▀▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪\nHey, you-- join us!  https://dimensionsoftware.com"
