
do ()->
  # OUTER = performance.now()
  TAU = Math.PI * 2
  size = 4096
  seed = (Math.random() * 754869)|0
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
      width = canvas.width = window.innerWidth * 2
      height = canvas.height = parseInt(window.getComputedStyle(canvas).height) * 2
      
      # DRAW BACKGROUND
      # context.fillStyle = "white"
      context.fillStyle = "#2C0028"
      context.fillRect(0, 0, width, height)
      
      # DISTRIBUTION CHECK
      # context.fillStyle = "black"
      # for n, i in randTable
      #   context.fillRect(i/size * width, height - n/size * height, 2, 2)
      
      # T = performance.now()
      
      # Background Smudges
      nBackgroundSmudges = width/20
      for i in [0..nBackgroundSmudges]
        increase = i/nBackgroundSmudges # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        w = randTable[i % size]
        h = randTable[w]
        y = randTable[h]
        l = randTable[y]
        o = randTable[l]
        c = randTable[o]
        x = randTable[c]
        x = (x * width  / size - 20)|0
        y = (y * height / size - 20)|0
        w = w / size * 100 + 20
        h = h / size * 100 + 20
        l = l / size * 8 + 10
        o = o / size * Math.min(5 * decrease, 0.5)
        c = c / size * 40 + 280
        context.fillStyle = "hsla(#{c}, 30%, #{l}%, #{o})"
        context.fillRect(x, y, w, h)
      
      # Small Square Stars
      nBSmallSquareStars = width/10
      for i in [0..nBSmallSquareStars]
        increase = i/nBSmallSquareStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        y = randTable[i % size]
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
        l = l / size * 30 + 30
        o = o / size * 10 * decrease
        c = c / size * 60 + 260
        context.fillStyle = "hsla(#{c}, 40%, #{l}%, #{o})"
        context.fillRect(x, y, w, h)
        
      # Big Stars
      nBigStars = width/100
      for i in [0..nBigStars]
        increase = i/nBigStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        l = randTable[i % size]
        o = randTable[l]
        c = randTable[o]
        x = randTable[c]
        y = randTable[x]
        r = randTable[y]
        sx = randTable[r]
        sy = randTable[sx]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 3 + 1
        l = l / size * 20 + 80
        o = o / size * Math.min(10 * decrease, 0.7) + 0.3
        c = c / size * 120 + 200
        sx = (sx / size * 2 - 1) * Math.abs(r)
        sy = (sy / size * 2 - 1) * Math.abs(r)
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 40%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        if randTable[i % size] > size/2
          context.beginPath()
          context.fillStyle = "hsla(0, 0%, 100%, #{o * 4})"
          context.arc(x + sx, y + sy, 2, 0, TAU)
          context.fill()
      
      # Planets
      nColorStars = width/500
      for i in [0..nColorStars]
        increase = i/nColorStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        o = randTable[i % size]
        c = randTable[o]
        x = randTable[c]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 6 * decrease + 1
        l = l / size * 50 + 50
        o = o / size * 10 * decrease
        c = c / size * 360
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 100%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
      
      # Blue Blobs
      nBlueBlobs = width/20
      for i in [0..nBlueBlobs]
        increase = i/nBlueBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        o = randTable[i % size]
        x = randTable[o]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 40 * decrease + 4
        l = l / size * 40 * decrease
        o = o / size * 0.3 * increase + 0.05
        h = h / size * 20 + 260
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
      
      # Purple Blobs
      nPurpBlobs = width/20
      for i in [0..nPurpBlobs]
        increase = i/nPurpBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        x = randTable[i % size]
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
      nBlueBlobs = width/50
      for i in [0..nBlueBlobs]
        increase = i/nBlueBlobs # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        o = randTable[i % size]
        x = randTable[o]
        y = randTable[x]
        r = randTable[y]
        l = randTable[r]
        h = randTable[l]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 10 * decrease + 4
        l = l / size * 50 * decrease
        o = o / size * 0.3 * increase + 0.05
        h = h / size * 30 + 320
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

      # Small Round Stars
      nSmallRoundStars = width/2
      for i in [0..nSmallRoundStars]
        increase = i/nSmallRoundStars # get bigger as i increases
        decrease = (1 - increase) # get smaller as i increases
        r = randTable[i % size]
        l = randTable[r]
        o = randTable[l]
        c = randTable[o]
        x = randTable[c]
        y = randTable[x]
        x = (x * width / size)|0
        y = (y * height / size)|0
        r = r / size * 2 + 0.5
        l = l / size * 50 + 30
        o = o / size * 10 * decrease
        c = c / size * 20 + 280
        context.beginPath()
        context.fillStyle = "hsla(#{c}, 30%, #{l}%, #{o})"
        context.arc(x, y, r, 0, TAU)
        context.fill()
        if r > 2
          context.beginPath()
          context.fillStyle = "hsla(#{c}, 10%, #{l + 20}%, #{o * 2})"
          context.arc(x, y, 1, 0, TAU)
          context.fill()
      
          context.beginPath()
          context.fillStyle = "hsla(#{265}, 70%, #{l*2/3}%, 0.1)"
          context.arc(x, y, r * r, 0, TAU)
          context.fill()
      
          context.beginPath()
          context.fillStyle = "hsla(#{265}, 70%, #{l/2}%, 0.05)"
          context.arc(x, y, r * r * r, 0, TAU)
          context.fill()
    
    
    # INNER = performance.now() - T
    # console.log Math.ceil(performance.now() - T), Math.ceil(INNER)

  window.addEventListener "DOMContentLoaded", redraw
  window.addEventListener "resize", redraw
