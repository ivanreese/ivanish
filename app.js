var express = require('express'),
    http = require('http'),
    path = require('path'),
    app = express();

// Remember: The order of the middleware matters!

// Everything in public will be accessible from '/'
app.use(express.static(path.join(__dirname, 'public')));

http.createServer(app).listen(3000);
