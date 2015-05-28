fadeHeader = ()->
  header = document.querySelector("header")
  opacity = 1 - document.body.scrollTop / header.offsetHeight
  header.style.opacity = opacity

fadeFooter = ()->
  footer = document.querySelector("footer")
  scrollBottom = document.body.scrollTop + window.innerHeight
  opacity = (scrollBottom - document.body.scrollHeight + footer.offsetHeight) / footer.offsetHeight
  footer.style.opacity = opacity

window.addEventListener "scroll", ()->
  fadeHeader()
  fadeFooter()
