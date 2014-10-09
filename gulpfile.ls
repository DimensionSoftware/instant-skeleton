
require! <[gulp del gulp-nodemon gulp-util gulp-livescript gulp-stylus nib gulp-jade gulp-webpack gulp-watch gulp-livereload]>

is-production = process.env.NODE_ENV is \production

# TODO build jade, stylus, etc...
# ---------
gulp.task \build:stylus ->
  gulp.src './client/stylus/master.styl'
    .pipe gulp-stylus {use: [nib!], +compress}
    .pipe gulp.dest './public'

gulp.task \build:server ->
  gulp.src './server/*.ls'
    .pipe gulp-livescript {+bare}
    .on \error -> throw it
    .pipe gulp.dest './build'
gulp.task \build:client ->
  gulp.src './client/*.ls'
    .pipe gulp-livescript {+bare}
    .on \error -> throw it
    .pipe gulp.dest './build/client'
gulp.task \build <[build:server build:client build:stylus]>

# asset optimization
# ---------
gulp.task \pack <[build:client]> ->
  gulp.src './build/client/*.js'
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
  gulp-nodemon {script: './build/main.js'}


# main
default-tasks = <[build pack]>
unless is-production then default-tasks.push \develop
gulp.task \default default-tasks
