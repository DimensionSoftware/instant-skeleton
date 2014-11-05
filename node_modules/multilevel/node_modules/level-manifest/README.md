# level-manifest

Describe the functions that multilevel should provide access to on the client.

[![Build Status](https://travis-ci.org/dominictarr/level-manifest.png?branch=master)](https://travis-ci.org/dominictarr/level-manifest)

## Example

Suppose you implement a levelup plugin that adds some cool new features to a
[sublevel](https://github.com/dominictarr/level-sublevel)

retrive a js object describing what methods a client protocol should be able
to access.
``` js
var manifest = require('level-manifest')

var m = manifest(db)
```

`manifest` build a tree of sublevels.

``` js
{
  methods:   {},
  sublevels: {
    foo: {
      methods: {},
      sublevels: {}
    }
  }
}
```

Plugins extending a sublevel should add a `methods` property that describes
any new methods that can be used by a remote client.

for example, the default methods are specified like this:

``` js
var methods = {
  createReadStream  : {type: 'readable'},
  readStream        : {type: 'readable'},
  createValueStream : {type: 'readable'},
  valueStream       : {type: 'readable'},
  createKeyStream   : {type: 'readable'},
  keyStream         : {type: 'readable'},
  createWriteStream : {type: 'writable'},
  writeStream       : {type: 'writable'},
  isOpen            : {type: 'sync'},
  isClosed          : {type: 'sync'},
  put               : {type: 'async'},
  get               : {type: 'async'},
  del               : {type: 'async'},
  batch             : {type: 'async'},
  approximateSize   : {type: 'async'}
}
```

`readable`, and `writable` mean readable or writable streams,
(use `duplex` for a stream that is both readable and writable.)

A client should also provide support for these types:
``` js
var other = {
  error        : {type: 'error', message: 'not-supported'},
  createStream : {type: 'duplex'},
  nested       : {type: 'object', methods: {get: {type: 'async'}}}
}
```
`error` is used when a method has been disabled.

## License

MIT
