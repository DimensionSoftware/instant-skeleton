
# tmp-stream

A stream that's ready to be replaced by another.

[![build status](https://secure.travis-ci.org/juliangruber/tmp-stream.png)](https://travis-ci.org/juliangruber/tmp-stream)

[![testling badge](https://ci.testling.com/juliangruber/tmp-stream.png)](https://ci.testling.com/juliangruber/tmp-stream)

## Usage

Create a temporary stream and replace it with the real one after 500ms.
Use the temporary stream immediately, everything gets buffered.

```js
var tmpStream = require('tmp-stream');
var through = require('through');

function createStream () {
  var tmp = tmpStream();
  setTimeout(function () {
    var realStream = through(function (chunk) {
      this.queue(chunk.toUpperCase());
    });
    tmp.replace(realStream);
    realStream.write('hey');
  }, 500);
  return tmp;
}

var stream = createStream();
stream.on('data', console.log);
stream.write('you');
```

outputs:

```bash
$ node example/simple.js
HEY
YOU
```

## API

### tmpStream()

Create a new temporary stream.

### tmpStream#replace(stream)

Use `stream` as the real underlying stream and feed it with both already
buffered and new incoming data.

You may call this method only once.

## Installation

With [npm](http://npmjs.org) do

```bash
$ npm install tmp-stream
```

## License

(MIT)

Copyright (c) 2013 Julian Gruber &lt;julian@juliangruber.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
