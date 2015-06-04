ready = (fn)->
  if document.readyState is "loading"
    document.addEventListener "DOMContentLoaded", parseEm
  else
    fn()
