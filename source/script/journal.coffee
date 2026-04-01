do ()->

  # Bail unless this is an encrypted journal page
  encryptedElm = document.querySelector "[encrypted-post]"
  input = document.querySelector ".journal-password input"
  return unless encryptedElm and input

  # The slug is used for both key derivation and the IV
  slug = window.location.pathname

  # These are the elements that can contain encrypted text
  blocks = ["title", "p", "h1", "h2", "h3", "h4", "li", "blockquote"]

  # Each byte maps to one cypher char
  cypher = "IiÌÍÎÏĨĪĬĮİƁƊƑƘƝƴȈȊɱʈʋʯϒӇӻӼԒḮỈỊ⌁⌃⌅⌆⌐⌑⌒⌓⌔⌗⌙⌠⌡⌬⌭⌱⌷⌸⌹⌺⌻⌽⌾⍀⍁⍂⍃⍄⍅⍆⍇⍈⍉⍊⍋⍌⍍⍎⍏⍐⍑⍒⍓⍔⍕⍖⍗⍙⍚⍛⍜⍝⍞⍟⍡⍢⍣⍤⍥⍦⍧⍨⍩⍫⍬⍭⍳⍴⍵⍶⍷⍸⍹⍺⍾⎄⎆⎈⎐⎚⎛⎝⎞⎠⎡⎣⎤⎦⎧⎨⎩⎫⎬⎭⎰⎱⎲⎳⏀⏂⏃⏅⏇⏚⏣␥⑄▁▂▃▄▅▆▇█▲△▴▵▶▷▸►▼▽▾▿◀◁◃◄◆◉◍◐◑◒◓◔◕◖◗◴◵◶◷☰☱☲☳☴☵☶☷⚌⚍⚎⚏⚙⦿Ɱ䷀䷁䷂䷃䷄䷅䷆䷇䷈䷉䷊䷋䷌䷍䷎䷏䷐䷑䷒䷓䷔䷕䷖䷗䷘䷙䷚䷛䷜䷝䷞䷟䷠䷡䷢䷣䷤䷥䷦䷧䷨䷩䷪䷫䷬䷭䷮䷯䷰䷱䷲䷳䷴䷵䷶䷷䷸䷹䷺䷻䷼䷽䷾䷿"

  # RNG for generating spaces between the encrypted words
  seededRandom = (seed)->
    s = @hash seed, 0x7fffffff
    ()-> s = (s * 0xCAFEBABE + 2222) & 0x7fffffff; s / 0x7fffffff
  random = seededRandom slug

  # Lil easter egger
  makeName = ()-> (cypher[Math.random() * cypher.length | 0] for i in [0...4]).join ""

  # On first run, parse each element's displayed cypher text back into raw cyphertext bytes.
  # We cache this because the DOM text gets overwritten on each keystroke.
  # {elm:Element, bytes:Uint8Array}[]
  chunks = null

  initChunks = ->
    return if chunks

    # Select all encrypted elements in DOM order (must match the Cakefile's encryption order)
    elms = encryptedElm.querySelectorAll blocks.join ", "

    chunks = for elm in elms

      # Strip the decorative spaces between cypher "words"
      text = elm.textContent.replaceAll /\s/g, ""

      # Map each cypher char back to a byte
      bytes = Uint8Array.from (cypher.indexOf c for c in Array.from text)

      {elm, bytes}

  running = false
  pending = false

  update = ()->
    return pending = true if running
    random = seededRandom slug # reset RNG so word breaks are consistent across keystrokes
    running = true

    initChunks()

    password = input.value

    # Remember the most recently-typed password for return visits
    localStorage.setItem "journal-password", password

    # Derive the key from the password
    enc = new TextEncoder()
    keyMaterial = await crypto.subtle.importKey "raw", enc.encode(password), "PBKDF2", false, ["deriveBits"]
    keyBits = await crypto.subtle.deriveBits {name: "PBKDF2", salt: enc.encode(slug), iterations: 300000, hash: "SHA-256"}, keyMaterial, 256
    key = await crypto.subtle.importKey "raw", keyBits, "AES-CTR", false, ["decrypt"]

    # Derive the IV from the slug
    ivHash = await crypto.subtle.digest "SHA-256", enc.encode slug
    iv = new Uint8Array(ivHash).slice 0, 16

    # The entire page was encrypted as one continuous stream, then split across elements. Reassemble the full cyphertext.
    totalLen = chunks.reduce ((sum, c)-> sum + c.bytes.length), 0
    allCyphertext = new Uint8Array totalLen
    offset = 0
    for chunk in chunks
      allCyphertext.set chunk.bytes, offset
      offset += chunk.bytes.length

    # Decrypt the page
    result = new Uint8Array await crypto.subtle.decrypt {name: "AES-CTR", counter: iv, length: 64}, key, allCyphertext

    # The last 4 bytes are magic (all zeros if the password is correct)
    magic = result.slice result.length - 4

    if magic.every (b)-> b is 0

      # Password is correct — distribute the decrypted HTML back to each element.
      # Each chunk's plaintext length matches its cyphertext length,
      # except the last chunk which has 4 extra bytes (the magic).
      offset = 0
      for chunk, i in chunks
        isMagic = if i is chunks.length - 1 then 4 else 0
        len = chunk.bytes.length - isMagic
        chunk.elm.innerHTML = new TextDecoder().decode result.slice offset, offset + len
        offset += len

      document.documentElement.setAttribute "journal-decrypted", ""

      # Lil easter egger
      document.querySelector("be-enticed .home-link").textContent = makeName() + " " + makeName()

    else
      document.documentElement.removeAttribute "journal-decrypted"

      # Wrong password — the decrypted bytes are garbage. Map each chunk byte to a cypher char.
      offset = 0
      for chunk in chunks
        garbled = result.slice offset, offset + chunk.bytes.length
        offset += chunk.bytes.length

        # Map each garbage byte to a cypher char
        text = (cypher[byte] for byte from garbled).join ""

        # Break into word-sized pieces so it wraps nicely
        words = while text.length > 0
          len = Math.min text.length, 2 + random() ** 2 * 9 | 0
          word = text.slice 0, len
          text = text.slice len
          word

        chunk.elm.textContent = words.join " "

    # If another keystroke came in while we were running, go again
    running = false
    if pending
      pending = false
      update()

  # Continually decrypt when typing
  input.addEventListener "input", update

  # Try to decrypt with a stored password on page load
  stored = localStorage.getItem "journal-password"
  if stored
    input.value = stored
    update()
