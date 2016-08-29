
require! {
  dotenv
  shelljs
}

# supervise instances of App

# init
# ---------
dotenv.load!
supervisor = {-starting, -instance}


# main
# ---------
console.log "\n[1;37m▄═━一一一  一    .. .[0;m"
restart! # initial b00t-up!

process
  ..on \SIGHUP ->
    for k,v of require.cache then delete require.cache[k] # clear require cache
    restart!
  ..on \SIGINT -> # for pm2 & friends
    supervisor.instance.stop ->
      <- set-timeout _, 150ms # allow event-loop cleanup ticks
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
