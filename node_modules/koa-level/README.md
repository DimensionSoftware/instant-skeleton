# koa-level

Session storage for [koa-generic-session](https://github.com/koajs/generic-session).

## Install

```
$ npm install koa-level
```

## Usage

```js
var koa = require('koa');
var level = require('levelup');
var session = require('koa-sess');
var store = require('koa-level');

var db = level('./db');

var app = koa();
app.use(session({
  store: store({ db: db })
}));

app.use(function*() {
  if(this.url.match(/hello\/\w+/)) {
    this.session.name = this.url.match(/hello\/(\w+)/)[1];
  }
  this.body = 'Hello ' + this.session.name
});

app.listen(3000);
```

## API

### store(opts)

Create [koa-generic-session](https://github.com/koajs/generic-session) compatilbe storage from
`opts.db`.

## Complex stuff

If you don't want to pollute the db, use [level-sublevel](https://github.com/dominictarr/level-sublevel) to prefix session ids (you can put data in different "*tables*").

TTL is only supported, when the underlying db supports it, via [level-ttl](https://github.com/rvagg/node-level-ttl) or similar.

You can use leveldb over the network with [multilevel](https://github.com/juliangruber/multilevel).

## License

MIT
