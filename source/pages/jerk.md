type: Song
time: 2024

---

! Jerk

<div class="hero">
  <img src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk.jpg" alt="Cover art for the song — a photo of corn stocks, faded and yellow in the fall, with some hands mysteriously poking out from the back.">
</div>

In the fall of 2010 I quit my job to go make indie games.

My friend Sterling finished comp sci at university, and I'd talked him out of getting an industry job. Big teams, no autonomy, no vision.

We each had some savings. He was a graphics programming savant, I had… other skills. We had similar tastes in weird games.

This was before Steam Greenlight. Before Indie Game: The Movie. The paint was still drying on the App Store. The iPad launched, and maybe this big portable screen would be a great canvas for games. Hell, any day now, Flash would come to iOS. But if it didn't, this new engine Unity seemed promising. It felt like indie games were right on the cusp of exploding, the way indie music had a few years ago.

World of Goo and Braid were surprise hits — people had an appetite for quirky, systems-driven games. Online, other indie devs were buzzing about "procedural content generation". With just one or two clever programmers, you could make _a system_ to generate all the art and levels and music for a game, one that'd normally take a whole team to produce. You could even make _a system_ that'd underlie your gameplay, letting you tap into new kinds of physics and feelings, breaking away from the old game genres. Could we do that?

The first game we tried to make was, almost exactly, [Jusant](https://en.wikipedia.org/wiki/Jusant) — a game where you climb up a babel-like tower, stretching from the ground to the sky, through the clouds, so high that by the end there'd be no gravity holding you down. We'd referenced Assassin's Creed and Metal Gear Solid 2, how they each so differently used the feeling of climbing way up high around the outside of a building. The sounds of the bustling city below fade away, overtaken by a stirring wind. Occasionally an interior passage would appear, giving you a moment of respite from the height and elements. And then back out.

There'd be grapple points and hanging ropes things to swing on. There'd be no combat — just climbing. The emphasis would be on the feeling of climbing, that incredible rush of speeding through a world (Mario) or the interplay between the space and your body (Metroid).

That idea sucked. We couldn't procedurally generate the tower — it'd need to be hand-authored. Doing procedural character animation for climbing seemed impossible. Hell, Assassin's Creed was just a really complicated system blending hundreds of hand-authored animations.

The next game we tried was [A Shrinking Feeling](/a-shrinking-feeling). I wanted to make like Braid — a clever twist on a classic, where you realized something was _possible_, hell it was _simple_, it was right there and nobody had done it, you could do it, you just have to be careful and do it really well. What did Braid do? They took something that's an implicit assumption in games — time moves forward at a steady rate — and they asked "what if it wasn't?" So I took this idea and generalized it by one step. _There are things you assume to be constant, but what if they weren't?_. What other constants exist?

Scale.

In this game, your character is shrinking. Always shrinking. Shrinking at a constant rate. Forever. The world around you is small right now, but just wait a minute. That little enemy you could have squished, no problem, is now quite the looming threat. But that little squiggle in the ground below you is now a crack, and then a cave, and then a cavern, and you can duck down into it to escape.

These ideas don't belong to any particular genre. But we needed to pick something to build around. So, we started with the classic: 2d action-adventure. Mario, Sonic… yeah, Braid too, sigh. But we could imagine generating these environments procedurally. We'd make little fragments of geometry defined as paths (not pixels), so that we could snap them together and scale them freely and then subdivide them recursively on the fly. We could texture them dynamically, so that as you shrunk the levels would go from looking normal and Earthly to microscopic to wildly abstract and impossible.

Sterling worked on prototypes of the shrinking engine. He got something playable, and it was kinda fun! I made some placeholder art, and was working on bits of narrative, and then… and then…

Music! I realized that this general idea — _There are things you assume to be constant, but what if they weren't?_ — you could do this with music, too! And, of course, the constant you could mess with in music, that would _immediately_ fit with the tone and idea of our game, was tempo. The music would slow down forever. As it slowed, the notes would stretch further and further apart, creating little gaps to be filled by tiny new melodies and rhythms.

I prototyped this music in Unity, and it sounded _great!_

<iframe style="width: 100%; height: 120px;" src="https://bandcamp.com/EmbeddedPlayer/album=3854177444/size=large/bgcol=ffffff/linkcol=de270f/tracklist=false/artwork=small/transparent=true/" seamless><a href="https://spiralganglion.bandcamp.com/album/a-shrinking-feeling">A Shrinking Feeling by Ivan Reese</a></iframe>

But… the game's development went poorly. It would take us many months, maybe a year or more, to make this one any good. We didn't have enough money saved up. So we put it aside, and tried to make [something else](/breakin). Something simple, that we could make and release within a month, just to prove that we could. We made it. And it was… fine. But never released it. We grew to resent each other and, due to the very human emotional mess of it all, with its many complications (like, say, the fact that I was dating his brother), Sterling and I parted ways… almost amicably. I went back to my old job. He went off and worked at big tech companies (eg: Apple Vision early on).

But I refuse to let go of this idea.

_There are things you assume to be constant, but what if they weren't?_

In 2012, I kept making _shrinking music_. And, naturally, _growing music_ — music that gets faster and faster forever.

I got involved with the sound art scene in Calgary. There was an artistic director at a major performing arts center who became quite fond of my musical experiments. She kept feeding me gig after incredible gig.

A [year-long installation](/plus-15-installation) with an array of speakers mounted in a walkway through a corporate office complex, for me to blast them with bizarre time-stretching noise music — for an entire year!

A [series](/the-unlimited-dream-company) of [performances](/mary-everest-boole) at the premiere sound art [festival](/a-d) in the city, and festivals [beyond](/are-we-small-yet).

An invited artists' talk. Workshops. Parties.

All of it was this shrinking music.

I came very, very close to quitting my job (again) to make a career of this sound art stuff. But… all of these gigs involved signing contracts, and these contracts came with exclusivity rules.

For instance, I'd been invited to join an experimental dance troupe to develop a new show. We'd rehearse for a few months, full days, 6 days a week. We'd do a run of shows locally, and then go on tour. But the local run of shows coincided with another sound art festival. And that was against the rules. "We're putting your name on the bill, which means people are coming to see you. That means you can't be on another bill elsewhere in town at the same time, because that'll split your audience, and we won't sell as many tickets."

I did the math. At the rate I was booking gigs, and for how much these gigs paid, I wouldn't be able to make enough to live on.

I stopped doing sound art. I quit my bands. I moved away from the city center, to live with my [girlfriend](/err) in a condo at the edge of town.

But I refuse to let go of this idea.

_There are things you assume to be constant, but what if they weren't?_

In 2016 I was learning more and more about coding. Watching Strange Loop talks. Building stuff in the browser. (Flash was not coming to the iPhone, sigh.) Picking up ClojureScript.

I [rebuilt the shrinking music](/diminished-fifth) in ClojureScript, in the browser. It sounded great. I loaded it up with samples from my last few albums, so that it sounded rich and textured and grounded in reality. I didn't just make it go slower forever, or faster forever — I gave it a custom function, interacting sine waves generating accelerations that'd pull it back and forth like an [infinite series diverging into the horizon](https://en.wikipedia.org/wiki/1_%E2%88%92_2_%2B_3_%E2%88%92_4_%2B_⋯).

But that was it. A little side project.

And aside from that, and an [unfinished album](/sneaky-dances) in 2014, I stopped making music entirely.

I stopped doing sound art. I quit my bands. I moved away from the city. I built a house in the woods. I had a kid. I make computer programs. That's the version of me you probably know.

_There are things you assume to be constant, but what if they weren't?_

I'm tired of just being a computer programmer. I'm tired of writing code. It's a grid of letters. It's monospaced. It doesn't move. You can't make it shrink and grow, stretch it out, squish it together.

Well, wait. I think [maybe you can](/hest-time-travel). You just have to get away from static text. You need to be in an environment where it makes sense for things to shrink and grow, for cracks to open up that you can slip down inside.

And I'm bored of not making music. A friend of my mother's, a widow whose husband used to play professionally, is getting rid of a beautiful old upright piano. An elderly man, a retired church pastor, is selling the beautiful antique pump organ from his old church.

I have all these instruments, and a few of my microphones aren't broken, and I have the weekend to myself once in a while.

I've started noodling again.

<audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk-rough.mp3" controls preload="metadata"></audio>

I've started turning these noodles into tunes. I've started [normalizing sharing](https://mastodon.social/@spiralganglion/112062486570705551).

<audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/jerk-demo.mp3" controls preload="metadata"></audio>

Alright, time to dust off the general idea.

One thing I've always wanted to do is record some of this shrinking/growing music with real instruments. I tried a few times. In Ableton Live, my music software, you can control how parts of your audio should change throughout the course of a song. You can make the volume go up and down, or bring in some reverb right when you need it. You can also control the tempo! You draw a line of how the tempo should change. You can make the change sudden, or you can make it gradual.

It sounds like shit. Ableton updates these values in small little steps, each step the size of a 32nd note. Every time it takes one of those steps, you can hear little pops and glitches from the changing tempo. (Ableton heads: this seems to happen even if you're not using warp modes. It's fucked up.)

So instead of relying on my usual music tools, I made my own. I took my old ClojureScript shrinking music, and turned it into a [metronome](https://mastodon.social/@spiralganglion/112062689066098055).

I recorded that metronome into Ableton Live, so that I could reference the sound of something speeding up _forever_ and record along with it.

I recorded piano, and drums, and bass guitar. It sounded great.

<iframe class="youtube" src="https://www.youtube-nocookie.com/embed/CoP1bg1GQTM?rel=0&showinfo=0" frameborder="0" allowfullscreen></iframe>

I kept adding instruments. Bass clarinet. Tuba. A little cheapo Casio. Shakers.

For every layer, I'd hit *record* and start playing along… slowly at first, and the metronome would get faster, and I'd play faster. And it'd keep getting faster, and I'd keep playing faster, until I started to make mistakes. And I'd keep playing faster, and the mistakes would compound, and the would smush together until I was playing total nonsense, and the rhythms would drift out of alignment until I couldn't keep up at all. Hit stop.

Then I'd pick up a different instrument, and start recording again, a little later on in the song when things were already fast, but I'd start playing more slowly — half time, quarter time.

The song was taking shape. I sent it to my friend Lu — maybe they'd want it for [their video](https://www.todepond.com/pondcast/finding-ninety-nine-sands/)?

<style>
  .hero.lu {
    box-shadow: -1em 2em 3em -1em #313338;
    rotate: 2deg;
    max-width: 30em;
    border-radius: .5em;
    overflow: hidden;
  }
</style>

<div class="hero lu">
  <img alt="Screenshot of a conversation with Lu, where I ask if I should release the song, save it for something, not release it. They tell me to save it, and release it, and not not release it." src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/lu.png">
</div>

I didn't release it. I kept mixing it. Trying to carve away sections where my playing was trash, or I'd made instrument choices that weren't working. I wanted the song to have lyrics and a main vocal line, but I… [can't](/dont-do-math).

So I gave up on it. The song is not finished. It's abandoned.

<p class="audio">
  <a download href="https://d3um8l2sa8g9bu.cloudfront.net/jerk/Jerk.mp3">Jerk</a>
  <audio src="https://d3um8l2sa8g9bu.cloudfront.net/jerk/Jerk.mp3" controls preload="metadata"></audio>
</p>


The mix is trash — I made the organ too loud at the start, right before I released it. The 2nd verse, at 2:30-ish, is my favourite part… but I couldn't make the rest of it live up to that moment. The ending sort of tails off.

But it _almost_ does do one thing. One special thing. A thing that I wanted it to do, from the outset.

> _There are things you assume to be constant, but what if they weren't?_

My new goal for the shrinking music is that it should _mean_ something. When the music shrinks, or it grows, it should be saying something. If the shrinking and growing doesn't express any idea, if it's just a cool trick, that's wrong.

A Shrinking Feeling, the game, was going to use the constant shrinking to say something — "if you leave a little thing alone, a little nagging worry, a little problem, it'll grow and grow until you can't deal with it any more… but you can slip away from it, and leave it behind… and that's just fine. you keep changing. you'll never stop changing. the you that was threatened by that thing is gone. there's a new you now."

I haven't figured out what the shrinking music should say. I had something in mind for this song, but… didn't get there yet. But I needed to do one thing to be able to say anything at all: you shouldn't notice the shrinking. It should feel natural. It's a means to an end, not an end in itself.

Am I a good enough musician to pull that off? Probably not. But I think I got close. I only notice the changing tempo at certain moments. For most of the song, it's so smooth.

I'll probably come back to this general idea again. I don't want to make music that only speeds up forever, or slows down forever. I want to find a way to make the tempo change, and the change of tempo change, and the change of the change of tempo change. (That's why the song is called "Jerk" — I'm a jerk because I didn't do this, even though the [joke](https://en.wikipedia.org/wiki/Jerk_(physics)) is right there.)

And unlike the tower game, (and the other ideas we had, some of which have [appeared](https://en.wikipedia.org/wiki/Everything_(video_game)) elsewhere), I haven't seen anyone do the shrinking game. So I'll probably come back to that too.
