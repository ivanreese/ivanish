ready ()->
  mod = (a, b)->
    (a % b + b) % b
  
  for canvas in document.querySelectorAll "canvas.js-stars"
    if window.getComputedStyle(canvas).display != "none"
      do (canvas)->
        context = canvas.getContext "2d"
        dpi = 2 # Just do everything at 2x so that we're good for most retina displays (hard to detect)
        width = canvas.width = window.innerWidth * dpi
        height = canvas.height = window.innerHeight * dpi
        density = Math.sqrt width * height # How many stellar objects do we need?
        dscale = density/3000 # This lets us define things in terms of a "natural" display size
        accel = 0
        vel = 0
        pos = 0
        renderRequested = false
        first = true
        lastTouchY = 0
        keyboardUp = false
        keyboardDown = false
        keySpeed = 1
        scrollPos = 0
        lastTime = performance.now()
        maxFpsFrac = 2
        targetMsPerFrame = 13
        smoothDt = targetMsPerFrame / maxFpsFrac

        context.globalAlpha = 1
        context.lineCap = "round"

        starSpots = false #Math.random() < 0.5
        blobSpots = false #Math.random() < 0.5
        
        
        doRender = (time)->
          renderRequested = false
          renderStars time, normalDrawCall
        
        requestRender = ()->
          unless renderRequested
            renderRequested = true
            requestAnimationFrame doRender
        
        requestScrollRender = (e)->
          p = document.body.scrollTop + document.body.parentNode.scrollTop
          delta = p - scrollPos
          scrollPos = p
          vel += delta / 5
          requestRender()
        
        requestMoveRender = (e)->
          y = e.touches.item(0).screenY
          vel -= (y - lastTouchY) / 10
          lastTouchY = y
          requestRender()
          e.preventDefault()
        
        touchStart = (e)->
          lastTouchY = e.touches.item(0).screenY
          
        keyDown = (e)->
          keyboardUp = true if e.keyCode == 38
          keyboardDown = true if e.keyCode == 40
          requestRender()
        
        keyUp = (e)->
          keyboardUp = false if e.keyCode == 38
          keyboardDown = false if e.keyCode == 40
          requestRender()
        
        
        # requestRender(firstDrawCall)
        # window.addEventListener "resize", requestRender
        window.addEventListener "scroll", requestScrollRender
        window.addEventListener "touchstart", touchStart
        window.addEventListener "touchmove", requestMoveRender
        window.addEventListener "keydown", keyDown
        window.addEventListener "keyup", keyUp
        
        
        firstDrawCall = (x, y, r, s, forceCircle = false)->
          context.beginPath()
          context.fillStyle = s
          context.arc(x, y, r, 0, TAU)
          context.fill()
        
        normalDrawCall = (x, y, r, s, forceCircle = false)->
          context.beginPath()
          context.strokeStyle = s
          context.lineWidth = r*2
          context.moveTo(x, y - vel*dpi)
          context.lineTo(x, y)
          context.stroke()
        
        requestAnimationFrame (time)->
          renderStars time, firstDrawCall
        
        renderStars = (time, drawCall)->
          # measurePerf, ready, randTable, randTableSize, and a few other things
          # are defined in app.coffee and are used as read-only globals.
          
          if keyboardDown and not keyboardUp
            accel = +keySpeed
          else if keyboardUp and not keyboardDown
            accel = -keySpeed
          else
            accel /= 1.1
          
          vel += accel
          vel /= 1.1
          recipVel = Math.min 1, Math.abs 10 / vel
          pos += vel * dpi
          
          if Math.abs(vel) > 0.3
            requestRender()
          
          if not first
            context.globalAlpha = Math.min 1, Math.sqrt Math.abs(vel/30)
          
          if measurePerf
            console.log ""
            starsPerfStart = performance.now()
          
          dt = time - lastTime
          smoothDt = smoothDt*.9 + dt*.1
          lastTime = time
          fpsFrac = Math.min maxFpsFrac, targetMsPerFrame/smoothDt
          
          pixelStars        = true
          stars             = true
          smallGlowingStars = true
          redBlobs          = true
          purpleBlobs       = true
          blueBlobs         = true
          
          nPixelStars        = fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.4, density / 5 , 0) |0
          nStars             = fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.4, density / 99, 0) |0
          nSmallGlowingStars = fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.4, density / 40, 0) |0
          nRedBlobs          = fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.4, density / 20, 0) |0
          nPurpBlobs         = fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.4, density / 25, 0) |0
          nBlueBlobs         = fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.4, density / 25, 0) |0
          
          # Count the number of objects we're about to render
          # console.log nRedBlobs + nPurpBlobs + nBlueBlobs + nPixelStars + nStars + nSmallGlowingStars
          
          
          # Pixel Stars
          if pixelStars
            start = performance.now() if measurePerf
            for i in [0..nPixelStars]
              increase = i/nPixelStars # get bigger as i increases
              x = randTable[(i + 5432) % randTableSize]
              y = randTable[x]
              o = randTable[y]
              r = randTable[o]
              x = x * width / randTableSize
              y = mod y * height / randTableSize - pos, height
              o = o / randTableSize * 0.5 + 0.5
              r = (r / randTableSize * 1.5 + .5) * recipVel
              drawCall x, y, r * dpi/2, "hsla(300, 25%, 50%, #{o})"#, starSpots
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
              x = x * width / randTableSize
              y = mod y * height / randTableSize - pos * decrease, height
              r1 = (r1 / randTableSize * 4 + .5) * recipVel
              r2 = (r2 / randTableSize * 3 + .5) * recipVel
              l = l / randTableSize * 20 + 20
              o = o / randTableSize * 10 * decrease + 0.3
              c = c / randTableSize * 120 + 200
              drawCall x, y, r1 * dpi/2, "hsla(#{c}, 30%, #{l}%, #{o})"#, starSpots
              drawCall x, y, r2 * dpi/2, "hsla(0, 0%, 100%, 1)"#, starSpots
            console.log((performance.now() - start).toPrecision(4) + "  stars") if measurePerf

          
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
              x = x * width / randTableSize
              y = mod y * height / randTableSize - pos * decrease, height
              r = (r / randTableSize * 2 + 1) * recipVel
              l = l / randTableSize * 20 + 40
              o = o / randTableSize * 1 * decrease + 0.25
              c = c / randTableSize * 180 + 200

              # far ring
              drawCall x, y, r * r * r * dpi/2, "hsla(#{c}, 70%, #{l}%, #{o/25})"#, starSpots
              
              # close ring
              drawCall x, y, r * r * dpi/2, "hsla(#{c}, 50%, #{l}%, #{o/6})"#, starSpots
              
              # round star body
              drawCall x, y, r * dpi/2, "hsla(#{c}, 20%, #{l}%, #{o})"#, starSpots
              
              # point of light
              drawCall x, y, 1 * dpi/2, "hsla(#{c}, 100%, 90%, #{o * 1.5})"#, starSpots
              
            console.log((performance.now() - start).toPrecision(4) + "  smallGlowingStars") if measurePerf
          

          
          if not first
            context.globalAlpha = Math.min 1, Math.sqrt Math.abs(vel/8)

          
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
              x = x / randTableSize * width*2/3 + width*1/6
              y = mod y / randTableSize * height*2/3 + height*1/6 - pos * (decrease/2 + 0.5), height
              r = r / randTableSize * 200 * dscale * decrease + 30
              l = l / randTableSize * 16 * increase + 5
              o = o / randTableSize * 0.12 * decrease + 0.05
              drawCall x, y, r * dpi/2, "hsla(290, 100%, #{l}%, #{o})"#, blobSpots
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
              x = x / randTableSize * width
              y = mod y / randTableSize * height - pos * (decrease/5 + 0.5), height
              r = r / randTableSize * 120 * dscale * decrease + 20
              s = l / randTableSize * 40 + 30
              l = l / randTableSize * 60 * decrease + 5
              h = h / randTableSize * 50 + 200
              drawCall x, y, r * 1 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, 0.015)"#, blobSpots
              drawCall x, y, r * 2 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, 0.020)"#, blobSpots
              drawCall x, y, r * 3 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, 0.025)"#, blobSpots
            console.log((performance.now() - start).toPrecision(4) + "  blueBlobs") if measurePerf


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
              x = x / randTableSize * width
              y = mod y / randTableSize * height - pos * (increase/2 + 0.5), height
              r = r / randTableSize * 120 * decrease * dscale + 20
              l = l / randTableSize * 60 * decrease + 15
              o = o / randTableSize * 0.018 + 0.008
              h = h / randTableSize * 30 + 350
              drawCall x, y, r * 1 * dpi/2, "hsla(#{h}, 100%, #{l}%, #{o})"#, blobSpots
              drawCall x, y, r * 2 * dpi/2, "hsla(#{h}, 100%, #{l}%, #{o*3/4})"#, blobSpots
              drawCall x, y, r * 3 * dpi/2, "hsla(#{h}, 100%, #{l}%, #{o/2})"#, blobSpots
            console.log((performance.now() - start).toPrecision(4) + "  redBlobs") if measurePerf

            
          if measurePerf
            console.log ""
            console.log (performance.now() - starsPerfStart).toPrecision(4) + "  Stars"
          
          
          first = false
