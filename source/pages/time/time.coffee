do ()->
  for canvas in document.querySelectorAll "canvas.js-streaks"
    context = canvas.getContext "2d", willReadFrequently: true
    inner = document.querySelector ".above"

    img = new Image()
    img.crossOrigin = "Anonymous"
    img.src = "https://d3um8l2sa8g9bu.cloudfront.net/time/bg.jpg"
    img.onload = ()->
      w = 0
      h = 0
      tracers = []
      count = 0
      tries = 0

      resize = ()->
        if window.innerWidth isnt w
          tracers = []
          w = canvas.width = window.innerWidth
          h = canvas.height = Math.max window.innerHeight, inner.clientHeight
          frac = h / img.height
          iw = img.width * frac
          ih = img.height * frac
          left = Math.max -iw * .4, w - iw
          context.drawImage img, left, h - ih, iw, ih

      newTracer = ()->
        tw = 1 + Math.pow(Math.random()-.5, 2) * 40 |0
        th = 2
        x = Math.random() * (w-tw - h/20) |0
        y = Math.random() * (h-th - h * .6) + h * .6 |0
        imageData = context.getImageData x, y, tw, th
        byte = 0
        intensity = 0
        while byte < imageData.data.length
          intensity += imageData.data[byte] if byte isnt (byte - (byte % 4) + 3)
          byte++
          null

        intensity /= (tw*th)

        if intensity > Math.max(10, h * .6 - count)
          dist: Math.pow(2, Math.pow(Math.random(), 4) * 7) |0
          imageData: imageData
          intensity: intensity
          offset: 0
          rand: 0.1 + Math.random() * 0.6
          x: x
          y: y
        else
          null

      updateTracers = ()->
        for tracer, i in tracers
          if tracer.offset < tracer.dist and (tracer.y-tracer.offset) > 0
            if Math.random() < tracer.rand
              tracer.offset++

              byte = 0

              while byte < tracer.imageData.data.length
                tracer.imageData.data[byte] *= 1.003
                byte++
                null

              context.putImageData tracer.imageData, tracer.x, tracer.y-tracer.offset
          else
            nt = newTracer()
            tracers[i] = nt if nt?
        undefined

      requestAnimationFrame update = (time)->
        tries = 0
        count += 0.3
        while tracers.length < h/30 and tries < 100
          t = newTracer()
          if t?
            tracers.push t
          else
            tries++
          null
        updateTracers()
        requestAnimationFrame update

      window.addEventListener "resize", resize
      resize()

  null
