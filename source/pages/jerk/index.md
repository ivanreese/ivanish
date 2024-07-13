type: Song
time: 2024

---

<style> title { margin-left: 9px; } </style>

! Jerk

<div class="hero">
  <img src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk.jpg" alt="Cover art for the song — a photo of corn stocks, faded and yellow in the fall, with some hands mysteriously poking out from the back.">
</div>

> If you'd like, you can listen to an audio version of this page. It includes all the contextually relevant bits of music, and a few ad libs not included in the text. But it doesn't include the links and images, naturally.
> <p class="audio"><audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk-post.mp3" controls preload="metadata"></audio></p>

<br><br>

In 2010 I quit my job to make indie games.

My childhood friend Sterling had just finished studying comp sci at university, and I'd talked him out of going straight into the industry. Big teams, no autonomy, no vision.

He was a graphics programming savant, deeply specialized, and I could do all the other stuff. Together, we were T-shaped. We had a shared appreciation for weird, innovative games. And we each had some savings.

This was before Steam Greenlight. Before Indie Game: The Movie. The paint was still drying on the App Store. The iPad was new and nobody knew what to do with it. Maybe this big portable screen would be a great canvas for games. Hell, any day now, Flash should come to iOS. But if it doesn't, Unity seems promising, if a little restrictive.

It feels like indie games are right on the cusp of exploding, the way indie music had a few years ago.

World of Goo and Braid were surprise hits — people had an appetite for quirky, systems-driven games. Online, other indie devs were buzzing about "procedural content generation". With just one or two clever programmers, you could make _a system_ to generate all the art and levels and music for a game, what would normally take a whole team to produce. You could even make _a system_ that'd underlie your gameplay, letting you tap into new kinds of physics and feelings, breaking away from traditional genres. Could we do that?

The first game we tried to make was, almost exactly, [Jusant](https://en.wikipedia.org/wiki/Jusant) — a game where you climb up a babel-like tower, stretching from the ground to the sky, through the clouds, so high that by the end there'd be no gravity holding you down. We'd referenced Assassin's Creed and Metal Gear Solid 2, how they each so differently used the feeling of climbing way up high around the outside of a building. The sounds of the bustling city below fade away, overtaken by a stirring wind. Any interior passages would be a relief, a moment of shelter from the elements and the fear of falling, but with risks of their own. And then back out, and up.

There'd be grapple points and hanging ropes, things to swing on, ladders and jutting rocks, narrow walkways. Crumbling abandoned huts built into the rock face, ripped nets, other materials that'd vary as you ascended. There'd be no combat, maybe no other people at all — just climbing. Just the feeling of climbing, that thrill of moving deftly through a complex world (Mario, racing games) or the interplay between the space and your body (Metroid, Mirror's Edge).

That idea sucked. We couldn't procedurally generate the tower — it'd need to be hand-authored. Doing procedural character animation for climbing seemed impossible. Hell, Assassin's Creed was just a really complicated system blending hundreds of hand-authored animations.

The next game we tried was [A Shrinking Feeling](/a-shrinking-feeling). I wanted to do what Braid did — a clever twist on a classic, where you realized something was _possible_, hell it was _simple_, it was right there and nobody had done it, you could do it, you just have to be careful and do it really well, really think about what has just changed, what you can do with it, what it might mean. Braid took something that's an implicit assumption in games — time moves forward at a steady rate — and asked, "What if it didn't?" So I took this idea and generalized it by one step.

_There are things you assumed were constant, but what if they aren't?_

What other constants exist?

Scale.

In this game, your character is shrinking. Always shrinking. Sometimes faster, sometimes slower. Always shrinking. Forever.

The world around you feels familiar right now, but just wait a minute. That little enemy you could have squashed, no problem, is now quite the looming threat. But that little squiggle in the ground below you is now a crack, and then a cave, and then a cavern, and you can duck down into it to escape. You are always shrinking. The world around you, and everything in it, is always growing.

