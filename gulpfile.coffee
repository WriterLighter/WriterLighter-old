gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
plumber    = require 'gulp-plumber'
concat     = require 'gulp-concat'
gutil      = require 'gulp-util'
less       = require 'gulp-less'
watch      = require 'gulp-watch'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
electron   = require('electron-connect').server.create()
rename     = require 'gulp-rename'
minifyCss  = require "gulp-clean-css"
uglify     = require "gulp-uglify"
gulpFilter = require 'gulp-filter'
bower      = require 'main-bower-files'

gulp.task 'vendorJS', ->
  browserify
    entries: ['src/namespace.coffee']
    extentions: ['.coffee']
  .bundle()
  .pipe source 'vendor.js'
  .pipe gulp.dest 'tmp'

# bowerで導入したパッケージのCSSを取ってくるタスク
gulp.task 'vendorCSS', ->
  cssFilter  = gulpFilter('**/*.css', {restore: true})
  gulp.src bower
    paths:
      bowerJson: 'bower.json'
		.pipe cssFilter
		.pipe rename
			prefix: '_',
			extname: '.css'
		.pipe gulp.dest 'tmp/css'
		.pipe cssFilter.restore

# パッケージのCSSを1つに結合してmin化するタスク
gulp.task 'css', ['vendorCSS','less'] ,->
  gulp.src 'tmp/css/*.css'
		.pipe concat('style.css')
		# CSSを1つにしたものを出力
		.pipe gulp.dest('dist/')
		.pipe minifyCss()
		.pipe rename
			extname: '.min.css'
		# CSSを1つにしてmin化したものを出力
		.pipe gulp.dest('dist/')
 
gulp.task 'app', ->
  gulp.src 'src/app/*.coffee'
    .pipe(plumber())
    .pipe(coffee())
    .pipe(concat('app.js'))
    .pipe(gulp.dest('tmp'))
 
gulp.task 'concat',['vendorJS', 'app'],  ->
  gulp.src ['tmp/vendor.js', 'tmp/app.js' ]
    .pipe(concat('index.js'))
    .pipe(gulp.dest('dist'))
 
gulp.task 'main', ->
  gulp.src 'src/main.coffee'
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest(''))
 
gulp.task 'less', ->
  gulp.src 'src/less/*.less'
    .pipe(less())
    .pipe(gulp.dest('tmp/css'))
 
gulp.task 'watch', ['default'], ->
  electron.start()
  watch('src/less/*.less', (e)-> gulp.start 'css')
  watch('src/main.coffee', (e)-> gulp.start 'main')
  watch(['src/app/**/*.coffee', 'src/namespace.coffee'], (e)-> gulp.start 'concat')
  watch 'dist/main.js', electron.restart
  watch ['index.html', 'dist/index.js', 'dist/css/*.css'], electron.reload
 
gulp.task 'default', ['concat', 'main', 'css', 'html']
