ready ()->
  mod = (a, b)->
    (a % b + b) % b
  
  isInfinite = document.getElementById("starfailed-full")
  bw = if document.querySelector "[js-stars-bw]" then 0 else 1
  
  if window.location.port is "3000"
    hud = document.querySelector "hud"
  
  for canvas in document.querySelectorAll "canvas.js-stars"
    if window.getComputedStyle(canvas).display != "none"
      do (canvas)->
        context = canvas.getContext "2d"
        dpi = 2 # Just do everything at 2x so that we're good for most retina displays (hard to detect)
        width = 0
        height = 0
        density = 0
        accel = 0
        vel = 0
        maxVel = 20
        pos = 0
        renderRequested = false
        first = true
        lastTouchY = 0
        keyboardUp = false
        keyboardDown = false
        keyboardAccel = 0.5
        scrollPos = dpi * (document.body.scrollTop + document.body.parentNode.scrollTop - canvas.offsetTop)
        lastTime = 0
        minFPS = 2
        smoothedFPS = 60
        smoothFPSAdaptationRate = 1/60 # The closer this gets to 1, the more sputtering we get
        
        canvas.setAttribute "bw", "" if bw is 0
        
        resize = ()->
          width  = canvas.width = canvas.parentNode.offsetWidth * dpi
          height = canvas.height = canvas.parentNode.offsetHeight * dpi
          density = scale Math.sqrt(width * height), 0, 3000, 0, 1 # Scale the number of objects based on the screen size
          context.globalAlpha = 1
          context.lineCap = "round"
        
        doRender = (time)->
          renderRequested = false
          renderStars time, normalDrawCall
        
        requestRender = ()->
          unless renderRequested
            renderRequested = true
            requestAnimationFrame doRender
        
        requestScrollRender = (e)->
          p = dpi * (document.body.scrollTop + document.body.parentNode.scrollTop - canvas.offsetTop)
          delta = p - scrollPos
          scrollPos = p
          vel += delta / 20
          requestRender()
        
        requestWheelRender = (e)->
          vel -= e.deltaY / 20
          requestRender()

        requestMoveRender = (e)->
          e.preventDefault() if isInfinite
          y = e.touches.item(0).screenY
          vel -= (y - lastTouchY) / 15
          lastTouchY = y
          requestRender()
        
        touchStart = (e)->
          e.preventDefault() if isInfinite
          lastTouchY = e.touches.item(0).screenY
          
        keyDown = (e)->
          keyboardUp = true if e.keyCode == 38
          keyboardDown = true if e.keyCode == 40
          requestRender()
        
        keyUp = (e)->
          keyboardUp = false if e.keyCode == 38
          keyboardDown = false if e.keyCode == 40
          requestRender()
        
        requestResize = ()->
          if width isnt canvas.parentNode.offsetWidth * dpi
            requestAnimationFrame (time)->
              first = true
              resize()
              renderStars time, firstDrawCall
        
        requestResize()
        window.addEventListener "resize", requestResize
        if isInfinite
          window.addEventListener "wheel", requestWheelRender
        else
          window.addEventListener "scroll", requestScrollRender, passive: true
        window.addEventListener "touchstart", touchStart, passive: !isInfinite
        window.addEventListener "touchmove", requestMoveRender, passive: !isInfinite
        window.addEventListener "keydown", keyDown
        window.addEventListener "keyup", keyUp
        
        
        firstDrawCall = (x, y, r, s)->
          context.beginPath()
          context.fillStyle = s
          context.arc(x, y, r, 0, TAU)
          context.fill()
        
        normalDrawCall = (x, y, r, s)->
          context.beginPath()
          context.strokeStyle = s
          context.lineWidth = r*2
          context.moveTo(x, y - vel*dpi)
          context.lineTo(x, y)
          context.stroke()
        
        renderStars = (time, drawCall)->
          # measurePerf, ready, randTable, randTableSize, and a few other things
          # are defined in app.coffee and are used as read-only globals.
          
          # if measurePerf
          #   console.log ""
          #   starsPerfStart = performance.now()
          
          # Limit the dt range to avoid divide by zero errors, major weirdness from long pauses, etc
          dt = clip time - lastTime, 1, 100
          fps = 1000/dt
          lastTime = time
          smoothedFPS = smoothedFPS*(1-smoothFPSAdaptationRate) + fps*smoothFPSAdaptationRate
          
          # If we aren't moving (eg: the initial render), render at full quality
          frameRateLOD = if vel is 0
            1
          
          # The scene is moving, so adjust the LOD based on the frame rate
          else
            # It's not worth hitting 60fps if that means rendering nothing.
            # This config reaches an equalibrium around 35 FPS in Safari on my Mac.
            scale smoothedFPS, 20, 60, 0.3, 1, true
          
          if keyboardDown and not keyboardUp
            accel = +keyboardAccel
          else if keyboardUp and not keyboardDown
            accel = -keyboardAccel
          else
            accel /= 1.1
          
          vel += accel
          vel /= 1.04
          vel = Math.min maxVel, Math.max -maxVel, vel
          recipVel = Math.min 1, Math.abs maxVel / vel
          pos -= vel * dpi
          
          if Math.abs(vel) > 0.1
            requestRender()
          
          if not first
            context.globalAlpha = Math.min 1, Math.sqrt Math.abs(vel/maxVel)
            # context.globalAlpha = Math.pow Math.sin(vel/maxVel * Math.PI/2), 2
          
          if hud?
            hud.textContent = context.globalAlpha.toPrecision(3)
          

          return unless scrollPos < height
          
          maxPurpBlobs = 120
          maxBlueBlobs = 120
          maxRedBlobs = 120
          
          nPixelStars        = density * frameRateLOD * 600 |0
          nStars             = density * frameRateLOD * 30  |0
          nSmallGlowingStars = density * frameRateLOD * 75  |0
          nPurpBlobs         = density * frameRateLOD * maxPurpBlobs |0
          nBlueBlobs         = density * frameRateLOD * maxBlueBlobs |0
          nRedBlobs          = density * frameRateLOD * maxRedBlobs |0
          
          # Count the number of objects we're about to render
          # console.log nRedBlobs + nPurpBlobs + nBlueBlobs + nPixelStars + nStars + nSmallGlowingStars
                    
          # Pixel Stars
          # start = performance.now() if measurePerf
          i = 0
          while i < nPixelStars
            x = randTable[(i + 5432) % randTableSize]
            y = randTable[x]
            o = randTable[y]
            r = randTable[o]
            x = x * width / randTableSize
            y = mod y * height / randTableSize - pos, height
            o = o / randTableSize * 0.5 + 0.5
            r = (r / randTableSize * 1.5 + .5) * recipVel
            drawCall x, y, r * dpi/2, "hsla(300, #{25*bw}%, 50%, #{o})"
            i++
          # console.log((performance.now() - start).toPrecision(4) + "  pixelStars") if measurePerf
            
          
          # Stars
          # start = performance.now() if measurePerf
          i = 0
          while i < nStars
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
            drawCall x, y, r1 * dpi/2, "hsla(#{c}, #{30*bw}%, #{l}%, #{o})"
            drawCall x, y, r2 * dpi/2, "hsla(0, 0%, 100%, 1)"
            i++
          # console.log((performance.now() - start).toPrecision(4) + "  stars") if measurePerf

          
          # Small Round Stars with circular glow rings
          # start = performance.now() if measurePerf
          i = 0
          while i < nSmallGlowingStars
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
            o = o / randTableSize * 1 * decrease + 0.3
            c = c / randTableSize * 180 + 200

            # far ring
            drawCall x, y, r * r * r * dpi/2, "hsla(#{c}, #{70*bw}%, #{l}%, #{o/25})"
            
            # close ring
            drawCall x, y, r * r * dpi/2, "hsla(#{c}, #{50*bw}%, #{l}%, #{o/6})"
            
            # round star body
            drawCall x, y, r * dpi/2, "hsla(#{c}, #{20*bw}%, #{l}%, #{o})"
            
            # point of light
            drawCall x, y, 1 * dpi/2, "hsla(#{c}, #{100*bw}%, 90%, #{o * 1.5})"
            
            i++
          # console.log((performance.now() - start).toPrecision(4) + "  smallGlowingStars") if measurePerf

          
          if not first
            context.globalAlpha = Math.min 1, Math.sqrt Math.abs(vel/8)
          
          
          # Purple Blobs
          # start = performance.now() if measurePerf
          i = 0
          while i < nPurpBlobs
            increase = i/maxPurpBlobs # get bigger as i increases
            decrease = (1 - increase) # get smaller as i increases
            x = randTable[(i + 1234) % randTableSize]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            o = randTable[l]
            x = x / randTableSize * width*2/3 + width*1/6
            y = mod y / randTableSize * height*2/3 + height*1/6 - pos * (1-0.5*r/randTableSize), height
            r = r / randTableSize * 300 * density * decrease + 20
            l = l / randTableSize * 20 * increase + 1
            o = o / randTableSize * 0.17 * decrease + 0.05
            drawCall x, y, r * dpi/2, "hsla(290, #{100*bw}%, #{l}%, #{o})"
            i++
          # console.log((performance.now() - start).toPrecision(4) + "  purpleBlobs") if measurePerf

          
          # Blue Blobs
          # start = performance.now() if measurePerf
          i = 0
          while i < nBlueBlobs
            increase = i/maxBlueBlobs # get bigger as i increases
            decrease = (1 - increase) # get smaller as i increases
            x = randTable[(i + 123) % randTableSize]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            h = randTable[l]
            x = x / randTableSize * width
            y = mod y / randTableSize * height - pos * (decrease*0.2 + 0.5), height
            r = r / randTableSize * 130 * density * decrease + 20
            s = (l / randTableSize * 30 + 55) * bw
            l = l / randTableSize * 64 * decrease + 1
            h = h / randTableSize * 50 * decrease + 205
            drawCall x, y, r * 1 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, 0.010)"
            drawCall x, y, r * 2 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, 0.014)"
            drawCall x, y, r * 3 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, 0.018)"
            i++
          # console.log((performance.now() - start).toPrecision(4) + "  blueBlobs") if measurePerf


          # Red Blobs
          # start = performance.now() if measurePerf
          i = 0
          while i < nRedBlobs
            increase = i/maxRedBlobs # get bigger as i increases
            decrease = (1 - increase) # get smaller as i increases
            o = randTable[(12345 + i) % randTableSize]
            x = randTable[o]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            h = randTable[l]
            x = x / randTableSize * width
            y = mod y / randTableSize * height - pos * (increase*0.8 + 0.2), height
            r = r / randTableSize * 170 * decrease * density + 20
            l = l / randTableSize * 65 * decrease + 15
            o = o / randTableSize * 0.014 + 0.008
            h = h / randTableSize * 30 + 350
            s = 100 * bw
            drawCall x, y, r * 1 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, #{o})"
            drawCall x, y, r * 2 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, #{o*3/4})"
            drawCall x, y, r * 3 * dpi/2, "hsla(#{h}, #{s}%, #{l}%, #{o/2})"
            i++
          # console.log((performance.now() - start).toPrecision(4) + "  redBlobs") if measurePerf

          
          # if measurePerf
          #   console.log ""
          #   console.log (performance.now() - starsPerfStart).toPrecision(4) + "  Stars"
          
          
          first = false
  null # Avoids coffeescript building an array
