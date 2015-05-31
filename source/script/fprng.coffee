# Fast Pseudo-Random Number Generator
# This trades a bit of randomness for the sake of speed.
# You should use a 3 or 4 digit prime for size, and a big prime for seed.
# That way, the base frequency will be relatively high, but it'll still run quickly. I think.


do ()->
  pool = null
  size = seed = a = b = 0
  
  swap = (i, j)->
    tmp = pool[i]
    pool[i] = pool[j]
    pool[j] = tmp
  
  window.FPRNG =
    init: (_size, _seed)->
      size = _size
      seed = _seed
      pool = [0...size]
      j = 0
      for i in [0...size]
        j = (j + seed) % size
        swap(i, j)
    
    next: ()->
      a = (a + 1) % size
      b = (b + pool[a]) % seed
      return pool[(a + b) % size] / size
      # return pool[(a + b + pool[b % size]) % size] / size
