require "sweetbread"

{ createHash, createCipheriv, pbkdf2Sync } = require "crypto"

coffeescript = require "coffeescript"
coffee = (code)-> coffeescript.compile code, bare: true

markdownit = require("markdown-it") html: true, typographer: true

# label: path
typePages =
  "2D": "art#2d"
  "3D": "art#3d"
  Album: "music#album"
  Art: "art"
  Band: "music#band"
  Blog: "blog"
  Game: "code#game"
  Interactive: "code#interactive"
  Journal: "uncategorized"
  Performance: "performance"
  Photography: "art#photography"
  "Procedural Music": "code" # not sure this makes sense — is this more music-y, or more code-y?
  Project: "project" # this is new-esq
  Score: "music#score" # this is new
  Song: "music#song"
  Scrap: "uncategorized" # Loose pages that don't belong to any ontology.
  Toy: "code#toy"
  Video: "art#video"

### Supported Frontmatter
type: [any typePages key]      # transcluding any text that doesn't match (see Shrinkin & Breakin)
time: [any year] or Immemorial # transcluding any text that doesn't match
header: min                    # tbd if there should be other options
main: [any text]               # injected into the <main> tag
publish: yyyy-mm-dd            # will make the page appear in the rss feed
desc: [any text]               # generates a description for the <head>
image: [s3 path, no leading /] # prefixes with cdn and puts og-image in <head>
###

macros = (macro, path, text, frontmatter, spaces)-> switch
  # Comment
  when macro.startsWith "#" then ""

  # Optional frontmatter
  when macro.endsWith "?" then frontmatter[macro.slice 0, -1] ? ""

  # Required frontmatter
  when frontmatter[macro] then frontmatter[macro]

  # Unrecognized
  else
    log "Unrecognized macro: #{macro} in #{green path}"
    " ?" + macro + "? "

# TODO: Charges needs to do the footer stuff nested inside some other DOM
# TODO: Use desc for the year page description?

# Helpers #########################################################################################
handlebars = /{{(.+?)}}/g

expandMacros = (path, text, frontmatter, limit = 10)->
  # bail unless we have macros to expand
  return text unless text.includes "{{"
  # expand all known macros
  text = text.replace handlebars, (_, macro)-> macros trim(macro), path, text, frontmatter
  # recurse
  if limit-- then expandMacros path, text, frontmatter, limit else throw "What the fuck are you doing?"

compact = (arr)-> arr.filter (v)-> v
indent = (str="", spaces="  ")-> joinLines splitLines(str).map (line)-> spaces + line
splitOnce = (str, sep)->
  i = str.indexOf sep
  if i is -1 then [str] else [str.slice(0, i), str.slice(i + sep.length)]
splitLines = (str)-> str.split "\n"
joinLines = (...a)-> a.flat(Infinity).join "\n"
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
  html.replaceAll regex, (match, spaces, attrs, contents)-> cb trim(contents), attrs, spaces

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

tidy = (path, source)->
  replace path,
    [source]: "public"
    ".html": "/index.html"
    ".md": "/index.html"
    "/index/": "/" # If the file was named index.ext it'd be /index/index.html which we don't want

# COMPILATION #####################################################################################

# Takes a file path, loads and parses the page, returns frontmatter object and body text
loadPage = (path)->

  # Load the page source, and split it up
  parts = read(path).split "---\n"

  # Initially, we assume pages have no frontmatter section
  frontmatter = {}
  body = parts[0]

  # But if the page is sectioned, parse the frontmatter and reassemble the body
  if parts.length > 1
    for line in splitLines parts[0]
      [k, v] = line.split /\s*:\s*/
      frontmatter[k] = trim v if v
    body = parts[1...].join "---\n"

  { frontmatter, body }

# Returns compiled html and body
compileContent = ({ path, frontmatter, body})->

  # Expand macros
  body = expandMacros path, body, frontmatter

  template = frontmatter.template ? "default"

  html = read "template/#{template}.html"

  # Expand macros
  frontmatter.content = body # TODO: use a proper "page" object
  html = expandMacros path, html, frontmatter

  # Return the processed html, and the body (for RSS)
  {html, body}

