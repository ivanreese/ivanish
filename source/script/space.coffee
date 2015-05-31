do ()->
  # RNG
  size = 256
  seed = 154871
  pool = [0...size]
  epsilon = Math.pow(2, -53)
  sizesquared = size * size
  s = t = 0
  
  swap = (i, j)->
    tmp = pool[i]
    pool[i] = pool[j]
    pool[j] = tmp
  
  do ()->
    j = 0
    for i in [0...size]
      j = (j + seed) % size
      swap(i, j)
  
  redraw = ()->
    # Setup & Locals
    canvas = document.querySelector "canvas.space"
    context = canvas.getContext "2d"
    w = canvas.width = window.innerWidth# * 2
    h = canvas.height = 100#200
    imageData = context.getImageData 0, 0, w, h
    buf = new ArrayBuffer imageData.data.length
    buf8 = new Uint8ClampedArray buf
    data = new Uint32Array buf
    r = b = g = 0
    a = 255
    
    T = performance.now()
    
    # Pass 1 — random purple noise and random white stars — loop over the array
    for y in [0...h]
      yy = y % size
      
      for x in [0...w]
        xx = x % size
        xy = (x + y) % size
        xxyy = (pool[xx] + pool[yy] + pool[xy]) % size
        r = pool[xxyy]
        b = pool[r]
        
        r = 40 + 10 * (r * r) / sizesquared
        b = 39 + 8 * (b * b) / sizesquared
        
        # r = t = s % 255
        # b = t = s % 255
        
        # r = r / size * 255 | 0
        # b = b / size * 255 | 0
        
        data[y * w + x] = a << 24 | b << 16 | g << 8 | r
    
    # Pass 2 — larger stars — random access into the array
    
    console.log performance.now() - T
    
    # Save
    imageData.data.set buf8
    context.putImageData imageData, 0, 0


  window.addEventListener "DOMContentLoaded", redraw
  window.addEventListener "resize", redraw
