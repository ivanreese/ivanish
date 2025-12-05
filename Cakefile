require "sweetbread"

coffeescript = require "coffeescript"
coffee = (code)-> coffeescript.compile code, bare: true, inlineMap: true

markdownit = require("markdown-it") html: true, typographer: true

typePages =
  "2D": "art"
  "3D": "art"
  Album: "music"
  "Art": "art"
  Band: "music"
  Blog: "blog"
  Game: "code"
  "Interactive": "code"
  Performance: "performance"
  Photography: "art"
  Podcast: "uncategorized"
  "Procedural Music": "code" # not sure this makes sense — is this more music-y, or more code-y?
  Project: "project" # this is new-esq
  Score: "music#score" # this is new
  Song: "music#song"
  Thoughts: "uncategorized"
  Toy: "code"
  Video: "art"
  Writing: "uncategorized"

### Supported Frontmatter
type: [any typePages key]      # transcluding any text that doesn't match (see Shrinkin & Breakin)
time: [any year] or Immemorial # transcluding any text that doesn't match
header: min                    # tbd if there should be other options
main: [any text]               # injected into the <main> tag
publish: yyyy-mm-dd            # will make the page appear in the rss feed
desc: [any text]               # generates a description for the <head>
image: [s3 path, no leading /] # prefixes with cdn and puts og-image in <head>
###

# TODO: Charges needs to do the footer stuff nested inside some other DOM
# TODO: Use desc for the year page description?

# Helpers #

compact = (arr)-> arr.filter (v)-> v
indent = (str="", spaces="  ")-> splitLines(str).map((line)-> spaces + line).join "\n"
splitOnce = (str, sep)->
  i = str.indexOf sep
  if i is -1 then [str] else [str.slice(0, i), str.slice(i + sep.length)]
splitLines = (str)-> str.split "\n"
trim = (s)-> s.trim()
trimAll = (arr)-> arr.map trim

# Split str to the left of the first occurrence of char
# splitBefore("1234", "3") => ["12", "34"]
# splitBefore("1234", "5") => ["", "1234"]
splitBefore = (str, char)->
  index = Math.max str.indexOf(char), 0
  [str.slice(0, index), str.slice(index)]

# Split str to the right of the first occurrence of char
# splitAfter("1234", "3") => ["123", "4"]
# splitAfter("1234", "5") => ["1234", ""]
splitAfter = (str, char)->
  index = str.indexOf char
  splitIndex = if index is -1 then str.length else index + 1
  [str.slice(0, splitIndex), str.slice(splitIndex)]

# Returns tuples with the link text and href
extractMdLinks = (sourceText)->
  Array.from(sourceText.matchAll /\[(.*?)\]\((.*?)\)/g).map ([_, linkText, linkUrl])-> [linkText, linkUrl]

getValuesOfAttributes = (src, attr)->
  compact [
    src.match new RegExp "#{attr}=\"[^\"]+\"", "g" # double quotes
    src.match new RegExp "#{attr}='[^']+'", "g"    # single quotes
  ]
    .flat()
    .map (match)-> match.slice attr.length + 2, -1 # attr="foo" -> foo

# Turn arbitrary text into nice(ish) url-safe "slugs". Eg: `This isn't *so* bad!` becomes `this-isnt-so-bad`
slugify = (s)-> s.toLowerCase().replaceAll(/['']/g, "").replace(/[^a-z0-9]+/g, " ").trim().replaceAll(/ +/g, "-")

# Similar to the above, but preserves more of unicode (eg: letters with accents)
anchorize = (s)-> s.toLowerCase().replaceAll("&amp;","and").replaceAll(/['']/g, "").replace(/[^\p{L}\p{N}]/gu, " ").trim().replaceAll(/ +/g, "-")

cdata = (s)-> "<![CDATA[#{s}]]>"

# Remove HTML tags — eg, for cleaning up the description frontmatter for inclusion in <meta>
# TODO: make this smart enough to ignore code blocks inside <pre>
plainify = (s)-> s.replace /<[^>]+>/g, ""

# Replace all instances of an html tag in a string, using a given replacement function
replaceHtmlTag = (html, tag, cb)->
  regex = new RegExp "( *)<#{tag}(?![a-zA-Z])([^>]*)>(.*?)</#{tag}>", "gs"
  html.replaceAll regex, (match, spaces, attrs, contents)-> cb contents.trim(), attrs, spaces

# For natural sorting
compare = new Intl.Collator("en").compare

# Some date string handling
isISOString = (str)-> /^\d{4}-\d{2}-\d{2}/.test str
dateIsInTheFuture = (str)-> compare(str, new Date().toISOString().slice(0, 10)) > 0

