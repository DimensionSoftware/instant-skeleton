var Transform = require('stream').Transform;
var assert = require('assert');
var util = require('util');
util.inherits(StreamInjecter, Transform);

function StreamInjecter(option) {
  Transform.call(this, option);
  this.matchRegExp = option.matchRegExp || /(<\/body>)/;
  this.injectString = option.inject || assert(true, "Error! : need injectString");
  this.replaceString = option.replace|| this.injectString + "$1";
  this.ignoreString = option.ignore || "";
  this.memoryBuffer = "";
}

StreamInjecter.prototype._transform = function(chunk, encoding, cb) {
  var buffer = (Buffer.isBuffer(chunk)) ?
    chunk :  // already is Buffer use it
    new Buffer(chunk, enc);
  this.memoryBuffer += buffer;
  cb();
};


StreamInjecter.prototype._flush = function(cb) {
  if (this.memoryBuffer.match(this.ignoreString)) cb();

  this.memoryBuffer = this.memoryBuffer.replace(this.matchRegExp, this.replaceString);
  this.push(this.memoryBuffer);

  cb();
};

module.exports = StreamInjecter;