These ideas don't belong to any particular genre. But we needed to pick something to build around. So, we started with the classic: 2d side-scroller. Mario, Sonic… yeah, Braid too. But we could imagine generating these worlds procedurally. We could make _a system_. I'd draw little bits of the world as paths (not pixels), so that we could snap them together and scale them up and subdivide them into smaller fragments. We could texture them so that as you shrunk, the levels would go from looking normal and Earthly to microscopic to wildly abstract and impossible.

Sterling worked on a prototype of the game. He got something playable, and it was kinda fun! I made some placeholder art, and was working on bits of narrative, and then… and then…

_There are things you assumed were constant, but what if they aren't?_

Music! I realized that this idea, you could do this with music, too! And, _of course_, the constant that could grow or shrink, that would perfectly fit with the tone and idea of our game, was _tempo_. The music would slow down forever. As it slowed, notes would be spaced further and further apart, creating little gaps to be filled by tiny new melodies and rhythms.

I prototyped _a system_, a little music system, in Unity, and it worked!

<iframe style="width: 100%; height: 120px;" src="https://bandcamp.com/EmbeddedPlayer/album=3854177444/size=large/bgcol=ffffff/linkcol=de270f/tracklist=false/artwork=small/transparent=true/" seamless><a href="https://spiralganglion.bandcamp.com/album/a-shrinking-feeling">A Shrinking Feeling by Ivan Reese</a></iframe>

That plan sucked. We figured it'd take us months, maybe a year or more, to make this game any good. We didn't have enough money.

So we put it aside, and tried to make something else. Something simple, that we could make and release within a month, hell, a week, just to prove that we could. We made it. [And it was… fine](/breakin). But we never released it. We grew to resent each other and, due to the very human emotional mess of it all, with its many complications (like, say, the fact that I was dating his brother), Sterling and I parted ways… almost amicably. I went back to my old job. He went off and worked at big tech companies (eventually joining Apple Vision around the time it was just getting started).

But I couldn't let go of this idea.

_There are things you assumed were constant, but what if they aren't?_

In 2012, I was making a little home for myself in the _sound art_ scene. There was a program director at a major performing arts center who became quite fond of my _systems_. She kept feeding me opportunities to exhibit and perform and mingle with other artists. It felt like she was almost just handing me a new career.

<style>
  #opportunities {
    margin: 1em 0;
    md { display: block; max-width: 50% } /* MAYBE THIS IS WRONG NOW?? */
    .a { margin-left: 30%; max-width: 60% }
    .b { margin-left: 10% }
    .c { margin-left: 60% }
    .d { margin-left: 30% }
    .e { margin-left: 50% }
  }
</style>

<div id="opportunities">

<md class="a">A [year-long installation](/plus-15-installation) with an array of speakers mounted in a walkway through a corporate office complex, that I could blast with bizarre time-stretching noise music.</md>

<md class="b">A [series](/the-unlimited-dream-company) of [performances](/mary-everest-boole) at the premiere sound art [festival](/a-d) in the city, and points [beyond](/are-we-small-yet).</md>

<md class="c">Invited artist talks.</md>

<md class="d">Workshops and demos.</md>

<md class="e">Parties.</md>

</div>

All of it was this shrinking music.

I came very, very close to quitting my job (again) to make a career of this sound art stuff. But… all of these gigs involved signing contracts, and these contracts came with exclusivity rules.

For instance. I'd been invited (by a _different_ program director at a competing performing arts center, haha) to join an experimental dance troupe to develop a new show. We'd rehearse for a few months, full days, 6 days a week. We'd do a run of shows locally, and then go on tour. But the local run of shows coincided with a sound art festival at _the other place_. I'd already been booked to perform there. And this was against the rules.

> We're putting your name on the bill, which means people are coming to see you. That means you can't be on another bill elsewhere in town at the same time, because that'll split your audience, and we won't sell as many tickets.

