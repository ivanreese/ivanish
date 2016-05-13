bioShift = Math.random()

renderBio = (canvases)->
  time = Date.now()/1000
  t = Math.sin(time/7)/2 + 0.5
  
  for canvas in canvases
    # Setup & Locals
    context = canvas.getContext "2d"
    width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2
    height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2
    
    # DRAW BACKGROUND
    context.fillStyle = "transparent"
    context.fillRect(0, 0, width, height)
    
    if measurePerf
      perfStart = performance.now()
    
    nBlobs = width/6
    for i in [0..nBlobs]
      increase = i/nBlobs # get bigger as i increases
      decrease = (1 - increase) # get smaller as i increases
      a = randTable[i % randTableSize]
      d = randTable[a]
      r = randTable[d]
      c = randTable[r]
      l = randTable[c]
      r = r / randTableSize * width / 5
      # start from 200 (blue), shift up to 170 degrees right (orange), + 40 degrees of jitter. Thus, no green.
      c = (c / randTableSize * 50 + (170 * t) + 200) % 360 |0
      l = l / randTableSize * 10 + 70
      x =          Math.cos((a/randTableSize) * TAU)  * Math.pow(d/randTableSize, 1/10) * (r/2 + width/2)  + width/2|0
      y = Math.abs(Math.sin((a/randTableSize) * TAU)) * Math.pow(d/randTableSize, 1/3)  * (r/2 + height/2) + height/2|0
      context.beginPath()
      context.fillStyle = "hsla(#{c}, 30%, #{l}%, .03)"
      context.arc(x, y, r, 0, TAU)
      context.fill()

  if measurePerf
    console.log((performance.now() - perfStart).toPrecision(4) + "  Bio")


ready ()->
  canvases = document.querySelectorAll "canvas.js-bio"
  
  doRender = ()-> renderBio(canvases)
  requestRender = ()-> requestAnimationFrame doRender
  
  requestRender()
  setInterval requestRender, 500
  # window.addEventListener "resize", requestRender
