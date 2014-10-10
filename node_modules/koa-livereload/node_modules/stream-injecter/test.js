var fs = require('fs');
var StreamInjecter = require('./index.js');

var snippet = "\n<script type=\"text/javascript\">document.write('<script src=\"abc.js\" type=\"text/javascript\"><\\/script>')</script>\n";
var stream = fs.createReadStream("./index.html");

var injecter = new StreamInjecter({
  matchRegExp : /(<\/body>)/,
  inject : snippet,
  replace : snippet + "$1",
  ignore : /livereload.js/
});

stream.pipe(injecter).pipe(process.stdout);
