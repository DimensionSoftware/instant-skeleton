
require! {
}

# init
# ---------
starting = false
instance = void

# main
# ---------
restart!
process.on \SIGHUP -> restart!


function restart
  start = ->
    starting := true
    App = require \./App
    instance := new App (process.argv.2 or parse-int(process.env.NODE_PORT) or 3000)
      ..start -> starting := false

  if starting then return console.warn 'Still restarting...' # guard
  if instance
    instance.stop start
  else
    start!

function get-CHANGESET
  {code, output} = shelljs.exec 'git rev-parse HEAD' {+silent}
  output.trim!
