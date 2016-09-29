do ()->
  
  compile = (text)->
    try
      code: CoffeeScript.compile text, bare: on
    catch {location, message}
      error: if location? then "Error on line #{location.first_line + 1}: #{message}" else message
  
  
  setupCM = (textarea, cb)->
    CodeMirror.defaults.lineNumbers = false
    CodeMirror.defaults.tabSize = 2
    CodeMirror.defaults.historyEventDelay = 200
    CodeMirror.defaults.viewportMargin = Infinity
    CodeMirror.defaults.extraKeys =
      Tab: false
      "Shift-Tab": false
      "Cmd-Enter": cb
    # This nonsense strips the right amount of whitespace
    textarea.textContent = textarea.textContent.replace(/^\s*/, "").replace(/\s*$/, "").replace(/\n      /g, "\n")
    editor = CodeMirror.fromTextArea textarea, mode: 'coffeescript'
    editor.on "changes", cb
    cb editor
  
  
  setup = (textarea)->
    repl = document.createElement "js-repl"
    textarea.parentElement.replaceChild repl, textarea
    repl.appendChild textarea
    
    results = document.createElement "p"
    repl.appendChild results
    results.className = "results"
    
    if textarea.hasAttribute "js-canvas"
      canvas = document.createElement "canvas"
      repl.appendChild canvas
      g = canvas.getContext "2d"
    
    animated = false
    animating = false
    compiled = null
    tau = Math.PI * 2
    cx = 0
    cy = 0
    w = 0
    h = 0
    time = 0
    
    log = (msg, label)->
      msg = msg.toPrecision 5 if typeof msg is "number"
      msg = label + ": " + msg if label?
      results.innerHTML += msg + "<br>"
    
    evaluate = ()->
      try
        eval compiled.code
      catch e
        log e
    
    render = ()->
      results.textContent = ""
      
      if g?
        g.clearRect 0,0,w,h
        g.fillStyle = "white"
        g.beginPath()
      
      if compiled?.code?
        evaluate()
      else if compiled?.error?
        log compiled.error
    
    tick = (t)->
      if animated and animating
        time = t / 1000
        render()
        requestAnimationFrame tick
      else
        animating = false
    
    run = ()->
      if not animated
        render()
      else if not animating
        animating = true
        requestAnimationFrame tick

    
    resize = ()->
      if canvas?
        w = canvas.width = parseInt canvas.offsetWidth
        h = canvas.height = parseInt canvas.offsetHeight
        cx = w/2
        cy = h/2
    
    window.addEventListener "resize", ()->
      resize()
      run()
    
    resize()
    
    setupCM textarea, (editor)->
      text = editor.getValue()
      compiled = compile text
      animated = compiled.code? and text.indexOf "time" isnt -1
      run()
  
  
  decloak = ()->
    for section in document.querySelectorAll "section"
      section.style.visibility = "visible"

  
  ready ()->
    # Setup REPLs
    for repl in document.querySelectorAll "[js-repl]"
      setup repl
    
    # Setup section links
    for a in document.querySelectorAll "a"
      if a.id.length > 0
        a.outerHTML = "<a href='##{a.id}' class='anchor' id='#{a.id}'>#{a.textContent}</a>"
    
    l = document.getElementById location.hash.replace("#", "")
    if l?
      scroll = ()->
        document.scrollTop = document.body.scrollTop = l.offsetTop
        decloak()
      setTimeout scroll, 150
    else
      decloak()
