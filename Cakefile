fs = require "fs"
glob = require "glob"
marked = require "marked"
{ markedSmartypants } = require "marked-smartypants"
require "sweetbread"

marked.use(markedSmartypants());

browserslist = "last 2 Chrome versions, last 2 ff versions, last 2 Safari versions, last 2 iOS versions"

readFile = (filePath)->
  fs.readFileSync(filePath).toString()

mkdest = (p)-> mkdir p.split("/")[...-1].join("/")

typePages =
  Song: "music"
  Thoughts: "thoughts"

### Supported Frontmatter
type: [any value listed in typePages]
time: [any year]
header: min
main: [any text, injected into the <main> tag]
###

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

  # MD
  start = performance.now()

  headerMin = readFile "source/header-min.kit"
  header = readFile "source/header.kit"

  for p in glob.sync "source/pages/**/*.md"
    dest = p
      .replace "source/pages", "public"
      .replace ".md", "/index.html"
      .replace "/index/", "/" # If the file was named index.md it'd be /index/index.html which we don't want

    mkdest dest

    parts = readFile(p).split "---"
    frontmatter = parts[0]
    markdown = parts[1...].join "---"

    if not markdown
      markdown = frontmatter
      frontmatter = ""

    markdown = markdown.replaceAll /^!\s+(.+)$/gm, "<title>$1</title>"

    data = {}
    for line in frontmatter.split "\n"
      [k,v] = line.split /\s*:\s*/
      data[k] = v

    pageHeader = headerMin
    pageHeader += "\n" + header unless data.header

    related = if data.type and data.time
      link = typePages[data.type] or throw "Missing type"
      "<section class='related'><a href='/#{link}'>#{data.type}</a> from <a href='/#{data.time}'>#{data.time}</a></section>"
    else
      ""

    result = [
      pageHeader
      "<main #{data.main or ''}>"
      marked.parse markdown
      related
      "</main>"
    ].join "\n"

    fs.writeFileSync dest, result

  log "Compiled public/**/*.html " + duration start

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
  for p in glob.sync "source/**/*.!(md|kit|scss|coffee)"
    dest = p.replace("source/", "public/").replace("/pages/", "")
    mkdest dest
    success = Compilers.static p, dest, quiet: true
    return unless success
  log "Copied static assets      " + duration start

  # Redirects
  if process.env.NETLIFY
    redirects = [
      "/codex   " + process.env.CODEX_URL
      "/meet    " + process.env.MEET_URL
      "/showdoc " + process.env.SHOWDOC_URL
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
