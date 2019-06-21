const gulp = require('gulp');
const sourcemaps = require('gulp-sourcemaps');
const coffee = require('gulp-coffee');
const browserSync = require('browser-sync').create();

gulp.task(('HTML'), () => {
  return gulp.src('./src/**/*.html')
  .pipe(gulp.dest('./bulid/'));
})

gulp.task('CSS', () => {
  return gulp.src('./src/**/*.css')
  .pipe(gulp.dest('./bulid/'));
})

gulp.task('img', () => {
  return gulp.src('./src/img/*')
  .pipe(gulp.dest('./bulid/img/'));
})

gulp.task('deploy', () => {
  return gulp.src('./bulid/**/*')
    .pipe($.ghPages());
});

gulp.task('coffee', () => {
  return gulp.src('./src/**/*.coffee')
  .pipe(sourcemaps.init())
  .pipe(coffee({bare: true}))
  .pipe(sourcemaps.write('.'))
  .pipe(gulp.dest('./bulid/'));
})

gulp.task('browser-sync', function() {
  browserSync.init({
      server: {
          baseDir: "./bulid" // 要注意這裡應該要指向到要模擬的伺服器資料夾，也就是 public
      }
  });
});

gulp.task('watch', gulp.parallel('browser-sync', () =>{
  gulp.watch('./src/**/*.html', gulp.series('HTML'));
  gulp.watch('./src/css/**/*.css',  gulp.series('CSS'));
  gulp.watch('./src/js/**/*.coffee', gulp.series('coffee'));
}));

gulp.task('default',gulp.series('HTML', 'CSS', 'img', 'coffee','watch'));