do ()->

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

  randTable = [0...randTableSize]
  j = 0
  for i in [0...randTableSize]
    j = (j + seed + randTable[i]) % randTableSize
    tmp = randTable[i]
    randTable[i] = randTable[j]
    randTable[j] = tmp

  ## END RAND TABLE

  # Check the DOM to see which mode we'll be running in
  isInfinite = document.getElementById "starfailed-full"
  bw = if document.querySelector "[js-stars-bw]" then 0 else 1

  for canvas in document.querySelectorAll "canvas.js-stars"
    if window.getComputedStyle(canvas).display isnt "none"
      do (canvas)->
        context = canvas.getContext "2d"
        dpi = Math.max 1, Math.round window.devicePixelRatio
        width = 0
        height = 0
        density = 0
        odensity = 0
        sdensity = 0
        bdensity = 0
        dScale = 0
        dScaleHalfDpi = 0
        accel = 0
        vel = 0
        maxVel = defaultMaxVel = if isInfinite then 4 else .3 # Multiplied by root of the screen height
        scaledVel = 0
        pos = 0
        absPos = 0
        renderRequested = false
        first = true
        lastTouchY = 0
        keyboardUp = false
        keyboardDown = false
        keyboardAccel = 0.5
        scrollPos = dpi * (document.body.scrollTop + document.body.parentNode.scrollTop - canvas.offsetTop)
        alpha = 1

        # This is for the css
        canvas.setAttribute "bw", "" if bw is 0

        resize = ()->
          width = canvas.width = canvas.parentNode.offsetWidth * dpi
          height = canvas.height = canvas.parentNode.offsetHeight * dpi
          odensity = scale height/dpi, 0, 1000, 0.3, 1 # Scale the opacity of objects based on the canvas height
          sdensity = scale Math.sqrt(width * height)/dpi, 100, 1000, .2, 1 # Scale the number of stars based on the canvas size
          bdensity = scale Math.sqrt(width * height)/dpi, 100, 1000, .6, 1 # Scale the number of blobs based on the canvas size
          density = scale Math.sqrt(width * height)/dpi, 0, 1500, 0, 1 # Scale the radius of objects based on the canvas size
          dScale = scale Math.sqrt(width * height)/dpi, 500, 3000, 1, 2 # Scale the size of objects based on the canvas size
          dScaleHalfDpi = dScale * dpi/2
          maxVel = defaultMaxVel * Math.sqrt window.innerHeight # Scale the velocity based on the height of the screen
          first = true

        doRender = ()->
          renderRequested = false
          renderStars normalDrawCall

        requestRender = ()->
          unless renderRequested
            renderRequested = true
            requestAnimationFrame doRender

        requestScrollRender = (e)->
          p = dpi * (document.body.scrollTop + document.body.parentNode.scrollTop - canvas.offsetTop)
          delta = p - scrollPos
          scrollPos = p
          vel += delta / if isInfinite then 24 else 5
          requestRender()

        requestWheelRender = (e)->
          vel -= e.deltaY / if isInfinite then 64 else 8
          requestRender()

        requestMoveRender = (e)->
          e.preventDefault() if isInfinite
          y = e.touches.item(0).screenY
          vel -= (y - lastTouchY) / if isInfinite then 24 else 5
          lastTouchY = y
          requestRender()

        touchStart = (e)->
          e.preventDefault() if isInfinite
          lastTouchY = e.touches.item(0).screenY

        keyDown = (e)->
          keyboardUp = true if e.keyCode == 38
          keyboardDown = true if e.keyCode == 40
          requestRender() if keyboardDown or keyboardUp

        keyUp = (e)->
          keyboardUp = false if e.keyCode == 38
          keyboardDown = false if e.keyCode == 40
          # requestRender() if keyboardDown or keyboardUp

        requestResize = ()->
          if width isnt canvas.parentNode.offsetWidth * dpi
            requestAnimationFrame ()->
              first = true
              resize()
              renderStars firstDrawCall

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

        renderStars = (drawCall)->
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
            vel /= if isInfinite then 1.02 else 1.05
          else
            vel /= (1 + absVel/5)
          vel = clip vel, -maxVel, maxVel
          scaledVel = vel * dpi * dScale
          pos -= scaledVel
          absPos -= Math.abs scaledVel

          absVel = Math.abs vel

          if absVel > 0.03
            requestRender()

          if first
            maxPixelStars = 800
            maxStars = 120
            maxSmallGlowingStars = 240
            maxBlueBlobs = 0
            maxRedBlobs = 0
            maxBlackBlobs = 0
          else
            maxPixelStars = 200
            maxStars = 40
            maxSmallGlowingStars = 50
            maxBlueBlobs = 120
            maxRedBlobs = 100
            maxBlackBlobs = 5

          nPixelStars        = sdensity * maxPixelStars |0
          nStars             = sdensity * maxStars |0
          nSmallGlowingStars = sdensity * maxSmallGlowingStars |0
          nBlueBlobs         = bdensity * maxBlueBlobs |0
          nRedBlobs          = bdensity * maxRedBlobs |0
          nBlackBlobs        = maxBlackBlobs

          if not first
            alpha = Math.pow(absVel/40, .5) * Math.cos clip absVel/7, 0, Math.PI

          context.lineCap = "butt"


          # Pixel Stars
          i = 0
          while i < nPixelStars
            increase = i/maxPixelStars
            x = randTable[(i + 5432) % randTableSize]
            y = randTable[x]
            o = randTable[y]
            r = randTable[o]
            x = x * width / randTableSize
            y = mod y * height / randTableSize - pos * increase, height
            o = o / randTableSize * .5 + 0.01
            r = r / randTableSize * 1 + .5
            drawCall x, y, r * dScaleHalfDpi, "hsla(300, 0%, 100%, #{o*alpha*odensity})", increase
            i++


          # Stars
          i = 0
          while i < nStars
            decrease = 1 - i/maxStars
            x = randTable[i % randTableSize]
            y = randTable[x]
            r = randTable[y]
            sx = randTable[r]
            sy = randTable[sx]
            l = randTable[sy]
            c = randTable[l]
            o = randTable[c]
            x = x * width / randTableSize
            r = r / randTableSize * 4 + .2
            y = mod(r + y * height / randTableSize - pos * decrease, height+r*2)-r
            l = l / randTableSize * 20 + 80
            o = o / randTableSize * decrease + 0.05
            c = c / randTableSize * 120 + 200
            drawCall x, y, r * dScaleHalfDpi, "hsla(#{c}, #{30*bw}%, #{l}%, #{o*alpha*odensity})", decrease
            i++


          if not first
            alpha = clip Math.pow(absVel/5, 3), 0, 2


          # Small Round Stars with circular glow rings
          i = 0
          while i < nSmallGlowingStars
            decrease = 1 - i/maxSmallGlowingStars
            r = randTable[(i + 345) % randTableSize]
            l = randTable[r]
            o = randTable[l]
            c = randTable[o]
            x = randTable[c]
            y = randTable[x]
            x = x * width / randTableSize
            r = r / randTableSize * 2 + 1
            y = mod(r + y * height / randTableSize - pos * decrease, height+r*2)-r
            l = l / randTableSize * 20 + 60
            o = o / randTableSize * decrease * .8 + 0.05
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

          return first = false if first


          # For blobs
          context.lineCap = "round"
          alpha = clip Math.pow(absVel/24, 1.4), 0, 0.5


          # Blue Blobs
          i = 0
          while i < nBlueBlobs
            increase = i/maxBlueBlobs
            x = randTable[(i + 123) % randTableSize]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            s = randTable[l]
            h = randTable[s]
            o = randTable[h]
            x = x / randTableSize * width
            _r = r / randTableSize
            velScale = 1 - .8 * _r
            r = _r * 120 * density + 20
            y = mod(r + y / randTableSize * height - absPos * velScale, height + r*2)-r
            s = (s / randTableSize * 70 + 30) * bw
            l = l / randTableSize * 74 + 1
            h = h / randTableSize * 55 + 207
            o = o / randTableSize * 0.1 + 0.05
            drawCall x, y, r * 1 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o*alpha})", velScale
            drawCall x, y, r * 2 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o/2*alpha})", velScale
            i++


          # Red Blobs
          i = 0
          while i < nRedBlobs
            increase = i/maxRedBlobs
            o = randTable[(12345 + i) % randTableSize]
            x = randTable[o]
            y = randTable[x]
            r = randTable[y]
            l = randTable[r]
            h = randTable[l]
            s = randTable[h]
            x = x / randTableSize * width
            _r = r / randTableSize
            velScale = 1 - .8 * _r
            r = _r * 120 * density + 20
            y = mod(r + y / randTableSize * height - absPos * velScale, height + r*2)-r
            l = l / randTableSize * 40 + 25
            o = o / randTableSize * 0.1 + 0.05
            h = h / randTableSize * 55 + 330
            s = (s / randTableSize * 70 + 30) * bw
            drawCall x, y, r * 1 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o*alpha})", velScale
            drawCall x, y, r * 2 * dScaleHalfDpi, "hsla(#{h}, #{s}%, #{l}%, #{o/2*alpha})", velScale
            i++


          # Black Blobs
          alpha = 0.002 + 0.05 * Math.sqrt absVel

          i = 0
          while i < nBlackBlobs
            increase = i/maxBlackBlobs
            decrease = 1 - increase
            x = randTable[(i + 771) % randTableSize]
            y = randTable[x]
            l = randTable[y]
            f = randTable[l]
            p = randTable[f]
            l = l / randTableSize * 2 + 3 * increase + 2
            r = 100 * increase * increase * density + 40 * density
            velScale = 600 / r / r + 10 / r
            y = mod(r + y / randTableSize * height + absPos * velScale, height+r*2)-r
            x = x / randTableSize * width * .8 + width * .1 + width/6 * velScale * Math.cos(-absPos * velScale / height * f / randTableSize + p / randTableSize)
            drawCall x, y, r * dScaleHalfDpi, "hsla(290, #{100*bw}%, #{l}%, #{alpha})", velScale
            i++

  null
