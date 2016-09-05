ready ()->
  for canvas in document.querySelectorAll "canvas.js-streaks"
    context = canvas.getContext "2d"
    inner = document.querySelector ".above"
    
    img = new Image()
    img.src = "/assets/time.jpg"
    img.onload = ()->
      w = 0
      h = 0
      tracers = []
      
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
        rand = Math.random()
        tracer =
          rand: rand
          offset: 0
          dist: Math.pow(2, 1 + rand * 6) |0
        size = 1 + Math.random() * 8 |0
        tracer.v = Math.min 1, size/2
        tracer.x = Math.random() * (w-size) |0
        tracer.y = Math.random() * (h-size) |0
        tracer.imageData = context.getImageData tracer.x, tracer.y, size, size
        tracer
      
      updateTracers = ()->
        tracers = for tracer in tracers when tracer.offset < tracer.dist and tracer.y > 0
          if Math.random() > tracer.rand
            tracer.offset += tracer.v
            
            i = 0
            while i < tracer.imageData.data.length
              tracer.imageData.data[i] *= 1.01
              i++
            
            context.putImageData tracer.imageData, tracer.x, tracer.y-tracer.offset
          tracer
      
      requestAnimationFrame update = (time)->
        tracers.push newTracer() while tracers.length < w/8
        updateTracers()
        requestAnimationFrame update
        
      window.addEventListener "resize", resize
      resize()
