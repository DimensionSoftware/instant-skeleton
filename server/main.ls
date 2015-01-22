
require! {
  dotenv
  shelljs
}

# supervise instances of App
# - TODO supervise more than a single instance

# init
# ---------
supervisor =
  starting: false # already starting new instance?
  instance: void  # singleton (for now)

dotenv.load! # load local environment vars from .env


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
      supervisor.instance.stop -> cl \done.
      set-timeout (-> cl \killed.; process.exit 0), 2000ms


function restart
  start = ->
    supervisor.starting = true
    App  = require \./App
    args = [
      parse-int (process.argv.2 or process.env.npm_package_config_node_port)
      process.env.CHANGESET
    ]

    # start!
    supervisor.instance := new App ...args
      ..start -> supervisor.starting = false

  if supervisor.starting then return console.warn 'Still restarting...' # guard
  if supervisor.instance # stop running app first
    supervisor.instance.stop start
  else
    start!
