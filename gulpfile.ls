
require! {
  del
  nib
  gulp
  \gulp-jade
  \gulp-livescript
  \gulp-nodemon
  \gulp-shell
  \gulp-util
  \gulp-watch
  \gulp-webpack
  \webpack

  './server/App': App
  'extract-text-webpack-plugin': ExtractText
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

# asset optimization
# ---------
gulp.task \pack [] ->
  # main app bundle
  plugins =
    * new webpack.DefinePlugin { 'process.env': {NODE_ENV: env} } # for react
    * new webpack.optimize.DedupePlugin
    * new ExtractText \site.css {+all-chunks}
  if env is \production then plugins = plugins ++ new webpack.optimize.UglifyJsPlugin
  gulp.src ['./{client,shared}', './client/stylus']
    .pipe gulp-webpack {
      plugins
      dev-tool: \source-map
      optimize: env is \production
      module:
        loaders:
          * test: /\.jade$/, loader: \jade-loader?self
          * test: /\.ls$/,   loader: \livescript-loader
          * test: /\.styl$/, loader: (ExtractText.extract \stylus-loader, \css-loader!stylus-loader)
      stylus:
        use: [nib!]
      entry: './client/layout.ls'
      node:
        fs: \empty
    }
    .pipe gulp.dest './public/builds'
  # TODO html, css, etc...

gulp.task \watch ->
  gulp.watch './shared/views/*.jade' [\pack]
  gulp.watch './shared/react/*.ls' [\pack]
  gulp.watch './{client,shared,server}/*.ls' [\pack]
  #gulp.watch './client/stylus/*.styl' [\build:stylus]

# cleanup
# ---------
gulp.task \stop (gulp-shell.task 'pm2 stop processes.json')

# env tasks
# ---------
gulp.task \development [\pack \watch] ->
  gulp-nodemon {script:config.main, ignore:<[cookbook logs ./node_modules/** ./build/**]>, node-args:'--harmony'}
gulp.task \production (gulp-shell.task 'pm2 start processes.json')

# main
default-tasks = <[build:primus pack]>
  ..push env
gulp.task \default default-tasks
