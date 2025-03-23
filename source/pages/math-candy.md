main: js-stars-bw
type: Procedural Art
time: 2009

---

! Math Candy

<section>

<div class="hero">
  <object data="https://cdn.ivanish.ca/math-candy/ghosts-and.swf" wmode="direct" quality="high" menu="false" type="application/x-shockwave-flash">
    <div class="flash-fallback">
      <img src="https://cdn.ivanish.ca/math-candy/ghosts-and.jpg">
    </div>
  </object>
</div>

## Ghosts, And
A procedural art piece done in Flash back in the AS2 era. It's pretty rough — I was only just learning how to code.
Here's how I described it at the time:

<blockquote>
  There's less than 2k of data in this "animation" (1608 bytes).
  The shapes are based on sequences of prime numbers. It will never repeat itself, and the longer you watch it the more curiously it will behave. There are no ready-made drawings here, everything is generated on-the-spot by various mathematical formulae.
  The animation is rather smart, and will adjust the complexity of the drawing to make sure it runs at a reasonable speed on your computer. That said, it looks better on a faster computer. Just saying...
  There are 2 modes to this thing. I won't tell you how to switch modes, because the other mode is kinda dumb and I should have pulled it out. It's pretty easy to figure out.
</blockquote>

Adorable, innit.

</section>




<section>

<div class="hero">
  <object data="https://cdn.ivanish.ca/math-candy/stained-glass.swf" wmode="direct" quality="high" menu="false" type="application/x-shockwave-flash">
    <div class="flash-fallback">
      <img src="https://cdn.ivanish.ca/math-candy/stained-glass.jpg">
    </div>
  </object>
</div>

## Stained Glass
Another one.

</section>


<section>


## Eigenvectors

<div class="hero">
  <object data="https://cdn.ivanish.ca/math-candy/eigenvectors.swf" wmode="direct" quality="high" menu="false" type="application/x-shockwave-flash">
    <div class="flash-fallback">
      <img src="https://cdn.ivanish.ca/math-candy/eigenvectors.jpg">
    </div>
  </object>
</div>

This is the third (or fourth?) piece of "math candy" I made in a two month span in 2009. Better than all the others in my opinion. It started off as an attempt to recreate Kiri's facebook pfp, but then I decided to pursue a different angle.

Click to change modes:


1. Addition (Traditional)
1. Knitting Furiously (String Theory)
1. Aurora (Traditional)
1. Tapeworms (Figure Skating)
1. Sparks (Ting Noise)
1. Invert (Invert)
1. Spermatozoom (Har Har)
1. Tapeworms (Synchronized Swimming)

And if you're wondering what an Eigenvector is, it's a mathematical term that basically means "The more things change, the more they stay the same". Sorta.


</section>

<!--

Here's the AS2 code for Ghosts, And. I should rebuild this in JS.

var radius = getDist(Stage.width/2, Stage.height/2);
var spirals = 0;
var maxSpirals = 5.5;
var delay = 20;
var maxVel = 0.01;
var count = 0; reset = 1;
var turnRate = 0.1, maxTurnRate = 1;
var turnVel = 1, maxTurnVel = 2;
var uSegs = 360, uSegsRange = 360, uSegsMin = 360, uSegsPhase = 0, uSegsSpeed = 0.01;
var spread = 1, maxSpread = 91;
var steps = 1, maxSteps = 181;
var reps = 1, maxReps = 67;
var x, y, r, q;

var rPhase = 0; rRange = 100; rSpeed = 0.0043, rMin = 100;

var skipN = 3;

var clip = _root.createEmptyMovieClip("clip", 0);
clip._x = Stage.width/2;
clip._y = Stage.height/2;
var clip2 = _root.createEmptyMovieClip("clip2", 1);
clip2._x = Stage.width/2;
clip2._y = Stage.height/2;

var color = 0, alpha = 100;

var up_steps = true;
var up_reps = true;
var up_spread = true;
var up_turn = true;
var up_turnVel = true;

var smooth = false;

onMouseDown = function(){
smooth = !smooth;
color = 0;
alpha = 100;
}

