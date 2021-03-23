# ivanish

A personal website.

Build with `gulp`.

It should go without saying.. the site, the code, and all content are Copyright (c) Ivan Reese 2016, excepting attributed images, fonts, and other content.

Sofia Pro Light by http://www.mostardesign.com

# Hosting

The site is hosted on Surge. Assets are on S3. Cloudflare does DNS and SSL proxy. Since Cloudflare's free proxy can't be used for lots of images or other heavy media, all links to that stuff go to S3 directly. If I want to set up a nice subdomain (like s3.ivanish.ca), I'll need to switch away from Surge and set up my own SSL.
