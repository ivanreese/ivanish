# Oh Hi!
# I wrote this code in 2014.
# Boy, I've learned a lot since then.

TAU = 2*Math.PI
DEG = 180/Math.PI

Array.prototype.sum = ()-> if this.length is 0 then 0 else this.reduce (a, b)-> a+b
Array.prototype.average = ()-> if this.length is 0 then 0 else this.sum() / this.length

# Map an array with a function that takes each element and the following
Array.prototype.mapPairs = (cb)->
	return [] unless this.length > 1
	values = []
	this.reduce (a, b)->
		values.push cb a, b
		b
	values

@Angle =
	wrap: (angle, bias)->
		while bias - angle > +Math.PI then angle += TAU
		while bias - angle < -Math.PI then angle -= TAU
		angle

@Vec =
	diff: (a, b)->
		x: b.x - a.x
		y: b.y - a.y

	angle: (a, b)->
		p = Vec.diff a, b
		Math.atan2 p.y, p.x

	hypot: ({x, y})-> Math.hypot x, y
	distance: (a, b)-> Vec.hypot Vec.diff a, b
	pathLength: (arr)-> arr.mapPairs(Vec.distance).sum()

	lerp: (a, b, t)->
		t = Math.max 0, Math.min 1, t
		x: a.x * (1-t) + b.x * t
		y: a.y * (1-t) + b.y * t

newPoint = ()-> x: 0, y: 0, a: 0

start = 				newPoint()
last = 					newPoint()
current = 			newPoint()
center = 				newPoint()
recentCenter = 	newPoint()
accumulated = 	newPoint()
recentMin = 		newPoint()
recentMax =			newPoint()
recentSize = 		newPoint()
activeCenter = 	newPoint()
usage = 				newPoint()
delta = 				newPoint()

centerTransitionTime = 100
recentAngleBasis = 0
recent = [{x:0, y:0}]
dragging = false
computedValue = 0
squareness = 0
time = 0
hud =
	left: 30
	labelLeft: 60
	top: 40
	space: 50
	pos: 0
	nextPos: ()-> hud.pos++
	resetPos: ()-> hud.pos = 0
canvas = null
g = null

# BEGIN
requestAnimationFrame ()->
	canvas = document.querySelector "canvas#good-knob"
	g = canvas.getContext "2d"
	resize()

# RESIZE
resize = ()->
	dpr = window.devicePixelRatio
	canvas.width = window.innerWidth   * dpr
	canvas.height = window.innerHeight * dpr
	g.scale dpr, dpr
	center =
		x:window.innerWidth/2
		y:window.innerHeight/2
	draw()
window.onresize = resize

# LOGIC
update = (p)->
	return unless Vec.distance(p, last) > 0
	current = p

	recent.unshift(current)
	recent.pop() while Vec.pathLength(recent) > 2*TAU * Vec.distance(activeCenter, current) and recent.length > 2

	recentMin = recent.reduce (a, b)-> { x: Math.min(a.x, b.x), y: Math.min(a.y, b.y) }
	recentMax = recent.reduce (a, b)-> { x: Math.max(a.x, b.x), y: Math.max(a.y, b.y) }
	recentSize = Vec.diff(recentMin, recentMax)
	recentCenter =
		x: (recentMin.x + recentMax.x)/2
		y: (recentMin.y + recentMax.y)/2

	time++
	activeCenter = Vec.lerp(center, recentCenter, time/centerTransitionTime)

	delta =
		x: (current.x - start.x)
		y: (current.y - start.y)
		a: angleToActiveCenter(current)

	accumulated.x += current.x - last.x
	accumulated.y += current.y - last.y
	accumulated.a += Angle.wrap(current.a - last.a, 0)

	computedValue += computedValueIncrement()

	squareness = computeSquareness(recentSize)

	last = current

	draw()

