do ()->
  sleepAfter = 300 * 1000
  checkEvery = 10 * 1000

  sleeping = false
  loadNextClip = false
  lastActive = performance.now()

  video = document.createElement "video"
  video.autoplay = true
  video.setAttribute "muted", ""
  video.setAttribute "playsinline", ""
  video.id = "screensaver"
  video.addEventListener "ended", ()-> loadNextClip = true

  bump = ()->
    lastActive = performance.now()
    video.remove() if sleeping
    sleeping = false

  screensaver = ()->
    tired = performance.now() - lastActive >= sleepAfter

    if not sleeping and tired
      document.body.append video
      loadNextClip = true
      sleeping = true

    if loadNextClip
      loadNextClip = false
      n = Math.ceil Math.random() * 20
      video.src = "https://d3um8l2sa8g9bu.cloudfront.net/screensaver/#{n}.mp4"

  window.addEventListener "keydown", bump, passive: true
  window.addEventListener "mousemove", bump, passive: true
  window.addEventListener "pointermove", bump, passive: true
  window.addEventListener "scroll", bump, passive: true
  window.addEventListener "touchmove", bump, passive: true
  window.addEventListener "touchstart", bump, passive: true
  window.addEventListener "wheel", bump, passive: true
  setInterval screensaver, checkEvery
