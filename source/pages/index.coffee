# BIO FADE
do ()->
  main = document.querySelector "main"
  stars = document.querySelector "canvas"
  elm = document.querySelector "profile-pic img"
  quipImg = document.querySelector "header witty-quip img"
  elm.style.opacity = headerTarget = headerCurrent = 1
  headerDelta = 0
  dirty = false
  epsilon = 0.0001

  fadeHeader = ()->
    scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop - (window.innerHeight * .85)
    opacity = scale scrollTop, 0, elm.offsetHeight * 4/5, 1, 0
    opacity = opacity * opacity * opacity
    opacity = Math.min 1, Math.max 0, opacity
    headerTarget = opacity

    if scrollTop > 700 and stars?
      quipImg?.style.filter = "invert(1) saturate(0)"
      main.setAttribute "spooky", ""
      document.spooky = true
      stars = null


  update = ()->
    dirty = false

    headerDelta = (headerTarget - headerCurrent)/5
    if Math.abs(headerDelta) > epsilon
      elm.style.opacity = headerCurrent = headerCurrent + headerDelta
      requestUpdate()

  requestUpdate = ()->
    if not dirty
      dirty = true
      window.requestAnimationFrame update

  scroll = ()->
    fadeHeader()
    requestUpdate()

  window.addEventListener "scroll", scroll, passive: true