computedValueIncrement = ()->
	# If usage.x and usage.y are both 0, then useAngularInput will be unfairly biased toward true.
	# This can happen even when dragging straight if you get 1 usage.a right off the bat.
	# So, cardinal bias gives us some "free" initial x/y usage.
	cardinalBias = 10

	preferAngularInput = usage.a > (cardinalBias + usage.x + usage.y) * 2

	useAngularInput = squareness > 0 or preferAngularInput

	if useAngularInput
		usage.a++
		Angle.wrap(current.a - last.a, 0) / TAU
	else if recentSize.x > recentSize.y
		usage.x++
		(current.x - last.x) / (TAU * 20)
	else
		usage.y++
		-(current.y - last.y) / (TAU * 20)


# EVENTS

window.onpointerdown = (e)->
	dragging = true
	time = 0
	recent = []
	usage = newPoint()
	activeCenter = center
	start = last = computePosition(e.pageX, e.pageY)

window.onpointerup = (e)->
	dragging = false

window.onpointermove = (e)->
	if dragging
		update(computePosition(e.pageX, e.pageY))


# MMMMMMMATH

angleToActiveCenter = (p)->
	d = Vec.diff(activeCenter, p)
	Math.atan2(d.y, d.x)

computePosition = (x, y)->
	p = {x:x, y:y}
	p.a = angleToActiveCenter(p)
	p

computeSquareness = (vec)->
	1-Math.abs(Math.log(vec.x/vec.y))


# DRAWING
prepareToDraw = ()->
	hud.resetPos()
	g.clearRect(0,0,canvas.width,canvas.height)
	g.font = "20px sans-serif"
	g.beginPath()

drawPoint = (p, style, size = 5)->
	g.beginPath()
	g.fillStyle = style
	g.arc(p.x, p.y, size, 0, TAU)
	g.fill()

drawRecent = ()->
	g.beginPath()
	g.strokeStyle = "#FFF"
	g.moveTo(current.x, current.y)
	g.lineTo(p.x,p.y) for p in recent
	g.stroke()

drawRecentBounds = ()->
	g.beginPath()
	g.strokeStyle = "#F00"
	g.strokeRect(recentMin.x, recentMin.y, recentSize.x, recentSize.y)

drawRecentAngle = ()->
	g.beginPath()
	g.strokeStyle = "#07F"

	angle = recent.mapPairs(Vec.angle).map((ang)-> Angle.wrap(ang, recentAngleBasis)).average()
	recentAngleBasis = angle # save for the future

	sx = current.x
	sy = current.y
	dx = sx + Math.cos(angle) * 50
	dy = sy + Math.sin(angle) * 50
	g.moveTo(sx, sy)
	g.lineTo(dx, dy)
	g.stroke()

drawComputedValue = ()->
	angle = computedValue * TAU
	loops = Math.floor(Math.abs(angle) / TAU)
	isNeg = angle < 0

	g.fillStyle = if isNeg then "rgba(255,0,0,0.2)" else "rgba(0,0,255,0.2)"

	r = 20

	for i in [0..loops]
		g.beginPath()
		g.arc(center.x, center.y, r * i, 0, TAU)
		g.lineTo(center.x, center.y)
		g.fill()

	offset = -TAU/4
	angle %= TAU

	g.beginPath()
	g.arc(center.x, center.y, r * (loops+1), offset, angle+offset, isNeg)
	g.lineTo(center.x, center.y)
	g.fill()

hudValue = (value, label)->
	pos = hud.nextPos()
	g.fillStyle = "#F70"
	g.fillText(Math.round(value*100)/100, hud.left - 20, hud.top + hud.space * pos)
	g.fillStyle = "#FFF"
	g.fillText(label, hud.left + hud.labelLeft, hud.top + hud.space * pos)

hudPoint = (point, label, aScale = 1)->
	hudValue(point.x, "X " + label)
	hudValue(point.y, "Y " + label)
	hudValue(point.a * aScale, "A " + label)

draw = ()->
	prepareToDraw()

	drawPoint(center, "#fff")
	drawComputedValue()

	# drawPoint(start, "#F70")
	# drawPoint(activeCenter, "#F00", 2)
	# drawRecent()
	# drawRecentBounds()

	# hudValue(computedValue, "Computed Value")
	# hudValue(squareness, "Squareness")
	# hudPoint(accumulated, "Accumulated", DEG)
	# hudPoint(usage, "Usage")
	# hudPoint(delta, "Delta", DEG)
