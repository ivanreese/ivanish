ready ()->
  for canvas in document.querySelectorAll "canvas.js-scatter"
    context = canvas.getContext "2d"
    content = document.querySelector ".above"
    
    img = new Image()
    img.src = "/assets/type.png"
    img.onload = ()->
      w = 0
      h = 0
      bottom = 0
      count = 0
      
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
          bottom = h/3
      
      requestAnimationFrame update = (time)->
        requestAnimationFrame update
        count++
        size = 2 + Math.pow(2, Math.random() * 9) |0
        size = size * w / 1500 |0
        sizeSquared = size * size
        bottom = Math.min h*2/3, bottom + 0.2
        fn = if count%3 is 0 then Math.max else Math.min
        tries = 0
        while tries++ < 5
          x = Math.random() * (w-size) |0
          y = Math.random() * bottom |0
          nx = Math.max 0, Math.min w-size, if Math.random() < 0.5 then x + size else x - size
          ny = Math.max 0, Math.min h-size, if Math.random() < 0.5 then y + size else y - size
          imageDataA = context.getImageData x, y, size, size
          imageDataB = context.getImageData nx, ny, size, size
          byte = 0
          colorDelta = 0
          skip = false
          while byte < imageDataA.data.length and not skip and y+size < h
            alphaByte = byte - (byte % 4) + 3
            alphaA = imageDataA.data[alphaByte]
            alphaB = imageDataB.data[alphaByte]
            if alphaA is 0 or alphaB is 0
              skip = true
            else if colorDelta > 12
              skip = true
            else if byte % 4 isnt 3
              x = Math.abs ((byte/4 |0) % size) - size/2 |0
              y = Math.abs ((byte/4 |0) / size) - size/2 |0
              if x + y < size/2
                colorDelta += Math.abs(imageDataA.data[byte] - imageDataB.data[byte]) / sizeSquared
                imageDataB.data[byte] = fn imageDataA.data[byte], imageDataB.data[byte]
            byte++
          if not skip and colorDelta > 2
            context.putImageData imageDataB, nx, ny
      
      window.addEventListener "resize", resize
      resize()
