fs = require "fs"
glob = require "glob"
require "sweetbread"

browserslist = "last 2 Chrome versions, last 2 ff versions, last 2 Safari versions, last 2 iOS versions"

task "build", "Compile everything", ()->
  outerStart = performance.now()

  dev = not process.env.NETLIFY

  # Folders
  start = performance.now()
  rm "public"
  mkdir "public"
  for p in glob.sync "source/pages/*/"
    mkdir p.replace "source/pages", "public"
  log "Made new public folders   " + duration start

  # HTML
  start = performance.now()
  for p in glob.sync "source/pages/**/*.kit"
    dest = p.replace("source/pages","public").replace(".kit",".html")
    Compilers.kit p, dest, minify:!dev, quiet: true
  log "Compiled public/**/*.html " + duration start

  # Global styles
  patterns = ["source/style/**/vars.scss", "source/style/**/!(vars).scss"]
  paths = (glob.sync p for p in patterns).flat()
  success = Compilers.scss paths, "public/styles.css", { minify: !dev, browserslist }
  return unless success

  # Global scripts
  paths = glob.sync "source/script/**/*.coffee"
  success = Compilers.coffee paths, "public/scripts.js", minify:!dev
  return unless success

  # Page styles
  start = performance.now()
  for p in glob.sync "source/pages/**/*.scss"
    dest = p.replace("source/pages","public").replace(".scss",".css")
    success = Compilers.scss p, dest, minify: !dev, quiet: true, browserslist
    return unless success
  log "Compiled public/**/*.css  " + duration start

  # Page scripts
  start = performance.now()
  for p in glob.sync "source/pages/**/*.coffee"
    dest = p.replace("source/pages","public").replace(".coffee",".js")
    success = Compilers.coffee p, dest, minify:!dev, quiet: true
    return unless success
  log "Compiled public/**/*.js   " + duration start

  # Static
  start = performance.now()
  for p in glob.sync "source/**/*.!(kit|scss|coffee)"
    dest = p.replace("source/", "public/").replace("/pages/", "")
    mkdir dest.split("/")[...-1].join("/")
    success = Compilers.static p, dest, quiet: true
    return unless success
  log "Copied static assets      " + duration start

  # Redirects
  if process.env.NETLIFY
    redirects = [
      "/codex   " + process.env.CODEX_URL
      "/meet    " + process.env.MEET_URL
      "/zoom    " + process.env.ZOOM_URL
    ]
    fs.writeFileSync "public/_redirects", redirects.join "\n"

  log "Done building             " + duration outerStart, white


task "watch", "Recompile on changes.", ()->
  watch "source", "build", reload

task "serve", "Spin up a live reloading server.", ()->
  serve "public"

task "start", "Build, watch, and serve.", ()->
  doInvoke "build"
  doInvoke "watch"
  doInvoke "serve"
