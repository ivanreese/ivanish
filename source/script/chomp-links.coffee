do ()->
  TIME = 2000
  HEADER_HEIGHT = 56
  holder = document.createElement("div")
  oldMain = null
  dirty = false
  scrollTarget = 0
  epsilon = 0.1
  
  # update = ()->
  #   dirty = false
  #   scrollTop = parseInt(document.body.scrollTop)
  #   deltaTop = scrollTarget - scrollTop
  #   if Math.abs(deltaTop) > epsilon
  #     newTop = scrollTop + deltaTop/1000
  #     document.body.scrollTop = newTop
  #     # if oldMain?
  #     #   oldMain.style.top = ((HEADER_HEIGHT - newTop) + Math.min(newTop, HEADER_HEIGHT)) + "px"
  #     requestUpdate()
  #
  # requestUpdate = ()->
  #   unless dirty
  #     dirty = true
  #     window.requestAnimationFrame(update)
  
  done = (elm)->
    ()->
      elm.classList.remove("chomp-on")
      elm.classList.remove("showing")
  
  show = (elm)->
    ()->
      elm.classList.add("showing")
      setTimeout done(elm), TIME
  
  kill = (elm)->
    ()->
      document.body.removeChild(elm)
    
  swapPage = (link, resp)->
    start = resp.indexOf "<main"
    end = resp.indexOf "</main>"
    newText = resp.substr(start, end - start + 7)
    
    holder.innerHTML = newText
    newMain = holder.firstChild
    newMain.classList.add("chomp-on")
    parseEm(newMain)
    
    document.body.insertBefore(newMain, oldMain)
    history.pushState(null, "", link.href)
    
    setTimeout show(newMain), TIME/2
  
  loadPage = (link)->
    oldMain = document.querySelector "main"
    oldMain.classList.add("chomp-away")
    oldMain.style.top = HEADER_HEIGHT + "px"
    
    setTimeout ()->
      # PREP THE OLD PAGE FOR DEATH
      oldMain.classList.add("hiding")
      setTimeout kill(oldMain), TIME

      # scrollTop = parseInt(document.body.scrollTop)
      # # oldMain.style.top = ((HEADER_HEIGHT - scrollTop) + Math.min(scrollTop, HEADER_HEIGHT)) + "px"
      # scrollTarget = Math.min(scrollTop, HEADER_HEIGHT)
      # requestUpdate()
      
      # LOAD THE NEW PAGE
      request = new XMLHttpRequest()
      request.open "GET", link.href, true
      
      request.onload = ()->
        if this.status >= 200 and this.status < 400
          swapPage(link, this.response)
        else
          alert "Whoops. This link is broken. Sorry! Maybe let me know on twitter? @spiralganglion"
      
      request.onerror = ()->
        alert "Your internet is borked maybe. Sorry."
      
      request.send()
  
  chompLink = (link)->
    link.setAttribute "chomped", true
    href = link.getAttribute("href")
    
    if href? and href.charAt(0) is "/" and href.charAt(1) isnt "/"
      link.addEventListener "click", (e)->
        e.preventDefault()
        loadPage(link)
  
  parseEm = (target = document)->
    for link in target.querySelectorAll "a"
      unless link.hasAttribute "chomped"
        chompLink(link)
  
  ready(parseEm)
