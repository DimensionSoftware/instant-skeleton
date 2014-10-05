describe('create server', function () {
  'use strict';

  var assume = require('assume')
    , create = require('../')
    , port = 1024
    , server;

  var https = require('https')
    , http = require('http')
    , spdy = require('spdy');

  afterEach(function (next) {
    if (server) try { server.close(next); }
    catch (e) { process.nextTick(next); }
    else process.nextTick(next);

    server = undefined;
  });

  it('is exported as function', function () {
    assume(create).to.be.a('function');
  });

  it('starts a HTTP server when given port number', function (next) {
    server = create(++port, { listening: function (err) {
      if (err) return next(err);

      assume(server.address().port).to.equal(port);
      next();
    }});

    assume(server).to.be.instanceOf(http.Server);
  });

  it('proxies the error to the listener', function (next) {
    server = create(80, { listening: function (err) {
      if (!err) throw new Error('Port 80 should be restricted, we are not root');

      next();
    }});
  });

  it('creates a HTTP server with the given port property', function (next) {
    server = create({ port: ++port }, { listening: function (err) {
      if (err) return next(err);

      assume(server.address().port).to.equal(port);
      next();
    }});

    assume(server).to.be.instanceOf(http.Server);
  });

  it('allows the callback object to be merged with the options', function (next) {
    server = create({ port: ++port, listening: function (err) {
      if (err) return next(err);

      assume(server.address().port).to.equal(port);
      next();
    }});
  });

  it('creates a HTTPS server when given certs', function (next) {
    server = create({
      port: ++port,
      root: __dirname,
      cert: './ssl/server.crt',
      key: './ssl/server.key',
      listening: next
    });

    assume(server).to.be.instanceOf(https.Server);
  });

  it('creates a SPDY server when given the SPDY boolean', function (next) {
    server = create({
      port: ++port,
      root: __dirname,
      cert: './ssl/server.crt',
      key: './ssl/server.key',
      spdy: true,
      listening: next
    });

    // spdy is spiced up HTTPS server
    assume(server).to.be.instanceOf(https.Server);
    assume(server).to.be.instanceOf(spdy.server.Server);
  });
});
