do ()->
  debug = false

  shift = Math.random()
  
  window.addEventListener "resize", ready ()->
    canvases = document.querySelectorAll "canvas.js-bio"
    for canvas in canvases
      # Setup & Locals
      context = canvas.getContext "2d"
      width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2
      height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2
      
      # DRAW BACKGROUND
      context.fillStyle = "transparent"
      context.fillRect(0, 0, width, height)
      
      INNER = performance.now() if debug
      
      nBlobs = width/3
      for i in [0..nBlobs]
        increase = i/nBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        a = randTable[i % size]
        d = randTable[a]
        r = randTable[d]
        c = randTable[r]
        l = randTable[c]
        r = r / size * width/5
        # start from 200 (blue), shift up to 170 degrees right (orange), + 40 degrees of jitter. Thus, no green.
        c = ((c / size * 50 + (170 * shift) + 200) % 360)|0
        l = l / size * 10 + 65
        x =          Math.cos((a/size) * TAU)  * Math.pow(d/size, 1/10) * (r/2 + width/2)  + width/2|0
        y = Math.abs(Math.sin((a/size) * TAU)) * Math.pow(d/size, 1/3)  * (r/2 + height/2) + height/2|0
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 30%, #{l}%, .03)"
        context.arc(x, y, r, 0, TAU)
        context.fill()
    
    if debug
      console.log Math.ceil(performance.now() - INNER)