# URL handling
withLeadingSlash = (path)-> if path.startsWith "/" then path else "/" + path
withTrailingSlash = (path)-> if path.endsWith "/" then path else path + "/"
withOuterSlashes = (path)-> withLeadingSlash withTrailingSlash path

toFullUrl = (path)->
  path = if path.startsWith "http" then path else "https://ivanish.ca" + withLeadingSlash path
  segs = path.split "/"
  path = if segs.at(-1).includes "." then path else withTrailingSlash path
  path


# COMPILATION #

loadPage = (path)->

  # Load the page source, and split it up
  parts = read(path).split "---"

  # If the page has no frontmatter section, it's static
  return { html: parts[0] } if parts.length is 1

  # Extract the frontmatter
  frontmatter = {}
  for line in splitLines parts[0]
    [k, v] = line.split /\s*:\s*/
    frontmatter[k] = v if k

  # Assemble the body
  body = parts[1...].join "---"

  return { frontmatter, body }

compileContent = (path)->

  { frontmatter, body, html } = loadPage path

  # If the page had no frontmatter, it's static
  return [{}, html, ""] if html

  html = read "template/default.html"
  html = replace html, "{{content}}": body

  # Return the frontmatter, the processed html, and the body (for RSS)
  [frontmatter, html, body]


compilePage = (head, header, path)->

  { frontmatter, body, html } = loadPage path

  # If the page had no frontmatter, it's static
  return [{}, html, ""] if html

  # Start with the <head>
  pageHeader = head

  # If we have a description, it goes in the <head>
  pageHeader += "  <meta name=\"description\" content=\"#{frontmatter.desc}\">" if frontmatter.desc

  # TODO: If we have an image we can use for rich previews, it goes in the <head>
  frontmatter.image ?= "assets/og.jpg"
  pageHeader += "  <meta property=\"og:image\" content=\"https://cdn.ivanish.ca/#{frontmatter.image}\">"

  # The <head> is now done
  pageHeader += "</head>\n<body>"

  # Based on frontmatter.header, figure out what <header> to prepend to the final page HTML
  # The only currently support option is "min", in which case we skip the header
  pageHeader += "\n" + header unless frontmatter.header is "min"

  # Page bodies will be wrapped in a <main>
  openMain = if frontmatter.main then "<main #{frontmatter.main}>" else "<main>"
  closeMain = "</main>"

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
      compact splitLines markdownit.renderInline md
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
  footer = makeFooter frontmatter

  # Combine all the parts of our page into the final HTML output
  html = [pageHeader, openMain, body, footer, closeMain].join "\n"

  # Return the frontmatter, the processed html, and the body (for RSS)
  [frontmatter, html, body]


makeFooter = (frontmatter)->
  if frontmatter.type
    type = frontmatter.type
    for name, page of typePages
      type = type.replaceAll name, "<a href=\"/#{page}\">#{name}</a>"

  if frontmatter.time
    time = frontmatter.time
      .replaceAll /(\d{4})/g, '<a href="/time#$1">$1</a>'
      .replaceAll "Immemorial", '<a href="/time#time-immemorial">Time Immemorial</a>'

  if type or time
    inner = if type and time then "#{type} from #{time}" else type or time
    "<footer>\n  #{inner}\n</footer>"
  else
    ""


generateFeed = (published)->
  published
    .sort (a, b)-> b[0].localeCompare a[0]
    .slice(0, 20) # Include only the 20 most recent posts
    .map ([published, body, dest])->

      pattern = /<title.*?>(.*?)<\/title>/
      title = body.match(pattern)?.at 1
      body = body.replace pattern, ""

      link = replace dest, "public/": "", "/index.html": ""

      published = new Date(published + "T12:00:00").toUTCString()
        # .toLocaleString "en-US", timeZone: "MST", year: "numeric", month: "short", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit", timeZoneName: "short"

      [published, body, dest, title, link]

feedItem = (title, link, published, body)->
  indent """
    <item>
      <title>#{title}</title>
      <link>https://ivanish.ca/#{link}</link>
      <guid isPermaLink="false">/#{link}</guid>
      <pubDate>#{published}</pubDate>
      <description>
        #{cdata body}
      </description>
    </item>\n
  """, "    "

generateRSS = (published)->
  posts = generateFeed published
    .map ([published, body, dest, title, link])-> feedItem title, link, published, body.replaceAll "\n", ""
  [read("source/feeds/rss"), posts, "  </channel>", "</rss>"].flat().join "\n"

