var expect  = require('chai').expect,
    sinon   = require('sinon'),
    request = require('supertest'),
    App     = require('../build/server/App.js'),
    app     = new App()


server = app.start().server;

describe('Can we fetch an index page?', function () {
  it('fetches', function (done) {
    request(server)
      .get('/')
      .expect(200)
      .end(function(err, data){
        if (err) return done(err);
        done();
      })
  });
});
