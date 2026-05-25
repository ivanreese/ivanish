do ()->

  posterize = 8 # how many different color bands (per channel)
  dither = .2 # how much noise (tuned by eye to match Pixelmator's posterize, which is pretty)
  tableSize = 4096 # small values show repeating patterns that are very sensitive to the image size

  # dommy mommy
  elm = document.querySelector "profile-pic div"
  img = elm.querySelector "img"
  canvas = document.createElement "canvas"
  ctx = canvas.getContext "2d", willReadFrequently: true, colorSpace: 'display-p3'
  canvas.innerText = img.alt
  elm.prepend canvas

  # extra buffers for pixel data to save reads
  source = null
  work = null

  # cut down on line noise
  round = Math.round

  # sundry state
  w = 0
  h = 0
  fade = 0
  fadeTarget = 0
  dirty = false
  document.spooky = false
  lastT = 0
  phase = 0

  # we're gonna precompute some biased noise outside the hot loop
  bitmask = tableSize - 1
  bias = new Float32Array tableSize
  noise = new Float32Array tableSize
  noise[k] = Math.random() - .5 for k in [0...tableSize]


  setup = ()->
    window.addEventListener "scroll", scroll, passive: true
    window.addEventListener "resize", resize
    resize()


  resize = ()->
    aspect = img.naturalHeight / img.naturalWidth
    rect = elm.getBoundingClientRect()
    width = round rect.width
    height = round width * aspect
    dpr = round @clip window.devicePixelRatio, 1, 2
    w = canvas.width = round width * dpr
    h = canvas.height = round height * dpr

    ctx.drawImage img, 0, 0, w, h
    work = ctx.getImageData 0, 0, w, h
    source = Uint8ClampedArray.from work.data

    scroll()
    render()


  scroll = ()->
    # Update if scrolling
    scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop - img.offsetHeight * 1.5
    lastTarget = fadeTarget
    fadeTarget = @scale scrollTop, 0, img.offsetHeight * 1, 0, 1, true
    render() if fadeTarget isnt lastTarget

    # Update if spooking
    if not document.spooky and scrollTop > window.innerHeight * 2
      document.spooky = true
      render()


  render = ()->
    return if dirty
    dirty = true
    requestAnimationFrame doRender


  doRender = (t)->
    dirty = false

    fade += (fadeTarget - fade) / 8
    render() if Math.abs(fadeTarget - fade) > .01

    if document.spooky
      phase += Math.min(t - lastT, 30) / 1000
      lastT = t
      posterize = @scale Math.sin(phase) * .5 + .5, -1, 1, 1.5, 4

    light = 255 * fade ** 2
    step = 255 / (posterize - 1)
    invStep = 1/step

    for k in [0...noise.length]
      bias[k] = noise[k] * step * dither + light

    i = 0
    p = 0
    out = work.data

    if not document.spooky
      while i < source.length
        out[i+0] = round((source[i+0] + bias[p++ & bitmask]) * invStep) * step
        out[i+1] = round((source[i+1] + bias[p++ & bitmask]) * invStep) * step
        out[i+2] = round((source[i+2] + bias[p++ & bitmask]) * invStep) * step
        i += 4
    else
      div = 1 / 255 ** 3 # exponent should be 1 less than the number of q's below
      while i < source.length
        q = round((265 - source[i+0] + bias[p++ & bitmask]) * invStep) * step
        out[i+2] = out[i+1] = out[i+0] = q * q * q * q * div # look at 'em q's
        i += 4

    ctx.putImageData work, 0, 0


  if img.complete and img.naturalWidth then setup()
  else img.addEventListener "load", setup, once: true
