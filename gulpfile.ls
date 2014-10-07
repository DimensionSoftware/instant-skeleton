
require! <[gulp del gulp-util gulp-livescript gulp-stylus gulp-jade gulp-webpack gulp-watch gulp-livereload]>

# TODO build jade, stylus, etc...
# ---------
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
gulp.task \build <[build:server build:client]>

# asset optimization
# ---------
gulp.task \pack <[build:client]> ->
  gulp.src './build/client/*.js'
    .pipe gulp-webpack!
    .pipe gulp.dest './public'
  # TODO html, css, etc...

# cleanup
# ---------
gulp.task \clean (cb) ->
  del <[./build/**]> cb


gulp.task \default <[build pack]>
