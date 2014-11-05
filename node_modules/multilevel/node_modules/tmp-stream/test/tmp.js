var test = require('tape');
var tmpStream = require('../');
var through = require('through');

test('tmp', function (t) {
  function createStream () {
    var tmp = tmpStream();
    setTimeout(function () {
      var tr = through(function (chunk) {
        this.queue(chunk.toUpperCase());
      });
      tmp.replace(tr);
      tr.write('hey');
    });
    return tmp;
  }

  var stream = createStream();
  stream.once('data', function (data) {
    t.equals(data, 'YOU');
    stream.once('data', function (data) {
      t.equals(data, 'HEY');
      t.end();
    });
  });
  stream.write('you');
});
