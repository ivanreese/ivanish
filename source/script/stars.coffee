do ()->
  useP3 = true

  # We use a rand table, rather than Math.random(), so that we can have deterministic randomness.
  # This is not a performance optimization — Math.random() is already VERY fast.
  # It just gives us repeatability from one frame to the next.

  # The table needs to be larger than the number of times we use it in one place, or else we'll get duplication.
  # At this size, it takes about ~1ms to populate the table on my machine
  randTableSize = 4096

  seed = 2 ** 31 - 1
  seed = seed * Math.random() |0 # Comment-out this line for repeatable debugging
  seed = 771 if seed % randTableSize is 1 # If the seed mod randTableSize is 1, we get awful results

  randTable = [0...randTableSize]
  j = 0
  for i in [0...randTableSize]
    j = (j + seed + randTable[i]) % randTableSize
    [randTable[i], randTable[j]] = [randTable[j], randTable[i]]

  # Check the DOM to see which mode we'll be running in
  isInfinite = document.getElementById "starfailed-full"
  bw = document.querySelector "[js-stars-bw]"
  bio = document.querySelector "[js-stars-bio]"

  # For these, the first element is the base value and the second is the random offset from it
  styles =
    normal:
      stars:      h: [200, 200], s: 100,      l: [60, 20]
      blueBlobs:  h: [207, 55],  s: [30, 70], l: [1, 74]
      redBlobs:   h: [330, 55],  s: [30, 70], l: [25, 40]
      blackBlobs: h: 290,        s: 100,      l: [3, 2]
    bio:
      stars:      h: [15, 40],   s: 35,       l: [20, 80]
      blueBlobs:  h: [220, 20],  s: [15, 10], l: [40, 20]
      redBlobs:   h: [5, 10],    s: [40, 20], l: [25, 40]
      blackBlobs: h: 11,         s: 41,       l: [3, 2]
    bw:
      stars:      h: [0, 0],     s: 0,        l: [0, 0]
      blueBlobs:  h: [0, 0],     s: [0, 0],   l: [0, 0]
      redBlobs:   h: [0, 0],     s: [0, 0],   l: [25, 40]
      blackBlobs: h: 0,          s: 0,        l: [3, 2]

  style = switch
    when bw then styles.bw
    when bio then styles.bio
    else styles.normal

  for canvas in document.querySelectorAll "canvas.js-stars"
    if window.getComputedStyle(canvas).display isnt "none"
      do (canvas)->
        context = canvas.getContext "2d", colorSpace: (if useP3 then "display-p3" else "srgb")
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
        lastTime = 0

        # This is for the css
        canvas.setAttribute "bw", "" if bw
        canvas.setAttribute "bio", "" if bio

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
          vel += delta / if isInfinite then 24 else if bio then 20 else 5
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
          return if not isInfinite and reduceMotion and not first

          time = performance.now()
          dt = Math.min 1/60, (time - lastTime)/1000
          lastTime = time
          timeScale = 60 * dt # the below is all still written assuming 60 fps

          if keyboardDown and not keyboardUp
            accel = +keyboardAccel
          else if keyboardUp and not keyboardDown
            accel = -keyboardAccel
          else
            accel /= 1 + .05 * timeScale

          vel += accel * timeScale
          absVel = Math.abs vel
          if absVel > .5
            vel /= 1 + (if isInfinite then .02 else .05) * timeScale
          else
            vel /= 1 + (absVel/5) * timeScale

          vel = clip vel, -maxVel, maxVel unless bio

          scaledVel = vel * dpi * dScale
          pos -= scaledVel * timeScale
          absPos -= Math.abs scaledVel * timeScale

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
            drawCall x, y, r * dScaleHalfDpi, hsla(300, 0, 100, o*alpha*odensity), increase
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
            drawCall x, y, r * dScaleHalfDpi, hsla(c, 30*bw, l, o*alpha*odensity), decrease
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
            l = l / randTableSize * style.stars.l[1] + style.stars.l[0]
            o = o / randTableSize * decrease * .8 + 0.05
            c = c / randTableSize * style.stars.h[1] + style.stars.h[0] % 360
            s = style.stars.s

            # far ring
            drawCall x, y, r * r * r * dScaleHalfDpi, hsla(c, .7*s, l, o/25*alpha), decrease

            # close ring
            drawCall x, y, r * r * dScaleHalfDpi, hsla(c, .5*s, l, o/6*alpha), decrease

            # round star body
            drawCall x, y, r * dScaleHalfDpi, hsla(c, .2*s, l, o*alpha), decrease

            # point of light
            drawCall x, y, 1 * dScaleHalfDpi, hsla(c, s, 90, o * 1.5*alpha), decrease

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
            s = s / randTableSize * style.blueBlobs.s[1] + style.blueBlobs.s[0]
            l = l / randTableSize * style.blueBlobs.l[1] + style.blueBlobs.l[0]
            h = h / randTableSize * style.blueBlobs.h[1] + style.blueBlobs.h[0]
            o = o / randTableSize * 0.1 + 0.05
            drawCall x, y, r * 1 * dScaleHalfDpi, hsla(h, s, l, o*alpha), velScale
            drawCall x, y, r * 2 * dScaleHalfDpi, hsla(h, s, l, o/2*alpha), velScale
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
            l = l / randTableSize * style.redBlobs.l[1] + style.redBlobs.l[0]
            o = o / randTableSize * 0.1 + 0.05
            h = h / randTableSize * style.redBlobs.h[1] + style.redBlobs.h[0]
            s = s / randTableSize * style.redBlobs.s[1] + style.redBlobs.s[0]
            drawCall x, y, r * 1 * dScaleHalfDpi, hsla(h, s, l, o*alpha), velScale
            drawCall x, y, r * 2 * dScaleHalfDpi, hsla(h, s, l, o/2*alpha), velScale
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
            l = l / randTableSize * style.blackBlobs.l[1] + style.blackBlobs.l[0] * increase + 2
            r = 100 * increase * increase * density + 40
            velScale = 600 / r / r + 10 / r
            y = mod(r + y / randTableSize * height + absPos * velScale, height+r*2)-r
            x = x / randTableSize * width * .8 + width * .1 + width/6 * velScale * Math.cos(-absPos * velScale / 2000 * f / randTableSize + p / randTableSize)
            drawCall x, y, r * dScaleHalfDpi, hsla(style.blackBlobs.h, style.blackBlobs.s, l, alpha), velScale
            i++

          null

  # By default, do a straightforward conversion
  hsla = (h, s, l, a)-> "hsla(#{h}, #{s}%, #{l}%, #{a})"

  # If the browser supports p3, run in p3.
  # When other CSS color funcs add support for p3, we can use lch or oklch or something
  if (useP3 and window.CSS.supports("color", "color(display-p3 1 1 1)"))
    hsla = (h, s, l, a) ->
      h /= 360
      s /= 100
      l /= 100
      return "color(display-p3 #{l} #{l} #{l} / #{a})" if s is 0
      q = if l < 0.5 then l * (1 + s) else l + s - l * s
      p = 2 * l - q
      r = hueToRgb p, q, h + 1 / 3
      g = hueToRgb p, q, h
      b = hueToRgb p, q, h - (1 / 3)
      "color(display-p3 #{r} #{g} #{b} / #{a})"

    hueToRgb = (p, q, t) ->
      t += 1 if t < 0
      t -= 1 if t > 1
      return p + (q - p) * 6 * t if t < 1 / 6
      return q if t < 1 / 2
      return p + (q - p) * (2 / 3 - t) * 6 if t < 2 / 3
      return p
