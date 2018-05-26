ready ()->

  ## BEGIN RAND TABLE
  # We use a rand table, rather than Math.random(), so that we can have determinstic randomness.
  # This is not a performance optimization — Math.random() is already VERY fast.
  # It just gives us repeatability from one frame to the next.

  # Set determinstic to true for debugging, false for deployment
  determinstic = false
  seed = if determinstic then 2147483647 else Math.random() * 2147483647 |0

  # Needs to be larger than the number of times we use it in one place, or else we'll get duplication.
  # At this size, it takes about ~2ms to populate the table on my machine
  randTableSize = 4096

  # This is just a generic swap function. It seems faster to let the browser JIT this than to inline it ourselves.
  swap = (i, j, p)->
    tmp = p[i]
    p[i] = p[j]
    p[j] = tmp

  randTable = [0...randTableSize]
  j = 0
  for i in [0...randTableSize]
    j = (j + seed + randTable[i]) % randTableSize
    swap i, j, randTable
  ## END RAND TABLE

  # Check the DOM to see which mode we'll be running in
  isInfinite = document.getElementById "starfailed-full"
  bw = if document.querySelector "[js-stars-bw]" then 0 else 1
  hud = document.querySelector "hud" if window.location.port is "3000"

  for canvas in document.querySelectorAll "canvas.js-stars"
    if window.getComputedStyle(canvas).display != "none"
      do (canvas)->
        context = canvas.getContext "2d"
        dpi = Math.max 1, Math.round(window.devicePixelRatio)
        width = 0
        height = 0
        density = 0
        ndensity = 0
        dScale = 0
        dScaleHalfDpi = 0
        accel = 0
        vel = 0
        maxVel = defaultMaxVel = .5 # Multiplied by root of the screen height
        scaledVel = 0
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
        # The closer these rates get to 1, the more sputtering
        smoothFPSAdaptationRateUp = 1/300 # Rate when current FPS is higher than smoothed FPS
        smoothFPSAdaptationRateDown = 1/60 # Rate when current FPS is lower than smoothed FPS
        alpha = 1

        # This is for the css
        canvas.setAttribute "bw", "" if bw is 0

        resize = ()->
          width  = canvas.width = canvas.parentNode.offsetWidth * dpi
          height = canvas.height = canvas.parentNode.offsetHeight * dpi
          ndensity = scale Math.sqrt(width * height)/dpi, 100, 1000, 0.5, 1 # Scale the number of stars based on the canvas height
          density = scale Math.sqrt(width * height)/dpi, 0, 1500, 0, 1 # Scale the number of blobs based on the canvas size
          dScale = scale Math.sqrt(width * height)/dpi, 500, 3000, 1, 2 # Scale the size of objects based on the canvas size
          dScaleHalfDpi = dScale * dpi/2
          maxVel = defaultMaxVel * Math.sqrt window.innerHeight # Scale the velocity based on the height of the screen
          context.lineCap = "round"
          first = true

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
          vel += delta / 8
          requestRender()

        requestWheelRender = (e)->
          vel -= e.deltaY / 8
          requestRender()

        requestMoveRender = (e)->
          e.preventDefault() if isInfinite
          y = e.touches.item(0).screenY
          vel -= (y - lastTouchY) / 8
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
          context.arc x, y, r, 0, TAU
          context.fill()

        normalDrawCall = (x, y, r, s, velScale)->
          context.beginPath()
          context.strokeStyle = s
          context.lineWidth = r*2
          context.moveTo x, y - (scaledVel * velScale)
          context.lineTo x, y
          context.stroke()

        renderStars = (time, drawCall)->
          # Limit the dt range to avoid divide by zero errors, major weirdness from long pauses, etc
          dt = clip time - lastTime, 16, 100
          fps = 1000/dt
          lastTime = time
          smoothedFPS = if fps > smoothedFPS
            smoothedFPS*(1-smoothFPSAdaptationRateUp) + fps*smoothFPSAdaptationRateUp
          else
            smoothedFPS*(1-smoothFPSAdaptationRateDown) + fps*smoothFPSAdaptationRateDown

          # If we aren't moving (eg: the initial render), render at full quality
          if vel is 0
            frameRateLODStars = 1
            frameRateLODBlobs = 1
          else # The scene is moving, so adjust the LOD based on the frame rate
            frameRateLODStars = scale smoothedFPS, 30, 60, 0.2, 1, true
            frameRateLODBlobs = scale smoothedFPS, 10, 60, 0.3, 1, true

          return unless scrollPos < Math.max(height, 1000) and !document.hidden

          if keyboardDown and not keyboardUp
            accel = +keyboardAccel
          else if keyboardUp and not keyboardDown
            accel = -keyboardAccel
          else
            accel /= 1.05

          vel += accel
          absVel = Math.abs vel
          if absVel > .5
            vel /= 1.1
          else
            vel /= (1 + absVel/5)
          vel = clip vel, -maxVel, maxVel
          scaledVel = vel * dpi * dScale
          pos -= scaledVel

          absVel = Math.abs vel

          if absVel > 0.03
            requestRender()

          if first
            maxPixelStars = 500
            maxStars = 80
            maxSmallGlowingStars = 80
            maxBlackBlobs = 0
            maxBlueBlobs = 0
            maxRedBlobs = 0
          else
            maxPixelStars = 200
            maxStars = 40
            maxSmallGlowingStars = 40
            maxBlackBlobs = 40
            maxBlueBlobs = 80
            maxRedBlobs = 80

          nPixelStars        = ndensity * frameRateLODStars * maxPixelStars |0
          nStars             = ndensity * frameRateLODStars * maxStars |0
          nSmallGlowingStars = ndensity * frameRateLODStars * maxSmallGlowingStars |0
          nBlueBlobs         = ndensity * frameRateLODBlobs * maxBlueBlobs |0
          nRedBlobs          = ndensity * frameRateLODBlobs * maxRedBlobs |0
          nBlackBlobs        = ndensity * maxBlackBlobs |0

          if hud?
            hud.textContent = smoothedFPS.toPrecision(3)


          if not first
            alpha = Math.cos(clip absVel/40, 0, Math.PI)

          # Pixel Stars
          i = 0
          while i < nPixelStars
            increase = i/maxPixelStars
            x = randTable[(i + 5432) % randTableSize]
            y = randTable[x]
            o = randTable[y]
            r = randTable[o]
            l = randTable[r]
            s = randTable[l]
            x = x * width / randTableSize
            y = mod y * height / randTableSize - pos * increase, height
            o = o / randTableSize + 0.01
            r = r / randTableSize * 1.5 + 0.5
            l = l / randTableSize * 50 + 50
            s = s / randTableSize * 25
            drawCall x, y, r * dScaleHalfDpi, "hsla(300, #{s*bw}%, #{l}%, #{o*alpha})", increase
            i++


          # Stars
          i = 0
          while i < nStars
            increase = i/maxStars
            decrease = 1 - increase
            x = randTable[i % randTableSize]
            y = randTable[x]
            r = randTable[y]
            sx = randTable[r]
            sy = randTable[sx]
            l = randTable[sy]
            c = randTable[l]
            o = randTable[c]
            x = x * width / randTableSize
            y = mod y * height / randTableSize - pos * decrease, height
            r = r / randTableSize * 4 + .2
            l = l / randTableSize * 20 + 80
            o = o / randTableSize * decrease + 0.1
            c = c / randTableSize * 120 + 200
            drawCall x, y, r * dScaleHalfDpi, "hsla(#{c}, #{30*bw}%, #{l}%, #{o*alpha})", decrease
            i++

          if not first
            alpha = clip Math.pow(absVel/5, 3), 0, 2

          # Small Round Stars with circular glow rings
          i = 0
          while i < nSmallGlowingStars
            increase = i/maxSmallGlowingStars
            decrease = 1 - increase
            r = randTable[(i + 345) % randTableSize]
            l = randTable[r]
            o = randTable[l]
            c = randTable[o]
            x = randTable[c]
            y = randTable[x]
            x = x * width / randTableSize
            y = mod y * height / randTableSize - pos * decrease, height
            r = r / randTableSize * 2 + 1
            l = l / randTableSize * 20 + 60
            o = o / randTableSize * decrease * .8 + 0.1
            c = c / randTableSize * 200 + 200 % 360

            # far ring
            drawCall x, y, r * r * r * dScaleHalfDpi, "hsla(#{c}, #{70*bw}%, #{l}%, #{o/25*alpha})", decrease

            # close ring
            drawCall x, y, r * r * dScaleHalfDpi, "hsla(#{c}, #{50*bw}%, #{l}%, #{o/6*alpha})", decrease

            # round star body
            drawCall x, y, r * dScaleHalfDpi, "hsla(#{c}, #{20*bw}%, #{l}%, #{o*alpha})", decrease

            # point of light
            drawCall x, y, 1 * dScaleHalfDpi, "hsla(#{c}, #{100*bw}%, 90%, #{o * 1.5*alpha})", decrease

            i++


          # Alpha for blobs
          if first
            alpha = 0.35
          if not first
            alpha = 1 - Math.cos(clip absVel/5, 0, Math.PI)


          # Blue Blobs
          i = 0
          while i < nBlueBlobs
            increase = i/maxBlueBlobs
            decrease = 1 - increase
            x = randTable[(i + 123) % randTableSize]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            s = randTable[l]
            h = randTable[s]
            o = randTable[h]
            x = x / randTableSize * width * increase
            r = r / randTableSize * 150 * density * decrease + 20
            velScale = decrease * 0.8 + 0.2
            y = mod(y / randTableSize * height - pos * velScale, height + r*2)-r
            s = (s / randTableSize * 30 + 70) * bw
            l = l / randTableSize * 74 + 1
            h = h / randTableSize * 50 + 200
            o = o / randTableSize * 0.03 + 0.005
            drawCall x, y, r * 1 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o*alpha})", velScale
            drawCall x, y, r * 2.5 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o/2*alpha})", velScale
            i++


          # Red Blobs
          i = 0
          while i < nRedBlobs
            increase = i/maxRedBlobs
            decrease = 1 - increase
            o = randTable[(12345 + i) % randTableSize]
            x = randTable[o]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            h = randTable[l]
            x = width - x / randTableSize * width * decrease
            r = r / randTableSize * 150 * density * increase + 20
            velScale = increase * 0.8 + 0.2
            y = mod(y / randTableSize * height * decrease - pos * velScale, height + r*2)-r
            l = l / randTableSize * 40 + 25
            o = o / randTableSize * 0.03 + 0.005
            h = h / randTableSize * 50 + 340
            s = 100 * bw
            drawCall x, y, r * 1 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o*alpha})", velScale
            drawCall x, y, r * 2 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o/3*alpha})", velScale
            i++

          if not first
            alpha = Math.sqrt absVel


          # Black Blobs
          i = 0
          while i < nBlackBlobs
            increase = i/maxBlackBlobs
            decrease = 1 - increase
            x = randTable[(i + 1234) % randTableSize]
            y = randTable[x]
            l = randTable[y]
            o = randTable[l]
            x = x / randTableSize * width*2/3 + width*1/6
            r = 300 * density * decrease * decrease + 1
            velScale = .5 * increase * increase + .1
            y = mod(r + y / randTableSize * height*2/3 + height*1/6 - pos * velScale, height+r*2)-r
            l = l / randTableSize * 10 * increase + 2.5 * decrease
            o = o / randTableSize * .1 + 0.005
            drawCall x, y, r * dScaleHalfDpi, "hsla(290, #{100*bw}%, #{l}%, #{o*alpha})", velScale
            i++

          first = false

  undefined
