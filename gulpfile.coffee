browser_sync = require("browser-sync").create()
gulp = require "gulp"
gulp_autoprefixer = require "gulp-autoprefixer"
gulp_coffee = require "gulp-coffee"
gulp_concat = require "gulp-concat"
gulp_kit = require "gulp-kit"
gulp_rename = require "gulp-rename"
gulp_sass = require "gulp-sass"
gulp_sourcemaps = require "gulp-sourcemaps"
gulp_using = require "gulp-using"
gulp_util = require "gulp-util"

paths =
  coffee:
    source: [
      "source/script/ready.coffee"
      "{bower_components,source}/**/*.coffee"
    ]
    watch: "{bower_components,source}/**/*.coffee"
  kit:
    source: "source/pages/*.kit"
    watch: "source/**/*.kit"
  sass:
    source: "source/styles.scss"
    watch: "{bower_components,source}/**/*.scss"


onError = (err)->
  console.error "Tell Ivan!", err.message
  @emit "end"


gulp.task "coffee", ()->
  gulp.src paths.coffee.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_sourcemaps.init()
    .pipe gulp_concat "scripts.coffee"
    .pipe gulp_coffee().on "error", gulp_util.log
    .pipe gulp_sourcemaps.write "."
    .on "error", onError
    .pipe gulp.dest "public/_assets"
    .pipe browser_sync.stream match: "**/*.js"


gulp.task "kit", ()->
  gulp.src paths.kit.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_kit()
    .pipe gulp_rename (path)->
      if path.basename is "index"
        path.dirname = ""
      else
        path.dirname = path.basename
        path.basename = "index"
      path
    .on "error", onError
    .pipe gulp.dest "public"
    .pipe browser_sync.stream match: "**/*.html"


gulp.task "sass", ()->
  gulp.src paths.sass.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_sourcemaps.init()
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 1
    .pipe gulp_autoprefixer
      browsers: "last 2 Chrome versions, last 2 ff versions, IE >= 10, Safari >= 8, iOS >= 8"
      cascade: false
      remove: false
    .pipe gulp_sourcemaps.write "."
    .on "error", onError
    .pipe gulp.dest "public/_assets"
    .pipe browser_sync.stream match: "**/*.css"


gulp.task "serve", ()->
  browser_sync.init
    files: [
        "./**/*.html"
        "./_assets/scripts.js"
        "./_assets/styles.css"
      ]
    ghostMode: false
    server:
      baseDir: "./public"
    ui: false
    watchOptions:
      ignored: "*.map"


gulp.task "default", ["serve", "coffee", "kit", "sass"], ()->
  gulp.watch paths.coffee.watch, ["coffee"]
  gulp.watch paths.kit.watch, ["kit"]
  gulp.watch paths.sass.watch, ["sass"]
