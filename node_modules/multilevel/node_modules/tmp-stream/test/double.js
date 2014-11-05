var test = require('tape');
var tmpStream = require('../');
var through = require('through');

test('double replace', function (t) {
  var tmp = tmpStream();
  tmp.replace(through());
  t.throws(tmp.replace.bind(tmp, through()));
  t.end();
});
