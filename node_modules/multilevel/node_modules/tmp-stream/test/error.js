var test = require('tape');
var tmpStream = require('../');
var Stream = require('stream');

test('error', function (t) {
  t.plan(1);

  function createStream () {
    var tmp = tmpStream();
    setTimeout(function () {
      var stream = new Stream();
      tmp.replace(stream);
      stream.emit('error', new Error('shit'));
    });
    return tmp;
  }

  var stream = createStream();
  stream.on('error', function (err) {
    t.ok(err);
  });
})
