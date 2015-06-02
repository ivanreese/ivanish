do ()->
  header = document.querySelector("header")
  footer = document.querySelector("footer")
  return unless header? and footer?
  header.style.opacity = headerTarget = headerCurrent = 1
  footer.style.opacity = footerTarget = footerCurrent = 0
  headerDelta = footerDelta = 0
  dirty = false
  epsilon = 0.0001

  fadeHeader = ()->
    opacity = 1 - document.body.scrollTop / header.offsetHeight
    opacity = opacity * opacity * opacity
    opacity = Math.min(1, Math.max(0, opacity))
    headerTarget = opacity

  fadeFooter = ()->
    scrollBottom = document.body.scrollTop + window.innerHeight
    opacity = (scrollBottom - document.body.scrollHeight + footer.offsetHeight) / footer.offsetHeight
    opacity = opacity * opacity * opacity
    opacity = Math.min(1, Math.max(0, opacity))
    footerTarget = opacity

  update = ()->
    dirty = false
    
    headerDelta = (headerTarget - headerCurrent)/5
    if Math.abs(headerDelta) > epsilon
      header.style.opacity = headerCurrent = headerCurrent + headerDelta
      requestUpdate()
    
    footerDelta = (footerTarget - footerCurrent)/5
    if Math.abs(footerDelta) > epsilon
      footer.style.opacity = footerCurrent = footerCurrent + footerDelta
      requestUpdate()
  
  requestUpdate = ()->
    unless dirty
      dirty = true
      window.requestAnimationFrame(update)
  
  window.addEventListener "scroll", ()->
    fadeHeader()
    fadeFooter()
    requestUpdate()
