fs = require "fs"
glob = require "glob"
require "sweetbread"

browserslist = "last 2 Chrome versions, last 2 ff versions, last 2 Safari versions, last 2 iOS versions"

task "build", "Compile everything", ()->

  dev = not process.env.NETLIFY

  rm "public"
  mkdir "public"

  # Global styles
  patterns = ["source/style/**/vars.scss", "source/style/**/!(vars).scss"]
  paths = (glob.sync p for p in patterns).flat()
  Compilers.scss paths, "public/styles.css", {browserslist, minify:!dev}

  # Page styles
  for p in glob.sync "source/pages/**/*.scss"
    name = p.replace("source/pages/","").replace(".scss","")
    mkdir "public/#{name}"
    Compilers.scss p, "public/#{name}/#{name}.css", {browserslist, minify:!dev}

  # Global scripts
  paths = glob.sync "source/script/**/*.coffee"
  Compilers.coffee paths, "public/scripts.js", minify:!dev

  # Page scripts
  for p in glob.sync "source/pages/**/*.coffee"
    name = p.replace("source/pages/","").replace(".coffee","")
    mkdir "public/#{name}"
    Compilers.coffee p, "public/#{name}/#{name}.js", minify:!dev

  # HTML
  for p in glob.sync "source/pages/**/*.kit"
    name = p.replace("source/pages/","").replace(".kit","")
    if name is "index"
      dest = "public/index.html"
    else
      mkdir "public/#{name}"
      dest = "public/#{name}/index.html"
    Compilers.kit p, dest, minify:!dev

  # Static
  for p in glob.sync "source/**/*.{rss,ico}"
    dest = p.replace "source/", "public/"
    Compilers.static p, dest

  # Redirects
  if process.env.NETLIFY
    redirects = [
      "/codex   " + process.env.CODEX_URL
      "/meet    " + process.env.MEET_URL
      "/zoom    " + process.env.ZOOM_URL
    ]
    fs.writeFileSync "public/_redirects", redirects.join "\n"


task "watch", "Recompile on changes.", ()->
  watch "source", "build", reload

task "serve", "Spin up a live reloading server.", ()->
  serve "public"

task "start", "Build, watch, and serve.", ()->
  doInvoke "build"
  doInvoke "watch"
  doInvoke "serve"
