var compression = require('compression');
var express = require('express');
var http = require('http');
var path = require('path');

var maxAge = 1000 * 60;// * 60 * 24 * 7; // Cache for 7 days
var app = express();

app.use(compression());

// Everything in public will be accessible from '/'
app.use(express.static(path.join(__dirname, 'public'), { maxAge: maxAge }));

http.createServer(app).listen(process.env.PORT || 3000);
