
require! {
  \./stylus/master
  \../shared/features
  immutable: window.Immutable
}

dimension!
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
# ---------
# configure primus
primus = window.primus = Primus.connect!
  ..on \close ->
    # count seconds disconnected
    if locals.env is \production
      window.closed-duration = 0
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

    # stream session updates from server
    session = primus.channel \session
      ..on \data (data) ->
        window.session = window.Immutable.Map(if typeof! data is \Object then data else JSON.parse data)

    # stream session updates to server
    window.set-session = (new-session) ->
      window.session = new-session
      session.write new-session.toJS!


function dimension
  if features.dimension # front!
    console?log "·▄▄▄▄  ▪  • ▌ ▄ ·. ▄▄▄ . ▐ ▄ .▄▄ · ▪         ▐ ▄ \n██▪ ██ ██ ·██ ▐███▪▀▄.▀·•█▌▐█▐█ ▀. ██ ▪     •█▌▐█\n▐█· ▐█▌▐█·▐█ ▌▐▌▐█·▐▀▀▪▄▐█▐▐▌▄▀▀▀█▄▐█· ▄█▀▄ ▐█▐▐▌\n██. ██ ▐█▌██ ██▌▐█▌▐█▄▄▌██▐█▌▐█▄▪▐█▐█▌▐█▌.▐▌██▐█▌\n▀▀▀▀▀• ▀▀▀▀▀  █▪▀▀▀ ▀▀▀ ▀▀ █▪ ▀▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪\nHey, you-- join us!  https://dimensionsoftware.com"