That deal sucked. I did the math and, at the rate I was booking gigs, and for how much these gigs paid, and for how much time they'd take, and for having to quit my current job to put that time in… I wouldn't make it. I didn't have enough money.

I stopped doing sound art. I moved out from the city, to live with my [girlfriend](/err) in a condo at the edge of town. It was a condo, so I couldn't make any music. My last album — [unfinished, at that](/sneaky-dances) — is from 2014.

But I refused to let go of this idea.

_There are things you assumed were constant, but what if they aren't?_

In 2016 I was learning more and more about coding. Watching Strange Loop talks. Building stuff in the browser. (Flash was not coming to the iPhone, sigh.) Picking up ClojureScript.

I [rebuilt the shrinking music](/diminished-fifth) in ClojureScript, in the browser. It sounded great. I loaded it up with samples from my last few albums, so that it sounded rich and textured and grounded in reality. I didn't just make it go slower forever, or faster forever — I gave it a custom function, interacting sine waves generating accelerations that'd pull it back and forth like an [infinite series diverging into the horizon](https://w.wiki/3Q9H).

But that was it. A little side project.

Life slowed down.

I moved away from the city. Slower.

I built a house in the woods. Slower.

I had a kid. Much slower.

I make computer programs,

and that's about it. To a crawl.

That's the version of me you probably first met.

_There are things you assumed were constant, but what if they aren't?_

I am tired of being a computer programmer. I am tired of writing code. It is a grid of letters. It is monospaced. It does not move. You cannot make it shrink and grow, stretch it out, squish it together. Well… [maybe you can](/hest-time-travel). <small>You just have to get away from static text. <small>You need to be in an environment where it makes sense for things to shrink and grow, <small>for cracks to open up that you can slip down inside.</small></small></small>

And I am bored of not making music.

A friend of my mother's, a widow whose husband used to play professionally, is getting rid of a beautiful old upright piano. An elderly man, a retired church pastor, is selling the beautiful antique pump organ from his old church.

I have all these instruments.

&nbsp;&nbsp;&nbsp;<small>I have a few remaining microphones that aren't broken.</small>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<small><small>I have the weekend to myself once in a while.</small></small>

<br><br>

I've started noodling again.

<p class="audio">
  <span>Jerk (Improv)</span>
  <audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk-rough.mp3" controls preload="metadata"></audio>
</p>

<br><br>

I've started turning these noodles into tunes.

<p class="audio">
  <span>Jerk (Progression)</span>
  <audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk-demo.mp3" controls preload="metadata"></audio>
</p>

<br><br>

I've started [normalizing sharing](https://mastodon.social/@spiralganglion/112062486570705551).

<style>
  .hero.normalize {
    text-align: left;
    margin-left: 3vw;
    img {
      box-shadow: -1em 2em 3em -1em #313338;
      rotate: -1deg;
      border-radius: .5em;
      width: 20em;
    }
  }
</style>
<div class="hero normalize">
  <a href="https://mastodon.social/@spiralganglion/112062486570705551">
    <img alt="a mastodon post: normalize sharing whatever this song is going to turn into, before it's turned into that" src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/normalize.jpg">
  </a>
</div>

<br><br>

One thing I've always wanted to do is record some of this shrinking/growing music with real instruments.

I tried a few times. In Ableton Live, my music software of choice, you can control how different parts of the sound should change throughout the course of a song. You can make the volume go up and down, or bring in some echo right when you need it. You can also control the tempo! You draw a graph showing how the tempo should change. You can make the change sudden, or you can make it gradual.

Live's tempo control sucks. It updates these values in small little steps, each step the size of a 32nd note. Every time it takes one of those steps, you can hear a little pop or glitch from the changing tempo. (Ableton heads: this seems to happen even if you're not using warp modes. It's fucked up.)

So instead of relying on this broken tool, I just made my own. I took my old ClojureScript shrinking music program, and turned it into a [metronome](https://mastodon.social/@spiralganglion/112062689066098055).

<style>
  .hero.metro {
    text-align: right;
    margin-right: 5vw;
    img {
      box-shadow: -1em 2em 3em -1em #25282c;
      rotate: .4deg;
      border-radius: .5em;
      width: 30em;
    }
  }
</style>
<div class="hero metro">
  <a href="/jerk/metronome">
    <img alt="screenshot of the metronome" src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/metro.png">
  </a>
</div>

<br><br>

I recorded that metronome into Ableton Live, so that I could listen to the sound of something smoothly speeding up _forever_ and record along with it.

Speeding up, yes. I'd tried it both ways. I knew how they each felt. Slowing down is sedate. Contemplative. I wanted to shake out the cobwebs. I wanted to go faster. I wanted that thrill of moving deftly through a complex world, the interplay between the space and my body.

<style>
  .hero.moire {
    text-align: center;
    img {
      box-shadow: -1em 2em 3em -1em #313338;
      rotate: -.3deg;
      border-radius: .5em;
      width: 40em;
    }
  }
</style>
<div class="hero moire">
  <img alt="Screenshot of the metronome recorded into Ableton Live, looking very much unlike a regular pattern, with wavy moire interference lines." src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/moire.png">
</div>

<br><br>

In early March, I had the house to myself for a few days. I recorded piano, and drums, guitar, and bass.

For every layer, I'd hit *record* and start playing along… slowly at first, and the metronome would get faster, and I'd play faster. And it'd keep getting faster, and I'd keep playing faster, until I started to make mistakes. And I'd keep playing faster, and the mistakes would compound, and the sounds would smush together until I was playing total nonsense, and the rhythms would drift out of alignment until I couldn't keep up at all. Hit stop.

Then I'd pick up a different instrument, and start recording again, a little later on in the song when things were already fast, but I'd start relatively slowly — half time, quarter time.

After I had a bunch of layers, I started mixing them together. EQ. Compressor. Reverb. Gain. I'd turn each layer down until you could barely hear it. Hide all the sounds behind each other. Every sound in the song is hidden behind the song. In psychoacoustics, this is called "[masking](https://en.wikipedia.org/wiki/Auditory_masking)", and I _love_ doing it.

I noticed that this song was… fun. You could loop a few bars, and they'd _ever so slightly_ push and pull at your feeling of time. Then loop the next few bars, and they'd do it again. So that's how I worked — advance the loop, fix the sound, advance the loop, fix the sound, advance the loop, fix the sound…

<style>
  .hero.faster {
    text-align: right;
    iframe:not(:fullscreen) {
      display: inline-block;
      width: 40em;
      border-radius: .5em;
      rotate: 3deg;
      margin: 0;
      box-shadow: -1em 2em 3em -1em #313338;
    }
    p {
      margin-right: 5em;
      font-size: .8em;
      rotate: 3deg;
    }
  }
</style>
<div class="hero faster">
  <iframe class="youtube" src="https://www.youtube-nocookie.com/embed/CoP1bg1GQTM?rel=0&showinfo=0" frameborder="0" allowfullscreen></iframe>
  <p>(I don't know why I look so angry in that video. I was feeling good. Maybe just concentrating.)</p>
</div>

The song was taking shape.

It had a weird B-section, and I kinda liked it, but it wasn't quite working. When I record a song, I usually like to try at least one or two new ways of playing an instrument. This song has two.

* First, the kick drum hits all coincide with a staccato blast of bass from the pump organ — a technique I picked up from Louis Cole, an [incredible drummer](https://www.youtube.com/watch?v=Ois3gfcwKSA) who [uses his left hand](https://www.youtube.com/watch?v=hT7x1NvGf5k) on a keyboard to play basslines in sync with his kickdrum. Of course, my drum kit and pump organ are in separate rooms, and not easily moved, so I had to record them separately. That was a chore, but I love how it turned out.
* Second, there's a distorted bass guitar. You don't hear distorted bass all that often, and the song already has a pretty thick low end from the pump organ, so I figured some crunchy bass guitar would sit nicely in the low-hundred Hz. I have a little fender amp that sounds shockingly good considering how small and cheap it is. I played a P-bass through the gain channel, and it sounded snarly as hell.

The snarly bass begged for crash cymbals, which screamed for icy piano… and the song sort of accidentally wound up with a tacky Nu Metal breakdown in the middle. Oops.

<p class="audio">
  <a download href="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk-nu-metal.mp3">Jerk (Nu Metal)</a>
  <audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk-nu-metal.mp3" controls preload="metadata"></audio>
</p>

<br><br><br>

At the end of the weekend, I sent the song to my friend Lu — maybe they'd want it for [their video](https://www.todepond.com/pondcast/finding-ninety-nine-sands/)?

<style>
  .hero.lu {
    box-shadow: -1em 2em 3em -1em #313338;
    rotate: -1deg;
    max-width: 30em;
    border-radius: .5em;
    overflow: hidden;
  }
</style>

<div class="hero lu">
  <img alt="Screenshot of a conversation with Lu, where I ask if I should release the song, save it for something, not release it. They tell me to save it, and release it, and not not release it." src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/lu.png">
</div>

I didn't release it. I kept working on it for a while. Trying to carve away sections where my playing was trash, or I'd made instrument choices that weren't working.

Lu used it in a video after all (along with another "song" I made by chopping up a bunch of my older songs and scrambling them together).

<style>
  .hero.torn {
    text-align: center;
    iframe:not(:fullscreen) {
      display: inline-block;
      width: 36em;
      border-radius: .5em;
      rotate: -.2deg;
      margin: 0;
      box-shadow: -1em 2em 3em -1em #313338;
    }
  }
</style>
<div class="hero torn">
  <iframe class="youtube" src="https://www.youtube-nocookie.com/embed/-FgAHiI3ZNY?rel=0&showinfo=0&si=yfqhucJy2hi4Mu8x" frameborder="0" allowfullscreen></iframe>
</div>

<br><br><br>

Over the following months, whenever I had some time alone, I added more instruments. Bass clarinet. Tuba. A little cheapo Casio. Shakers. Melodica. Recorder.

I wanted the song to have lyrics and a main vocal line. But the shrinking _meant_ something to me, so the lyrics would need to _mean_ something, and I… [don't do that](/dont-do-math) anymore.

So now I've given up on it. The song is not finished. It's abandoned. But I'm okay with that.

<iframe style="width: 100%; height: 120px;" src="https://bandcamp.com/EmbeddedPlayer/track=716744794/size=large/bgcol=ffffff/linkcol=de270f/tracklist=false/artwork=small/transparent=true/" seamless><a href="https://spiralganglion.bandcamp.com/track/jerk">Jerk by Spiral Ganglion</a></iframe>

<br><br>

The mix is trash. The day I released it, right before the final render, I made the organ too loud at the start, and I'm going to resent that forever. The drums sound fake. The guitar playing is sloppy. The A-section desperately needs a countermelody (which… was supposed to be the vocals). The recorder is too loud. The B-section (that used to be Nu Metal) feels stilted and vacant. The later part is dull, but yet the ending comes too quickly. The melodica is cheesy. The recorder is cheesy. The main melody is cloying and predictable and childish. None of the section transitions flow. The song sucks.

<br><br>

<p class="audio">
  <a download href="https://d3um8l2sa8g9bu.cloudfront.net/jerk/a2.mp3">2nd A-section</a>
  <audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/a2.mp3" controls preload="metadata"></audio>
</p>

The 2nd A-section, at 2:23, is… fucking great. It makes me so happy. It was a total accident, too. Everything just worked together, right from the get go, totally unplanned. Sure, it's just a drone on E, but who cares, it grooves. And that trashy [china](https://en.wikipedia.org/wiki/China_cymbal)-esq crash cymbal that keeps coming in and out (at double duration each time — eighth notes, then quarter, half, whole, breve) sits _perfectly_ in the mix. See, look what happens when I pull it out…

<p class="audio">
  <a download href="https://d3um8l2sa8g9bu.cloudfront.net/jerk/trash.mp3">Trash</a>
  <audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/trash.mp3" controls preload="metadata"></audio>
</p>

…it sounds like junk by itself! But it just _melts_ into place with everything else around it. I've never used this cymbal before _because it sounds like junk_, so I had no idea it could _do this_. And you can't quite perceive it, but there's a shaker doubling that cymbal, too. This is called "masking", and I love doing it.


<style>
  .hero.cymbals {
    text-align: center;
    img {
      width: 45em;
      border-radius: 1em;
      rotate: -5deg;
      box-shadow: -1em 2em 3em -1em #313338;
    }
    p {
      font-size: .8em;
      rotate: -5deg;
    }
  }
</style>
<div class="hero cymbals">
  <img alt="My drum kit, with a dozen-ish weird cymbals. The kit is decorated with little fake plants, a John Deere tractors flag, a small plastic bust of Darth Maul, bright orange flagging tape, a tiny boob, and other nonsense doodads." src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/cymbals.jpg">
  <p>(Someday I'll tell the story of how I got all these cymbals.)</p>
</div>

<br><br>

There's an imperceptible little draaag where all the instruments slow down a tiny bit, and then they all race ahead to catch up to the beat. I did it by accident when recording the very first drum track, and then just repeated the same mistake in every layer that followed. The drag is so small, but it feels so weirdly good to just stretch out how you feel the moment passing. The interplay between the space and your body.

<p class="audio">
  <a download href="https://d3um8l2sa8g9bu.cloudfront.net/jerk/drag.mp3">Drag</a>
  <audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/drag.mp3" controls preload="metadata"></audio>
</p>

<br><br>

And the song, it _almost_ does one more thing. A very special thing. A thing that I always, always wanted the shrinking to do. I've been trying to make it do. For over a decade. For 14 years now. And a half. Almost fifteen. Years. Now.

> _There are things you assumed were constant, but what if they aren't?_

My goal for the shrinking is that it should _mean_ something. When something shrinks, or it grows, it should say something. You should feel something. If the shrinking and growing doesn't express anything, if it's just a cool trick, that's wrong. It's wrong.

[A Shrinking Feeling](/a-shrinking-feeling), the game, was going to use its constant shrinking to say something: "if you leave a little thing alone, a little nagging worry, a little problem, it'll grow and grow until you can't deal with it any more… but you can slip away from it, and leave it behind… and that's just fine. you keep changing. you'll never stop changing. the you that was threatened by that thing is gone. there's a new you now."

I haven't figured out what the shrinking _music_ should say. I had something in mind for this song, that I could say through some lyrics, but… I [don't do that](/dont-do-math) anymore.

But I need to do one thing first, with this music, to eventually be able to say something with it: I need to know I can make you not notice the shrinking. It should feel natural. It's a means to an end, not an end in itself.

Am I a good enough musician to pull that off? Probably not. I didn't quite get there, this time. But I think I got close. For most of the song, it's so smooth, but then at moments it's jarring. But when I tap my fingers together, keeping time, speeding up, the smooth bits and the jarring bits feel the same. I came so close with this one.

I'll probably come back to this idea again. I don't want to make music that only speeds up forever, or slows down forever. I want to find a way to make the tempo change, and the change of tempo change, and the change of the change of tempo change. (That's why the song is called "Jerk" — _I'm a jerk because I didn't do [the thing](https://en.wikipedia.org/wiki/Jerk_(physics))_.)

And unlike the tower game, (and the other ideas we had, some of which have [appeared](https://en.wikipedia.org/wiki/Everything_(video_game)) elsewhere), I haven't seen anyone do a shrinking game. So I'll probably come back to that too.