# Returns compiled html and body
compilePage = ({head, header, path, frontmatter, body})->

  # Start with the <head>
  pageHeader = head

  # If we have a description, it goes in the <head>
  if frontmatter.desc
    pageHeader += "  <meta name=\"description\" content=\"#{frontmatter.desc}\">"
    pageHeader += "  <meta name=\"og:description\" content=\"#{frontmatter.desc}\">"

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

  # Process custom cdn syntax
  body = body.replaceAll "cdn://", "https://cdn.ivanish.ca/"


  # Process markdown pages
  body = markdownit.render body if path.endsWith "md"

  # Process markdown in <md> tags
  body = body.replaceAll /( *)<md>(.+?)<\/md>/gs, (match, spaces, md)->
    joinLines [
      "#{spaces}<p>"
      compact splitLines markdownit.renderInline md
        .map (v)-> "#{spaces}  #{v}"
      "#{spaces}</p>"
    ]

  # Warn if we encountered a pre, because that probably means markdown goofed
  log "warning: <pre> from #{green path}" if body.includes "<pre"

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

  # Expand macros
  body = expandMacros path, body, frontmatter

  # If the page doesn't include a footer marker, make one
  footerMarker = if body.includes "<!-- footer -->" then "" else "<!-- footer -->"

  # Combine all the parts of our page into the final HTML output
  html = [pageHeader, openMain, body, footerMarker, closeMain].join "\n"

  # Replace the footer marker with a real footer
  html = html.replace "<!-- footer -->", makeFooter frontmatter

  # Expand macros
  html = expandMacros path, html, frontmatter

  # Return the processed html, and the body (for RSS)
  {html, body}


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
  for line in trimAll splitLines read "Redirects.txt"
    continue unless line.startsWith "/" # Bare text is treated as a comment and ignored

    [oldPath, newPath] = line.split /\s+/
    continue unless oldPath and newPath

    # Only two destination types are supported: absolute path and full URL
    unless newPath.startsWith("/") or newPath.startsWith("http")
      log "Redirects.txt contains an invalid destination path: #{green newPath}"
      continue

    # info the page would have had if it were a real page
    path = "content#{withTrailingSlash oldPath}index.html"
    frontmatter = template: "redirect", redirect: newPath, index: false
    body = ""

    { html } = compileContent { path, frontmatter, body }

    dest = tidy path, "content"

    write dest, html

# TASKS ###########################################################################################

task "build", "Compile everything", ()->
  compile "everything", ()->

    rm "public"

    head = read "source/head.html"
    header = read "source/header.html"

    # Store all the published pages we encounter, so we can generate an rss feed
    published = []

    compile "content", "content/**/*.{md,html}", (path)->
      dest = tidy path, "content"

      { frontmatter, body } = loadPage path
      { html, body } = compileContent { path, frontmatter, body }

      # If this page has a published date, store it for the RSS feed
      published.push [frontmatter.publish, body, dest] if frontmatter.publish?.match /^\d{4}-\d{2}-\d{2}$/

      write dest, html

    compile "pages", "source/pages/**/*.{md,html}", (path)->
      dest = tidy path, "source/pages"

      { frontmatter, body } = loadPage path
      { html, body } = compilePage { head, header, path, frontmatter, body }

      # If this page has a published date, store it for the RSS feed
      published.push [frontmatter.publish, body, dest] if frontmatter.publish?.match /^\d{4}-\d{2}-\d{2}$/

      write dest, html

    # Generate the RSS feed
    write "public/rss", generateRSS published

    # Generate the CSS feed
    write "public/css", generateCSS published

    # yep
    generateRedirectPages()

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

blockMarkers = ["#### ", "### ", "## ", "# ", "- ", "* ", "! ", "> "]

password = trim read ".secret"

cypher = "IiÌÍÎÏĨĪĬĮİƁƊƑƘƝƴȈȊɱʈʋʯϒӇӻӼԒḮỈỊ⌁⌃⌅⌆⌐⌑⌒⌓⌔⌗⌙⌠⌡⌬⌭⌱⌷⌸⌹⌺⌻⌽⌾⍀⍁⍂⍃⍄⍅⍆⍇⍈⍉⍊⍋⍌⍍⍎⍏⍐⍑⍒⍓⍔⍕⍖⍗⍙⍚⍛⍜⍝⍞⍟⍡⍢⍣⍤⍥⍦⍧⍨⍩⍫⍬⍭⍳⍴⍵⍶⍷⍸⍹⍺⍾⎄⎆⎈⎐⎚⎛⎝⎞⎠⎡⎣⎤⎦⎧⎨⎩⎫⎬⎭⎰⎱⎲⎳⏀⏂⏃⏅⏇⏚⏣␥⑄▁▂▃▄▅▆▇█▲△▴▵▶▷▸►▼▽▾▿◀◁◃◄◆◉◍◐◑◒◓◔◕◖◗◴◵◶◷☰☱☲☳☴☵☶☷⚌⚍⚎⚏⚙⦿Ɱ䷀䷁䷂䷃䷄䷅䷆䷇䷈䷉䷊䷋䷌䷍䷎䷏䷐䷑䷒䷓䷔䷕䷖䷗䷘䷙䷚䷛䷜䷝䷞䷟䷠䷡䷢䷣䷤䷥䷦䷧䷨䷩䷪䷫䷬䷭䷮䷯䷰䷱䷲䷳䷴䷵䷶䷷䷸䷹䷺䷻䷼䷽䷾䷿"