generateCSS = (published)->
  posts = generateFeed published
    .map ([published, body, dest, title, link])->
      pattern = /<style>([\s\S]*?)<\/style>/ig
      styles = Array.from(body.matchAll(pattern)).map (match)-> match[1]
      return "" unless styles.length
      feedItem title, link, published, "<pre><code>#{styles.join "\n\n"}</code></pre>"
  [read("source/feeds/css"), posts, "  </channel>", "</rss>"].flat().join "\n"



generateRedirectPages = ()->
  redirects = read "Redirects.txt"
  lines = trimAll splitLines redirects
  pages = []

  for line in lines
    continue unless line.startsWith "/" # Bare text is treated as a comment and ignored

    [oldPath, newPath] = line.split /\s+/
    continue unless oldPath and newPath

    # Only two destination types are supported: absolute path and full URL
    unless newPath.startsWith("/") or newPath.startsWith("http")
      log "Redirects.txt contains an invalid destination path: #{green newPath}"
      continue

    # If both the oldPath and the newPath include an extension, we'll assume they're static assets.
    # In this case, we copy newPath->oldPath (using a hardlink). We have to do this because we don't
    # control the server, so we can't do a 301 or 302, so this is the next best option.
    if oldPath.includes(".") and newPath.includes(".")
      # paths are relative to the public folder, so we need to find the source file
      newFile = glob("{content,template}#{newPath}")[0]
      linkFile newFile, "public#{oldPath}" if newFile
      continue

    # If the oldPath includes .html, we need to make sure it skips the /name.html -> /name/index.html rewrite.
    wasHtml = oldPath.endsWith ".html"

    # path the page would have had if it were a real page
    path = if wasHtml then "content#{oldPath}" else "content#{withTrailingSlash oldPath}index.html"

    # Generate the source text for the redirect page. It's all frontmatter.
    fm = ["template: redirect", "redirect_url: #{newPath}", "index: false"]
    fm.push "clean: false" if wasHtml
    source = ["---", fm..., "---"].join "\n"


task "build", "Compile everything", ()->
  compile "everything", ()->

    rm "public"

    head = read "source/head.html"
    header = read "source/header.html"

    # Store all the published pages we encounter, so we can generate an rss feed
    published = []

    compile "content", "content/**/*.{md,html}", (path)->
      dest = replace path,
        "content": "public"
        ".html": "/index.html"
        ".md": "/index.html"
        "/index/": "/" # If the file was named index.ext it'd be /index/index.html which we don't want

      [frontmatter, html, body] = compileContent path

      # If this page has a published date, store it for the RSS feed
      published.push [frontmatter.publish, body, dest] if frontmatter.publish?.match /^\d{4}-\d{2}-\d{2}$/

      write dest, html

    compile "pages", "source/pages/**/*.{md,html}", (path)->
      dest = replace path,
        "source/pages": "public"
        ".html": "/index.html"
        ".md": "/index.html"
        "/index/": "/" # If the file was named index.ext it'd be /index/index.html which we don't want

      [frontmatter, html, body] = compilePage head, header, path

      # If this page has a published date, store it for the RSS feed
      published.push [frontmatter.publish, body, dest] if frontmatter.publish?.match /^\d{4}-\d{2}-\d{2}$/

      write dest, html

    # Generate the RSS feed
    write "public/rss", generateRSS published

    # Generate the CSS feed
    write "public/css", generateCSS published

    # Compile the rest of the stuff
    compile "global styles", ()->
      write "public/styles.css", concat readAll "source/style/**/vars.css", "source/style/**/!(vars).css"

    compile "global scripts", ()->
      write "public/scripts.js", coffee concat readAll "source/script/**/*.coffee"

    compile "page styles", "source/pages/**/*.css", (path)->
      copy path, replace path, "source/pages":"public"

    compile "page coffee", "source/pages/**/*.coffee", (path)->
      dest = replace path, "source/pages":"public", "coffee":"js"
      write dest, coffee read path

    compile "static", "source/**/*.!(coffee|html|md|css)", "source/404.html", (path)->
      copy path, replace path, "source/":"public/", "/pages/":"/"

task "diff", "Test build system changes.", ()->
  invoke "build"
  execSync "git diff --no-index public-snapshot public || true"

task "kiss", "Save current public as known-good.", ()->
  rm "public-snapshot"
  execSync "cp -r public public-snapshot"

task "watch", "Recompile on changes.", ()->
  watch "source", "build", reload

task "serve", "Spin up a live reloading server.", ()->
  serve "public"

task "start", "Build, watch, and serve.", ()->
  invoke "build"
  invoke "watch"
  invoke "serve"
