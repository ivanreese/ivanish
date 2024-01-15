fs = require "fs"
glob = require "glob"
markdownit = require("markdown-it") html: true, typographer: true
require "sweetbread"

browserslist = "last 2 Chrome versions, last 2 ff versions, last 2 Safari versions, last 2 iOS versions"

readFile = (filePath)-> fs.readFileSync(filePath).toString()
mkdest = (p)-> mkdir p.split("/")[...-1].join("/")

typePages =
  "2D": "art"
  "3D": "art"
  Album: "music"
  "Art?": "art"
  Band: "music"
  Game: "code"
  Milk: "performance"
  Performance: "performance"
  Photography: "art"
  Podcast: "thoughts"
  "Procedural Art": "code" # not sure this makes sense — is this more art-y, or more code-y?
  "Procedural Music": "code" # not sure this makes sense — is this more music-y, or more code-y?
  Project: "project" # this is new-esq
  Score: "music" # this is new
  Song: "music"
  Thoughts: "thoughts"
  Video: "art"
  Writing: "thoughts"

### Supported Frontmatter
type: [any typePages key]      # transcluding any text that doesn't match (see Shrinkin & Breakin)
time: [any year] or Immemorial # transcluding any text that doesn't match
header: min                    # tbd if there should be other options
main: [any text]               # injected into the <main> tag
publish: false                 # todo!
###

# publish should probably also accept a yyyy-mm-dd date, for the RSS feed to know when an existing page is updated

# TODO: hest-time-travel has multiple <main>s
# TODO: Charges needs to do the related stuff nested inside some other DOM

# TODO: Specifying the thumbnail and short description (used on year pages) in the frontmatter would be nice for og preview head meta

compilePage = (head, header, p)->

  # Compute the destination path from the page path
  dest = p
    .replace "source/pages", "public"
    .replace ".html", "/index.html"
    .replace ".md", "/index.html"
    .replace "/index/", "/" # If the file was named index.ext it'd be /index/index.html which we don't want

  # Make any parent folders for this destination
  mkdest dest

  # Separate the frontmatter from the page body
  parts = readFile(p).split "---"
  frontmatter = parts[0]
  body = parts[1...].join "---"
  [body, frontmatter] = [frontmatter, ""] unless body

  # Extract k-v pairs from the frontmatter
  data = {}
  for line in frontmatter.split "\n"
    [k,v] = line.split /\s*:\s*/
    data[k] = v if k

  # Based on data.header, figure out what head[er] to prepend to the final page HTML
  pageHeader = head
  pageHeader += "\n" + header unless data.header

  # Page bodies will be wrapped in a <main>, unless they already contain a <main>
  # Also inject any attrs specified in data.main
  hasMain = body.indexOf("<main") > -1
  openMain = if hasMain then "" else if data.main then "<main #{data.main}>" else "<main>"
  closeMain = if hasMain then "" else "</main>"

  # Process custom <title> syntax
  body = body.replaceAll /^!\s+(.+)$/gm, "<title>$1</title>"

  # Process markdown pages
  body = markdownit.render body if p.endsWith "md"

  # Process markdown in <md> tags
  body = body.replaceAll /( *)<md>(.+?)<\/md>/gs, (match, spaces, md)->
    return [ # This return needs to be explicit for some reason I don't understand
      "#{spaces}<p>"
      markdownit.renderInline md
        .split "\n"
        .filter (v)-> v
        .map (v)-> "#{spaces}  #{v}"
      "#{spaces}</p>"
    ].flat().join "\n"

  # Warn if we encounter a pre, because that probably means markdown goofed
    console.log "warning: <pre> in #{dest}" if body.indexOf("<pre") > -1

  # Add rel="nofollow" to external links that don't already have a rel
  body = body.replaceAll /<a .*?>/g, (match)->
    if match.indexOf("href=\"/") isnt -1 # Internal link?
      match
    else if match.indexOf("href=\"#") isnt -1 # On-page link?
      match
    else if match.indexOf("rel=") isnt -1 # Has a rel?
      match
    else if match.indexOf("href") is -1 # Not a link, just an anchor?
      match
    else # External link, no rel
      match.replace "<a ", "<a rel=\"nofollow\" "

  # Add a <section class="related"> at the bottom of most pages
  related = makeRelated data

  # Combine all the parts of our page into the final HTML output
  fs.writeFileSync dest, [
    pageHeader
    openMain
    body
    related
    closeMain
  ].join "\n"


makeRelated = (data)->
  if data.type
    type = data.type
    for name, page of typePages
      type = type.replaceAll name, "<a href=\"/#{page}\">#{name}</a>"

  if data.time
    time = data.time
      .replaceAll /(\d{4})/g, '<a href="/$1">$1</a>'
      .replaceAll "Immemorial", '<a href="/time-immemorial">Time Immemorial</a>'

  if type or time
    inner = if type and time then "#{type} from #{time}" else type or time
    "<section class=\"related\">\n  #{inner}\n</section>"
  else
    ""


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

  # Pages
  start = performance.now()
  head = readFile "source/head.html"
  header = readFile "source/header.html"
  for p in glob.sync "source/pages/**/*.{md,html}"
    compilePage head, header, p
  log "Compiled pages            " + duration start

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
  for p in glob.sync "source/**/*.!(coffee|html|md|scss)"
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
