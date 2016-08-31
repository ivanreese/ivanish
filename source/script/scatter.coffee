ready ()->
  return unless performance.now? # Fuck IE
  
  for canvas in document.querySelectorAll "canvas.js-scatter"
    context = canvas.getContext "2d"
    content = document.querySelector ".above"
    
    img = new Image()
    img.src = "/assets/type.png"
    img.onload = ()->
      w = 0
      h = 0
      
      resize = ()->
        if window.innerWidth isnt w
          w = canvas.width = window.innerWidth
          frac = w / img.width
          iw = img.width * frac
          ih = img.height * frac
          top = content.firstChild.clientHeight - iw * .13 + 200
          h = canvas.height = Math.max ih + top, window.innerHeight
          content.style.height = ih + "px"
          top = Math.max top, h - ih
          context.drawImage img, 0, top, iw, ih
      
      count = 0
      requestAnimationFrame update = (time)->
        requestAnimationFrame update
        count++
        size = 40 + Math.pow(2, Math.random() * 7) |0
        size = Math.min size, w / 5 |0
        sizeSquared = size * size
        
        fn = if count%2 is 0 then Math.min else Math.max
        tries = 0
        
        while performance.now() < time + 10 and tries++ < 30
          x = Math.random() * (w-size) |0
          y = Math.random() * (h-size) |0
          nx = Math.max 0, Math.min w-size, if Math.random() < 0.5 then x + size else x - size
          ny = Math.max 0, Math.min h-size, if Math.random() < 0.5 then y + size else y - size
          imageDataA = context.getImageData x, y, size, size
          imageDataB = context.getImageData nx, ny, size, size
          j = 0
          colorDelta = 0
          brightness = 0
          skip = false
          while j < imageDataA.data.length and not skip
            alphaByte = j - (j % 4) + 3
            alphaA = imageDataA.data[alphaByte]
            alphaB = imageDataB.data[alphaByte]
            if alphaA is 0 or alphaB is 0
              skip = true
            else if colorDelta > 12
              skip = true
            else if j % 4 isnt 3
              x = Math.abs ((j/4 |0) % size) - size/2 |0
              y = Math.abs ((j/4 |0) / size) - size/2 |0
              if x + y < size/2
                colorDelta += Math.abs(imageDataA.data[j] - imageDataB.data[j]) / (sizeSquared)
                imageDataB.data[j] = fn imageDataA.data[j], imageDataB.data[j]
                brightness += imageDataB.data[j]
            j++
          if not skip and colorDelta > 4 and brightness > 0.24 * size * size * 255 * 4
            context.putImageData imageDataB, nx, ny
        
      window.addEventListener "resize", resize
      resize()
