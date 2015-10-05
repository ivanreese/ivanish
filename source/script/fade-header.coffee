do ()->
  header = document.querySelector("header")
  return unless header?
  header.style.opacity = headerTarget = headerCurrent = 1
  headerDelta = 0
  dirty = false
  epsilon = 0.0001

  fadeHeader = ()->
    opacity = 1 - document.body.scrollTop / header.offsetHeight * 1.2
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
    unless dirty
      dirty = true
      window.requestAnimationFrame(update)
  
  window.addEventListener "scroll", ()->
    fadeHeader()
    requestUpdate()
