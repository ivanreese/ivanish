do ()->
  header = document.querySelector("header")
  return unless header?
  return if document.querySelector "#index"
  header.style.opacity = headerTarget = headerCurrent = 1
  headerDelta = 0
  dirty = false
  epsilon = 0.0001

  fadeHeader = ()->
    scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop
    opacity = scale scrollTop, 0, header.offsetHeight, 1, -0.3
    opacity = opacity * opacity * opacity
    opacity = Math.min(1, Math.max(0, opacity))
    headerTarget = opacity

  update = ()->
    dirty = false
    
    headerDelta = (headerTarget - headerCurrent)/5
    if Math.abs(headerDelta) > epsilon
      header.style.opacity = headerCurrent = headerCurrent + headerDelta
      requestUpdate()
  
  requestUpdate = ()->
    if not dirty
      dirty = true
      window.requestAnimationFrame(update)
  
  window.addEventListener "scroll", ()->
    fadeHeader()
    requestUpdate()
