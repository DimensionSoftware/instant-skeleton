
require! {
  del
  gulp
  \gulp-jade
  \gulp-livereload
  \gulp-livescript
  \gulp-nodemon
  \gulp-shell
  \gulp-shell
  \gulp-stylus
  \gulp-util
  \gulp-watch
  \gulp-webpack
  \webpack
  \jquery
  nib

  primus: Primus

  './server/App': App
}

config = require './package.json'
env    = process.env.NODE_ENV or \development

# build transformations
# ---------
# TODO shared jade
gulp.task \build:primus (cb) ->
  app = new App 31337
  <- app.start
  app # save primus from koa config
    ..primus.save './public/vendor/primus.js'
    ..stop cb
gulp.task \build:stylus ->
  gulp.src \./client/stylus/master.styl
    .pipe gulp-stylus {use: nib!, +compress}
    .pipe gulp.dest \./public
gulp.task \build:react ->
  gulp.src './shared/react/*.ls'
    .pipe gulp-livescript {+bare, -header} # strip
    .pipe gulp.dest './build/shared/react'
gulp.task \build:js ->
  gulp.src './{client,shared,server}/*.ls'
    .pipe gulp-livescript {+bare, -header} # strip
    .pipe gulp.dest './build'
gulp.task \build <[build:react build:js build:stylus]>

# asset optimization
# ---------
gulp.task \pack <[build ]> ->
  # main app bundle
  plugins =
    * new webpack.DefinePlugin { 'process.env': {NODE_ENV: env} } # for react
    * new webpack.optimize.DedupePlugin
    * new webpack.ProvidePlugin { $: jquery }
  if env is \production then plugins = plugins ++ new webpack.optimize.UglifyJsPlugin
  gulp.src './{client,shared}'
    .pipe gulp-webpack {
      plugins
      dev-tool: \source-map
      optimize: env is \production
      module:
        loaders:
          * test: /\.jade$/, loader: \jade-loader?self
          * test: /\.json$/, loader: \json
          * test: /\.ls$/,   loader: \livescript
      #amd: { +jquery }
      entry: './build/client/layout.js'
      node:
        fs: \empty
    }
    .pipe gulp.dest './public/builds'
  # TODO html, css, etc...

gulp.task \watch ->
  gulp.watch './shared/views/*.jade' [\pack]
  gulp.watch './shared/react/*.ls' [\pack]
  gulp.watch './{client,shared,server}/*.ls' [\pack]
  gulp.watch './client/stylus/*.styl' [\build:stylus]
  gulp-livereload.listen!

# cleanup
# ---------
gulp.task \stop (gulp-shell.task 'pm2 stop processes.json')
gulp.task \clean (cb) ->
  del <[./build/**]> cb

# env tasks
# ---------
gulp.task \development [\pack \watch] ->
  gulp-nodemon {script:config.main, node-args: '--harmony'}
gulp.task \production (gulp-shell.task 'pm2 start processes.json')

# main
default-tasks = <[build:primus pack]>
  ..push env
gulp.task \default default-tasks
