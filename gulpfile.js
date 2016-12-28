let gulp;
module.exports = gulp = require('gulp');

const $           = require('gulp-load-plugins')();
const config      =    require('./package.json');
const del         =    require('del');
const packager    =    require('electron-packager');
const runSequence =    require('run-sequence');
const Path        =    require('path');
const extend      =    require('extend');
const mkdirp      =    require('mkdirp');
const electron    = require('electron-connect')
  .server.create();

const isHTML = file => Path.extname(file.path === "html");

const packageOpts = {
  asar: true,
  dir: 'dist',
  out: 'packages',
  name: config.name,
  version: config.dependencies['electron-prebuilt'],
  prune: true,
  overwrite: true,
  'app-version': config.version,
  'version-string': {
    ProductName: config.name,
    InternalName: config.name,
    FileDescription: config.name,
    CompanyName: 'Shibafu',
    LegalCopyright: '',
    OriginalFilename: `${config.name}.exe`
  }
};

const packageElectron = function(opts, done) {
  if (opts == null) { opts = {}; }
  return packager(extend(packageOpts, opts), function(err) {
    if (err) {
      if (err.syscall === 'spawn wine') {
        $.util.log('Packaging failed. Please install wine.');
      } else {
        throw err;
      }
    }

    if (done != null) { return done(); }
  });
};

const globFolders = function(pattern, func, callback) {
  let g;
  let doneTasks = 0;
  return g = new (require("glob").Glob)(pattern, function(err, pathes) {
    if (err) { throw err; }
    const done = function() {
      doneTasks++;
      if ((callback != null) && doneTasks >= pathes.length) { return callback(); }
    };

    if (pathes.length > 0) {
      return Array.from(pathes).map((path) => func(path, done));
    } else {
      return callback();
    }
  });
};

gulp.task('clean', ['clean:css', 'clean:dist', 'clean:packages']);
gulp.task('clean:css', () => del(['css/**/*', 'css']));
gulp.task('clean:dist', () => del(['dist/**/*', 'dist']));
gulp.task('clean:packages', () => del(['packages/**/*', 'packages']));
gulp.task('clean:releases', () => del(['releases/**/*', 'releases']));

gulp.task('compile', ['compile:scss']);
gulp.task('compile:production', ['compile:scss:production']);

gulp.task('compile:scss', () =>
  gulp.src('src/scss/**/*.scss')
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.sass())
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('css'))
);

gulp.task('compile:scss:production', ['clean:css'], () =>
  gulp.src('src/scss/**/*.scss')
    .pipe($.sass())
    .pipe($.cssnano({
      zindex: false})
  )
    .pipe(gulp.dest('css'))
);

gulp.task('dist', ['clean:dist'], () =>
  gulp.src([
    'src',
    'css/**/*',
    'assets/**/*',
    'はじめよう/**/*',
    'extensions/**/*',
    '*.html',
    '*.js',
    '!gulpfile.js',
    'menu.yml',
    '*.json'
  ], { base: '.' })
    .pipe($.if(isHTML, $.useref()))
    .pipe(gulp.dest('dist'))
    .pipe($.install({
      production: true})
  )
);

gulp.task('package', ['clean:packages', 'dist'], done => runSequence('package:win32', 'package:darwin', 'package:linux', done));

gulp.task('package:win32', done =>
  packageElectron({
    platform: 'win32',
    arch: 'ia32,x64',
    icon: Path.join(__dirname, '')
  }, done)
);
gulp.task('package:linux', done =>
  packageElectron({
    platform: 'linux',
    arch: 'ia32,x64'
  }, done)
);
gulp.task('package:darwin', done =>
  packageElectron({
    platform: 'darwin',
    arch: 'x64',
    icon: Path.join(__dirname, '')
  }, () =>
    gulp.src([`packages/*-darwin-*/${config.name}.app/Contents/Info.plist`], { base: '.' })
      .pipe($.plist({
        CFBundleDocumentTypes: [
          {
            CFBundleTypeExtensions: '',
            CFBundleTypeIconFile: '',
            CFBundleTypeName: '',
            CFBundleTypeRole: 'Editor',
            LSHandlerRank: 'Owner'
          }
        ]}))
      .pipe(gulp.dest('.'))
      .on('end', done)
  )
);

gulp.task('build',        done => runSequence('compile:production', 'package', done));
gulp.task('build:win32',  done => runSequence('compile:production', 'dist', 'package:win32', done));
gulp.task('build:linux',  done => runSequence('compile:production', 'dist', 'package:linux', done));
gulp.task('build:darwin', done => runSequence('compile:production', 'dist', 'package:darwin', done));

gulp.task('archive', ['archive:win32', 'archive:darwin', 'archive:linux']);

gulp.task('archive:win32', done =>
  globFolders('packages/*-win32-*', (path, globDone) =>
    gulp.src([`${path}/**/*`])
      .pipe($.zip(`${config.version}-${Path.basename(path, '.*')}.zip`))
      .pipe(gulp.dest('releases'))
      .on('end', globDone)
  
  , done)
);

gulp.task('archive:darwin', function(done) {
  const appdmg = (() => { try {
    return require('appdmg');
  } catch (err) {
    return null;
  } })();

  if (!appdmg) {
    $.util.log('Archiving for darwin is supported only OSX.');
    $.util.log('In OSX, please install appdmg (`npm install appdmg`)');
    return done();
  }

  return globFolders('packages/*-darwin-*', function(path, globDone) {
    const release_to = Path.join(__dirname, `releases/${config.version}-${Path.basename(path, '.*')}.dmg`);

    return mkdirp(Path.dirname(release_to), err =>
      del(release_to)
        .then(function() {
          const running_appdmg = appdmg({
            target: release_to,
            basepath: Path.join(__dirname, path),
            specification: {
              title: config.name,
              background: Path.join(__dirname, "resources/darwin/dmg-background.png"),
              'icon-size': 80,
              window: {
                position: { x: 90, y: 90 },
                size: { width: 624, height: 412 }
              },
              contents: [
                { x: 210, y: 300, type: 'file', path: `${config.name}.app` },
                { x: 410, y: 300, type: 'link', path: '/Applications' }
              ]
            }
          });
          return running_appdmg.on('finish', globDone);
      })
    );
  }
  , done);
});

gulp.task('archive:linux', done =>
  globFolders('packages/*-linux-*', (path, globDone) =>
    gulp.src([`${path}/**/*`])
      .pipe($.tar(`${config.version}-${Path.basename(path, '.*')}.tar`))
      .pipe($.gzip())
      .pipe(gulp.dest('releases'))
      .on('end', globDone)
  
  , done)
);

gulp.task('release', done => runSequence('build', 'archive', 'clean', done));

gulp.task('run', ['compile'], function() {
  electron.start();

  $.watch("./src/scss/**/*.scss",     () => gulp.start("compile:scss"));

  $.watch(["./css/**/*.css", "./src/js/**/*.js", "./*.html"], () => electron.reload());
  $.watch("./src/js/main.js", () => electron.restart());
  return this;
});
