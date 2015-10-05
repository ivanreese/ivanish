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
    var OUTER, TAU, debug, k, randTable, redraw, results, seed, size, swap;
    debug = false;
    if (debug) {
      OUTER = performance.now();
    }
    TAU = Math.PI * 2;
    size = 4096;
    seed = 754873;
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
      var INNER, c, canvas, canvases, context, decrease, h, height, i, increase, l, len, m, n, nBSmallSquareStars, nBigStars, nBlueBlobs, nPurpBlobs, nSmallRoundStars, o, q, r, ref, ref1, ref2, ref3, ref4, ref5, s, sx, sy, t, u, v, w, width, x, y;
      canvases = document.querySelectorAll("canvas");
      for (m = 0, len = canvases.length; m < len; m++) {
        canvas = canvases[m];
        context = canvas.getContext("2d");
        width = canvas.width = parseInt(document.body.offsetWidth) * 2;
        height = canvas.height = canvas.getAttribute("set-height") * 2;
        context.fillStyle = "#2C0028";
        context.fillRect(0, 0, width, height);
        if (debug) {
          INNER = performance.now();
        }
        nBigStars = width / 100;
        for (i = n = 0, ref = nBigStars; 0 <= ref ? n <= ref : n >= ref; i = 0 <= ref ? ++n : --n) {
          increase = i / nBigStars;
          decrease = 1 - increase;
          l = randTable[i % size];
          o = randTable[l];
          c = randTable[o];
          x = randTable[c];
          y = randTable[x];
          r = randTable[y];
          sx = randTable[r];
          sy = randTable[sx];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 3 + 1;
          l = l / size * 20 + 40;
          o = o / size * Math.min(10 * decrease, 0.3) + 0.3;
          c = c / size * 120 + 200;
          sx = (sx / size * 2 - 1) * Math.abs(r);
          sy = (sy / size * 2 - 1) * Math.abs(r);
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 40%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          if (randTable[i % size] > size / 2) {
            context.beginPath();
            context.fillStyle = "hsla(0, 0%, 100%, " + (o * 4) + ")";
            context.arc(x + sx, y + sy, 2, 0, TAU);
            context.fill();
          }
        }
        nBlueBlobs = width / 20;
        for (i = q = 0, ref1 = nBlueBlobs; 0 <= ref1 ? q <= ref1 : q >= ref1; i = 0 <= ref1 ? ++q : --q) {
          increase = i / nBlueBlobs;
          decrease = 1 - increase;
          o = randTable[i % size];
          x = randTable[o];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 40 * decrease + 4;
          l = l / size * 40 * decrease;
          o = o / size * 0.3 * increase + 0.05;
          h = h / size * 20 + 260;
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
        nPurpBlobs = width / 20;
        for (i = s = 0, ref2 = nPurpBlobs; 0 <= ref2 ? s <= ref2 : s >= ref2; i = 0 <= ref2 ? ++s : --s) {
          increase = i / nPurpBlobs;
          decrease = 1 - increase;
          x = randTable[i % size];
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
        nBlueBlobs = width / 50;
        for (i = t = 0, ref3 = nBlueBlobs; 0 <= ref3 ? t <= ref3 : t >= ref3; i = 0 <= ref3 ? ++t : --t) {
          increase = i / nBlueBlobs;
          decrease = 1 - increase;
          o = randTable[i % size];
          x = randTable[o];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 10 * decrease + 4;
          l = l / size * 50 * decrease;
          o = o / size * 0.3 * increase + 0.05;
          h = h / size * 30 + 320;
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
        for (i = u = 0, ref4 = nBSmallSquareStars; 0 <= ref4 ? u <= ref4 : u >= ref4; i = 0 <= ref4 ? ++u : --u) {
          increase = i / nBSmallSquareStars;
          decrease = 1 - increase;
          y = randTable[i % size];
          w = randTable[y];
          h = randTable[w];
          l = randTable[h];
          o = randTable[l];
          c = randTable[o];
          x = randTable[c];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          w = w / size * 3 + 1;
          h = h / size * 3 + 1;
          l = l / size * 20 + 30;
          o = o / size * 10 * decrease;
          c = c / size * 60 + 260;
          context.fillStyle = "hsla(" + c + ", 40%, " + l + "%, " + o + ")";
          context.fillRect(x, y, w, h);
        }
        nSmallRoundStars = width / 4;
        for (i = v = 0, ref5 = nSmallRoundStars; 0 <= ref5 ? v <= ref5 : v >= ref5; i = 0 <= ref5 ? ++v : --v) {
          increase = i / nSmallRoundStars;
          decrease = 1 - increase;
          r = randTable[i % size];
          l = randTable[r];
          o = randTable[l];
          c = randTable[o];
          x = randTable[c];
          y = randTable[x];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          r = r / size * 2 + 0.5;
          l = l / size * 30 + 30;
          o = o / size * 10 * decrease;
          c = c / size * 20 + 280;
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 30%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          if (r > 2) {
            context.beginPath();
            context.fillStyle = "hsla(" + c + ", 10%, " + (l + 20) + "%, " + (o * 2) + ")";
            context.arc(x, y, 1, 0, TAU);
            context.fill();
            context.beginPath();
            context.fillStyle = "hsla(" + 265. + ", 70%, " + (l * 2 / 3) + "%, 0.1)";
            context.arc(x, y, r * r, 0, TAU);
            context.fill();
            context.beginPath();
            context.fillStyle = "hsla(" + 265. + ", 70%, " + (l / 2) + "%, 0.05)";
            context.arc(x, y, r * r * r, 0, TAU);
            context.fill();
          }
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
