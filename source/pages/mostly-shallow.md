type: Toy
time: 2023
publish: 2024-12-24

---

<style>
  body {
    color: white;
    background: black;
  }

  main img {
    margin: 3em 0;
    max-width: 100%;
  }
</style>

! Mostly Shallow

I'm slowly teaching myself Swift by making a few little toy iOS apps. One of them is this "depth camera" that I use as a webcam for live streams and for taking portraits of friends at conferences.

It works by using the depth data from my iPhone's camera combined with the video feed from the camera. Every frame, it generates a dot per pixel of the video feed, and places the dot in 3d space using the depth data to control the z value.

The depth data is really inconsistent and low-res, with weird sampling / interpolation artifacts. So it produces beautiful results!

Here are some images from the [LA Ink & Switch Unconf](https://www.inkandswitch.com/events/2024-unconf-losangeles/).

![The camera got confused when taking this photo of Marcel, so his face is flat with a background exploding outward around him](https://d3um8l2sa8g9bu.cloudfront.net/mostly-shallow/marcel.png)
![Worm-eye view of Taylor, with a disintegrating hand and big grin](https://d3um8l2sa8g9bu.cloudfront.net/mostly-shallow/taylor.png)
![Forrest with a point-cloud finger held out in front of his face](https://d3um8l2sa8g9bu.cloudfront.net/mostly-shallow/forrest.png)

I needed a depth-punny name, so I just went with an [MBV reference (warning: flashing)](https://www.youtube.com/watch?v=nwfCoKNI5hs).
