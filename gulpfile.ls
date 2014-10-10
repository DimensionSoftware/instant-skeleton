
require! <[gulp del gulp-nodemon gulp-util gulp-livescript gulp-stylus nib gulp-jade gulp-webpack gulp-watch gulp-livereload]>

is-production = process.env.NODE_ENV is \production

# build transformations
# ---------
# TODO jade
gulp.task \build:stylus ->
  gulp.src \./client/stylus/master.styl
    .pipe gulp-stylus {use: nib!, +compress}
    .pipe gulp.dest \./public
gulp.task \build:js ->
  gulp.src './{client,shared,server}/*.ls'
    .pipe gulp-livescript {+bare}
    .pipe gulp.dest './build'
gulp.task \build <[build:js build:stylus]>

# asset optimization
# ---------
gulp.task \pack <[build:js]> ->
  gulp.src './build/{client,shared}/*.js'
    .pipe gulp-webpack!
    .pipe gulp.dest './public'
  # TODO html, css, etc...

gulp.task \watch ->
  livereload.listen!
  gulp.watch 'build/**'

# cleanup
# ---------
gulp.task \clean (cb) ->
  del <[./build/**]> cb

# develop
# ---------
gulp.task \develop <[build]> ->
  gulp-nodemon {script: './build/server/main.js'}


# main
default-tasks = <[build pack]>
unless is-production then default-tasks.push \develop
gulp.task \default default-tasks
