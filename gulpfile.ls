
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
  nib

  primus: Primus

  './server/App': App
}

env = process.env.NODE_ENV or \development

# build transformations
# ---------
# TODO shared jade
# TODO save primus.js at every build
gulp.task \build:primus (cb) ->
  #app = new App
  #<~ app.start
  #app.primus.save './public/vendor/primus.js'
  #app.stop cb
  cb!
gulp.task \build:stylus ->
  gulp.src \./client/stylus/master.styl
    .pipe gulp-stylus {use: nib!, +compress}
    .pipe gulp.dest \./public
gulp.task \build:react ->
  gulp.src './shared/react/*.ls'
    .pipe gulp-livescript {+bare}
    .pipe gulp.dest './build/shared/react'
gulp.task \build:js ->
  gulp.src './{client,shared,server}/*.ls'
    .pipe gulp-livescript {+bare}
    .pipe gulp.dest './build'
gulp.task \build <[build:primus build:js build:stylus]>

# asset optimization
# ---------
gulp.task \pack <[build:primus build:js build:react]> ->
  gulp.src './build/{client,shared}/*.js'
    .pipe gulp-webpack!
    .pipe gulp.dest './public/builds'
  gulp.src './client/vendor/*.js'
    .pipe gulp-webpack {
      dev-tool: \source-map
      context:  "#__dirname/build"
      entry:    './client/layout.js'
      optimize: env is \production
    }
    .pipe gulp.dest './public/vendor/builds'
  # TODO html, css, etc...

gulp.task \watch ->
  gulp.watch './shared/react/*.ls' [\build:react]
  gulp.watch './{client,shared,server}/*.ls' [\build:js \pack]
  gulp.watch './client/stylus/*.styl' [\build:stylus]
  gulp-livereload.listen!

# cleanup
# ---------
gulp.task \stop (gulp-shell.task 'pm2 stop processes.json')
gulp.task \clean (cb) ->
  del <[./build/**]> cb

# env tasks
# ---------
script = './build/server/main.js'
gulp.task \development <[build watch]> ->
  gulp-nodemon {script, node-args: '--harmony'}
gulp.task \production <[build]> (gulp-shell.task 'pm2 start processes.json')

# main
default-tasks = <[build pack]>
  ..push env
gulp.task \default default-tasks
