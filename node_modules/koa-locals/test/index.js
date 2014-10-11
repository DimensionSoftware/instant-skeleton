'use strict';

/**
 * Module dependencies.
 */

var locals = require('..');
var path = require('path');
var request = require('supertest');
var koa = require('koa');
var assert = require('assert');

describe('koa-locals', function(){
  describe('app.locals', function () {
    it('should be return app.locals', function() {
      var app = koa();
      locals(app, {
        name: 'Kick koa!'
      });
      'Kick koa!'.should.equal(app.locals.name);
    })
  });

  describe('ctx.locals', function () {
    var app = koa();
    locals(app, {
      name: 'node'
    });
    app.use(function *() {
      this.body = this.locals.name;
    });
    it('should be return ctx.locals', function (done) {
      request(app.listen())
        .get('/')
        .expect('node')
        .expect(200, done);
    })
  });

  describe('ctx.lodals', function () {
    var app = koa();
    locals(app, {
      name: 'node'
    });
    app.use(function *() {
      this.locals.version = '0.11.12';
      this.body = this.locals.name + '@' + this.locals.version;
    });
    it('should add new prop to locals', function (done) {
      request(app.listen())
        .get('/')
        .expect('node@0.11.12')
        .expect(200, done);
    })
  });
});
