# BIO FADE
do ()->
  elm = document.querySelector("#index .hero")
  elm.style.opacity = headerTarget = headerCurrent = 1
  headerDelta = 0
  dirty = false
  epsilon = 0.0001

  fadeHeader = ()->
    scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop - window.innerHeight
    opacity = scale scrollTop, 0, elm.offsetHeight/2, 1, 0
    opacity = opacity * opacity * opacity * opacity
    opacity = Math.min(1, Math.max(0, opacity))
    headerTarget = opacity

  update = ()->
    dirty = false

    headerDelta = (headerTarget - headerCurrent)/5
    if Math.abs(headerDelta) > epsilon
      elm.style.opacity = headerCurrent = headerCurrent + headerDelta
      requestUpdate()

  requestUpdate = ()->
    if not dirty
      dirty = true
      window.requestAnimationFrame(update)

  scroll = ()->
    fadeHeader()
    requestUpdate()

  window.addEventListener "scroll", scroll, passive: true
