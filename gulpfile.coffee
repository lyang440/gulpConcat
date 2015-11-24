'use strict'

gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
minifier = require 'gulp-minifier'
del = require 'del'

coffeeOption =
  bare: true

Files = [
  './resources/*'
]

minifierOption =
  minify: true
  collapseWhitespace: true
  conservativeCollapse: true
  minifyJS: true
  minifyCSS: true

IS_PROD = false

gulp.task 'build-file', ->
  gulp.src Files
    .pipe concat 'main.txt'
    .pipe(if IS_PROD then minifier minifierOption else gutil.noop())
    .pipe gulp.dest './resources'

gulp.task 'clean', -> del(Files)

gulp.task 'default', ['build-file']
