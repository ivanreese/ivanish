(function() {
  var TAU, k, randTable, results, seed, size, swap, time;

  TAU = Math.PI * 2;

  size = 4096;

  seed = Math.random() * 999999 | 0;

  time = Date.now() / 1000;

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

  (function() {
    var debug, shift;
    debug = false;
    shift = Math.random();
    return window.addEventListener("resize", ready(function() {
      var INNER, a, c, canvas, canvases, context, d, decrease, height, i, increase, l, len, m, n, nBlobs, r, ref, width, x, y;
      canvases = document.querySelectorAll("canvas.js-bio");
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
        nBlobs = width / 3;
        for (i = n = 0, ref = nBlobs; 0 <= ref ? n <= ref : n >= ref; i = 0 <= ref ? ++n : --n) {
          increase = i / nBlobs;
          decrease = 1 - increase;
          a = randTable[i % size];
          d = randTable[a];
          r = randTable[d];
          c = randTable[r];
          l = randTable[c];
          r = r / size * width / 5;
          c = ((c / size * 50 + (170 * shift) + 200) % 360) | 0;
          l = l / size * 10 + 65;
          x = Math.cos((a / size) * TAU) * Math.pow(d / size, 1 / 10) * (r / 2 + width / 2) + width / 2 | 0;
          y = Math.abs(Math.sin((a / size) * TAU)) * Math.pow(d / size, 1 / 3) * (r / 2 + height / 2) + height / 2 | 0;
          context.beginPath();
          context.fillStyle = "hsla(" + c + ", 23%, " + l + "%, .03)";
          context.arc(x, y, r, 0, TAU);
          context.fill();
        }
      }
      if (debug) {
        return console.log(Math.ceil(performance.now() - INNER));
      }
    }));
  })();

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
    var debug;
    debug = false;
    return window.addEventListener("resize", ready(function() {
      var INNER, aa, ab, ac, c, canvas, canvases, context, decrease, h, height, i, increase, l, len, m, n, nBSmallSquareStars, nBigStars, nBlueBlobs, nPurpBlobs, nRedBlobs, nSmallBlueBlobs, nSmallRoundStars, o, pixelStars, q, r, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, s, sx, sy, t, u, v, w, width, wscale, x, y, z;
      canvases = document.querySelectorAll("canvas.js-stars");
      for (m = 0, len = canvases.length; m < len; m++) {
        canvas = canvases[m];
        context = canvas.getContext("2d");
        width = canvas.width = parseInt(canvas.parentNode.offsetWidth) * 2;
        height = canvas.height = parseInt(canvas.parentNode.offsetHeight) * 2;
        wscale = width / 3000;
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
          x = randTable[(i + 123) % size];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x / size * width) | 0;
          y = (y / size * height) | 0;
          r = r / size * 100 * wscale * decrease + 20;
          s = l / size * 40 + 30;
          l = l / size * 40 * decrease + 5;
          h = h / size * 30 + 200;
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.01)";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.009)";
          context.arc(x, y, r * 2, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.008)";
          context.arc(x, y, r * 3, 0, TAU);
          context.fill();
        }
        nSmallBlueBlobs = width / 30;
        for (i = u = 0, ref3 = nSmallBlueBlobs; 0 <= ref3 ? u <= ref3 : u >= ref3; i = 0 <= ref3 ? ++u : --u) {
          increase = i / nSmallBlueBlobs;
          decrease = 1 - increase;
          x = randTable[(i + 473) % size];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x / size * width * 2 / 3 + width / 3) | 0;
          y = (y / size * height) | 0;
          r = r / size * 20 * wscale * decrease + 5;
          s = l / size * 30 + 40;
          l = l / size * 40 * decrease + 20;
          h = h / size * 50 + 200;
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.03)";
          context.arc(x, y, r, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.02)";
          context.arc(x, y, r * 2, 0, TAU);
          context.fill();
          context.beginPath();
          context.fillStyle = "hsla(" + h + ", " + s + "%, " + l + "%, 0.01)";
          context.arc(x, y, r * 3, 0, TAU);
          context.fill();
        }
        nPurpBlobs = width / 20;
        for (i = v = 0, ref4 = nPurpBlobs; 0 <= ref4 ? v <= ref4 : v >= ref4; i = 0 <= ref4 ? ++v : --v) {
          increase = i / nPurpBlobs;
          decrease = 1 - increase;
          x = randTable[(i + 1234) % size];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          o = randTable[l];
          x = (x / size * width * 2 / 3 + width * 1 / 6) | 0;
          y = (y / size * height * 2 / 3 + height * 1 / 6) | 0;
          r = r / size * 300 * wscale * decrease + 30;
          l = l / size * 10 * increase + 9;
          o = o / size * 0.03 * decrease + 0.03;
          context.beginPath();
          context.fillStyle = "hsla(290, 100%, " + l + "%, " + o + ")";
          context.arc(x, y, r, 0, TAU);
          context.fill();
        }
        nRedBlobs = width / 20;
        for (i = z = 0, ref5 = nRedBlobs; 0 <= ref5 ? z <= ref5 : z >= ref5; i = 0 <= ref5 ? ++z : --z) {
          increase = i / nRedBlobs;
          decrease = 1 - increase;
          o = randTable[(12345 + i) % size];
          x = randTable[o];
          y = randTable[x];
          r = randTable[y];
          l = randTable[r];
          h = randTable[l];
          x = (x / size * width) | 0;
          y = (y / size * height) | 0;
          r = r / size * 100 * wscale * decrease + 20;
          l = l / size * 30 * decrease + 30;
          o = o / size * 0.01 + 0.002;
          h = h / size * 30 + 350;
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
        nBSmallSquareStars = width / 10;
        for (i = aa = 0, ref6 = nBSmallSquareStars; 0 <= ref6 ? aa <= ref6 : aa >= ref6; i = 0 <= ref6 ? ++aa : --aa) {
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
        for (i = ab = 0, ref7 = nSmallRoundStars; 0 <= ref7 ? ab <= ref7 : ab >= ref7; i = 0 <= ref7 ? ++ab : --ab) {
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
        pixelStars = width / 5;
        for (i = ac = 0, ref8 = pixelStars; 0 <= ref8 ? ac <= ref8 : ac >= ref8; i = 0 <= ref8 ? ++ac : --ac) {
          x = randTable[(i + 5432) % size];
          y = randTable[x];
          o = randTable[y];
          x = (x * width / size) | 0;
          y = (y * height / size) | 0;
          o = o / size * 0.3 + 0.7;
          context.beginPath();
          context.fillStyle = "hsla(300, 30%, 50%, " + o + ")";
          context.arc(x, y, 1, 0, TAU);
          context.fill();
        }
      }
      if (debug) {
        console.log("STARS");
        return console.log(Math.ceil(performance.now() - INNER));
      }
    }));
  })();

}).call(this);

//# sourceMappingURL=scripts.js.map
