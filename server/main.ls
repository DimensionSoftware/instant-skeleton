
require! {
  dotenv
  shelljs
}

# supervise instances of App

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
process.on \SIGINT -> # for pm2 & friends
  supervisor.instance.stop ->
    <- set-timeout _, 300ms # allow event-loop some ticks
    process.exit 0

function restart
  start = ->
    supervisor.starting = true
    port = parse-int(process.env.NODE_APP_INSTANCE or 0) + parse-int(process.env.NODE_PORT or process.env.npm_package_config_node_port)
    App  = require \./App
    args =
      port
      process.env.CHANGESET or process.env.npm_package_version

    # start!
    supervisor.instance := new App ...args
      ..start -> supervisor.starting = false

  if supervisor.starting then return console.warn 'Still restarting...' # guard
  if supervisor.instance # stop running app first
    supervisor.instance.stop start
  else
    start!
