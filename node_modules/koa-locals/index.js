
'use strict';

/**
 *  Module dependencies.
 */

var debug = require('debug')('koa:locals');
var mixin = require('utils-merge');

module.exports = function (app, opts) {

  // setup locals
  app.locals = Object.create(null);

  mixin(app.locals, opts || Object.create(null));

  debug('app.locals %j', app.locals);

  /**
   *  Lazily creates a locals.
   *
   *  @api public
   */
  app.context.__defineGetter__('locals', function () {
    if (this._locals) {
      return this._locals;
    }

    this._locals = mixin({}, app.locals);

    debug('app.ctx.locals %j', this._locals);

    return this._locals;
  });

  app.response.__defineGetter__('locals', function () {
    return this.ctx.locals;
  });

  return app;
};
