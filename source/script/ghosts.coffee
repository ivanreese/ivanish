do ()->
  # 1 in 10 chance to run ghosts
  return if Math.random() > (1 / 10)

  # Grab the last paragraph
  return unless elm = Array.from(document.getElementsByTagName("p")).at(-1)

  # Bail if the paragraph contains HTML that's not, like, basic text formatting
  for child in Array.from elm.querySelectorAll "*"
    unless ["em", "strong", "i", "b", "span"].includes child.tagName.toLowerCase()
      return "No"

  # Grab all the chars from the paragraph
  head = Array.from elm.innerHTML

  # Peel off some number of those chars
  tail = head.splice @randInt -200, -10

  # Update the paragraph
  elm.innerHTML = head.join ""

  # When the paragraph scrolls into view…
  observer = new IntersectionObserver ([entry])->
    return unless entry.isIntersecting
    observer.unobserve(elm)
    animate()

  # …animate the chars appearing
  animate = ()->
    if Math.random() < 0.2
      head.push tail.shift()
      elm.innerHTML = head.join ""
    if tail.length > 0
      requestAnimationFrame animate

  observer.observe elm
