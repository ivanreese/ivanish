var express = require('express');
var http = require('http');
var path = require('path');

var maxAge = 1000 * 60 * 60 * 24;
var app = express();

app.use(express.compress());

// Everything in public will be accessible from '/'
app.use(express.static(path.join(__dirname, 'public'), { maxAge: maxAge }));

http.createServer(app).listen(process.env.PORT || 3000);
