do ()->
  debug = false
  
  OUTER = performance.now() if debug
  TAU = Math.PI * 2
  size = 4096
  half_size = size/2
  seed = 754874
  randTable = [0...size]
  
  swap = (i, j, p)->
    tmp = p[i]
    p[i] = p[j]
    p[j] = tmp
  
  # Initialize the randomness table
  do ()->
    j = 0
    for i in [0...size]
      j = (j + seed + randTable[i]) % size
      swap(i, j, randTable)
  
  redraw = ()->
    canvases = document.querySelectorAll "canvas"
    for canvas in canvases
      # Setup & Locals
      context = canvas.getContext "2d"
      width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2
      height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2
      
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
      

      # Big Star Color
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
        r = r / size * 3 + 1
        l = l / size * 20 + 20
        o = o / size * 10 * decrease + 0.3
        c = c / size * 120 + 200
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 40%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()


      # Big Star Glow
      nBigStars = width/200
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

      
      # Blue Blobs
      nBlueBlobs = width/20
      for i in [0..nBlueBlobs]
        increase = i/nBlueBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        o = randTable[(i + 123) % size]
        x = randTable[o]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 40 * decrease + 4
        s = l / size * 50 + 30
        l = l / size * 20 * decrease + 10
        o = o / size * 0.3 * increase + 0.05
        h = h / size * 20 + 260
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, #{o/2})"
        context.arc(x, y, r * 2, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, #{o/4})"
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
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 200 * decrease + 2
        l = l / size * 12 * increase + 7
        o = o / size * 0.1 * decrease + 0.01
        context.beginPath()
        context.fillStyle = "hsla(290, 100%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
      
      # Red Blobs
      nRedBlobs = width/50
      for i in [0..nRedBlobs]
        increase = i/nRedBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        o = randTable[(12345 + i) % size]
        x = randTable[o]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 10 * decrease + 20
        l = l / size * 20 * decrease + 5
        o = o / size * 0.3 * increase + 0.05
        h = h / size * 30 + 350
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o/2})"
        context.arc(x, y, r * 2, 0, TAU)
        context.fill()
        context.beginPath()
        context.fillStyle = "hsla(#{h}, 100%, #{l}%, #{o/4})"
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
      pixelStars = width/6
      for i in [0..pixelStars]
        x = randTable[(i + 5432) % size]
        y = randTable[x]
        o = randTable[y]
        x = (x * width / size)|0
        y = (y * height / size)|0
        o = o / size * 0.6 + 0.4
        context.beginPath()
        context.fillStyle = "hsla(300, 30%, 50%, #{o})"
        # context.arc(x, y, 1, 0, TAU)
        context.fillRect(x, y, 1, 1)
        context.fill()
        
    
    if debug
      console.log Math.ceil(performance.now() - INNER), Math.ceil(performance.now() - OUTER)
  
  ready(redraw)
  window.addEventListener "resize", redraw
