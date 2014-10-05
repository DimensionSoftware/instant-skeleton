var _ = require('lodash');
var session = require('express-session');
var cookieParser = require('cookie-parser');
var passport = require('passport');
var debug = require('debug')('feathers-passport:main');

var authorization = require('./authorizer');
var getDefaults = function() {
  return {
    cookieParser: cookieParser,
    passport: passport,
    name: 'connect.sid',
    userProperty: passport._userProperty || 'user',
    createSession: session
  };
};

var getSettings = function(settings) {
  var defaults = getDefaults();
  var result = typeof settings === 'function' ?
    settings(defaults) : _.extend(defaults, settings);

  if(!result.session) {
    result.session = result.createSession(result);
  }

  return result;
};

module.exports = function(configuration) {
  var settings = getSettings(configuration);
  var authorizer = authorization(settings);

  if(!settings.secret) {
    throw new Error('Session secret must be provided!');
  }

  if(!settings.store) {
    throw new Error('Session store must be provided');
  }

  return function() {
    var app = this;
    var oldSetup = app.setup;

    debug('setting up feathers-passport');

    app.use(settings.cookieParser(settings.secret))
      .use(settings.session)
      .use(settings.passport.initialize())
      .use(settings.passport.session())
      .use(function(req, res, next) {
        // Make the Passport user also available for services
        req.feathers.user = req.user;
        next();
      });

    app.setup = function() {
      var result = oldSetup.apply(this, arguments);
      var io = app.io;
      var primus = app.primus;

      debug('running app.setup');

      if(io) {
        debug('intializing SocketIO middleware');
        io.use(function(socket, next) {
          authorizer(socket.request, function(error, user) {
            debug('authorizer for SocketIO returned', error, user);

            if(error) {
              return next(error);
            }

            socket.feathers = _.extend({ user: user }, socket.feathers);
            next();
          });
        });
      }

      if(primus) {
        debug('intializing Primus middleware');
        primus.authorize(function(req, done) {
          authorizer(req, function(error, user) {
            debug('authorizer for Primus returned', error, user);

            if(error) {
              return done(error);
            }

            req.feathers = _.extend({ user: user }, req.feathers);
            done();
          });
        });
      }

      return result;
    };
  };
};
