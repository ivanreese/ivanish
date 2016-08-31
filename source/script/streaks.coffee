ready ()->
  for canvas in document.querySelectorAll "canvas.js-streaks"
    context = canvas.getContext "2d"
    
    img = new Image()
    img.src = "/assets/time.jpg"
    img.onload = ()->
      w = 0
      h = 0
      pw = 2
      ph = 2
      tracers = []
            
      resize = ()->
        tracers = []
        w = canvas.width = window.innerWidth
        h = canvas.height = window.innerHeight
        frac = h / img.height
        iw = img.width * frac
        ih = img.height * frac
        context.drawImage img, w - iw, h - ih, iw, ih
      
      newTracer = ()->
        tracer =
          offset: 0
          dist: Math.pow 2, Math.random() * 6 |0
          x: Math.random() * (w-pw) |0
          y: Math.random() * (h-ph) |0
        tracer.imageData = context.getImageData tracer.x, tracer.y, pw, ph
        tracer
      
      updateTracers = ()->
        tracers = for tracer in tracers when tracer.offset < tracer.dist and tracer.y > 0
          if Math.random() > 0.5
            tracer.offset += 2
            
            i = 0
            while i < tracer.imageData.data.length
              tracer.imageData.data[i] *= 1.01
              i++
            
            context.putImageData tracer.imageData, tracer.x, tracer.y-tracer.offset
          tracer
      
      requestAnimationFrame update = (time)->
        for i in [0..100]
          tracers.push newTracer()
        updateTracers()
        requestAnimationFrame update
        
      window.addEventListener "resize", resize
      resize()
