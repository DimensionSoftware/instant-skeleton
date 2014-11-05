var throughout = require('throughout');
var through = require('through');

var nextTick = typeof setImmediate !== 'undefined'
  ? setImmediate
  : process.nextTick;

module.exports = tmp;

function tmp () {
  var buf = [];
  var real;

  var input = through(function (chunk) {
    if (!real) {
      buf.push(chunk);
      return false;
    } else {
      return real.write(chunk);
    }
  });

  var output = through();
  var tr = throughout(input, output);

  tr.replace = function (stream) {
    if (!input.readable) return stream.end(); // already ended
    if (real) throw new Error('can replace only once');

    real = stream;
    
    tr.readable = real.readable;
    tr.writable = real.writable;

    if (real.readable) real.pipe(output);
    if (real.writable) input.pipe(real);

    stream.on('error', function (err) {
      tr.emit('error', err);
    });

    for (var i = 0; i < buf.length; i++) real.write(buf[i]);
    buf = null;
  }

  return tr;
}
