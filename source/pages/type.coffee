ready ()->
  for canvas in document.querySelectorAll "canvas.js-scatter"
    context = canvas.getContext "2d"
    above = document.querySelector ".above"
    inner = document.querySelector ".inner"
    
    img = new Image()
    img.src = "/assets/type.png"
    img.onload = ()->
      w = 0
      h = 0
      iw = 0
      ih = 0
      pad = 0
      top = 0
      bottom = 0
      count = 0
      
      resize = ()->
        if window.innerWidth isnt w
          w = canvas.width = window.innerWidth
          frac = w / img.width
          iw = img.width * frac
          ih = img.height * frac
          # This adjusts where we draw to match the responsive layout of .inner — it's just guess-and-check
          pad = iw * .13 - 200
          top = inner.clientHeight - pad
          h = canvas.height = Math.max ih + top, window.innerHeight
          top = Math.max top, h - ih
          bottom = ih/3
          above.style.height = ih + "px"
          context.fillStyle = "white"
          context.fillRect(0, 0, w, h)
          context.drawImage img, 0, top, iw, ih
      
      requestAnimationFrame update = (time)->
        requestAnimationFrame update
        count++
        
        # Our size will be no smaller than 1/8th of the width of the image
        # Our size will scale proportionally to the size of the image
        # Our size will vary between 2^0 and 2^9, plus 2
        size = Math.min(iw/8, (w/1500) * Math.pow(2, Math.random() * 9) + 4) |0
        sizeSquared = size * size
        bottom = Math.min h*2/3, bottom + 0.1
        fn = if count%3 is 0 then Math.max else Math.min
        tries = 0
        
        while tries++ < 3
          x = Math.random() * (w-size) |0
          y = Math.min h-size, -pad + size + top + Math.random() * bottom |0
          nx = Math.max 0, Math.min w-size, if Math.random() < 0.5 then x + size else x - size
          ny = Math.max 0, Math.min h-size, if Math.random() < 0.5 then y + size else y - size
          imageDataA = context.getImageData x, y, size, size
          imageDataB = context.getImageData nx, ny, size, size
          byte = 0
          colorDelta = 0
          skip = false
          while byte < imageDataA.data.length and not skip
            alphaByte = byte - (byte % 4) + 3
            alphaA = imageDataA.data[alphaByte]
            alphaB = imageDataB.data[alphaByte]
            if alphaA is 0 or alphaB is 0
              skip = true
            else if colorDelta > 12
              skip = true
            else if byte % 4 isnt 3
              px = Math.abs(((byte/4 |0) % size) - size/2)|0
              py = Math.abs(((byte/4 |0) / size) - size/2)|0
              if px + py < size/2
                colorDelta += Math.abs(imageDataA.data[byte] - imageDataB.data[byte]) / sizeSquared
                imageDataB.data[byte] = fn imageDataA.data[byte], imageDataB.data[byte]
            byte++
          if not skip and colorDelta > 2
            context.putImageData imageDataB, nx, ny
      
      window.addEventListener "resize", resize
      resize()
