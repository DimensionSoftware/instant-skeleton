
require! {
  gulp
  gutil
  dotenv
  \del
  \open
  \gulp-jade
  \gulp-livescript
  \gulp-nodemon
  \gulp-shell
  \gulp-util
  \gulp-watch
  \gulp-webpack
  \webpack

  './server/App': App

  './package.json': config
  './webpack.config.js': wp-config
  'webpack-dev-server': WebpackDevServer
}

dotenv.load!

const env       = process.env.NODE_ENV or \development
const port      = parse-int process.env.npm_package_config_node_port
const dev-port  = process.env.npm_package_config_dev_port
const subdomain = process.env.npm_package_config_subdomain

const prod = env is \production
const dev  = env is \development
const test = env is \test

const compiler = webpack wp-config # use code caching

# build transformations
# ---------------------
gulp.task \build:primus (cb) ->
  app = new App 31337
  <- app.start
  app # save primus client from koa config
    ..primus.save './public/vendor/primus.js'
    ..stop cb

gulp.task \build:server [] ->
  gulp.src ['./{shared,server}/**/*.ls']
    .pipe gulp-livescript {+bare, -header} # strip
    .pipe gulp.dest './build'

dev-server = void
gulp.task \build:client (cb) -> # build client app bundle
  (gulp-webpack  wp-config, webpack).pipe gulp.dest './public/builds'

  if dev # boot webpack live-reload server!
    unless dev-server
      dev-server := new WebpackDevServer compiler, {
        +hot
        -quiet
        -no-info
        watch-delay: 300ms
        stats: { +colors }
        public-path: "http://#subdomain:#dev-port/assets"
        content-base: "http://#subdomain:#port"
      }
      dev-server.listen dev-port, subdomain
    cb!
  else
    cb!

gulp.task \watch ->
  gulp.watch ['./server/**/*.ls', './shared/**/*.ls'] [\build:server]
  gulp.watch ['./shared/views/*.jade', './client/**/*.ls', './client/stylus/*.styl'] [\build:client]


# cleanup
# -------
gulp.task \stop (gulp-shell.task 'pm2 stop processes.json')
gulp.task \clean (cb) -> del ['./build/*', './public/builds/*'], cb

# env tasks
# ---------
gulp.task \development <[build:server watch ]> ->
  gulp-nodemon {script:config.main, ignore:<[cookbook logs ./node_modules/** ./build/**]>, node-args:'--harmony'}
    .once \start ->
      <- set-timeout _, 1250ms # wait a bit longer for server to fully boot
      open "http://#subdomain:#dev-port/webpack-dev-server/"
    .on \restart ->
      compiler.run (err, stats) ->
        #if err then throw new gutil.PluginError "webpack:build-dev: #err"
        if err then console.error \ERROR:, err
gulp.task \production (gulp-shell.task 'pm2 start processes.json')


# main
default-tasks = <[build:server build:primus build:client ]>
  ..push env
gulp.task \default default-tasks


# vim:fdm=marker
