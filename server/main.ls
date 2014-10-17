
require! {
  shelljs
}

# XXX the goal of main.ls is to encapsulate instances of App

# init
# ---------
starting = false
instance = void
global.CHANGESET = get-latest-webpack 'public/builds'
global.VENDORSET = get-latest-webpack 'public/vendor'
global.React     = require \react/addons

# main
# ---------
restart!
process.on \SIGHUP -> restart!
process.on \message (msg) ->
  cl = console.log
  switch msg
    | \shutdown => # force after 2s
      cl 'Closing all connections: '
      instance.stop -> cl \done.
      set-timeout (-> cl \killed.; process.exit 0), 2000ms


function restart
  start = ->
    starting := true
    App = require \./App
    instance := new App (process.argv.2 or (parse-int process.env.NODE_PORT) or 3000)
      ..start -> starting := false

  if starting then return console.warn 'Still restarting...' # guard
  if instance
    instance.stop start
  else
    start!


function get-latest-webpack dest
  {code, output} = shelljs.exec "ls -t #dest|head -1" {+silent} # use latest webpack hash
  output.trim!replace /\.js$/ '' # strip extension
