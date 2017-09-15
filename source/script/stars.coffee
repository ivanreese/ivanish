ready ()->
  mod = (a, b)->
    (a % b + b) % b
  
  isHome = document.getElementById("#index")?
  bw = if document.querySelector "[js-stars-bw]" then 0 else 1
  
  for canvas in document.querySelectorAll "canvas.js-stars"
    if window.getComputedStyle(canvas).display != "none"
      do (canvas)->
        context = canvas.getContext "2d"
        dpi = 2 # Just do everything at 2x so that we're good for most retina displays (hard to detect)
        width = 0
        height = 0
        density = 0
        dscale = 0
        accel = 0
        vel = 0
        pos = 0
        renderRequested = false
        first = true
        lastTouchY = 0
        keyboardUp = false
        keyboardDown = false
        keySpeed = 1
        scrollPos = document.body.scrollTop + document.body.parentNode.scrollTop - canvas.offsetTop
        lastTime = 0
        maxFpsFrac = 2
        maxDt = 500
        targetMsPerFrame = 13
        smoothDt = 1
        speedScale = 1
        
        canvas.setAttribute "bw", "" if bw is 0
        
        resize = ()->
          if isHome
            width  = canvas.width = window.innerWidth * dpi
            height = canvas.height = window.innerHeight * dpi
          else
            width  = canvas.width = canvas.parentNode.offsetWidth * dpi
            height = canvas.height = canvas.parentNode.offsetHeight * dpi
          density = Math.sqrt width * height # How many stellar objects do we need?
          dscale = density/3000 # This lets us define things in terms of a "natural" display size
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
          p = document.body.scrollTop + document.body.parentNode.scrollTop - canvas.offsetTop
          delta = p - scrollPos
          scrollPos = p
          vel += delta / 10
          requestRender()
        
        requestMoveRender = (e)->
          y = e.touches.item(0).screenY
          vel -= (y - lastTouchY) / 15
          lastTouchY = y
          requestRender()
        
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
        
        requestResize = ()->
          containerWidth = if isHome then window.innerWidth else canvas.parentNode.offsetWidth
          if width isnt containerWidth * dpi
            requestAnimationFrame (time)->
              first = true
              smoothDt = 1
              resize()
              renderStars time, firstDrawCall
        
        requestResize()
        window.addEventListener "resize", requestResize
        window.addEventListener "scroll", requestScrollRender, passive: true
        window.addEventListener "touchstart", touchStart, passive: true
        window.addEventListener "touchmove", requestMoveRender, passive: true
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
          context.moveTo(x, y - vel*dpi*speedScale)
          context.lineTo(x, y)
          context.stroke()
        
        renderStars = (time, drawCall)->
          # measurePerf, ready, randTable, randTableSize, and a few other things
          # are defined in app.coffee and are used as read-only globals.
          
          # if measurePerf
          #   console.log ""
          #   starsPerfStart = performance.now()
          
          # We're deliberately adding 1 frame of latency to our fpsFrac, so that the first frame always renders at top quality
          fpsFrac = Math.min maxFpsFrac, targetMsPerFrame/smoothDt
          dt = Math.min maxDt, time - lastTime
          smoothDt = smoothDt*.95 + dt*.05
          lastTime = time
          
          
          if keyboardDown and not keyboardUp
            accel = +keySpeed
          else if keyboardUp and not keyboardDown
            accel = -keySpeed
          else
            accel /= 1.1
          
          vel += accel
          vel /= 1.04
          vel = Math.min 20, Math.max -20, vel
          recipVel = Math.min 1, Math.abs 10 / vel
          pos -= vel * dpi * speedScale
          
          if Math.abs(vel) > 0.01
            requestRender()
          
          if not first
            context.globalAlpha = Math.min 1, Math.sqrt Math.abs(vel/30)
          
          nPixelStars        = (fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.6, density /   5, 0)) |0
          nStars             = (fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.6, density / 100, 0)) |0
          nSmallGlowingStars = (          Math.max 0, scale(scrollPos, 0, height*0.6, density /  40, 0)) |0
          nPurpBlobs         = (fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.6, density /  25, 0)) |0
          nBlueBlobs         = (fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.6, density /  25, 0)) |0
          nRedBlobs          = (fpsFrac * Math.max 0, scale(scrollPos, 0, height*0.6, density /  25, 0)) |0
          
          # Count the number of objects we're about to render
          # console.log nRedBlobs + nPurpBlobs + nBlueBlobs + nPixelStars + nStars + nSmallGlowingStars
          
          
          # Pixel Stars
          # start = performance.now() if measurePerf
          i = 0
          while i < nPixelStars
            increase = i/nPixelStars # get bigger as i increases
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
            increase = i/nPurpBlobs # get bigger as i increases
            decrease = (1 - increase) # get smaller as i increases
            x = randTable[(i + 1234) % randTableSize]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            o = randTable[l]
            x = x / randTableSize * width*2/3 + width*1/6
            y = mod y / randTableSize * height*2/3 + height*1/6 - pos * (decrease/2 + 0.5), height
            r = r / randTableSize * 300 * dscale * decrease + 20
            l = l / randTableSize * 20 * increase + 1
            o = o / randTableSize * 0.17 * decrease + 0.05
            drawCall x, y, r * dpi/2, "hsla(290, #{100*bw}%, #{l}%, #{o})"
            i++
          # console.log((performance.now() - start).toPrecision(4) + "  purpleBlobs") if measurePerf

          
          # Blue Blobs
          # start = performance.now() if measurePerf
          i = 0
          while i < nBlueBlobs
            increase = i/nBlueBlobs # get bigger as i increases
            decrease = (1 - increase) # get smaller as i increases
            x = randTable[(i + 123) % randTableSize]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            h = randTable[l]
            x = x / randTableSize * width
            y = mod y / randTableSize * height - pos * (decrease/5 + 0.5), height
            r = r / randTableSize * 130 * dscale * decrease + 20
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
            r = r / randTableSize * 170 * decrease * dscale + 20
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
