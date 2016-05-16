ready ()->
  canvases = document.querySelectorAll "canvas.js-stars"
  
  doRender = ()-> renderStars(canvases)
  requestRender = ()-> requestAnimationFrame doRender
  
  requestRender()
  window.addEventListener "resize", requestRender

renderStars = (canvases)->
  
  # measurePerf, ready, randTable, randTableSize, and a few other things
  # are defined in app.coffee and are used as read-only globals.
  
  for canvas in canvases
    context = canvas.getContext "2d"
    
    # Just do everything at 2x so that we're good for most retina displays (hard to detect)
    width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2
    height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2
    
    # How many stellar objects do we need?
    density = Math.sqrt width * height
    
    # This lets us define things in terms of a "natural" display size
    dscale = density/3000
    
    # DRAW BACKGROUND
    context.fillStyle = "transparent"
    context.fillRect(0, 0, width, height)
    
    if measurePerf
      console.log ""
      starsPerfStart = performance.now()
    
    
    pixelStars        = true
    stars             = true
    redBlobs          = true
    purpleBlobs       = true
    blueBlobs      = true
    smallGlowingStars = true
    
    nPixelStars        = density/5  |0
    nStars             = density/50 |0
    nRedBlobs          = density/25 |0
    nPurpBlobs         = density/20 |0
    nBlueBlobs      = density/25 |0
    nSmallGlowingStars = density/30 |0
    
    
    # Pixel Stars
    if pixelStars
      start = performance.now() if measurePerf
      for i in [0..nPixelStars]
        x = randTable[(i + 5432) % randTableSize]
        y = randTable[x]
        o = randTable[y]
        r = randTable[o]
        x = x * width / randTableSize |0
        y = y * height / randTableSize |0
        o = o / randTableSize * 0.5 + 0.5
        r = r / randTableSize * 1.5 + .5
        context.beginPath()
        context.fillStyle = "hsla(300, 25%, 50%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(300, 0%, 50%, 0.01)"
        context.arc(x, y, r*20, 0, TAU)
        context.fill()
      console.log((performance.now() - start).toPrecision(4) + "  pixelStars") if measurePerf
      
    
    # Stars
    if stars
      start = performance.now() if measurePerf
      for i in [0..nStars]
        increase = i/nStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[i % randTableSize]
        y = randTable[x]
        r1 = randTable[y]
        r2 = randTable[r1]
        sx = randTable[r2]
        sy = randTable[sx]
        l = randTable[sy]
        c = randTable[l]
        o = randTable[c]
        x = x * width / randTableSize  |0
        y = y * height / randTableSize |0
        r1 = r1 / randTableSize * 4 + .5
        r2 = r2 / randTableSize * 3 + .5
        l = l / randTableSize * 20 + 20
        o = o / randTableSize * 10 * decrease + 0.3
        c = c / randTableSize * 120 + 200
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 30%, #{l}%, #{o})"
        context.arc(x, y, r1, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(0, 0%, 100%, 1)"
        context.arc(x, y, r2, 0, TAU)
        context.fill()
      console.log((performance.now() - start).toPrecision(4) + "  stars") if measurePerf
    
    
    # Red Blobs
    if redBlobs
      start = performance.now() if measurePerf
      for i in [0..nRedBlobs]
        increase = i/nRedBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        o = randTable[(12345 + i) % randTableSize]
        x = randTable[o]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = x / randTableSize * width  |0
        y = y / randTableSize * height |0
        r = r / randTableSize * 120 * decrease * dscale + 20
        l = l / randTableSize * 30 * decrease + 30
        o = o / randTableSize * 0.015 + 0.008
        h = h / randTableSize * 30 + 350
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o*3/4})"
        context.arc(x, y, r * 2, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o/2})"
        context.arc(x, y, r * 3, 0, TAU)
        context.fill()
      console.log((performance.now() - start).toPrecision(4) + "  redBlobs") if measurePerf


    # Purple Blobs
    if purpleBlobs
      start = performance.now() if measurePerf
      for i in [0..nPurpBlobs]
        increase = i/nPurpBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[(i + 1234) % randTableSize]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        o = randTable[l]
        x = (x / randTableSize * width*2/3 + width*1/6)|0
        y = (y / randTableSize * height*2/3 + height*1/6)|0
        r = r / randTableSize * 200 * dscale * decrease + 30
        l = l / randTableSize * 10 * increase + 9
        o = o / randTableSize * 0.07 * decrease + 0.05
        context.beginPath()
        context.fillStyle = "hsla(290, 100%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
      console.log((performance.now() - start).toPrecision(4) + "  purpleBlobs") if measurePerf

    
    # Blue Blobs
    if blueBlobs
      start = performance.now() if measurePerf
      for i in [0..nBlueBlobs]
        increase = i/nBlueBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[(i + 123) % randTableSize]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x / randTableSize * width)|0
        y = (y / randTableSize * height)|0
        r = r / randTableSize * 120 * dscale * decrease + 20
        s = l / randTableSize * 40 + 30
        l = l / randTableSize * 40 * decrease + 10
        h = h / randTableSize * 30 + 200
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.017)"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.015)"
        context.arc(x, y, r * 2, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.013)"
        context.arc(x, y, r * 3, 0, TAU)
        context.fill()
      console.log((performance.now() - start).toPrecision(4) + "  blueBlobs") if measurePerf
    
    
    # Small Round Stars with circular glow rings
    if smallGlowingStars
      start = performance.now() if measurePerf
      for i in [0..nSmallGlowingStars]
        increase = i/nSmallGlowingStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        r = randTable[(i + 345) % randTableSize]
        l = randTable[r]
        o = randTable[l]
        c = randTable[o]
        x = randTable[c]
        y = randTable[x]
        x = (x * width / randTableSize)|0
        y = (y * height / randTableSize)|0
        r = r / randTableSize * 2 + 1
        l = l / randTableSize * 20 + 40
        o = o / randTableSize * 1 * decrease + 0.25
        c = c / randTableSize * 180 + 200

        # far ring
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 70%, #{l}%, #{o/25})"
        context.arc(x, y, r * r * r, 0, TAU)
        context.fill()
        
        # close ring
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 50%, #{l}%, #{o/6})"
        context.arc(x, y, r * r, 0, TAU)
        context.fill()
        
        # round star body
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 20%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()

        # point of light
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 100%, 90%, #{o * 1.5})"
        context.arc(x, y, 1, 0, TAU)
        context.fill()
        
      console.log((performance.now() - start).toPrecision(4) + "  smallGlowingStars") if measurePerf

      
    if measurePerf
      console.log ""
      console.log (performance.now() - starsPerfStart).toPrecision(4) + "  Stars"