var allowableFrameRate = 20;
var mspf = Math.round(1000/allowableFrameRate);
var cur = null, prev = null;

function keepFrameRate(){
cur = new Date();

if (prev != null){
var diff = cur.getTime() - prev.getTime();
if (diff > mspf) skipN += 0.05;
else skipN -= 0.05;
skipN = skipN > 10 ? 10 : skipN < 1 ? 1 : skipN;
}

prev = cur;
}

function onEnterFrame(){
keepFrameRate();

up_turnVel = turnVel > maxTurnVel ? false : turnVel < 2 ? true : up_turnVel;
turnVel = up_turnVel ? turnVel+turnVel/100: turnVel-turnVel/100;

up_turn = turnRate > maxSpread ? false : turnRate < 2 ? true : up_turn;
turnRate = up_turn ? turnRate += 0.02 : turnRate -= 0.02;
clip2._rotation = clip._rotation = clip._rotation + Math.sin(turnRate) * turnVel;

spirals += Math.min(maxVel, (maxSpirals - spirals)/delay);

up_steps = steps > maxSteps ? false : steps < 2 ? true : up_steps;
steps = up_steps ? steps+steps/10: steps-steps/10;

maxReps = reps > maxReps ? maxReps + 20 : maxReps;
up_reps = reps > maxReps ? false : reps < 2 ? true : up_reps;
reps = up_reps ? reps+reps/10 : reps-reps/10;

up_spread = spread > maxSpread ? false : spread < 2 ? true : up_spread;
spread = up_spread ? spread+spread/10 : spread-spread/10;

uSegsPhase += uSegsSpeed;
uSegs = uSegsMin + Math.sin(uSegsPhase*Math.PI) * uSegsRange;
if (smooth) steps = Math.ceil(steps/2)*2;

rPhase += rSpeed;
q = r = rMin + Math.sin(rPhase*Math.PI) * rRange;
x = Math.cos(toRad(0)) * r;
y = Math.sin(toRad(0)) * r;

if (smooth && count++ > reset) {
count = 0;
color = 0xFFFFFF * Math.random();
}
alpha = 100 - 90 * Math.sin(uSegsPhase*Math.PI);
clip.clear();
clip2.clear();
clip.lineStyle(thicky(x, y), color, alpha);
clip2.lineStyle(thicky(x, y), color, alpha);

clip.moveTo(x, y);
clip2.moveTo(-x, -y);
var i;
for (var j = 1; j <= spirals * uSegs; j+=skipN){
i = Math.floor(j);
calculateR(i);
r = r * i/(spirals * uSegs);
r = Math.max(r, q);
x = Math.cos(toRad(i)) * r;
y = Math.sin(toRad(i)) * r;
clip.lineStyle(thicky(x, y), color, alpha);
clip2.lineStyle(thicky(x, y), color, alpha);
clip.lineTo(x, y);
clip2.lineTo(-x, -y);
}
}

function toRad(i){
return i * Math.PI / 180;
}

function thicky(x, y){
var a = Math.atan2(y, x);
var b = Math.atan2(-y, x);
a = Math.abs(a - b);
a = 180 * a / Math.PI;
a = a / 10;
return a;
}

function calculateR(i){
r = Math.sin(toRad(i*reps));
r = Math.pow(r, Math.round(steps));
r = radius + r * spread;
}

function getDist(a, b){
var dist = 0;
dist = a * a + b * b;
dist = Math.sqrt(dist);
return dist;
}

-->

<style>
  body { background: #d8ded5; }
  object, ruffle-object {
    width: 100%;
    height: auto;
    aspect-ratio: 1;
  }
</style>


<script src="https://cdn.ivanish.ca/assets/ruffle/ruffle.js"></script>
<script>
  window.RufflePlayer = window.RufflePlayer || {};
  window.RufflePlayer.config = {
      "autoplay": "on",
      "contextMenu": "off",
      "frameRate": 60,
      "letterbox": "off",
      "menu": false,
      "quality": "low",
      "scale": "noscale",
      "splashScreen": true,
      "unmuteOverlay": "hidden",
      "warnOnUnsupportedContent": false,
      "wmode": "transparent"
  };
</script>
