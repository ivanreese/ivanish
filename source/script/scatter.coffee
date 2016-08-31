ready ()->
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
        ph = pw = 50 + Math.random() * 100 |0
        # ph = 1 + Math.random() * 20 |0
        
        fn = if count%2 is 0 then Math.min else Math.max
        
        for i in [0..10]
          x = Math.random() * (w-pw) |0
          y = Math.random() * (h-ph) |0
          nx = Math.max 0, Math.min w-pw, if Math.random() < 0.5 then x + pw else x - pw
          ny = Math.max 0, Math.min h-ph, if Math.random() < 0.5 then y + ph else y - ph
          imageDataA = context.getImageData x, y, pw, ph
          imageDataB = context.getImageData nx, ny, pw, ph
          j = 0
          delta = 0
          power = 0
          bail = false
          while j < imageDataA.data.length
            if imageDataA.data[j-(j%4)+3] is 0 or imageDataB.data[j-(j%4)+3] is 0
              bail = true
              break
            if j % 4 isnt 3
              x = Math.abs ((j/4 |0) % pw) - pw/2 |0
              y = Math.abs ((j/4 |0) / pw) - ph/2 |0
              if x + y < pw/2
                delta += Math.abs imageDataA.data[j] - imageDataB.data[j]
                imageDataB.data[j] = fn imageDataA.data[j], imageDataB.data[j]
                power += imageDataB.data[j]
            j++
          if not bail and delta < 10 * pw * ph and power > 0.2 * pw * ph * 255 * 4
            context.putImageData imageDataB, nx, ny
        
      window.addEventListener "resize", resize
      resize()
