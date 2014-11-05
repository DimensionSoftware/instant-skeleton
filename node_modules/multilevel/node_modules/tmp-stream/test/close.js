var test = require('tape');
var tmpStream = require('../');
var through = require('through');

test('tmp', function (t) {
  function createStream () {
    var tmp = tmpStream();
    setTimeout(function () {
      var tr = through();
      tmp.replace(tr);
      tr.queue(null);
    });
    return tmp;
  }

  var stream = createStream();
  stream.once('close', function (data) {
    t.ok(true);
    stream.once('close', function (data) {
      t.fail();
    });
    setTimeout(t.end.bind(t), 0);
  });
});
