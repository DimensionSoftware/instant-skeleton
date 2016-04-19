
require! {
  fs
  gulp
  dotenv
  \open
  \gulp-livescript
  \gulp-nodemon
  \gulp-shell
  \gulp-util
  \gulp-watch
  \gulp-clean
  \gulp-exit
  \webpack

  './package.json': config
  './webpack.config.js': wp-config

  './server/App': App
  'webpack-dev-server': WebpackDevServer
}

dotenv.load!

const [env, dev-port, domain, port] =
  process.env.NODE_ENV or \development
  process.env.npm_package_config_dev_port
  process.env.DOMAIN or process.env.npm_package_config_domain
  parse-int <| process.env.NODE_PORT or process.env.npm_package_config_node_port

const [prod, compiler] =
  env is \production
  webpack wp-config # use code caching

# building
# --------
gulp.task \build:server ->
  gulp.src ['./{shared,server}/**/*.ls']
    .pipe gulp-livescript {+bare, -header, const:true} # strip
    .pipe gulp.dest './build'

gulp.task \build:client run-compiler # build client app bundle

gulp.task \clean ->
  gulp.src \build {-read}
    .pipe gulp-clean!
    .pipe gulp-exit!

# watching
# --------
gulp.task \webpack:dev-server <[build:client]> (cb) ->
  const dev-server = new WebpackDevServer compiler, {
    +quiet
    hot: !prod
    debug: !prod
    devtool: \sourcemap
    public-path:  "http://#domain:#dev-port/builds/"
    content-base: "http://#domain:#port"
  }
  dev-server.listen dev-port, (err) ->
    if err then throw new gulp-util.PluginError "webpack-dev-server: #err"
    cb!

gulp.task \watch -> # changes needing server restart
  gulp.watch ['./server/**/*.ls' './shared/**/*.ls'] [\build:server]

# env tasks
# ---------
gulp.task \development <[watch webpack:dev-server ]> ->
  gulp-nodemon {script:config.main, ext:'ls jade', ignore:<[node_modules bin build client shared/react test]>, node-args:'--harmony'}
    .once \start ->
      <- set-timeout _, 1700ms # TODO child-to-parent messaging?
      open "http://#domain:#port"
gulp.task \production <[build:client ]> -> process.exit 0

# main
# ----
gulp.task \default [\build:server env]


function run-compiler cb
  (err, stats) <- compiler.run
  if err then throw new gulp-util.PluginError "webpack-dev-server: #err"
  process.env.CHANGESET = stats.hash
  cb!

# vim:fdm=marker
