main: id="blog" class="types"
desc: Rubbing two brain cells for warmth.

---

! Blog

<style>
  main {
    position: relative;
  }
  #podes {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 1600px;
    z-index: -1;
  }

  @media (prefers-color-scheme: dark) {
    body { background: hsl(0, 0%, 6%); }
    main { color: hsl(0, 0%, 70%); }
    a:hover, a:visited:hover { color: #FFF; }
  }

  title {
    font-weight: 900;
  }

  h1 {
    font-size: 2em;
    font-weight: 900;
  }
</style>

<!--
<script type="importmap">{"imports": {"gl-matrix": "/js/gl-matrix/gl-matrix.js"}}</script>
<script type="module" src="podes.js"></script>
-->

<section id="posts">

  Hey, this page is… to say it is under "active development" would be misleadingly auspicious. This blog is palliative care for my ambitions. My big ideas lie here, wrong, like yolk seeping down the nest. If I haven't sent you a link to a specific post, then these pages aren't for you — they're for me. But… you can read them, because you understand.

  # 2024
  [Stage Fright (Stub)](/stage-fright)

  this shouldn't be under "blog" because it's a project:
  [Body Issues (Stub)](/body-issues)

  [Get off Slack (Stub)](/get-off-slack)
  [Criticism (Draft)](/criticism)

  I should do posts about:
  * Hyperzine, as a proto local-first app, which used the filesystem itself as database (and point of coordination between multiple apps)
  * The experience of writing code in a specific PL that's meant to be legible to people who don't know that PL.
  * My experiences living with rural internet — no cell service (for SMS 2FA), 1s RTT, the whole trustd fiasco — and the web dev skills / tech aesthetics I've developed in this environment (subsetting fonts, hand-optimizing SVGs, optimizing images before I share them so the upload is quicker, avoiding JS/CSS dependencies entirely, menu bar widget showing my network traffic, TripMode). Maybe also talk about what a goddamn quality-of-life difference Starlink has made (allowing me to do calls, meaning I can a podcast and work for I&S).

  # 2021
  [Workspace: 2021 (Pointless)](/workspace-2021)

  # 2019
  [Steve Krouse's Lunch with Alan Kay (Dumb)](/lunch-with-alan-kay)
  [Art Programming (Draft)](/art-programming)

  # 2018
  [Mental Models (Draft)](/mental-models)
  [Sound Theory (Draft)](/sound-theory)
  [Correspondence (Dumb Draft)](/correspondence)

</section>

<style>
  #posts {
    a {
      display: block;
      margin: .5em 0;
      font-size: 1.4em;
    }

    h1 {
      margin: 1em 0 0;
    }
  }
</style>

<section id="blogroll">

  # Blogroll

  [droqen](https://kinopio.club/loading--c6rgUnlHCH8386yogunZ-)
  [eli_oat](https://eli.li)
  [Jimmy Miller](https://jimmyhmiller.github.io)
  [Justin Barclay](https://justinbarclay.ca/)
  [Kartik Agaram](http://akkartik.name)
  [Mariano Guerra](https://marianoguerra.org)
  [Szymon Kaliski](https://szymonkaliski.com/)
  [tevis thompson](http://tevisthompson.com/)
  [TodePond](https://todepond.com)
  [tonsky.me](https://tonsky.me/)
  [Xavier Lambein](https://lambein.xyz)

</section>

<style>
  #blogroll {
    h1, a {
      display: inline-block;
      rotate: -12deg;
      margin-bottom: 1em;
    }
  }
</style>

<section>

  # How I Blog

  Most of this website, I talk about what I do. It's a scrapbook. The audience is me. A deeply personal website.

  Here, I tell you what to do. I talk to you. It's a soapbox. The audience is you. Still, a deeply personal website.

  <br><br>

  I work on posts in the open. They'll live here, flagged as some sort of draft, until they're done. When they're done, I'll add them to my [RSS feed](/rss).

  <br><br>

  Why do I even need a blog? If I'm writing about something, then that *thing* is the category for the writing. Like, if I write about Hyperzine, that should go under Code. So maybe the blog should only be for things that I think about, or want to talk about, that have nothing to do with something I've made.

</section>
