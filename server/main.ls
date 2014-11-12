
require! {
  shelljs
}

# XXX the goal of main.ls is to encapsulate instances of App

# init
# ---------
starting = false # keep track of app state
instance = void

# main
# ---------
console.log "\n[1;37m,.._________[0;m"
restart! # initial b00t-up!

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
    App  = require \./App
    args = [
      process.argv.2 or (parse-int process.env.NODE_PORT) or 3000 # port
      get-latest-webpack 'public/builds'                          # changeset
    ]

    # start!
    instance := new App ...args
      ..start -> starting := false

  if starting then return console.warn 'Still restarting...' # guard
  if instance # stop running app first
    instance.stop start
  else
    start!


function get-latest-webpack dest
  {code, output} = shelljs.exec "ls -t #dest|head -1" {+silent} # use latest webpack hash
  output.trim!replace /\.js$/ '' # strip extension
