TAU = Math.PI * 2
size = 4096 # Needs to be larger than any pixel width we want to draw, I think
seed = Math.random() * 999999 |0
time = Date.now()/1000
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
