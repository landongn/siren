"use strict";

var gulp = require("gulp");
var sass = require("gulp-sass");
var browserify = require("browserify");
var sourcemaps = require("gulp-sourcemaps");
var fs = require("fs");
var wait = require("gulp-wait");
var mkdirp = require("mkdirp");

gulp.task("js", function() {
  browserify("./js/app.js")
    .transform("babelify", {})
    .bundle()
    .pipe(fs.createWriteStream("../priv/static/js/app.js"));
});

gulp.task("assets", function() {
  return gulp.src("./static/**/*").pipe(gulp.dest("../priv/static/"));
});

gulp.task("styles", function() {
  return gulp
    .src("./css/**/*.scss")
    .pipe(sourcemaps.init())
    .pipe(wait(200))
    .pipe(sass().on("error", sass.logError))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest("../priv/static/css/"));
});

gulp.task("default", ["js", "assets", "styles", "dev:watch"]);

gulp.task("dev:watch", function() {
  mkdirp("../priv/static/js");
  gulp.watch("./css/**/*.*", ["styles"]);
  gulp.watch("./js/**/*.js", ["js"]);
  gulp.watch("./static/**/*.*", ["assets"]);
});
