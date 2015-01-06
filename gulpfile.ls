
require! {
  fs
  gulp
  dotenv
  \del
  \open
  \gulp-jade
  \gulp-livescript
  \gulp-nodemon
  \gulp-shell
  \gulp-util
  \gulp-watch
  \webpack

  './package.json': config
  './webpack.config.js': wp-config

  './server/App': App
  'webpack-dev-server': WebpackDevServer
}

dotenv.load!

const env       = process.env.NODE_ENV or \development
const port      = parse-int process.env.npm_package_config_node_port
const dev-port  = process.env.npm_package_config_dev_port
const subdomain = process.env.npm_package_config_subdomain

const prod = env is \production

const compiler = webpack wp-config # use code caching


# build transformations
# ---------------------
gulp.task \build:primus (cb) ->
  const app = new App port
  <- fs.mkdir \./public/vendor
  <- app.start
  app # save primus client from koa config
    ..primus.save './public/vendor/primus.js'
    ..stop cb

gulp.task \build:server ->
  gulp.src ['./{shared,server}/**/*.ls']
    .pipe gulp-livescript {+bare, -header, const:true} # strip
    .pipe gulp.dest './build'

gulp.task \build:client run-compiler # build client app bundle


# watching
# --------
gulp.task \webpack:dev-server <[build:primus build:client]> (cb) ->
  const dev-server = new WebpackDevServer compiler, {
    #+hot # TODO
    quiet: prod
    debug: !prod
    devtool: \sourcemap
    public-path:  "http://#subdomain:#dev-port/builds/"
    content-base: "http://#subdomain:#port"
  }
  dev-server.listen dev-port, (err) ->
    if err then throw new gulp-util.PluginError "webpack-dev-server: #err"
    cb!

gulp.task \watch ->
  gulp.watch ['./server/**/*.ls' './shared/**/*.ls'] [\build:server]


# cleanup
# -------
gulp.task \stop (gulp-shell.task 'pm2 stop processes.json')
gulp.task \clean (cb) -> del ['./build/*' './public/builds/*'] cb


# env tasks
# ---------
gulp.task \development <[build:server watch webpack:dev-server ]> ->
  gulp-nodemon {script:config.main, ext:'ls jade', ignore:<[node_modules client]>, node-args:'--harmony'}
    .once \start ->
      <- boot-delay-fn
      open "http://#subdomain:#port"
    .on \restart ->
      <- boot-delay-fn
      <- run-compiler
gulp.task \production <[build:client ]> (gulp-shell.task 'pm2 start processes.json')


# main
# ----
default-tasks = <[build:server build:primus ]>
  ..push env
gulp.task \default default-tasks


function boot-delay-fn fn
  set-timeout fn, 1700ms # TODO replace with child-to-parent msg

function run-compiler cb
  (err, stats) <- compiler.run
  if err then throw new gulp-util.PluginError "webpack-dev-server: #err"
  process.env.CHANGESET = stats.hash
  cb!

# vim:fdm=marker
