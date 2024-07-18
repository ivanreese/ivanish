markdownit = require("markdown-it") html: true, typographer: true
require "sweetbread"

typePages =
  "2D": "art"
  "3D": "art"
  Album: "music"
  "Art": "art"
  Band: "music"
  Blog: "blog"
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
publish: yyyy-mm-dd            # will make the page appear in the rss feed
desc: [any text]               # generates a description for the <head>
###

# TODO: hest-time-travel has multiple <main>s
# TODO: Charges needs to do the footer stuff nested inside some other DOM
# TODO: Use desc for the year page description?
# TODO: specify an image in the frontmatter for OG?

compilePage = (head, header, path)->

  # Load the page source, then separate the frontmatter from the body
  parts = read(path).split "---"

  # If the page doesn't have frontmatter, just copy it over to the public folder
  return parts[0] if parts.length is 1

  frontmatter = parts[0]
  body = parts[1...].join "---"

  # Extract k-v pairs from the frontmatter
  data = {}
  for line in frontmatter.split "\n"
    [k, v] = line.split /\s*:\s*/
    data[k] = v if k

  # Now we'll begin building the HTML

  # Start with the <head>
  pageHeader = head

  # If we have a description, it goes in the <head>
  pageHeader += "  <meta name=\"description\" content=\"#{data.desc}\">" if data.desc

  # TODO: If we have an image we can use for rich previews, it goes in the <head>
  data.image ?= "assets/og.jpg"
  pageHeader += "  <meta property=\"og:image\" content=\"https://d3um8l2sa8g9bu.cloudfront.net/#{data.image}\">"

  # The <head> is now done
  pageHeader += "</head>\n<body>"

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

  # Process custom comment syntax
  body = body.replaceAll /^\s*\/\/.*$/gm, ""

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

  # Add a <footer> at the bottom of most pages
  footer = makeFooter data

  # Combine all the parts of our page into the final HTML output
  html = [pageHeader, openMain, body, footer, closeMain].join "\n"

  # Return the data, the processed html, and the body (for RSS)
  [data, html, body]


makeFooter = (data)->
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
    "<footer>\n  #{inner}\n</footer>"
  else
    ""

alphaSort = new Intl.Collator('en').compare

generateRSS = (published)->
  posts = published
    .sort (a, b)-> b[0].localeCompare(a[0])
    .slice(0, 20) # Include only the 20 most recent posts
    .map ([published, body, dest])->

      pattern = /<title>(.*?)<\/title>/
      title = body.match(pattern)[1]
      body = body.replace pattern, ""

      link = replace dest, "public/": "", "/index.html": ""

      published = new Date(published + "T00:00:00").toUTCString()
        # .toLocaleString "en-US", timeZone: "MST", year: "numeric", month: "short", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit", timeZoneName: "short"

      body = body.replaceAll "\n", ""

      """
        <item>
          <title>#{title}</title>
          <link>https://ivanish.ca/#{link}</link>
          <guid isPermaLink="false">/#{link}</guid>
          <pubDate>#{published}</pubDate>
          <description>
            <![CDATA[#{body}]]>
          </description>
        </item>\n
      """.split("\n").map((l)-> "    " + l).join("\n")

  [read("source/rss"), posts, "  </channel>", "</rss>"].flat().join "\n"


task "build", "Compile everything", ()->
  compile "everything", ()->

    rm "public"

    head = read "source/head.html"
    header = read "source/header.html"

    # Store all the published pages we encounter, so we can generate an rss feed
    published = []

    compile "pages", "source/pages/**/*.{md,html}", (path)->
      dest = replace path,
        "source/pages": "public"
        ".html": "/index.html"
        ".md": "/index.html"
        "/index/": "/" # If the file was named index.ext it'd be /index/index.html which we don't want

      [data, html, body] = compilePage head, header, path

      # If this page has a published date, store it for the RSS feed
      published.push [data.publish, body, dest] if data.publish?.match /^\d{4}-\d{2}-\d{2}$/

      write dest, html

    # Generate the RSS feed
    write "public/rss", generateRSS published

    # Compile the rest of the stuff
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
