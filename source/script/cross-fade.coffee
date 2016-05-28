ready ()->
  document.body.removeAttribute "fade-out"
  window.addEventListener "popstate", ()->
    document.body.removeAttribute "fade-out"
  window.addEventListener "beforeunload", ()->
    document.body.setAttribute "fade-out", true
