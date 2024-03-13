# BIO FADE
do ()->
  main = document.querySelector "main"
  stars = document.querySelector "canvas"
  elm = document.querySelector "profile-pic div"
  quipImg = document.querySelector "header witty-quip img"
  elm.style.opacity = headerTarget = headerCurrent = 1
  headerDelta = 0
  dirty = false
  epsilon = 0.0001

  fadeHeader = ()->
    scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop - (window.innerHeight * .8)
    opacity = scale scrollTop, 0, elm.offsetHeight * 3/4, 1, 0
    opacity = opacity * opacity * opacity
    opacity = Math.min 1, Math.max 0, opacity
    headerTarget = opacity

    if scrollTop > 700 and stars?
      stars.style.filter = "invert(1) saturate(0) brightness(0.666) contrast(2.3)"
      quipImg?.style.filter = "invert(1) saturate(0)"
      main.removeAttribute "js-stars-bio"
      main.setAttribute "js-stars-bw", ""
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
