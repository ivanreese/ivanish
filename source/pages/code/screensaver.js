(function() {
  if (window.reduceMotion) return;
  var API, canvas, context, count, dpr, elm, height, i, len, lines, makeL, makeP, moveL, moveP, rand, ref, render, renderRequested, requestRender, requestResize, resize, running, width;
  canvas = document.querySelector("#screensaver");
  context = canvas.getContext("2d");
  dpr = 1;
  width = 0;
  height = 0;
  running = false;
  renderRequested = false;
  count = 0;
  lines = null;
  resize = function() {
    width = canvas.width = window.innerWidth * dpr;
    return height = canvas.height = window.innerHeight * dpr;
  };
  requestResize = function() {
    var heightChanged, widthChanged;
    widthChanged = 2 < Math.abs(width - window.innerWidth * dpr);
    heightChanged = 50 < Math.abs(height - window.innerHeight * dpr);
    if (widthChanged || heightChanged) {
      return requestAnimationFrame(function(time) {
        var first;
        first = true;
        resize();
        return requestRender();
      });
    }
  };
  requestRender = function() {
    if (!renderRequested) {
      renderRequested = true;
      return requestAnimationFrame(render);
    }
  };
  rand = function(max) {
    return Math.floor(Math.random() * max);
  };
  makeP = function() {
    return {
      x: rand(width),
      y: rand(height),
      xDir: 2 * rand(2) - 1,
      yDir: 2 * rand(2) - 1
    };
  };
  makeL = function() {
    return {
      p1: makeP(),
      p2: makeP()
    };
  };
  moveP = function(p) {
    p.x += p.xDir * 5;
    p.y += p.yDir * 5;
    if (p.x <= 0 || p.x >= width) {
      p.xDir *= -1;
    }
    if (p.y <= 0 || p.y >= height) {
      return p.yDir *= -1;
    }
  };
  moveL = function(l) {
    moveP(l.p1);
    return moveP(l.p2);
  };
  render = function(time) {
    var j, len1, line;
    renderRequested = false;
    if (running) {
      requestRender();
    }
    if (document.hidden) {
      return;
    }
    if (count++ % 2 !== 0) {
      return;
    }
    context.globalCompositeOperation = "destination-over"

    for (j = 0, len1 = lines.length; j < len1; j++) {
      line = lines[j];
      moveL(line);
      context.beginPath();
      context.strokeStyle = "hsl(" + (Math.random() * 360) + ", 100%, 50%)";
      context.lineWidth = 100;
      context.moveTo(line.p1.x, line.p1.y);
      context.lineTo(line.p2.x, line.p2.y);
      context.stroke();
    }
  };
  window.addEventListener("resize", requestResize);
  resize();
  lines = [makeL()];
  running = true;
  requestRender();
}).call(this);