olRegex = /^\d+\.\s/

mod = (input, max)-> (input % max + max) % max

hash = (string, range, h = 0) ->
  h = (h * 31 + ch.charCodeAt(0)) | 0 for ch in string
  mod h, range + 1

seededRandom = (seed)->
  s = hash seed, 0x7fffffff
  ()-> s = (s * 0xCAFEBABE + 2222) & 0x7fffffff; s / 0x7fffffff

task "encrypt", "We're telling secrets.", ()->
  compile "encrypt", "journal/**/*", (path)->

    # Derive the encryption key based on the slug and password
    slug = "/" + replace path, ".md": "/"
    key = pbkdf2Sync password, slug, 300000, 32, "sha256"

    # RNG for generating spaces between the encrypted words, seeded so that we don't make git noise
    random = seededRandom slug

    # Load the page and extract the body
    { frontmatter, body } = loadPage path

    # Add special frontmatter for journals
    frontmatter.main ||= "journal"

    # Merge consecutive plain lines into single blocks
    # TODO: Could probably clean this up a bunch. Meh.
    lines = splitLines body
    merged = []
    buffer = []
    flush = ()->
      if buffer.length > 0
        merged.push buffer.join " "
        buffer = []
    for line in lines
      isBlank = line.trim() is ""
      hasMarker = !isBlank and (blockMarkers.some((s)-> line.startsWith s) or olRegex.test line)
      if isBlank or hasMarker
        flush()
        merged.push line
      else
        buffer.push line
    flush()

    # Derive the IV from the slug
    iv = createHash("sha256").update(slug).digest().slice 0, 16

    # Single cypher for the whole page — one continuous keystream
    encrypter = createCipheriv "aes-256-ctr", key, iv

    # Encrypt each line
    body = for line in merged

      # Skip blank lines
      if line.trim() is "" then line

      else
        # Detect most blocks
        marker = blockMarkers.find (s)-> line.startsWith s
        if marker then line = line.substring marker.length
        # Detect lists
        else if olRegex.test line
          marker = "1. "
          [, line] = splitOnce line, ". "
        # If there is no block, just use an empty string
        else marker = ""

        # Strip marker, render
        line = markdownit.renderInline line

        # Encrypt this block as part of the continuous stream
        encrypted = encrypter.update line, "utf8"

        # Map each byte to a cypher char
        encrypted = (cypher[byte] for byte from encrypted).join ""

        # Break the encrypted text into word-sized pieces
        words = while encrypted.length > 0
          len = Math.min encrypted.length, 2 + random() ** 2 * 9 | 0
          word = encrypted.slice 0, len
          encrypted = encrypted.slice len
          word

        # Join the encrypted words, prepend the marker
        marker + words.join " "

    # Append magic bytes (four 0s) to the last block for verification
    magic = encrypter.update Buffer.alloc 4
    magic = (cypher[byte] for byte from magic).join ""
    for i in [body.length - 1..0]
      if body[i].trim() isnt ""
        body[i] += magic
        break

    encrypter.final()
    body = joinLines body

    # Rebuild the frontmatter
    frontmatter = joinLines(k + ": " + v for k, v of frontmatter)

    input = '<form class="journal-password"><input autofocus="true" type="password" name="password" class="visible-password" autocomplete="current-password"></form>'

    open = '<div encrypted-post>'
    close = '</div>'

    # Rebuild the page, get the dest, write
    page = joinLines frontmatter, "---", input, open, body, close
    dest = replace path, "journal/":"source/pages/journal/"
    write dest, page

task "diff", "Test build system changes.", ()->
  invoke "build"
  execSync "git diff --no-index public-snapshot public || true"

task "kiss", "Save current public as known-good.", ()->
  rm "public-snapshot"
  execSync "cp -r public public-snapshot"

task "watch", "Recompile on changes.", ()->
  watch "journal", "encrypt"
  watch "source", "build", reload

task "serve", "Spin up a live reloading server.", ()->
  serve "public"

task "start", "Build, watch, and serve.", ()->
  invoke "encrypt"
  invoke "build"
  invoke "watch"
  invoke "serve"
