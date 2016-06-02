ready ()->
  mod = (a, b)->
    (a % b + b) % b
  
  for canvas in document.querySelectorAll "canvas.js-infinite-stars"
    if window.getComputedStyle(canvas).display != "none"
      do (canvas)->
        renderRequested = false
        context = canvas.getContext "2d"
        width = 0
        height = 0
        dpi = 2
        density = 0
        dscale = 0
        lastP = 0
        accel = 0
        vel = 0
        pos = 0
        trace = ""
        grad = null
        first = true
        lastTouchY = 0
        keyboardUp = false
        keyboardDown = false
        keySpeed = 1
        
        doRender = ()->
          renderRequested = false
          renderStars()
        
        requestRender = ()->
          unless renderRequested
            renderRequested = true
            requestAnimationFrame doRender
        
        requestWheelRender = (e)->
          vel += e.deltaY / 20
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
        
        requestRender()
        window.addEventListener "resize", requestRender
        window.addEventListener "wheel", requestWheelRender
        window.addEventListener "touchstart", touchStart
        window.addEventListener "touchmove", requestMoveRender
        window.addEventListener "keydown", keyDown
        window.addEventListener "keyup", keyUp
        
        drawCall = (x, y, r, s)->
          context.beginPath()
          if first
            context.fillStyle = s
            context.arc(x, y, r, 0, TAU)
            context.fill()
          else
            context.strokeStyle = s
            context.lineWidth = r*2
            context.moveTo(x, y - vel*dpi)
            context.lineTo(x, y)
            context.stroke()

        
        renderStars = ()->
          # measurePerf, ready, randTable, randTableSize, and a few other things
          # are defined in app.coffee and are used as read-only globals.
          
          accel = +keySpeed if keyboardDown and not keyboardUp
          accel = -keySpeed if keyboardUp and not keyboardDown
          
          accel /= 1.1
          vel += accel
          vel /= 1.1
          pos += vel * dpi
          
          if Math.abs(vel) > 0.3
            requestRender()
          
          # Only resize the buffer when the width changes
          # This provides the nicest behaviour for iOS (which resizes on scroll)
          # And the best perf for Firefox (which hates resizing the buffer)
          newWidth = parseInt(canvas.parentNode.offsetWidth) * dpi
          if width != newWidth
            context = canvas.getContext "2d"
            
            width = canvas.width = newWidth
            height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * dpi
            
            # How many stellar objects do we need?
            density = Math.sqrt(width * height) / (dpi/2)
            
            # This lets us define things in terms of a "natural" display size
            dscale = density/3000
            
            r1 = Math.sqrt(width*width + height*height)
            grad = context.createRadialGradient 0, height, 0, 0, height, r1
            
            grad.addColorStop 0.0, "hsl(210, 100%, 8%)"
            grad.addColorStop 0.2, "hsl(250, 60%,16%)"
            grad.addColorStop 0.4, "hsl(250, 40%,6%)"
            grad.addColorStop 0.9, "hsl(330, 40%, 12%)"
            grad.addColorStop 1.0, "hsl(10, 90%, 22%)"
            context.fillStyle = grad
            context.fillRect 0, 0, width, height
            a = 1
            first = true
          else
            a = Math.min 1, Math.abs(vel/2)
            first = false
            
          if measurePerf
            console.log ""
            starsPerfStart = performance.now()
          
          redBlobs          = true
          purpleBlobs       = true
          blueBlobs         = true
          pixelStars        = true
          stars             = true
          smallGlowingStars = true
          
          nRedBlobs          = Math.max 0, scale(Math.cos(pos / height), 1, -1.2, density / 25, 1)
          nPurpBlobs         = Math.max 0, scale(Math.cos(pos / height), 1, -1.2, density / 20, 1)
          nBlueBlobs         = Math.max 0, scale(Math.cos(pos / height), 1, -1.2, density / 25, 1)
          nPixelStars        = Math.max 0, scale(Math.cos(pos / height), 1, -1.2, density / 5 , 1)
          nStars             = Math.max 0, scale(Math.cos(pos / height), 1, -1.2, density / 50, 1)
          nSmallGlowingStars = Math.max 0, scale(Math.cos(pos / height), 1, -1.2, density / 20, 1)
          
          context.lineCap = "round"
          
          # Count the number of objects we're about to render
          trace = nRedBlobs + nPurpBlobs + nBlueBlobs + nPixelStars + nStars + nSmallGlowingStars |0
          
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
              y = mod y / randTableSize * height - pos * (increase*9/10 + 0.1), height
              r = r / randTableSize * 120 * decrease * dscale + 20
              l = l / randTableSize * 30 * decrease + 30
              o = (o / randTableSize * 0.015 + 0.008) * a
              h = h / randTableSize * 30 + 350
              drawCall x, y, r * 2 * dpi/2, "hsla(#{h}, 100%, #{l}%, #{o*3/4})"
              drawCall x, y, r * 3 * dpi/2, "hsla(#{h}, 100%, #{l}%, #{o/2})"
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
              x = x / randTableSize * width*2/3 + width*1/6
              y = mod y / randTableSize * height*2/3 + height*1/6 - pos * (decrease*9/10 + 0.1), height
              r = r / randTableSize * 200 * dscale * decrease + 30
              l = l / randTableSize * 10 * increase + 9
              o = (o / randTableSize * 0.07 * decrease + 0.05) * a
              drawCall x, y, r * dpi/2, "hsla(290, 100%, #{l}%, #{o})"
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
              y = mod y / randTableSize * height - pos * (decrease*9/10 + 0.1), height
              r = r / randTableSize * 120 * dscale * increase + 20
              s = l / randTableSize * 40 + 30
              l = l / randTableSize * 40 * decrease + 10
              h = h / randTableSize * 50 + 200
              drawCall x, y, r * dpi/2, "hsla(#{h}, #{s}%, #{l}%, #{0.017*a})"
              drawCall x, y, r * 2 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, #{0.015*a})"
              drawCall x, y, r * 3 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, #{0.013*a})"
            console.log((performance.now() - start).toPrecision(4) + "  blueBlobs") if measurePerf
          
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
              o = (o / randTableSize * 0.5 + 0.5) * a
              r = r / randTableSize * 1.5 + .5
              drawCall x, y, r * dpi/2, "hsla(300, 25%, 50%, #{o})"
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
              y = mod y * height / randTableSize - pos * (decrease*9/10 + 0.1), height
              r1 = r1 / randTableSize * 4 + .5
              r2 = r2 / randTableSize * 3 + .5
              l = l / randTableSize * 20 + 20
              o = (o / randTableSize * 10 * decrease + 0.3) * a
              c = c / randTableSize * 120 + 200
              drawCall x, y, r1 * dpi/2, "hsla(#{c}, 30%, #{l}%, #{o})"
              drawCall x, y, r2 * dpi/2, "hsla(0, 0%, 100%, #{a})"
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
              y = mod y * height / randTableSize - pos * (decrease*9/10 + 0.1), height
              r = r / randTableSize * 2 + 1
              l = l / randTableSize * 20 + 40
              o = (o / randTableSize * 1 * decrease + 0.25) * a
              c = c / randTableSize * 180 + 200

              # far ring
              drawCall x, y, r * r * r * dpi/2, "hsla(#{c}, 70%, #{l}%, #{o/25})"
              
              # close ring
              drawCall x, y, r * r * dpi/2, "hsla(#{c}, 50%, #{l}%, #{o/6})"
              
              # round star body
              drawCall x, y, r * dpi/2, "hsla(#{c}, 20%, #{l}%, #{o})"

              # point of light
              drawCall x, y, 1 * dpi/2, "hsla(#{c}, 100%, 90%, #{o * 1.5})"
              
            console.log((performance.now() - start).toPrecision(4) + "  smallGlowingStars") if measurePerf
          
          context.fillStyle = "black"
          context.fillRect(0, 0, 36*dpi, 20*dpi)
          context.fillStyle = "white"
          context.font = "#{16*dpi}px monospace"
          context.fillText(trace, 4*dpi, 16*dpi)
          
            
          if measurePerf
            console.log ""
            console.log (performance.now() - starsPerfStart).toPrecision(4) + "  Stars"
