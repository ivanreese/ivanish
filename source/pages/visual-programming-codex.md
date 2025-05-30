type: Project
time: 2018–Onwards

---

<style>
  #wiggle {
    margin: 0;
    z-index: -1;
  }
</style>

<div id="wiggle"></div>

! Visual Programming Codex

I've long been fond of visual programming languages. In my early years, I spent hours with HyperCard and HyperStudio, drag-and-drop game making tools, and various [3D graphics](/art/#3d) and VFX packages. At University, I took a class on Max/MSP and picked up Pure Data, then put those skills to use for a series of [sound art performances](/performance/#sound-art).

I work as a programmer, writing textual code. But I yearn for more visual approaches to programming. I'd love to work professionally in a spatial programming tool, with color and animation and icons to express meaning.

So I made a GitHub repo called the [Visual Programming Codex](http://github.com/ivanreese/visual-programming-codex) to collect all the beautiful and weird and inspiring and ancient approaches to programming that stretch beyond the confines of text.

It's been quite warmly received by the broader community, which is lovely.

Soon, I'm hoping to rebuild it as a proper microsite, since the repo format doesn't fit what I'd like this resource to become.

If you find it helpful, let me know! If you find something I haven't included, open an issue!

<script>
  var F2, F3, G2, G3, Grad, PI, TAU, clip, fade, grad3, gradP, lerp, p, perlin2, perlin3, perm, scale, seed, simplex2, simplex3;

  PI = Math.PI;

  TAU = PI * 2;

  clip = function(input, inputMin, inputMax) {
    if (inputMin == null) {
      inputMin = 0;
    }
    if (inputMax == null) {
      inputMax = 1;
    }
    return Math.min(inputMax, Math.max(inputMin, input));
  };

  scale = function(input, inputMin, inputMax, outputMin, outputMax, doClip) {
    if (inputMin == null) {
      inputMin = 0;
    }
    if (inputMax == null) {
      inputMax = 1;
    }
    if (outputMin == null) {
      outputMin = 0;
    }
    if (outputMax == null) {
      outputMax = 1;
    }
    if (doClip == null) {
      doClip = false;
    }
    if (inputMin === inputMax) {
      return outputMin;
    }
    if (doClip) {
      input = clip(input, inputMin, inputMax);
    }
    input -= inputMin;
    input /= inputMax - inputMin;
    input *= outputMax - outputMin;
    input += outputMin;
    return input;
  };

  lerp = function(a, b, t) {
    return (1 - t) * a + t * b;
  };

  Grad = function(x, y, z) {
    this.x = x;
    this.y = y;
    this.z = z;
  };

  fade = function(t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
  };

  lerp = function(a, b, t) {
    return (1 - t) * a + t * b;
  };

  Grad.prototype.dot2 = function(x, y) {
    return this.x * x + this.y * y;
  };

  Grad.prototype.dot3 = function(x, y, z) {
    return this.x * x + this.y * y + this.z * z;
  };

  grad3 = [new Grad(1, 1, 0), new Grad(-1, 1, 0), new Grad(1, -1, 0), new Grad(-1, -1, 0), new Grad(1, 0, 1), new Grad(-1, 0, 1), new Grad(1, 0, -1), new Grad(-1, 0, -1), new Grad(0, 1, 1), new Grad(0, -1, 1), new Grad(0, 1, -1), new Grad(0, -1, -1)];

  p = [151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180];

  perm = new Array(512);

  gradP = new Array(512);

  seed = function(seed) {
    var i, v;
    if (seed > 0 && seed < 1) {
      seed *= 65536;
    }
    seed = Math.floor(seed);
    if (seed < 256) {
      seed |= seed << 8;
    }
    i = 0;
    while (i < 256) {
      v = void 0;
      if (i & 1) {
        v = p[i] ^ seed & 255;
      } else {
        v = p[i] ^ seed >> 8 & 255;
      }
      perm[i] = perm[i + 256] = v;
      gradP[i] = gradP[i + 256] = grad3[v % 12];
      i++;
    }
  };

  seed(0);


  /*
  for(var i=0; i<256; i++) {
    perm[i] = perm[i + 256] = p[i];
    gradP[i] = gradP[i + 256] = grad3[perm[i] % 12];
  }
   */

  F2 = 0.5 * (Math.sqrt(3) - 1);

  G2 = (3 - Math.sqrt(3)) / 6;

  F3 = 1 / 3;

  G3 = 1 / 6;

  simplex2 = function(xin, yin) {
    var gi0, gi1, gi2, i, i1, j, j1, n0, n1, n2, s, t, t0, t1, t2, x0, x1, x2, y0, y1, y2;
    n0 = void 0;
    n1 = void 0;
    n2 = void 0;
    s = (xin + yin) * F2;
    i = Math.floor(xin + s);
    j = Math.floor(yin + s);
    t = (i + j) * G2;
    x0 = xin - i + t;
    y0 = yin - j + t;
    i1 = void 0;
    j1 = void 0;
    if (x0 > y0) {
      i1 = 1;
      j1 = 0;
    } else {
      i1 = 0;
      j1 = 1;
    }
    x1 = x0 - i1 + G2;
    y1 = y0 - j1 + G2;
    x2 = x0 - 1 + 2 * G2;
    y2 = y0 - 1 + 2 * G2;
    i &= 255;
    j &= 255;
    gi0 = gradP[i + perm[j]];
    gi1 = gradP[i + i1 + perm[j + j1]];
    gi2 = gradP[i + 1 + perm[j + 1]];
    t0 = 0.5 - (x0 * x0) - (y0 * y0);
    if (t0 < 0) {
      n0 = 0;
    } else {
      t0 *= t0;
      n0 = t0 * t0 * gi0.dot2(x0, y0);
    }
    t1 = 0.5 - (x1 * x1) - (y1 * y1);
    if (t1 < 0) {
      n1 = 0;
    } else {
      t1 *= t1;
      n1 = t1 * t1 * gi1.dot2(x1, y1);
    }
    t2 = 0.5 - (x2 * x2) - (y2 * y2);
    if (t2 < 0) {
      n2 = 0;
    } else {
      t2 *= t2;
      n2 = t2 * t2 * gi2.dot2(x2, y2);
    }
    return 70 * (n0 + n1 + n2);
  };

  simplex3 = function(xin, yin, zin) {
    var gi0, gi1, gi2, gi3, i, i1, i2, j, j1, j2, k, k1, k2, n0, n1, n2, n3, s, t, t0, t1, t2, t3, x0, x1, x2, x3, y0, y1, y2, y3, z0, z1, z2, z3;
    n0 = void 0;
    n1 = void 0;
    n2 = void 0;
    n3 = void 0;
    s = (xin + yin + zin) * F3;
    i = Math.floor(xin + s);
    j = Math.floor(yin + s);
    k = Math.floor(zin + s);
    t = (i + j + k) * G3;
    x0 = xin - i + t;
    y0 = yin - j + t;
    z0 = zin - k + t;
    i1 = void 0;
    j1 = void 0;
    k1 = void 0;
    i2 = void 0;
    j2 = void 0;
    k2 = void 0;
    if (x0 >= y0) {
      if (y0 >= z0) {
        i1 = 1;
        j1 = 0;
        k1 = 0;
        i2 = 1;
        j2 = 1;
        k2 = 0;
      } else if (x0 >= z0) {
        i1 = 1;
        j1 = 0;
        k1 = 0;
        i2 = 1;
        j2 = 0;
        k2 = 1;
      } else {
        i1 = 0;
        j1 = 0;
        k1 = 1;
        i2 = 1;
        j2 = 0;
        k2 = 1;
      }
    } else {
      if (y0 < z0) {
        i1 = 0;
        j1 = 0;
        k1 = 1;
        i2 = 0;
        j2 = 1;
        k2 = 1;
      } else if (x0 < z0) {
        i1 = 0;
        j1 = 1;
        k1 = 0;
        i2 = 0;
        j2 = 1;
        k2 = 1;
      } else {
        i1 = 0;
        j1 = 1;
        k1 = 0;
        i2 = 1;
        j2 = 1;
        k2 = 0;
      }
    }
    x1 = x0 - i1 + G3;
    y1 = y0 - j1 + G3;
    z1 = z0 - k1 + G3;
    x2 = x0 - i2 + 2 * G3;
    y2 = y0 - j2 + 2 * G3;
    z2 = z0 - k2 + 2 * G3;
    x3 = x0 - 1 + 3 * G3;
    y3 = y0 - 1 + 3 * G3;
    z3 = z0 - 1 + 3 * G3;
    i &= 255;
    j &= 255;
    k &= 255;
    gi0 = gradP[i + perm[j + perm[k]]];
    gi1 = gradP[i + i1 + perm[j + j1 + perm[k + k1]]];
    gi2 = gradP[i + i2 + perm[j + j2 + perm[k + k2]]];
    gi3 = gradP[i + 1 + perm[j + 1 + perm[k + 1]]];
    t0 = 0.6 - (x0 * x0) - (y0 * y0) - (z0 * z0);
    if (t0 < 0) {
      n0 = 0;
    } else {
      t0 *= t0;
      n0 = t0 * t0 * gi0.dot3(x0, y0, z0);
    }
    t1 = 0.6 - (x1 * x1) - (y1 * y1) - (z1 * z1);
    if (t1 < 0) {
      n1 = 0;
    } else {
      t1 *= t1;
      n1 = t1 * t1 * gi1.dot3(x1, y1, z1);
    }
    t2 = 0.6 - (x2 * x2) - (y2 * y2) - (z2 * z2);
    if (t2 < 0) {
      n2 = 0;
    } else {
      t2 *= t2;
      n2 = t2 * t2 * gi2.dot3(x2, y2, z2);
    }
    t3 = 0.6 - (x3 * x3) - (y3 * y3) - (z3 * z3);
    if (t3 < 0) {
      n3 = 0;
    } else {
      t3 *= t3;
      n3 = t3 * t3 * gi3.dot3(x3, y3, z3);
    }
    return 32 * (n0 + n1 + n2 + n3);
  };

  perlin2 = function(x, y) {
    var X, Y, n00, n01, n10, n11, u;
    X = Math.floor(x);
    Y = Math.floor(y);
    x = x - X;
    y = y - Y;
    X = X & 255;
    Y = Y & 255;
    n00 = gradP[X + perm[Y]].dot2(x, y);
    n01 = gradP[X + perm[Y + 1]].dot2(x, y - 1);
    n10 = gradP[X + 1 + perm[Y]].dot2(x - 1, y);
    n11 = gradP[X + 1 + perm[Y + 1]].dot2(x - 1, y - 1);
    u = fade(x);
    return lerp(lerp(n00, n10, u), lerp(n01, n11, u), fade(y));
  };

  perlin3 = function(x, y, z) {
    var X, Y, Z, n000, n001, n010, n011, n100, n101, n110, n111, u, v, w;
    X = Math.floor(x);
    Y = Math.floor(y);
    Z = Math.floor(z);
    x = x - X;
    y = y - Y;
    z = z - Z;
    X = X & 255;
    Y = Y & 255;
    Z = Z & 255;
    n000 = gradP[X + perm[Y + perm[Z]]].dot3(x, y, z);
    n001 = gradP[X + perm[Y + perm[Z + 1]]].dot3(x, y, z - 1);
    n010 = gradP[X + perm[Y + 1 + perm[Z]]].dot3(x, y - 1, z);
    n011 = gradP[X + perm[Y + 1 + perm[Z + 1]]].dot3(x, y - 1, z - 1);
    n100 = gradP[X + 1 + perm[Y + perm[Z]]].dot3(x - 1, y, z);
    n101 = gradP[X + 1 + perm[Y + perm[Z + 1]]].dot3(x - 1, y, z - 1);
    n110 = gradP[X + 1 + perm[Y + 1 + perm[Z]]].dot3(x - 1, y - 1, z);
    n111 = gradP[X + 1 + perm[Y + 1 + perm[Z + 1]]].dot3(x - 1, y - 1, z - 1);
    u = fade(x);
    v = fade(y);
    w = fade(z);
    return lerp(lerp(lerp(n000, n100, u), lerp(n001, n101, u), w), lerp(lerp(n010, n110, u), lerp(n011, n111, u), w), v);
  };

  var container = document.querySelector("#wiggle")
  var API, absolutePos, blurSamples, blurTime, count, dpr, granularity, height, l, len, makeSurface, memoizedNoise, name, noiseMemory, noiseRadius, phase, ref, render, renderMain, renderRequested, requestRender, requestResize, resize, running, surfaceNames, surfaces, width, x1, x2, y1, y2;
  surfaceNames = ["main", "blur"];
  dpr = 1;
  surfaces = {};
  width = 0;
  height = 0;
  running = false;
  renderRequested = false;
  count = 0;
  phase = 0;
  absolutePos = function(elm) {
    elm.style.position = "absolute";
    elm.style.top = elm.style.left = "0";
    return elm.style.width = elm.style.height = "100%";
  };
  makeSurface = function(name) {
    var canvas;
    canvas = document.createElement("canvas");
    container.appendChild(canvas);
    absolutePos(canvas);
    return surfaces[name] = {
      canvas: canvas,
      context: canvas.getContext("2d")
    };
  };
  resize = function() {
    var name, surface;
    width = container.offsetWidth * dpr;
    height = container.offsetHeight * dpr;
    for (name in surfaces) {
      surface = surfaces[name];
      surface.canvas.width = width;
      surface.canvas.height = height;
    }
    return null;
  };
  requestResize = function() {
    var heightChanged, widthChanged;
    widthChanged = 2 < Math.abs(width - container.offsetWidth * dpr);
    heightChanged = 50 < Math.abs(height - container.offsetHeight * dpr);
    if (widthChanged || heightChanged) {
      return requestAnimationFrame(function(time) {
        var first;
        first = true;
        resize();
        if (!renderRequested) {
          return render();
        }
      });
    }
  };
  requestRender = function() {
    if (!renderRequested) {
      renderRequested = true;
      return requestAnimationFrame(render);
    }
  };
  render = function(ms) {
    var t;
    t = ms / 1000;
    renderRequested = false;
    if (isNaN(ms)) {
      return requestRender();
    }
    if (running) {
      requestRender();
    }
    if (document.hidden) {
      return;
    }
    t /= 5;
    return renderMain(t);
  };
  noiseRadius = 0.5;
  x1 = function(t) {
    seed = 317;
    return 0.25 * width + width / 5 * memoizedNoise(seed + noiseRadius * Math.cos(TAU * t * .3), noiseRadius * Math.sin(TAU * t * .3));
  };
  y1 = function(t) {
    seed = 1697;
    return 0.1 * height + 200 + width / 8 * memoizedNoise(seed + noiseRadius * Math.cos(TAU * t * .3), noiseRadius * Math.sin(TAU * t * .3));
  };
  x2 = function(t) {
    seed = 1317;
    return 0.75 * width + width / 8 * memoizedNoise(seed + noiseRadius * Math.cos(TAU * t * .2), noiseRadius * Math.sin(TAU * t * .2));
  };
  y2 = function(t) {
    seed = 697;
    return 0.1 * height + 200 + width / 10 * memoizedNoise(seed + noiseRadius * Math.cos(TAU * t * .2), noiseRadius * Math.sin(TAU * t * .2));
  };
  blurTime = 1;
  blurSamples = 5;
  noiseMemory = [];
  granularity = 0.01;
  window.addEventListener("mousemove", function(e) {
    noiseMemory = [];
    granularity = Math.pow(10, scale(e.clientY, 0, height, -1, -2.5));
    blurSamples = scale(e.clientX, 0, width, 1, 10);
    return blurSamples = Math.floor(blurSamples * blurSamples);
  });
  memoizedNoise = function(x, y) {
    var s, smem, t, tmem;
    t = Math.round(x / granularity);
    s = Math.round(y / granularity);
    tmem = noiseMemory[t] != null ? noiseMemory[t] : noiseMemory[t] = [];
    return smem = tmem[s] != null ? tmem[s] : tmem[s] = simplex2(x, y);
  };
  renderMain = function(time, blur) {
    var alphaCurve, ctx, delay, frac, i, l, m, ref, ref1, results, steps, t, tFrac, x, y;
    ctx = surfaces.main.context;
    ctx.clearRect(0, 0, width, height);
    results = [];
    for (i = l = 0, ref = blurSamples; 0 <= ref ? l < ref : l > ref; i = 0 <= ref ? ++l : --l) {
      tFrac = i / blurSamples;
      t = time - tFrac * blurTime;
      alphaCurve = Math.cos(scale(i, 0, blurSamples, -PI, PI));
      ctx.globalAlpha = scale(alphaCurve, -1, 1, 0.1, .5);
      ctx.beginPath();
      ctx.strokeWidth = 2;
      ctx.strokeStyle = "hsl(311 100% 10%)";
      ctx.moveTo(x1(t), y1(t));
      steps = 100;
      delay = 3;
      for (i = m = 1, ref1 = steps; 1 <= ref1 ? m < ref1 : m > ref1; i = 1 <= ref1 ? ++m : --m) {
        frac = i / steps;
        x = lerp(x1(t - delay * frac), x2(t - delay * (1 - frac)), frac);
        y = lerp(y1(t - delay * frac), y2(t - delay * (1 - frac)), frac);
        ctx.lineTo(x, y);
      }
      results.push(ctx.stroke());
    }
    return results;
  };
  absolutePos(container);

  for (l = 0, len = surfaceNames.length; l < len; l++) {
    name = surfaceNames[l];
    makeSurface(name);
  }
  if ((ref = surfaces.blur) != null) {
    ref.canvas.style["-webkit-filter"] = "blur(20px)";
  }
  window.addEventListener("resize", requestResize);
  resize();
  running = !window.reduceMotion;
  render();
</script>
