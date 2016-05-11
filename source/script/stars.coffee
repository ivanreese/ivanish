do ()->
  debug = false
  
  window.addEventListener "resize", ready ()->
    canvases = document.querySelectorAll "canvas.js-stars"
    for canvas in canvases
      # Setup & Locals
      context = canvas.getContext "2d"
      width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2
      height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2
      
      # This lets us define things in terms of a "natural" display size — aka a biased vw
      wscale = width/3000
      
      # DRAW BACKGROUND
      # context.fillStyle = "white"
      context.fillStyle = "transparent"
      context.fillRect(0, 0, width, height)
      
      # DISTRIBUTION CHECK
      # context.fillStyle = "black"
      # for n, i in randTable
      #   context.fillRect(i/size * width, height - n/size * height, 2, 2)
      
      INNER = performance.now() if debug
      
      # Background Smudges
      # nBackgroundSmudges = width/20
      # for i in [0..nBackgroundSmudges]
      #   increase = i/nBackgroundSmudges # get bigger as i increases
      #   decrease = (1 - increase) # get smaller as i increases
      #   w = randTable[i % size]
      #   h = randTable[w]
      #   y = randTable[h]
      #   l = randTable[y]
      #   o = randTable[l]
      #   c = randTable[o]
      #   x = randTable[c]
      #   x = (x * width  / size - 20)|0
      #   y = (y * height / size - 20)|0
      #   w = w / size * 100 + 20
      #   h = h / size * 100 + 20
      #   l = l / size * 8 + 10
      #   o = o / size * Math.min(5 * decrease, 0.5)
      #   c = c / size * 40 + 280
      #   context.fillStyle = "hsla(#{c}, 30%, #{l}%, #{o})"
      #   context.fillRect(x, y, w, h)
      
      # Star Color
      nBigStars = width/100
      for i in [0..nBigStars]
        increase = i/nBigStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[i % size]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        c = randTable[l]
        o = randTable[c]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 3 + 1.5
        l = l / size * 20 + 20
        o = o / size * 10 * decrease + 0.3
        c = c / size * 120 + 200
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 40%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
      
      
      # Star Glow
      nBigStars = width/100
      for i in [0..nBigStars]
        x = randTable[i % size]
        y = randTable[x]
        r = randTable[y]
        sx = randTable[r]
        sy = randTable[sx]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 2 + 0.5
        sx = (sx / size * 2 - 0.5)
        sy = (sy / size * 2 - 0.5)
        context.beginPath()
        context.fillStyle = "hsla(0, 0%, 100%, 1)"
        context.arc(x + sx, y + sy, r, 0, TAU)
        context.fill()

      # Planets
      nBigStars = width/100
      for i in [0..nBigStars]
        increase = i/nBigStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[(i + 239) % size]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        c = randTable[l]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * wscale * 5 * decrease + 2
        l = l / size * 20 + 10
        c = (c / size * 180 + 200) % 360
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 50%, #{l}%, 0.5)"
        context.arc(x, y, r, 0, TAU)
        context.fill()
      
      
      # Big Blue Blobs
      nBlueBlobs = width/20
      for i in [0..nBlueBlobs]
        increase = i/nBlueBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[(i + 123) % size]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x / size * width)|0
        y = (y / size * height)|0
        r = r / size * 100 * wscale * decrease + 20
        s = l / size * 40 + 30
        l = l / size * 40 * decrease + 5
        h = h / size * 30 + 200
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.01)"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.009)"
        context.arc(x, y, r * 2, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.008)"
        context.arc(x, y, r * 3, 0, TAU)
        context.fill()
      
      # Small Blue Blobs
      nSmallBlueBlobs = width/30
      for i in [0..nSmallBlueBlobs]
        increase = i/nSmallBlueBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[(i + 473) % size]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x / size * width*2/3 + width/3)|0
        y = (y / size * height)|0
        r = r / size * 20 * wscale * decrease + 5
        s = l / size * 30 + 40
        l = l / size * 40 * decrease + 20
        h = h / size * 50 + 200
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.03)"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.02)"
        context.arc(x, y, r * 2, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, 0.01)"
        context.arc(x, y, r * 3, 0, TAU)
        context.fill()
      
      # Purple Blobs
      nPurpBlobs = width/20
      for i in [0..nPurpBlobs]
        increase = i/nPurpBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[(i + 1234) % size]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        o = randTable[l]
        x = (x / size * width*2/3 + width*1/6)|0
        y = (y / size * height*2/3 + height*1/6)|0
        r = r / size * 300 * wscale * decrease + 30
        l = l / size * 10 * increase + 9
        o = o / size * 0.03 * decrease + 0.03
        context.beginPath()
        context.fillStyle = "hsla(290, 100%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
      
      # Red Blobs
      nRedBlobs = width/20
      for i in [0..nRedBlobs]
        increase = i/nRedBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        o = randTable[(12345 + i) % size]
        x = randTable[o]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x / size * width)|0
        y = (y / size * height)|0
        r = r / size * 100 * wscale * decrease + 20
        l = l / size * 30 * decrease + 30
        o = o / size * 0.01 + 0.002
        h = h / size * 30 + 350
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o*3/4})"
        context.arc(x, y, r * 2, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o/2})"
        context.arc(x, y, r * 3, 0, TAU)
        context.fill()
      
      
      # Small Square Stars
      nBSmallSquareStars = width/10
      for i in [0..nBSmallSquareStars]
        y = randTable[(i + 234) % size]
        w = randTable[y]
        h = randTable[w]
        l = randTable[h]
        o = randTable[l]
        c = randTable[o]
        x = randTable[c]
        x = (x * width / size)|0
        y = (y * height / size)|0
        w = w / size * 2 + 1
        h = h / size * 2 + 1
        l = l / size * 30 + 10
        o = o / size * 0.5 + 0.2
        c = c / size * 40 + 240
        context.fillStyle = "hsla(#{c}, 30%, #{l}%, #{o})"
        context.fillRect(x, y, w, h)
      
      
      # Small Round Stars
      nSmallRoundStars = width/20
      for i in [0..nSmallRoundStars]
        r = randTable[(i + 345) % size]
        l = randTable[r]
        o = randTable[l]
        c = randTable[o]
        x = randTable[c]
        y = randTable[x]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 2 + 1
        l = l / size * 40 + 10
        o = o / size * 0.4 + 0.2
        c = c / size * 100 + 220
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 30%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
      
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 30%, #{l + 40}%, #{o * 2})"
        context.arc(x, y, 1, 0, TAU)
        context.fill()
      
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 70%, #{l*2/3}%, 0.1)"
        context.arc(x, y, r * r, 0, TAU)
        context.fill()
      
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 70%, #{l/2}%, 0.05)"
        context.arc(x, y, r * r * r, 0, TAU)
        context.fill()
      
      
      # Pixel Stars
      pixelStars = width/5
      for i in [0..pixelStars]
        x = randTable[(i + 5432) % size]
        y = randTable[x]
        o = randTable[y]
        x = (x * width / size)|0
        y = (y * height / size)|0
        o = o / size * 0.3 + 0.7
        context.beginPath()
        context.fillStyle = "hsla(300, 30%, 50%, #{o})"
        context.arc(x, y, 1, 0, TAU)
        context.fill()
      
    
    if debug
      console.log "STARS"
      console.log Math.ceil(performance.now() - INNER)
