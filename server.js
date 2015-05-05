var express = require('express'),
    http = require('http'),
    path = require('path'),
    app = express();

// Everything in public will be accessible from '/'
app.use(express.static(path.join(__dirname, 'public')));

http.createServer(app).listen(process.env.PORT || 3000);
