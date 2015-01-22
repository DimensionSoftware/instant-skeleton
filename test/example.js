var expect  = require('chai').expect,
    sinon   = require('sinon'),
    request = require('supertest'),
    App     = require('../build/server/App.js'),
    app     = new App(process.env.npm_package_config_node_port-1)

server = null


// TODO better coverage
describe('Can we boot the app?', function () {
  this.timeout(5000);
  before(function (done) {
    app.start(function() {
      server = app.server // set app instance
      done()
    })
  });

  describe('Can we fetch an index page?', function () {
    it('fetches', function (done) {
      request(server)
        .get('/')
        .expect(200, done)
    });
  });
});


