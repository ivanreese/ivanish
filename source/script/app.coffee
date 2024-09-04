@TAU = Math.PI * 2

@mod = (input, max)->
  (input % max + max) % max

@clip = (input, inputMin = 0, inputMax = 1)->
  Math.min inputMax, Math.max inputMin, input

@randInt = (low, high)->
  Math.round Math.random() * (high - low) + low

@scale = (input, inputMin = 0, inputMax = 1, outputMin = 0, outputMax = 1, doClip = false)->
  return outputMin if inputMin is inputMax # Avoids a divide by zero
  input = clip(input, inputMin, inputMax) if doClip
  input -= inputMin
  input /= inputMax - inputMin
  input *= outputMax - outputMin
  input += outputMin
  return input

window.reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches
