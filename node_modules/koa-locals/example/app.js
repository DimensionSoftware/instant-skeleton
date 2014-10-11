var koa = require('koa');
var locals = require('../');
var csrf = require('koa-csrf');
var render = require('koa-swig');
var session = require('koa-session');
var app = koa();

app.keys = ['key'];
locals(app, {
  name: 'koa app'
});

csrf(app);
app.use(session())
app.use(function *(next) {
  this.locals._csrf = this.csrf;
  yield next;
});

render(app, {
  root: __dirname,
  ext: 'html',
  locals: {
    language: 'zh-cn'
  }
});

app.use(function *() {
  this.locals.title = 'Kick Koa!';
  yield this.render('index', {
    username: 'fundon'
  });
});

if (process.env.NODE_ENV === 'test') {
  module.exports = app.callback();
} else {
  app.listen(2333);
}
