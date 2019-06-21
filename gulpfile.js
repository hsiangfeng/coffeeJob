const gulp = require('gulp');
const sourcemaps = require('gulp-sourcemaps');
const coffee = require('gulp-coffee');

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
  .pipe(sourcemaps.write())
  .pipe(gulp.dest('./bulid/'));
})

gulp.task('watch', () => {
  gulp.watch('./src/**/*.html', gulp.series('HTML'));
  gulp.watch('./src/css/**/*.scss',  gulp.series('CSS'));
  gulp.watch('./src/js/**/*.coffee', gulp.series('coffee'));
})

gulp.task('default',gulp.series('HTML', 'CSS', 'img', 'coffee','watch'));