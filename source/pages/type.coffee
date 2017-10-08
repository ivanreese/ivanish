ready ()->
  for canvas in document.querySelectorAll "canvas.js-scatter"
    context = canvas.getContext "2d"
    
    above = document.querySelector ".above" # The layer above the canvas, used for course-grained positioning
    inner = document.querySelector ".inner" # A layer inside .above, used for fine-grained positioning, which contains page content HTML
    
    img = new Image()
    img.src = "/assets/type.png"
    img.onload = ()->
      w = 0 # Width of the window
      h = 0 # Height of the window, which will be expanded as necessary to fit the image
      ih = 0 # The height of the image
      iTop = 0 # The y position of the top of the image within the canvas
      iUpper = 0 # The proportion of the image above the tip of the wing
      lowerLimit = 0 # The lowest point we should be drawing into — gradually moves down
      wScale = 0 # Global scaling factor based on image size
      count = 0 # Used with mod to switch comparison functions
      
      resize = (force)-> (e)->
        if force or window.innerWidth isnt w # Only resize when the width changes — improves UX on mobile, because the height changes during scroll
          w = canvas.width = window.innerWidth
          ih = img.height * (w / img.width) # Set the image height based on the window width
          iUpper = w * .13
          iTop = Math.max 0, above.clientHeight - iUpper
          h = canvas.height = Math.max ih + iTop, window.innerHeight # Size the canvas to fit the image height, which expands the window height as necessary
          iTop = Math.max iTop, h - ih # If needed, draw the image lower so it's bottom-aligned with the window
          lowerLimit = ih/4
          wScale = w/1500
          # above.style.height = ih + "px" # Not sure why we need this??
          # context.fillStyle = "white"
          # context.fillRect(0, 0, w, h) # We need to fill the upper part with white, or else we won't have enough
          context.drawImage img, 0, iTop, w, ih
      
      requestAnimationFrame update = (time)->
        requestAnimationFrame update
        count++
        
        # Our size will be no smaller than 1/8th of the width of the image
        # Our size will scale proportionally to the size of the image
        # Our unscaled size will vary between 2^0 and 2^9, plus 8
        size = 8 + wScale * Math.pow(2, Math.random() * 9) |0
        halfSize = size/2
        sizeSquared = size * size
        lowerLimit = Math.min ih*1/2, lowerLimit + 0.1 * wScale
        fn = if count%3 is 0 then Math.max else Math.min # Bias towards darker colors
        reps = 0
        done = false
        
        while ++reps <= 20 and not done
          x = Math.random() * (w-size) |0
          y = Math.min h-size, iUpper + iTop + Math.random() * lowerLimit |0
          nx = Math.max 0, Math.min w-size, if Math.random() < 0.5 then x + size else x - size
          ny = Math.max iTop, Math.min h-size, if Math.random() < 0.5 then y + size else y - size
          imageDataA = context.getImageData x, y, size, size # Source sample
          imageDataB = context.getImageData nx, ny, size, size # Destination sample
          byte = 0
          colorDelta = 0
          skip = false
          while byte < imageDataA.data.length and not skip # Loop over each byte of each pixel of the source sample
            alphaByte = byte - (byte % 4) + 3 # Grab the byte in the alpha channel for the current pixel
            alphaA = imageDataA.data[alphaByte]
            alphaB = imageDataB.data[alphaByte]
            if alphaA is 0 or alphaB is 0 # If there's ANY transparency, bail
              skip = true
            else if colorDelta > 13 # Keep things subtle
              skip = true
            else if byte isnt alphaByte # Skip the alpha channel
              px = Math.abs(((byte/4 |0) % size) - halfSize)|0
              py = Math.abs(((byte/4 |0) / size) - halfSize)|0
              if px + py < halfSize # This creates the diamond shape
                byteA = imageDataA.data[byte]
                byteB = imageDataB.data[byte]
                colorDelta += Math.abs(byteA - byteB) / sizeSquared
                imageDataB.data[byte] = fn(byteA, byteB) / 0.99 |0 # Apply the fn, then bias towards darker colors
            byte++
            null
          if not skip and colorDelta > 3 # Don't bother drawing if it won't make much visible difference
            context.putImageData imageDataB, nx, ny
            done = true
          null
      
      window.addEventListener "resize", resize false
      resize(false)()
      requestAnimationFrame resize true # This fixes a rendering glitch, probably caused by this code running before styles are finished
