gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
plumber    = require 'gulp-plumber'
concat     = require 'gulp-concat'
gutil      = require 'gulp-util'
sass       = require 'gulp-sass'
watch      = require 'gulp-watch'
notify     = require 'gulp-notify'
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
  .pipe notify 'vendor.js done!!!', {onLast: true}

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
gulp.task 'css', ['vendorCSS','sass'] ,->
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
    .pipe notify 'app.js done!!!', {onLast: true}
 
gulp.task 'concat',['vendorJS', 'app'],  ->
  gulp.src ['tmp/vendor.js', 'tmp/app.js' ]
    .pipe(concat('index.js'))
    .pipe(gulp.dest('dist'))
    .pipe notify 'index.js done!!!', {onLast: true}
 
gulp.task 'main', ->
  gulp.src 'src/main.coffee'
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest(''))
    .pipe notify 'main.js done!!!', {onLast: true}
 
gulp.task 'sass', ->
  gulp.src 'src/fonts/*.*'
    .pipe(gulp.dest('dist/fonts'))
  gulp.src 'src/sass/*.scss'
    .pipe(sass())
    .pipe(gulp.dest('tmp/css'))
    .pipe notify 'index.css done!!!', {onLast: true}
 
gulp.task 'html', ->
  gulp.src 'src/index.html'
    .pipe(gulp.dest('dist'))
    .pipe notify 'index.html done!!!', {onLast: true}
 
gulp.task 'watch', ['default'], ->
  electron.start()
  watch('src/sass/*.scss', (e)-> gulp.start 'css')
  watch('src/index.html', (e)-> gulp.start 'html')
  watch('src/main.coffee', (e)-> gulp.start 'main')
  watch(['src/app/**/*.coffee', 'src/namespace.coffee'], (e)-> gulp.start 'concat')
  watch 'dist/main.js', electron.restart
  watch ['dist/index.html', 'dist/index.js', 'dist/css/*.css'], electron.reload
 
gulp.task 'default', ['concat', 'main', 'css', 'html']
