(function() {
  var TAU, bioShift, measurePerf, renderBio, renderStars;

  measurePerf = false;

  if (measurePerf) {
    console.log("Performance --------------------");
  }

  TAU = Math.PI * 2;

  (function() {
    var determinstic, i, j, k, m, perfStart, ref, results, seed, swap;
    determinstic = false;
    seed = determinstic ? 2147483647 : Math.random() * 2147483647 | 0;
    window.randTableSize = 4096;
    swap = function(i, j, p) {
      var tmp;
      tmp = p[i];
      p[i] = p[j];
      return p[j] = tmp;
    };
    if (measurePerf) {
      perfStart = performance.now();
    }
    window.randTable = (function() {
      results = [];
      for (var k = 0; 0 <= randTableSize ? k < randTableSize : k > randTableSize; 0 <= randTableSize ? k++ : k--){ results.push(k); }
      return results;
    }).apply(this);
    j = 0;
    for (i = m = 0, ref = randTableSize; 0 <= ref ? m < ref : m > ref; i = 0 <= ref ? ++m : --m) {
      j = (j + seed + randTable[i]) % randTableSize;
      swap(i, j, randTable);
    }
    if (measurePerf) {
      return console.log((performance.now() - perfStart).toPrecision(4) + "  Table");
    }
  })();

  bioShift = Math.random();

  renderBio = function(canvases) {
    var a, c, canvas, context, d, decrease, height, i, increase, k, l, len, m, nBlobs, perfStart, r, ref, t, time, width, x, y;
    time = Date.now() / 1000;
    t = Math.sin(time / 7) / 2 + 0.5;
    for (k = 0, len = canvases.length; k < len; k++) {
      canvas = canvases[k];
      context = canvas.getContext("2d");
      width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2;
      height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2;
      context.fillStyle = "transparent";
      context.fillRect(0, 0, width, height);
      if (measurePerf) {
        perfStart = performance.now();
      }
      nBlobs = width / 6;
      for (i = m = 0, ref = nBlobs; 0 <= ref ? m <= ref : m >= ref; i = 0 <= ref ? ++m : --m) {
        increase = i / nBlobs;
        decrease = 1 - increase;
        a = randTable[i % randTableSize];
        d = randTable[a];
        r = randTable[d];
        c = randTable[r];
        l = randTable[c];
        r = r / randTableSize * width / 5;
        c = (c / randTableSize * 50 + (170 * t) + 200) % 360 | 0;
        l = l / randTableSize * 10 + 70;
        x = Math.cos((a / randTableSize) * TAU) * Math.pow(d / randTableSize, 1 / 10) * (r / 2 + width / 2) + width / 2 | 0;
        y = Math.abs(Math.sin((a / randTableSize) * TAU)) * Math.pow(d / randTableSize, 1 / 3) * (r / 2 + height / 2) + height / 2 | 0;
        context.beginPath();
        context.fillStyle = "hsla(" + c + ", 30%, " + l + "%, .03)";
        context.arc(x, y, r, 0, TAU);
        context.fill();
      }
    }
    if (measurePerf) {
      return console.log((performance.now() - perfStart).toPrecision(4) + "  Bio");
    }
  };

  ready(function() {
    var canvases, doRender, requestRender;
    canvases = document.querySelectorAll("canvas.js-bio");
    doRender = function() {
      return renderBio(canvases);
    };
    requestRender = function() {
      return requestAnimationFrame(doRender);
    };
    requestRender();
    return setInterval(requestRender, 500);
  });

  (function() {
    var dirty, epsilon, fadeHeader, header, headerCurrent, headerDelta, headerTarget, requestUpdate, update;
    header = document.querySelector("header");
    if (header == null) {
      return;
    }
    header.style.opacity = headerTarget = headerCurrent = 1;
    headerDelta = 0;
    dirty = false;
    epsilon = 0.0001;
    fadeHeader = function() {
      var opacity;
      opacity = 1 - document.body.scrollTop / header.offsetHeight * 1.2;
      opacity = opacity * opacity * opacity;
      opacity = Math.min(1, Math.max(0, opacity));
      return headerTarget = opacity;
    };
    update = function() {
      dirty = false;
      headerDelta = (headerTarget - headerCurrent) / 5;
      if (Math.abs(headerDelta) > epsilon) {
        header.style.opacity = headerCurrent = headerCurrent + headerDelta;
        return requestUpdate();
      }
    };
    requestUpdate = function() {
      if (!dirty) {
        dirty = true;
        return window.requestAnimationFrame(update);
      }
    };
    return window.addEventListener("scroll", function() {
      fadeHeader();
      return requestUpdate();
    });
  })();

  renderStars = function(canvases) {
    var blueBlobs, c, canvas, context, decrease, density, dscale, h, height, i, increase, k, l, len, m, n, nBlueBlobs, nPixelStars, nPurpBlobs, nRedBlobs, nSmallGlowingStars, nStars, o, pixelStars, purpleBlobs, q, r, r1, r2, redBlobs, ref, ref1, ref2, ref3, ref4, ref5, results, s, smallGlowingStars, stars, starsPerfStart, start, sx, sy, u, v, w, width, x, y;
    results = [];
    for (k = 0, len = canvases.length; k < len; k++) {
      canvas = canvases[k];
      context = canvas.getContext("2d");
      width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2;
      height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2;
      density = Math.sqrt(width * height);
      dscale = density / 3000;
      context.fillStyle = "transparent";
      context.fillRect(0, 0, width, height);
      if (measurePerf) {
        console.log("");
        starsPerfStart = performance.now();
      }
      pixelStars = true;
      stars = true;
      redBlobs = true;
      purpleBlobs = true;
      blueBlobs = true;
      smallGlowingStars = true;
      nPixelStars = density / 3 | 0;
      nStars = density / 200 | 0;
      nRedBlobs = density / 25 | 0;
      nPurpBlobs = density / 20 | 0;
      nBlueBlobs = density / 25 | 0;
      nSmallGlowingStars = density / 20 | 0;
      if (pixelStars) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = m = 0, ref = nPixelStars; 0 <= ref ? m <= ref : m >= ref; i = 0 <= ref ? ++m : --m) {
          x = randTable[(i + 5432) % randTableSize];
          y = randTable[x];
          o = randTable[y];
          x = x * width / randTableSize | 0;
          y = y * height / randTableSize | 0;
          o = o / randTableSize * 0.5 + 0.5;
          context.beginPath();
          context.fillStyle = "hsla(300, 25%, 50%, " + o + ")";
          context.arc(x, y, 1, 0, TAU);
          context.fill();
        }
        if (measurePerf) {
          console.log((performance.now() - start).toPrecision(4) + "  pixelStars");
        }
      }
      if (stars) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = n = 0, ref1 = nStars; 0 <= ref1 ? n <= ref1 : n >= ref1; i = 0 <= ref1 ? ++n : --n) {
          increase = i / nStars;
          decrease = 1 - increase;
          x = randTable[i % randTableSize];
          y = randTable[x];
          r1 = randTable[y];
          r2 = randTable[r1];
          sx = randTable[r2];
          sy = randTable[sx];
          l = randTable[sy];
          c = randTable[l];
          o = randTable[c];
          x = x * width / randTableSize | 0;
          y = y * height / randTableSize | 0;
          r1 = r1 / randTableSize * 3 + 2.5;
          r2 = r2 / randTableSize * 2 + 0.5;
          l = l / randTableSize * 20 + 20;
          o = o / randTableSize * 10 * decrease + 0.3;
          c = c / randTableSize * 120 + 200;
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 30%, " + l + "%, " + o + ")";
          context.arc(x, y, r1, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(0, 0%, 100%, 1)";
          context.arc(x, y, r2, 0, TAU);
          context.fill();
        }
        if (measurePerf) {
          console.log((performance.now() - start).toPrecision(4) + "  stars");
        }
      }
      if (redBlobs) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = q = 0, ref2 = nRedBlobs; 0 <= ref2 ? q <= ref2 : q >= ref2; i = 0 <= ref2 ? ++q : --q) {
          increase = i / nRedBlobs;
          decrease = 1 - increase;
          o = randTable[(12345 + i) % randTableSize];
          x = randTable[o];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = x / randTableSize * width | 0;
          y = y / randTableSize * height | 0;
          r = r / randTableSize * 150 * decrease * dscale + 20;
          l = l / randTableSize * 30 * decrease + 30;
          o = o / randTableSize * 0.012 + 0.003;
          h = h / randTableSize * 30 + 350;
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", 100%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", 100%, " + l + "%, " + (o * 3 / 4) + ")";
          context.arc(x, y, r * 2, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", 100%, " + l + "%, " + (o / 2) + ")";
          context.arc(x, y, r * 3, 0, TAU);
          context.fill();
        }
        if (measurePerf) {
          console.log((performance.now() - start).toPrecision(4) + "  redBlobs");
        }
      }
      if (purpleBlobs) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = u = 0, ref3 = nPurpBlobs; 0 <= ref3 ? u <= ref3 : u >= ref3; i = 0 <= ref3 ? ++u : --u) {
          increase = i / nPurpBlobs;
          decrease = 1 - increase;
          x = randTable[(i + 1234) % randTableSize];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          o = randTable[l];
          x = (x / randTableSize * width * 2 / 3 + width * 1 / 6) | 0;
          y = (y / randTableSize * height * 2 / 3 + height * 1 / 6) | 0;
          r = r / randTableSize * 300 * dscale * decrease + 30;
          l = l / randTableSize * 10 * increase + 9;
          o = o / randTableSize * 0.07 * decrease + 0.03;
          context.beginPath();
          context.fillStyle = "hsla(290, 100%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
        }
        if (measurePerf) {
          console.log((performance.now() - start).toPrecision(4) + "  purpleBlobs");
        }
      }
      if (blueBlobs) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = v = 0, ref4 = nBlueBlobs; 0 <= ref4 ? v <= ref4 : v >= ref4; i = 0 <= ref4 ? ++v : --v) {
          increase = i / nBlueBlobs;
          decrease = 1 - increase;
          x = randTable[(i + 123) % randTableSize];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x / randTableSize * width) | 0;
          y = (y / randTableSize * height) | 0;
          r = r / randTableSize * 150 * dscale * decrease + 20;
          s = l / randTableSize * 40 + 30;
          l = l / randTableSize * 40 * decrease + 10;
          h = h / randTableSize * 30 + 200;
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.015)";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.013)";
          context.arc(x, y, r * 2, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.011)";
          context.arc(x, y, r * 3, 0, TAU);
          context.fill();
        }
        if (measurePerf) {
          console.log((performance.now() - start).toPrecision(4) + "  blueBlobs");
        }
      }
      if (smallGlowingStars) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = w = 0, ref5 = nSmallGlowingStars; 0 <= ref5 ? w <= ref5 : w >= ref5; i = 0 <= ref5 ? ++w : --w) {
          r = randTable[(i + 345) % randTableSize];
          l = randTable[r];
          o = randTable[l];
          c = randTable[o];
          x = randTable[c];
          y = randTable[x];
          x = (x * width / randTableSize) | 0;
          y = (y * height / randTableSize) | 0;
          r = r / randTableSize * 2 + 1;
          l = l / randTableSize * 20 + 40;
          o = o / randTableSize * 0.4 + 0.2;
          c = c / randTableSize * 180 + 200;
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 70%, " + l + "%, " + (o / 25) + ")";
          context.arc(x, y, r * r * r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 50%, " + l + "%, " + (o / 6) + ")";
          context.arc(x, y, r * r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 20%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 100%, 90%, " + (o * 1.5) + ")";
          context.arc(x, y, 1, 0, TAU);
          context.fill();
        }
        if (measurePerf) {
          console.log((performance.now() - start).toPrecision(4) + "  smallGlowingStars");
        }
      }
      if (measurePerf) {
        console.log("");
        results.push(console.log((performance.now() - starsPerfStart).toPrecision(4) + "  Stars"));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  ready(function() {
    var canvases, doRender, requestRender;
    canvases = document.querySelectorAll("canvas.js-stars");
    doRender = function() {
      return renderStars(canvases);
    };
    requestRender = function() {
      return requestAnimationFrame(doRender);
    };
    requestRender();
    return window.addEventListener("resize", requestRender);
  });

}).call(this);

//# sourceMappingURL=scripts.js.map
