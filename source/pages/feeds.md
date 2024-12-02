type: Blog
time: 2024
publish: 2024-12-01
---

! Feeds

<style>
  /* Hey, thanks for checking out my CSS feed! */

  /* The CSS rules on my site are where I experiment. Hacks abound. Bad is practiced. But, hey, best foot forward: */
  @supports(background-image: linear-gradient(in oklch, color(display-p3 0 0 0), #000)) {

    .easter-egg {
      background-image: linear-gradient(to right in oklch, color(display-p3 .2 0 .2), color(display-p3 0 .2 0));
      background-clip: text;

      /* DYK? This isn't technically a prefix — it's a compat standard. Cursed. */
      /* https://compat.spec.whatwg.org/#the-webkit-text-fill-color */
      -webkit-text-fill-color: transparent;
    }

  }
</style>

I think RSS is the bee's knees!

There are two ways to consume my website via your feed reader of choice:

<section>

## My RSS feed: [ivanish.ca/rss](/rss)
This is a normal-ass RSS feed. Whenever I publish a new page / post on my site, it goes in the feed. When I substantially update an existing page / post, it gets a fresh date and rolls in at the top of the feed.

Syndicated gardening!

</section><section>

## My CSS feed: [ivanish.ca/css](/css)
This is the sicko-mode RSS feed, for real web-heads. It's mostly the same as the RSS feed, but instead of publishing the *content* of each post / page, it just publishes the <span class="easter-egg">custom style rules.</span>

It's my love letter to CSS, my favourite programming language.

This is a fun way to get a notification when I publish a new post / page, and then you can click through and read it on my site — you know, to see how the styles look when executed lovingly by your browser.

(This was also my first ever [December Adventure](/december-adventure) project.)


</section><section>

Who knows, maybe I'll come up with some more fun `_SS` acronyms and make feeds for them.

</section>
