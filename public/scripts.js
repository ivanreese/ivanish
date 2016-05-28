(function() {
  var TAU, clip, measurePerf, scale;

  measurePerf = false;

  if (measurePerf) {
    console.log("Performance --------------------");
  }

  TAU = Math.PI * 2;

  clip = function(input, inputMin, inputMax) {
    if (inputMin == null) {
      inputMin = 0;
    }
    if (inputMax == null) {
      inputMax = 1;
    }
    return Math.min(1, Math.max(0, input));
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

  (function() {
    var determinstic, i, j, k, m, perfStart, ref, results, seed, swap;
    determinstic = true;
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

  ready(function() {
    var bioShift, canvas, count, doRender, renderBio, requestRender, scrollTop;
    bioShift = Math.random();
    canvas = document.querySelector("canvas.js-bio");
    if (!((canvas != null) && window.getComputedStyle(canvas).display !== "none")) {
      return;
    }
    scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop;
    count = Math.random() * 100 | 0;
    doRender = function() {
      return renderBio();
    };
    requestRender = function() {
      var st;
      st = document.body.scrollTop + document.body.parentNode.scrollTop;
      if (st === scrollTop) {
        requestAnimationFrame(doRender);
      }
      return scrollTop = st;
    };
    requestRender();
    setInterval(requestRender, 150);
    return renderBio = function() {
      var a, c, context, d, decrease, height, i, increase, k, l, nBlobs, perfStart, r, ref, t, width, x, y;
      t = Math.sin(++count / 20) / 2 + 0.5;
      context = canvas.getContext("2d");
      width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2;
      height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2;
      context.fillStyle = "transparent";
      context.fillRect(0, 0, width, height);
      if (measurePerf) {
        perfStart = performance.now();
      }
      nBlobs = width / 6;
      for (i = k = 0, ref = nBlobs; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
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
        context.fillStyle = "hsla(" + c + ", 43%, " + l + "%, .04)";
        context.arc(x, y, r, 0, TAU);
        context.fill();
      }
      if (measurePerf) {
        return console.log((performance.now() - perfStart).toPrecision(4) + "  Bio");
      }
    };
  });

  ready(function() {
    document.body.removeAttribute("fade-out");
    window.addEventListener("popstate", function() {
      return document.body.removeAttribute("fade-out");
    });
    return window.addEventListener("beforeunload", function() {
      return document.body.setAttribute("fade-out", true);
    });
  });

  (function() {
    var dirty, epsilon, fadeHeader, header, headerCurrent, headerDelta, headerTarget, requestUpdate, update;
    header = document.querySelector("header");
    if (header == null) {
      return;
    }
    if (document.querySelector("#index")) {
      return;
    }
    header.style.opacity = headerTarget = headerCurrent = 1;
    headerDelta = 0;
    dirty = false;
    epsilon = 0.0001;
    fadeHeader = function() {
      var opacity, scrollTop;
      scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop;
      opacity = scale(scrollTop, 0, header.offsetHeight, 1, 0.2);
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

  ready(function() {
    var canvas, context, density, doRender, dpi, dscale, height, renderRequested, renderStars, requestRender, width;
    renderRequested = false;
    canvas = document.querySelector("canvas.js-stars");
    if (!((canvas != null) && window.getComputedStyle(canvas).display !== "none")) {
      return;
    }
    context = null;
    width = 0;
    height = 0;
    density = 0;
    dscale = 0;
    dpi = 2;
    doRender = function() {
      renderRequested = false;
      return renderStars();
    };
    requestRender = function() {
      if (!renderRequested) {
        renderRequested = true;
        return requestAnimationFrame(doRender);
      }
    };
    requestRender();
    window.addEventListener("resize", requestRender);
    window.addEventListener("scroll", requestRender);
    return renderStars = function() {
      var blueBlobs, c, decrease, h, i, increase, k, l, m, n, nBlueBlobs, nPixelStars, nPurpBlobs, nRedBlobs, nSmallGlowingStars, nStars, newWidth, o, pixelStars, purpleBlobs, q, r, r1, r2, redBlobs, ref, ref1, ref2, ref3, ref4, ref5, s, scrollTop, smallGlowingStars, stars, starsPerfStart, start, sx, sy, u, v, x, y;
      scrollTop = document.body.scrollTop + document.body.parentNode.scrollTop;
      newWidth = parseInt(canvas.parentNode.offsetWidth) * dpi;
      if (width !== newWidth) {
        context = canvas.getContext("2d");
        width = canvas.width = newWidth;
        height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * dpi;
        density = Math.sqrt(width * height);
        dscale = density / 3000;
      }
      if (measurePerf) {
        console.log("");
        starsPerfStart = performance.now();
      }
      redBlobs = true;
      purpleBlobs = true;
      blueBlobs = true;
      pixelStars = true;
      stars = true;
      smallGlowingStars = true;
      nRedBlobs = Math.max(0, scale(scrollTop, 0, height * 0.4, density / 25, 0) | 0);
      nPurpBlobs = Math.max(0, scale(scrollTop, 0, height * 0.4, density / 20, 0) | 0);
      nBlueBlobs = Math.max(0, scale(scrollTop, 0, height * 0.4, density / 25, 0) | 0);
      nPixelStars = Math.max(0, scale(scrollTop, 0, height * 0.4, density / 5, 0) | 0);
      nStars = Math.max(0, scale(scrollTop, 0, height * 0.4, density / 50, 0) | 0);
      nSmallGlowingStars = Math.max(0, scale(scrollTop, 0, height * 0.4, density / 20, 0) | 0);
      if (redBlobs) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = k = 0, ref = nRedBlobs; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
          increase = i / nRedBlobs;
          decrease = 1 - increase;
          o = randTable[(12345 + i) % randTableSize];
          x = randTable[o];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = x / randTableSize * width | 0;
          y = y / randTableSize * height - scrollTop * increase | 0;
          r = r / randTableSize * 120 * decrease * dscale + 20;
          l = l / randTableSize * 30 * decrease + 30;
          o = o / randTableSize * 0.015 + 0.008;
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
        for (i = m = 0, ref1 = nPurpBlobs; 0 <= ref1 ? m <= ref1 : m >= ref1; i = 0 <= ref1 ? ++m : --m) {
          increase = i / nPurpBlobs;
          decrease = 1 - increase;
          x = randTable[(i + 1234) % randTableSize];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          o = randTable[l];
          x = x / randTableSize * width * 2 / 3 + width * 1 / 6 | 0;
          y = y / randTableSize * height * 2 / 3 + height * 1 / 6 - scrollTop * decrease | 0;
          r = r / randTableSize * 200 * dscale * decrease + 30;
          l = l / randTableSize * 10 * increase + 9;
          o = o / randTableSize * 0.07 * decrease + 0.05;
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
        for (i = n = 0, ref2 = nBlueBlobs; 0 <= ref2 ? n <= ref2 : n >= ref2; i = 0 <= ref2 ? ++n : --n) {
          increase = i / nBlueBlobs;
          decrease = 1 - increase;
          x = randTable[(i + 123) % randTableSize];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = x / randTableSize * width | 0;
          y = y / randTableSize * height - scrollTop * decrease | 0;
          r = r / randTableSize * 120 * dscale * decrease + 20;
          s = l / randTableSize * 40 + 30;
          l = l / randTableSize * 40 * decrease + 10;
          h = h / randTableSize * 50 + 200;
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.017)";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.015)";
          context.arc(x, y, r * 2, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.013)";
          context.arc(x, y, r * 3, 0, TAU);
          context.fill();
        }
        if (measurePerf) {
          console.log((performance.now() - start).toPrecision(4) + "  blueBlobs");
        }
      }
      if (pixelStars) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = q = 0, ref3 = nPixelStars; 0 <= ref3 ? q <= ref3 : q >= ref3; i = 0 <= ref3 ? ++q : --q) {
          increase = i / nPixelStars;
          x = randTable[(i + 5432) % randTableSize];
          y = randTable[x];
          o = randTable[y];
          r = randTable[o];
          x = x * width / randTableSize | 0;
          y = y * height / randTableSize - scrollTop | 0;
          o = o / randTableSize * 0.5 + 0.5;
          r = r / randTableSize * 1.5 + .5;
          context.beginPath();
          context.fillStyle = "hsla(300, 25%, 50%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
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
        for (i = u = 0, ref4 = nStars; 0 <= ref4 ? u <= ref4 : u >= ref4; i = 0 <= ref4 ? ++u : --u) {
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
          y = y * height / randTableSize - scrollTop * decrease | 0;
          r1 = r1 / randTableSize * 4 + .5;
          r2 = r2 / randTableSize * 3 + .5;
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
      if (smallGlowingStars) {
        if (measurePerf) {
          start = performance.now();
        }
        for (i = v = 0, ref5 = nSmallGlowingStars; 0 <= ref5 ? v <= ref5 : v >= ref5; i = 0 <= ref5 ? ++v : --v) {
          increase = i / nSmallGlowingStars;
          decrease = 1 - increase;
          r = randTable[(i + 345) % randTableSize];
          l = randTable[r];
          o = randTable[l];
          c = randTable[o];
          x = randTable[c];
          y = randTable[x];
          x = x * width / randTableSize | 0;
          y = y * height / randTableSize - scrollTop * decrease | 0;
          r = r / randTableSize * 2 + 1;
          l = l / randTableSize * 20 + 40;
          o = o / randTableSize * 1 * decrease + 0.25;
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
        return console.log((performance.now() - starsPerfStart).toPrecision(4) + "  Stars");
      }
    };
  });

}).call(this);
