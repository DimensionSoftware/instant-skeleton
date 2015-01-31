
require! {
  react: {create-factory}:React
  immutable: window.Immutable
  immstruct
  \../shared/react/App
  \../shared/features
  \./stylus/master
}

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
# b00t react!
init-react!  # expose app cursor
init-primus! # setup realtime


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

  # TODO move into client/resources/*
  # example "foo" resource
  foo = primus.resource \foo
    ..on \ready ->
      foo.command \test (res) ->
        console.log \res: res

  # TODO refactor into init-live-stream
  # stream session updates from server
  session = primus.channel \session
    ..on \data (data) ->
      cur = if typeof! data is \Object then data else JSON.parse data # force Object
      if cur then app.update \session, -> Immutable.fromJS cur
    ..on \open ->
      window.sync-session = (key, value) ->
        app = window.app
        cur = if typeof! key is \Object # merge key as obj
          app.merge-deep key
        else
          app.update-in [\session, key], -> value
        owned = cur.update-in [\session, \spark-id], -> window.spark-id # add update's owner
        session.write (owned.get \session .toJS!)
    ..on \close -> # cleanup
      delete window.sync-session

  init-live-stream \public


# create realtime "live" data streams w/ leveldb
function init-live-stream name
  ch = primus.channel name
    ..on \data (data) ->
      # stream updates from server
      cur = if typeof! data is \Object then data else JSON.parse data # force Object
      if cur then app.update name, -> Immutable.fromJS cur
    ..on \open ->
      # fn to stream updates to server
      window["#{name}Sync"] = (key, value) ->
        app = window.app
        cur = if typeof! key is \Object
          app.merge-deep key
        else
          app.update-in [name, key], -> value
        owned = cur.update-in [name, \spark-id], -> window.spark-id # add update's owner
        ch.write (owned.get name .toJS!)
    ..on \close ->
      # cleanup
      delete window.sync-live

function init-react
  [locals, path] = [window.locals, window.location.pathname]
  state = immstruct {path, locals, session:{updated:0}}
  body  = document.get-elements-by-tag-name \body .0

  # update on animation frames (avoids browser janks)
  render = (cur, old) ->
    React.render App(window.app = state.cursor!), body # render app to body
  state.on \next-animation-frame render
  render!

  state.cursor! # expose immutable data structure


if features.dimension # front!
  console?log "·▄▄▄▄  ▪  • ▌ ▄ ·. ▄▄▄ . ▐ ▄ .▄▄ · ▪         ▐ ▄ \n██▪ ██ ██ ·██ ▐███▪▀▄.▀·•█▌▐█▐█ ▀. ██ ▪     •█▌▐█\n▐█· ▐█▌▐█·▐█ ▌▐▌▐█·▐▀▀▪▄▐█▐▐▌▄▀▀▀█▄▐█· ▄█▀▄ ▐█▐▐▌\n██. ██ ▐█▌██ ██▌▐█▌▐█▄▄▌██▐█▌▐█▄▪▐█▐█▌▐█▌.▐▌██▐█▌\n▀▀▀▀▀• ▀▀▀▀▀  █▪▀▀▀ ▀▀▀ ▀▀ █▪ ▀▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪\nHey, you-- join us!  https://dimensionsoftware.com"
