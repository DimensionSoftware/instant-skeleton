var tmpStream = require('../');
var through = require('through');

function createStream () {
  var tmp = tmpStream();
  setTimeout(function () {
    var tr = through(function (chunk) {
      this.queue(chunk.toUpperCase());
    });
    tmp.replace(tr);
    tr.write('hey');
  }, 500);
  return tmp;
}

var stream = createStream();
stream.on('data', console.log);
stream.write('you');
