markdownit = require("markdown-it") html: true, typographer: true
require "sweetbread"

typePages =
  "2D": "art"
  "3D": "art"
  Album: "music"
  "Art?": "art"
  Band: "music"
  Game: "code"
  "Interactive Art": "code" # not sure this makes sense — is this more art-y, or more code-y?
  Performance: "performance"
  Photography: "art"
  Podcast: "thoughts"
  "Procedural Art": "code" # not sure this makes sense — is this more art-y, or more code-y?
  "Procedural Music": "code" # not sure this makes sense — is this more music-y, or more code-y?
  Project: "project" # this is new-esq
  Score: "music" # this is new
  Song: "music"
  Thoughts: "thoughts"
  Toy: "code"
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

compilePage = (head, header, path)->

  # Load the page source, then separate the frontmatter from the body
  parts = read(path).split "---"
  frontmatter = parts[0]
  body = parts[1...].join "---"
  # [body, frontmatter] = [frontmatter, ""] unless body
  throw "Expect all pages to have frontmatter" unless body

  # Extract k-v pairs from the frontmatter
  data = {}
  for line in frontmatter.split "\n"
    [k, v] = line.split /\s*:\s*/
    data[k] = v if k

  # Now we'll begin building the HTML

  # Start with the <head>
  pageHeader = head

  # If we have a description, it goes in the <head>
  pageHeader += "<meta name=\"description\" content=\"#{data.desc}\">" if data.desc

  # The <head> is now done
  pageHeader += "\n</head>\n<body>"

  # Based on data.header, figure out what <header> to prepend to the final page HTML
  # The only currently support option is "min", in which case we skip the header
  pageHeader += "\n" + header unless data.header is "min"

  # Page bodies will be wrapped in a <main>, unless they already contain a <main>
  # Also inject any attrs specified in data.main
  hasMain = body.includes "<main"
  openMain = if hasMain then "" else if data.main then "<main #{data.main}>" else "<main>"
  closeMain = if hasMain then "" else "</main>"

  # Process custom <title> syntax
  body = body.replaceAll /^\s*!\s+(.+)$/gm, "<title>$1</title>"
  body = body.replaceAll /^\s*!-\s+(.+)$/gm, "<title class=\"hide\">$1</title>"

  # Process markdown pages
  body = markdownit.render body if path.endsWith "md"

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

  # Warn if we encountered a pre, because that probably means markdown goofed
  console.log "warning: <pre> from #{path}" if body.includes "<pre"

  # Add rel="nofollow" to external links that don't already have a rel
  body = body.replaceAll /<a .*?>/g, (match)->
    if /href=.\//.test match # Internal link?
      match
    else if /href=.#/.test match # On-page link?
      match
    else if match.includes "rel=" # Has a rel?
      match
    else unless match.includes "href" # Not a link, just an anchor?
      match
    else # External link, no rel
      match.replace "<a ", "<a rel=\"nofollow\" "

  # Add a <section class="related"> at the bottom of most pages
  related = makeRelated data

  # Combine all the parts of our page into the final HTML output
  [pageHeader, openMain, body, related, closeMain].join "\n"


makeRelated = (data)->
  if data.type
    type = data.type
    for name, page of typePages
      type = type.replaceAll name, "<a href=\"/#{page}\">#{name}</a>"

  if data.time
    time = data.time
      .replaceAll /(\d{4})/g, '<a href="/time#$1">$1</a>'
      .replaceAll "Immemorial", '<a href="/time#time-immemorial">Time Immemorial</a>'

  if type or time
    inner = if type and time then "#{type} from #{time}" else type or time
    "<section class=\"related\">\n  #{inner}\n</section>"
  else
    ""


task "build", "Compile everything", ()->
  compile "everything", ()->

    rm "public"

    head = read "source/head.html"
    header = read "source/header.html"

    compile "pages", "source/pages/**/*.{md,html}", (path)->
      dest = replace path,
        "source/pages": "public"
        ".html": "/index.html"
        ".md": "/index.html"
        "/index/": "/" # If the file was named index.ext it'd be /index/index.html which we don't want
      write dest, compilePage head, header, path

    compile "global styles", ()->
      write "public/styles.css", concat readAll "source/style/**/vars.css", "source/style/**/!(vars).css"

    compile "global scripts", ()->
      write "public/scripts.js", coffee concat readAll "source/script/**/*.coffee"

    compile "page styles", "source/pages/**/*.css", (path)->
      copy path, replace path, "source/pages":"public"

    compile "page scripts", "source/pages/**/*.coffee", (path)->
      dest = replace path, "source/pages":"public", "coffee":"js"
      write dest, coffee read path

    compile "static", "source/**/*.!(coffee|html|md|css)", "source/404.html", (path)->
      copy path, replace path, "source/":"public/", "/pages/":"/"

    # Redirects
    if process.env.NETLIFY
      write "public/_redirects", [
        "/codex   " + process.env.CODEX_URL
        "/meet    " + process.env.MEET_URL
        "/showdoc " + process.env.SHOWDOC_URL
        "/zoom    " + process.env.ZOOM_URL
      ].join "\n"


task "watch", "Recompile on changes.", ()->
  watch "source", "build", reload

task "serve", "Spin up a live reloading server.", ()->
  serve "public"

task "start", "Build, watch, and serve.", ()->
  invoke "build"
  invoke "watch"
  invoke "serve"
