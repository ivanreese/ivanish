(function() {
  var ready;

  ready = function(fn) {
    if (document.readyState === "loading") {
      return document.addEventListener("DOMContentLoaded", parseEm);
    } else {
      return fn();
    }
  };

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

  (function() {
    var OUTER, TAU, debug, half_size, k, randTable, redraw, results, seed, size, swap;
    debug = false;
    if (debug) {
      OUTER = performance.now();
    }
    TAU = Math.PI * 2;
    size = 4096;
    half_size = size / 2;
    seed = 754874;
    randTable = (function() {
      results = [];
      for (var k = 0; 0 <= size ? k < size : k > size; 0 <= size ? k++ : k--){ results.push(k); }
      return results;
    }).apply(this);
    swap = function(i, j, p) {
      var tmp;
      tmp = p[i];
      p[i] = p[j];
      return p[j] = tmp;
    };
    (function() {
      var i, j, m, ref, results1;
      j = 0;
      results1 = [];
      for (i = m = 0, ref = size; 0 <= ref ? m < ref : m > ref; i = 0 <= ref ? ++m : --m) {
        j = (j + seed + randTable[i]) % size;
        results1.push(swap(i, j, randTable));
      }
      return results1;
    })();
    redraw = function() {
      var INNER, aa, ab, c, canvas, canvases, context, decrease, h, height, i, increase, l, len, m, n, nBSmallSquareStars, nBigStars, nBlueBlobs, nPurpBlobs, nRedBlobs, nSmallRoundStars, o, pixelStars, q, r, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, s, sx, sy, t, u, v, w, width, x, y, z;
      canvases = document.querySelectorAll("canvas");
      for (m = 0, len = canvases.length; m < len; m++) {
        canvas = canvases[m];
        context = canvas.getContext("2d");
        width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2;
        height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2;
        context.fillStyle = "transparent";
        context.fillRect(0, 0, width, height);
        if (debug) {
          INNER = performance.now();
        }
        nBigStars = width / 100;
        for (i = n = 0, ref = nBigStars; 0 <= ref ? n <= ref : n >= ref; i = 0 <= ref ? ++n : --n) {
          increase = i / nBigStars;
          decrease = 1 - increase;
          x = randTable[i % size];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          c = randTable[l];
          o = randTable[c];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 3 + 1;
          l = l / size * 20 + 20;
          o = o / size * 10 * decrease + 0.3;
          c = c / size * 120 + 200;
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 40%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
        }
        nBigStars = width / 200;
        for (i = q = 0, ref1 = nBigStars; 0 <= ref1 ? q <= ref1 : q >= ref1; i = 0 <= ref1 ? ++q : --q) {
          x = randTable[i % size];
          y = randTable[x];
          r = randTable[y];
          sx = randTable[r];
          sy = randTable[sx];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 2 + 0.5;
          sx = sx / size * 2 - 0.5;
          sy = sy / size * 2 - 0.5;
          context.beginPath();
          context.fillStyle = "hsla(0, 0%, 100%, 1)";
          context.arc(x + sx, y + sy, r, 0, TAU);
          context.fill();
        }
        nBlueBlobs = width / 20;
        for (i = t = 0, ref2 = nBlueBlobs; 0 <= ref2 ? t <= ref2 : t >= ref2; i = 0 <= ref2 ? ++t : --t) {
          increase = i / nBlueBlobs;
          decrease = 1 - increase;
          o = randTable[(i + 123) % size];
          x = randTable[o];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 40 * decrease + 4;
          s = l / size * 50 + 30;
          l = l / size * 20 * decrease + 10;
          o = o / size * 0.3 * increase + 0.05;
          h = h / size * 20 + 260;
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, " + (o / 2) + ")";
          context.arc(x, y, r * 2, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, " + (o / 4) + ")";
          context.arc(x, y, r * 3, 0, TAU);
          context.fill();
        }
        nPurpBlobs = width / 20;
        for (i = u = 0, ref3 = nPurpBlobs; 0 <= ref3 ? u <= ref3 : u >= ref3; i = 0 <= ref3 ? ++u : --u) {
          increase = i / nPurpBlobs;
          decrease = 1 - increase;
          x = randTable[(i + 1234) % size];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          o = randTable[l];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 200 * decrease + 2;
          l = l / size * 12 * increase + 7;
          o = o / size * 0.1 * decrease + 0.01;
          context.beginPath();
          context.fillStyle = "hsla(290, 100%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
        }
        nRedBlobs = width / 50;
        for (i = v = 0, ref4 = nRedBlobs; 0 <= ref4 ? v <= ref4 : v >= ref4; i = 0 <= ref4 ? ++v : --v) {
          increase = i / nRedBlobs;
          decrease = 1 - increase;
          o = randTable[(12345 + i) % size];
          x = randTable[o];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 10 * decrease + 20;
          l = l / size * 20 * decrease + 5;
          o = o / size * 0.3 * increase + 0.05;
          h = h / size * 30 + 350;
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", 100%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", 100%, " + l + "%, " + (o / 2) + ")";
          context.arc(x, y, r * 2, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", 100%, " + l + "%, " + (o / 4) + ")";
          context.arc(x, y, r * 3, 0, TAU);
          context.fill();
        }
        nBSmallSquareStars = width / 10;
        for (i = z = 0, ref5 = nBSmallSquareStars; 0 <= ref5 ? z <= ref5 : z >= ref5; i = 0 <= ref5 ? ++z : --z) {
          y = randTable[(i + 234) % size];
          w = randTable[y];
          h = randTable[w];
          l = randTable[h];
          o = randTable[l];
          c = randTable[o];
          x = randTable[c];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          w = w / size * 2 + 1;
          h = h / size * 2 + 1;
          l = l / size * 30 + 10;
          o = o / size * 0.5 + 0.2;
          c = c / size * 40 + 240;
          context.fillStyle = "hsla(" + c + ", 30%, " + l + "%, " + o + ")";
          context.fillRect(x, y, w, h);
        }
        nSmallRoundStars = width / 20;
        for (i = aa = 0, ref6 = nSmallRoundStars; 0 <= ref6 ? aa <= ref6 : aa >= ref6; i = 0 <= ref6 ? ++aa : --aa) {
          r = randTable[(i + 345) % size];
          l = randTable[r];
          o = randTable[l];
          c = randTable[o];
          x = randTable[c];
          y = randTable[x];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 2 + 1;
          l = l / size * 40 + 10;
          o = o / size * 0.4 + 0.2;
          c = c / size * 100 + 220;
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 30%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 30%, " + (l + 40) + "%, " + (o * 2) + ")";
          context.arc(x, y, 1, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 70%, " + (l * 2 / 3) + "%, 0.1)";
          context.arc(x, y, r * r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 70%, " + (l / 2) + "%, 0.05)";
          context.arc(x, y, r * r * r, 0, TAU);
          context.fill();
        }
        pixelStars = width / 6;
        for (i = ab = 0, ref7 = pixelStars; 0 <= ref7 ? ab <= ref7 : ab >= ref7; i = 0 <= ref7 ? ++ab : --ab) {
          x = randTable[(i + 5432) % size];
          y = randTable[x];
          o = randTable[y];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          o = o / size * 0.6 + 0.4;
          context.beginPath();
          context.fillStyle = "hsla(300, 30%, 50%, " + o + ")";
          context.fillRect(x, y, 1, 1);
          context.fill();
        }
      }
      if (debug) {
        return console.log(Math.ceil(performance.now() - INNER), Math.ceil(performance.now() - OUTER));
      }
    };
    ready(redraw);
    return window.addEventListener("resize", redraw);
  })();

}).call(this);

//# sourceMappingURL=scripts.js.map
