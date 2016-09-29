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
    textarea.textContent = textarea.textContent.replace(/^\s*/, "").replace(/\s*$/, "").replace(/\n      /g, "\n")
    editor = CodeMirror.fromTextArea textarea, mode: 'coffeescript'
    editor.on "changes", cb
    cb editor
  
  setup = (section)->
    textarea = section.querySelector "textarea"
    results = section.querySelector "p"
    canvas = section.querySelector "canvas"
    context = canvas.getContext "2d"
    code = null
    w = 0
    h = 0
    
    log = (msg)->
      results.textContent += msg + "\n"
    
    evaluate = (code, context, w, h)->
      try eval code

    run = ()->
      if code.code?
        results.textContent = ""
        evaluate code.code, context, w, h
      else
        log code.error
    
    resize = ()->
      # w = canvas.width = parseInt canvas.offsetWidth
      # h = canvas.height = parseInt canvas.offsetHeight
    
    window.addEventListener "resize", ()->
      resize()
      run code
    
    resize()
    
    setupCM textarea, (editor)->
      run code = compile editor.getValue()
  
  ready ()->
    setup section for section in document.querySelectorAll "[js-repl]"
