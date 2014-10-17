
require! <[gulp gulp-shell del gulp-nodemon gulp-util gulp-livescript gulp-stylus nib gulp-jade gulp-webpack gulp-watch gulp-livereload]>

env = process.env.NODE_ENV or \development

# build transformations
# ---------
# TODO jade
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
gulp.task \build <[build:js build:stylus]>

# asset optimization
# ---------
gulp.task \pack <[build:js build:react]> ->
  gulp.src './build/{client,shared}/*.js'
    .pipe gulp-webpack!
    .pipe gulp.dest './public/builds'
  # TODO html, css, etc...

gulp.task \watch ->
  gulp.watch './shared/react/*.ls' [\build:react]
  gulp.watch './{client,shared,server}/*.ls' [\build:js]
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
