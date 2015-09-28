ready = (fn)->
  if document.readyState is "loading"
    document.addEventListener "DOMContentLoaded", parseEm
  else
    fn()

# @codekit-prepend "script/chomp-links.coffee"
# @codekit-prepend "script/fade-header.coffee"
# @codekit-prepend "script/stars.coffee"
