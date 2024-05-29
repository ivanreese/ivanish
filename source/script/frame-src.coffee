do ()->
  iframes = document.querySelectorAll "iframe[frame-src]"

  deactivate = (elm)->
    return if elm._activated is false
    elm._activated = false
    elm.src = ""

  activate = (elm)->
    return if elm._activated is true
    elm._activated = true
    elm.src = elm.getAttribute "frame-src"

  scroll = ()->
    for elm in iframes
      pos = elm.getBoundingClientRect()
      elm.getAttribute("frame-src") + " " + (pos.bottom > 0 and pos.top < window.innerHeight)
      if pos.bottom > 0 and pos.top < window.innerHeight
        activate elm
      else
        deactivate elm

  window.addEventListener "scroll", scroll
  scroll()
