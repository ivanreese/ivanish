do ()->
  seqs = [23, 25, 25, 33, 72]

  frames = []

  for lastFrameNum, seqIndex in seqs
    for frameNum in [1..lastFrameNum]
      frames.push elm = document.createElement "div"
      elm.style.backgroundImage = "url(https://ivanish.s3.amazonaws.com/brain-scrubber/assets/#{seqIndex}/#{frameNum}.jpg)"
      elm.style.opacity = 0
      document.body.appendChild elm

  dragging = false
  start = 0
  vel = 0

  pos = 0
  speed = 0

  hammer = Hammer document.body
  hammer.on "dragstart", ()-> dragging = true; start = vel
  hammer.on "drag", (e)->
    vel = start
    vel += -2 * e.gesture.deltaX / document.body.clientWidth
    vel += -2 * e.gesture.deltaY / document.body.clientHeight
  hammer.on "dragend", ()-> dragging = false

  document.ontouchmove = (e)-> e.preventDefault()

  do animate = ()->
    if not dragging
      vel /= 1.03
      vel = 0 if Math.abs(vel) < .03

    pos += vel

    pos += frames.length while pos < 0

    for frame, i in frames
      p = pos % frames.length
      o = Math.min 1, Math.max 0, 1 - Math.abs(p - i)/4
      frame.style.opacity = o

    requestAnimationFrame animate
