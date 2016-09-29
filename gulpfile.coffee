browser_sync = require("browser-sync").create()
del = require "del"
gulp = require "gulp"
gulp_autoprefixer = require "gulp-autoprefixer"
gulp_changed = require "gulp-changed"
gulp_coffee = require "gulp-coffee"
gulp_concat = require "gulp-concat"
gulp_htmlmin = require "gulp-htmlmin"
gulp_kit = require "gulp-kit"
gulp_notify = require "gulp-notify"
gulp_rename = require "gulp-rename"
gulp_sass = require "gulp-sass"
gulp_uglify = require "gulp-uglify"


# CONFIG ##########################################################################################


paths =
  assets:
    source: "source/assets/**/*"
  coffee:
    source: "source/script/**/*.coffee"
  kit:
    source: "source/pages/**/*.kit"
    header: "source/{header,header-min}.kit"
    watch: "source/**/*.kit" # pages + header-min.kit, header.kit
  pageCoffee:
    source: "source/pages/**/*.coffee"
  pageSCSS:
    source: "source/pages/**/*.scss"
  scss:
    source: [
      "source/**/vars.scss"
      "source/style/**/*.scss"
    ]


gulp_notify.logLevel(0)


# HELPER FUNCTIONS ################################################################################


logAndKillError = (err)->
  console.log "\n## Error ##"
  console.log err.toString() + "\n"
  gulp_notify.onError(
    emitError: true
    icon: false
    message: err.message
    title: "👻"
    wait: true
    )(err)
  @emit "end"


# TASKS: APP COMPILATION ##########################################################################


gulp.task "assets", ()->
  gulp.src paths.assets.source
    .pipe gulp.dest "public/assets"
    .pipe browser_sync.stream
      match: "**/*"
        

gulp.task "coffee", ()->
  gulp.src paths.coffee.source
    .pipe gulp_concat "scripts.coffee"
    .pipe gulp_coffee()
    .pipe gulp_uglify()
    .on "error", logAndKillError
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.js"


gulp.task "del:public", ()->
  del "public"


gulp.task "del:html", ()->
  del "public/**/*.html"

      
gulp.task "kit", ()->
  gulp.src paths.kit.source
    .on "error", logAndKillError
    .pipe gulp_kit()
    .pipe gulp_rename (path)->
      if path.basename is "index"
        path.dirname = ""
      else
        path.dirname = path.dirname + "/" + path.basename
        path.basename = "index"
      return path
    .pipe gulp_htmlmin
      collapseWhitespace: true
      collapseBooleanAttributes: true
      conservativeCollapse: false
      includeAutoGeneratedTags: false
      minifyCSS: true
      minifyJS: true
      removeComments: true
      sortAttributes: true
      sortClassName: true
    .pipe gulp_changed "public", extension: ".html", hasChanged: gulp_changed.compareSha1Digest
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.html"


gulp.task "pageCoffee", ()->
  gulp.src paths.pageCoffee.source
    .pipe gulp_coffee()
    .pipe gulp_uglify()
    .on "error", logAndKillError
    .pipe gulp_rename (path)->
      path.dirname = path.dirname + "/" + path.basename
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.js"


gulp.task "pageSCSS", ()->
  gulp.src paths.pageSCSS.source
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 2
    .on "error", logAndKillError
    .pipe gulp_autoprefixer
      browsers: "last 5 Chrome versions, last 5 ff versions, IE >= 11, Safari >= 9, iOS >= 9"
      cascade: false
      remove: false
    .pipe gulp_rename (path)->
      path.dirname = path.dirname + "/" + path.basename
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.css"


gulp.task "scss", ()->
  gulp.src paths.scss.source
    .pipe gulp_concat "styles.scss"
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 2
    .on "error", logAndKillError
    .pipe gulp_autoprefixer
      browsers: "last 5 Chrome versions, last 5 ff versions, IE >= 11, Safari >= 9, iOS >= 9"
      cascade: false
      remove: false
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.css"
      

gulp.task "serve", ()->
  browser_sync.init
    ghostMode: false
    online: true
    server:
      baseDir: "public"
    ui: false


gulp.task "watch", (cb)->
  gulp.watch paths.kit.header, gulp.series "del:html", "kit" # Kit causes a double-compile, but without it we get a Cannot GET / when we edit the header.kit
  gulp.watch paths.assets.source, gulp.series "assets"
  gulp.watch paths.coffee.source, gulp.series "coffee"
  gulp.watch paths.kit.watch, gulp.series "kit"
  gulp.watch paths.pageCoffee.source, gulp.series "pageCoffee"
  gulp.watch paths.pageSCSS.source, gulp.series "pageSCSS"
  gulp.watch paths.scss.source, gulp.series "scss"
  cb()


gulp.task "default", gulp.series "del:public", gulp.parallel("assets", "coffee", "kit", "pageCoffee", "pageSCSS", "scss"), "watch", "serve"
