type: Toy
time: 2023

---

<style>
  .full-width iframe {
    margin: 0 5vw;
    width: 90vw;
    background: #f2f2f2;
  }
</style>

! Magnetic Fields

I tried to learn how magnets work by making them from scratch.

---

In the below simulation, you can drag the white dot at the center.

<div class="full-width">
  <iframe frame-src="https://d3um8l2sa8g9bu.cloudfront.net/magnetic-fields/wire/index.html"></iframe>
</div>

This first experiment (above) was about simulating the field around a single wire carrying DC.

The wire is pointing straight out of the screen, so the field around it looks like a circle.

The particles are flowing in the direction of magnetic North. The blue glow around the wire shows the strength of the field, but it doesn't show anything about the polarity.

---

In the below, try dragging one dot on top of the other. Looks like a pulsar, hey?

<div class="full-width">
  <iframe frame-src="https://d3um8l2sa8g9bu.cloudfront.net/magnetic-fields/wires/index.html"></iframe>
</div>

This experiment (above) involved two wires, each carrying the current in opposite directions (outward on the left, inward on the right).

I decided that the story behind the particles is that they're what you'd get if you broke compass needles in half, and each half was purely attracted toward its preferred magnetic pole.

Physically impossible (probably), kinda nonsense, but very useful for exploring the space intuitively.


<div class="full-width">
  <iframe frame-src="https://d3um8l2sa8g9bu.cloudfront.net/magnetic-fields/wiress/index.html"></iframe>
</div>

More wires now, to better understand if the way I'm modelling the field actually works the way it ought to.

And it super doesn't!

For instance, the glows around wires (showing field intensity) now incorporates a bit of info about polarity. But it's wrong!

So I did a bunch more research, rewrote the code so that it runs on the GPU, and set up a rough SDF model of an electric motor:

<div class="full-width">
  <iframe frame-src="https://d3um8l2sa8g9bu.cloudfront.net/magnetic-fields/rmf/index.html"></iframe>
</div>

Now we're talking! The glows now show poles — red is a North pole, blue is a South pole. The dots around the outside are the 12 coils of wire in the stator, carefully arranged to turn 3-phase AC power into something called an RMF or Rotating Magnetic Field.

You can turn "Rotor Strength" down to zero and then all you'll see is the RMF. I was so thrilled when I got this working, and the field rotated smoothly.

I learned a lot from this project — I'll do a more detailed writeup in the future.
